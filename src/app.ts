import express from 'express';
import routes from './routes/routes';
import { loggerMiddleware } from './middleware/logger-middleware';


const app = express();
const port = process.env.PORT || 3000;

app.use(express.json());
app.use(loggerMiddleware); // Use the logging middleware
app.use(routes);

app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});