import express, { Application } from 'express';
import { UserService } from './services/UserService';
import { ApiResponse } from './types/ApiResponse';
import { DemoFeatureService } from './demo-feature';

const app: Application = express();
const port = process.env.PORT || 3000;
const userService = new UserService();
const demoFeatureService = new DemoFeatureService();

app.use(express.json());

app.get('/', (_req, res) => {
  const response: ApiResponse<string> = {
    success: true,
    data: 'Hello World! Git Flow Demo API',
    message: 'Welcome to the demo application'
  };
  res.json(response);
});

app.get('/api/users', async (_req, res) => {
  try {
    const users = await userService.getAllUsers();
    const response: ApiResponse<typeof users> = {
      success: true,
      data: users,
      message: 'Users retrieved successfully'
    };
    res.json(response);
  } catch (error) {
    const response: ApiResponse<null> = {
      success: false,
      data: null,
      message: 'Failed to retrieve users',
      error: error instanceof Error ? error.message : 'Unknown error'
    };
    res.status(500).json(response);
  }
});

app.get('/api/users/:id', async (req, res) => {
  try {
    const userId = parseInt(req.params.id);
    const user = await userService.getUserById(userId);
    
    if (!user) {
      const response: ApiResponse<null> = {
        success: false,
        data: null,
        message: 'User not found'
      };
      res.status(404).json(response);
      return;
    }

    const response: ApiResponse<typeof user> = {
      success: true,
      data: user,
      message: 'User retrieved successfully'
    };
    res.json(response);
  } catch (error) {
    const response: ApiResponse<null> = {
      success: false,
      data: null,
      message: 'Failed to retrieve user',
      error: error instanceof Error ? error.message : 'Unknown error'
    };
    res.status(500).json(response);
  }
});

app.get('/api/features', async (_req, res) => {
  try {
    const features = await demoFeatureService.getAllFeatures();
    const response: ApiResponse<typeof features> = {
      success: true,
      data: features,
      message: 'Demo features retrieved successfully'
    };
    res.json(response);
  } catch (error) {
    const response: ApiResponse<null> = {
      success: false,
      data: null,
      message: 'Failed to retrieve demo features',
      error: error instanceof Error ? error.message : 'Unknown error'
    };
    res.status(500).json(response);
  }
});

app.post('/api/features/:id/toggle', async (req, res) => {
  try {
    const featureId = parseInt(req.params.id);
    const feature = await demoFeatureService.toggleFeature(featureId);
    
    if (!feature) {
      const response: ApiResponse<null> = {
        success: false,
        data: null,
        message: 'Demo feature not found'
      };
      res.status(404).json(response);
      return;
    }

    const response: ApiResponse<typeof feature> = {
      success: true,
      data: feature,
      message: 'Demo feature toggled successfully'
    };
    res.json(response);
  } catch (error) {
    const response: ApiResponse<null> = {
      success: false,
      data: null,
      message: 'Failed to toggle demo feature',
      error: error instanceof Error ? error.message : 'Unknown error'
    };
    res.status(500).json(response);
  }
});

app.listen(port, () => {
  console.log(`🚀 Server running at http://localhost:${port}`);
  console.log('📋 Available endpoints:');
  console.log('  GET / - Welcome message');
  console.log('  GET /api/users - Get all users');
  console.log('  GET /api/users/:id - Get user by ID');
  console.log('  GET /api/features - Get demo features');
  console.log('  POST /api/features/:id/toggle - Toggle demo feature');
});

export default app;