use std::ops::Deref;
use std::sync::Mutex;

use actix_web::{get, post, web, App, HttpResponse, HttpServer, Responder};
use anyhow::{Context, Result};
use log::{info, warn, LevelFilter};
use once_cell::sync::Lazy;
use serde::Deserialize;
use serde::Serialize;
use sled::Db;
use uuid::Uuid;
use actix_cors::Cors;

static DATABASE: Lazy<Mutex<Db>> = Lazy::new(|| {
    cfg_if::cfg_if! {
        if #[cfg(test)] {
            Mutex::new(sled::open(format!("target/{}/scores.db", Uuid::new_v4().to_string())).unwrap())
        } else {
            Mutex::new(sled::open("data/scores.db").unwrap())
        }
    }
});

#[derive(Debug, Serialize, Deserialize, PartialEq, Eq)]
struct Score {
    name: String,
    score: u64,
}

#[get("/")]
async fn get_score() -> impl Responder {
    let mut scores = DATABASE
        .lock()
        .unwrap()
        .iter()
        .flat_map(|score| {
            score
                .ok()
                .map(|(_key, value)| {
                    let vec = value.to_vec();
                    let res: Option<Score> = serde_json::from_slice(vec.as_slice()).ok();
                    res
                })
                .flatten()
        })
        .collect::<Vec<_>>();

    scores.sort_by_key(|score| score.score);
    scores.reverse();
    scores.truncate(10);

    web::Json(scores)
}

#[post("/")]
async fn publish_score(score: web::Json<Score>) -> impl Responder {
    if let Err(e) = insert(score.into_inner()) {
        warn!("insert failed: {e:?}")
    }
    HttpResponse::Accepted()
}

fn insert(score: Score) -> Result<()> {
    let key = Uuid::new_v4();
    let _old = DATABASE
        .lock()
        .unwrap()
        .insert(
            key.to_string().deref(),
            serde_json::to_vec(&score).context("json")?,
        )
        .context("insert")?;
    Ok(())
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    let _ = env_logger::builder()
        .filter_module("snake_backend", LevelFilter::Info)
        .try_init();
    let port = 9090;
    info!("Starting on {port}");
    HttpServer::new(|| App::new().service(get_score).service(publish_score)            .wrap(
        Cors::default()
            .supports_credentials()
            .allow_any_origin()
            .allow_any_method()
            .allow_any_header(),
    ))
        .bind(("0.0.0.0", port))?
        .run()
        .await
}

#[cfg(test)]
mod tests {
    use super::*;
    use actix_web::test;
    use actix_web::test::TestRequest;

    #[actix_web::test]
    async fn test() {
        let _ = env_logger::builder()
            .filter_module("snake_backend", LevelFilter::Info)
            .try_init();
        let app = test::init_service(App::new().service(get_score).service(publish_score)).await;

        let req = TestRequest::get().uri("/").to_request();
        let scores: Vec<Score> = test::call_and_read_body_json(&app, req).await;
        println!("scores: {scores:?}");
        assert!(scores.is_empty());

        let req = TestRequest::post()
            .uri("/")
            .set_json(Score {
                name: "Adam".to_string(),
                score: 10,
            })
            .to_request();
        test::call_service(&app, req).await;

        let req = TestRequest::get().uri("/").to_request();
        let scores: Vec<Score> = test::call_and_read_body_json(&app, req).await;
        println!("scores: {scores:?}");
        assert_eq!(
            scores,
            vec![Score {
                name: "Adam".to_string(),
                score: 10,
            }]
        );

        for i in 0..20 {
            let req = TestRequest::post()
                .uri("/")
                .set_json(Score {
                    name: i.to_string(),
                    score: i,
                })
                .to_request();
            test::call_service(&app, req).await;
        }

        let req = TestRequest::get().uri("/").to_request();
        let scores: Vec<Score> = test::call_and_read_body_json(&app, req).await;
        println!("scores: {scores:?}");
        assert_eq!(
            scores,
            vec![
                Score {
                    name: "19".to_string(),
                    score: 19
                },
                Score {
                    name: "18".to_string(),
                    score: 18
                },
                Score {
                    name: "17".to_string(),
                    score: 17
                },
                Score {
                    name: "16".to_string(),
                    score: 16
                },
                Score {
                    name: "15".to_string(),
                    score: 15
                },
                Score {
                    name: "14".to_string(),
                    score: 14
                },
                Score {
                    name: "13".to_string(),
                    score: 13
                },
                Score {
                    name: "12".to_string(),
                    score: 12
                },
                Score {
                    name: "11".to_string(),
                    score: 11
                },
                Score {
                    name: "10".to_string(),
                    score: 10
                },
            ]
        );
        assert_eq!(scores.len(), 10);
    }
}
