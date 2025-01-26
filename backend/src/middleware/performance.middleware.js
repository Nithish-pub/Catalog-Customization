const { performance } = require('perf_hooks');

const performanceMiddleware = (req, res, next) => {
  const start = performance.now();

  res.on('finish', () => {
    const duration = performance.now() - start;
    console.log({
      method: req.method,
      url: req.originalUrl,
      duration: `${duration.toFixed(2)}ms`,
      status: res.statusCode,
    });
  });

  next();
};

module.exports = performanceMiddleware; 