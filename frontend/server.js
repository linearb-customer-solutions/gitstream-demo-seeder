const express = require("express");
const fetch = require("node-fetch");
const app = express();

const AUTH_URL = "http://auth-python:8000/auth/login";
const ORDERS_URL = "http://orders-java:8080/orders";

app.use(express.static("public"));
app.use(express.json());

app.post("/api/login", async (req, res) => {
  const response = await fetch(AUTH_URL, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(req.body),
  });

  const data = await response.json();
  res.json(data);
});

app.post("/api/orders", async (req, res) => {
  const token = req.headers["authorization"];
  const response = await fetch(ORDERS_URL, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "Authorization": token,
    },
    body: JSON.stringify(req.body),
  });

  const text = await response.text();
  res.status(response.status).send(text);
});

app.listen(3000, () => console.log("Frontend on :3000"));
