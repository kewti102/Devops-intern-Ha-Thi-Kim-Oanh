const http = require("http");

const PORT = process.env.PORT || 3000;

const server = http.createServer((req, res) => {
  if (req.url === "/health") {
    res.writeHead(200, {
      "Content-Type": "application/json",
    });

    return res.end(
      JSON.stringify({
        status: "ok",
      })
    );
  }

  res.writeHead(200, {
    "Content-Type": "application/json",
  });

  res.end(
    JSON.stringify({
      app: "day-6-cicd-basics",
      message: "hello ci/cd",
      timestamp: Date.now(),
    })
  );
});

server.listen(PORT, () => {
  console.log(`Server listening on port ${PORT}`);
});
