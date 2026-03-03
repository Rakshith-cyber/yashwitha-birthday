const http = require('http');
const fs = require('fs');
const path = require('path');
const os = require('os');

const PORT = 3000;

const mimeTypes = {
    '.html': 'text/html',
    '.jpg': 'image/jpeg',
    '.jpeg': 'image/jpeg',
    '.png': 'image/png',
    '.gif': 'image/gif',
    '.webp': 'image/webp',
    '.mp3': 'audio/mpeg',
    '.css': 'text/css',
    '.js': 'application/javascript'
};

const baseDir = 'c:\\Users\\Bahat\\OneDrive\\Desktop';

function getLocalIP() {
    const interfaces = os.networkInterfaces();
    for (const name of Object.keys(interfaces)) {
        for (const iface of interfaces[name]) {
            if (iface.family === 'IPv4' && !iface.internal) {
                return iface.address;
            }
        }
    }
    return 'localhost';
}

const server = http.createServer((req, res) => {
    let filePath = req.url === '/' ? '/index.html' : req.url;
    filePath = path.join(baseDir, filePath);
    
    const ext = path.extname(filePath).toLowerCase();
    const contentType = mimeTypes[ext] || 'application/octet-stream';
    
    fs.readFile(filePath, (err, content) => {
        if (err) {
            if (err.code === 'ENOENT') {
                res.writeHead(404);
                res.end('File not found');
            } else {
                res.writeHead(500);
                res.end('Server error');
            }
        } else {
            res.writeHead(200, { 'Content-Type': contentType });
            res.end(content);
        }
    });
});

server.listen(PORT, '0.0.0.0', () => {
    const ip = getLocalIP();
    console.log('=========================================');
    console.log('Birthday Website Server');
    console.log('=========================================');
    console.log(`Local access:   http://localhost:${PORT}`);
    console.log(`Network access: http://${ip}:${PORT}`);
    console.log('=========================================');
    console.log('Press Ctrl+C to stop');
});
