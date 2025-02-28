#[macro_use] extern crate rocket;
use rocket::serde::json::Json;
use rocket::serde::{Deserialize, Serialize};
use rocket::tokio::fs::File;
use rocket::tokio::io::AsyncWriteExt;

#[derive(Debug, Deserialize, Serialize)]
struct WebhookPayload {
    #[serde(flatten)]
    data: serde_json::Value,
}

#[post("/wh", format = "json", data = "<payload>")]
async fn webhook(payload: Json<WebhookPayload>) {
    let log_entry = format!("Received webhook: {}\n", serde_json::to_string_pretty(&payload.data).unwrap());
    
    println!("{}", log_entry);
}

#[rocket::main]
async fn main() {
//    env_logger::init(); // Initialize logger

    // Manually launch Rocket and handle errors
    match rocket::build().mount("/", routes![webhook]).launch().await {
        Ok(_) => info!("Rocket server shut down cleanly."),
        Err(e) => {
            error!("Rocket failed to launch: {}", e);
            std::process::exit(1); // Exit with an error code
        }
    }
}
