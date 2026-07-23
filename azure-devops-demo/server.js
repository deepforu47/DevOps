const express = require('express');
const app = express();
const PORT = process.env.PORT || 8080;

app.get('/', (req, res) => {
    res.send(`
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Azure DevOps Pipeline Demo</title>
            <link rel="preconnect" href="https://fonts.googleapis.com">
            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
            <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
            <style>
                * { box-sizing: border-box; margin: 0; padding: 0; }
                body {
                    font-family: 'Inter', sans-serif;
                    background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
                    color: #f8fafc;
                    min-height: 100vh;
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    padding: 20px;
                }
                .card {
                    background: rgba(30, 41, 59, 0.7);
                    backdrop-filter: blur(16px);
                    border: 1px solid rgba(255, 255, 255, 0.1);
                    border-radius: 16px;
                    padding: 40px;
                    max-width: 550px;
                    width: 100%;
                    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.4);
                    text-align: center;
                }
                .badge {
                    display: inline-block;
                    background: linear-gradient(90deg, #0078D4 0%, #00BCF2 100%);
                    color: white;
                    font-weight: 600;
                    padding: 6px 16px;
                    border-radius: 20px;
                    font-size: 0.85rem;
                    text-transform: uppercase;
                    letter-spacing: 1px;
                    margin-bottom: 20px;
                }
                h1 {
                    font-size: 1.8rem;
                    font-weight: 700;
                    margin-bottom: 12px;
                    color: #ffffff;
                }
                p.subtitle {
                    color: #94a3b8;
                    font-size: 1rem;
                    margin-bottom: 30px;
                }
                .grid {
                    display: grid;
                    grid-template-columns: 1fr 1fr;
                    gap: 15px;
                    margin-bottom: 30px;
                }
                .info-box {
                    background: rgba(15, 23, 42, 0.6);
                    border: 1px solid rgba(255, 255, 255, 0.05);
                    padding: 16px;
                    border-radius: 10px;
                }
                .info-box span.label {
                    display: block;
                    font-size: 0.75rem;
                    color: #64748b;
                    text-transform: uppercase;
                    margin-bottom: 4px;
                }
                .info-box span.value {
                    font-size: 1.1rem;
                    font-weight: 600;
                    color: #38bdf8;
                }
                .status-live {
                    color: #4ade80 !important;
                }
                footer {
                    font-size: 0.8rem;
                    color: #64748b;
                    border-top: 1px solid rgba(255, 255, 255, 0.1);
                    padding-top: 20px;
                }
            </style>
        </head>
        <body>
            <div class="card">
                <div class="badge">Azure DevOps Demo</div>
                <h1>🚀 App Service Deployment</h1>
                <p class="subtitle">Node.js Web App Deployed via Azure DevOps Pipelines</p>
                <div class="grid">
                    <div class="info-box">
                        <span class="label">App Version</span>
                        <span class="value">v1.0.1</span>
                    </div>
                    <div class="info-box">
                        <span class="label">Status</span>
                        <span class="value status-live">● LIVE</span>
                    </div>
                </div>
                <footer>
                    Automated CI/CD Build & Deployment using Reusable Pipeline Templates
                </footer>
            </div>
        </body>
        </html>
    `);
});

app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});

