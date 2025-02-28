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

#[launch]
fn rocket() -> _ {
    rocket::build().mount("/", routes![webhook])
}

