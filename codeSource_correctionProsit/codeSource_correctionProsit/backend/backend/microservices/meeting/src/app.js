const express = require('express');
const swaggerUi = require('swagger-ui-express');
const openapiSpec = require('./config/swagger');
const meetingRoutes = require('./routes/meeting.routes');
const pkg = require('../package.json');

const app = express();

app.use(express.json());

// ---- Health & Info endpoints (Partie 5) ----
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'UP' });
});

app.get('/info', (req, res) => {
  res.status(200).json({
    name: pkg.name,
    version: pkg.version,
    description: pkg.description,
  });
});

// ---- Swagger documentation ----
app.get('/v3/api-docs', (req, res) => res.json(openapiSpec));
app.use('/swagger-ui', swaggerUi.serve, swaggerUi.setup(openapiSpec));

// ---- API routes ----
app.use('/api/meetings', meetingRoutes);
app.use('/meetings', meetingRoutes);
app.use('/meeting', meetingRoutes);

// ---- 404 for unknown routes ----
app.use((req, res) => {
  res.status(404).json({ status: 404, error: 'Not Found', message: `Route ${req.method} ${req.originalUrl} not found` });
});

// ---- Error handler ----
// eslint-disable-next-line no-unused-vars
app.use((err, req, res, next) => {
  const status = err.status || 500;
  res.status(status).json({ status, error: status === 500 ? 'Internal Server Error' : 'Error', message: err.message });
});

module.exports = app;
