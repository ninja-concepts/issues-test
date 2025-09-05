import express, { Application } from 'express';
import { UserService } from './services/UserService';
import { ApiResponse } from './types/ApiResponse';
import { runTestSuite, formatTestResult } from './utils/testUtils';

const app: Application = express();
const port = process.env.PORT || 3000;
const userService = new UserService();

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

app.get('/api/test/ai-workflow', (_req, res) => {
  try {
    const testResults = runTestSuite();
    const formattedResults = testResults.map(formatTestResult);
    
    const response: ApiResponse<string[]> = {
      success: true,
      data: formattedResults,
      message: 'AI workflow test suite completed'
    };
    res.json(response);
  } catch (error) {
    const response: ApiResponse<null> = {
      success: false,
      data: null,
      message: 'AI workflow test failed',
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
  console.log('  GET /api/test/ai-workflow - Test AI workflow functionality');
});

export default app;