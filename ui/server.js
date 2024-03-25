const  { createProxyMiddleware } = require('http-proxy-middleware');
const express = require('express');

const app = express();
const port = 3000;

app.get('/', (req, res) => {
    res.sendFile(__dirname + '/start.html');
});
app.get('/game', (req, res) => {
    res.sendFile(__dirname + '/game.html');
});

app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});

app.use(
    '/solvable',
    createProxyMiddleware({
        target: 'http://localhost:8080',
        changeOrigin: true,
    })
);

app.use(
    '/solve',
    createProxyMiddleware({
        target: 'http://localhost:8080',
        changeOrigin: true,
    })
);