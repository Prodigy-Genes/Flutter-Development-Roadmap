import winston from "winston";

const logger = winston.createLogger({
    level: 'info',
    format: winston.format.json(),
    transports: [
        // Save errors to a specific file
        new winston.transports.File({ filename: 'errors.log', level: 'error'}),
        // Save everyhting else to a combined file
        new winston.transports.File({ filename: 'combined.log'})
    ],
});

// If we're not in production then log to the console
if (process.env.NODE_NODE !== 'production') {
  logger.add(new winston.transports.Console({
    format: winston.format.simple(),
  }));
}

export default logger;