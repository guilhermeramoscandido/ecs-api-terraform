import { Router, Request, Response, NextFunction } from 'express';
import { CombinedController } from '../controllers/controller';

const router = Router();
const combinedController = new CombinedController();

router.get('/hello_world', combinedController.getHelloWorld.bind(combinedController));
router.get('/current_time', combinedController.getCurrentTime.bind(combinedController));
router.get('/healthcheck', combinedController.healthCheck.bind(combinedController));

// Middleware to handle unknown routes
router.use((req: Request, res: Response, next: NextFunction) => {
    res.status(404).json({ error: "Route not found" });
});

export default router;