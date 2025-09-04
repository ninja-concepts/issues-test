import request from 'supertest';
import app from '../src/index';

describe('API Endpoints', () => {
  describe('GET /', () => {
    it('should return welcome message', async () => {
      const response = await request(app).get('/');
      
      expect(response.status).toBe(200);
      expect(response.body).toHaveProperty('success', true);
      expect(response.body).toHaveProperty('data');
      expect(response.body).toHaveProperty('message');
      expect(response.body.data).toContain('Hello World');
    });
  });

  describe('GET /api/users', () => {
    it('should return all users', async () => {
      const response = await request(app).get('/api/users');
      
      expect(response.status).toBe(200);
      expect(response.body).toHaveProperty('success', true);
      expect(response.body).toHaveProperty('data');
      expect(Array.isArray(response.body.data)).toBe(true);
      expect(response.body.data.length).toBeGreaterThan(0);
    });

    it('should return users with correct structure', async () => {
      const response = await request(app).get('/api/users');
      const firstUser = response.body.data[0];
      
      expect(firstUser).toHaveProperty('id');
      expect(firstUser).toHaveProperty('name');
      expect(firstUser).toHaveProperty('email');
      expect(firstUser).toHaveProperty('createdAt');
      expect(firstUser).toHaveProperty('isActive');
    });
  });

  describe('GET /api/users/:id', () => {
    it('should return specific user when valid ID provided', async () => {
      const response = await request(app).get('/api/users/1');
      
      expect(response.status).toBe(200);
      expect(response.body).toHaveProperty('success', true);
      expect(response.body.data).toHaveProperty('id', 1);
      expect(response.body.data).toHaveProperty('name');
      expect(response.body.data).toHaveProperty('email');
    });

    it('should return 404 when user not found', async () => {
      const response = await request(app).get('/api/users/999');
      
      expect(response.status).toBe(404);
      expect(response.body).toHaveProperty('success', false);
      expect(response.body.data).toBeNull();
      expect(response.body.message).toContain('not found');
    });

    it('should handle invalid ID format gracefully', async () => {
      const response = await request(app).get('/api/users/invalid');
      
      expect(response.status).toBe(404);
      expect(response.body).toHaveProperty('success', false);
    });
  });
});