import { UserService } from '../src/services/UserService';

describe('UserService', () => {
  let userService: UserService;

  beforeEach(() => {
    userService = new UserService();
  });

  describe('getAllUsers', () => {
    it('should return all users', async () => {
      const users = await userService.getAllUsers();
      
      expect(users).toBeDefined();
      expect(Array.isArray(users)).toBe(true);
      expect(users.length).toBeGreaterThan(0);
      expect(users[0]).toHaveProperty('id');
      expect(users[0]).toHaveProperty('name');
      expect(users[0]).toHaveProperty('email');
    });
  });

  describe('getUserById', () => {
    it('should return a user when valid ID is provided', async () => {
      const user = await userService.getUserById(1);
      
      expect(user).toBeDefined();
      expect(user?.id).toBe(1);
      expect(user?.name).toBe('John Doe');
      expect(user?.email).toBe('john.doe@example.com');
    });

    it('should return null when invalid ID is provided', async () => {
      const user = await userService.getUserById(999);
      
      expect(user).toBeNull();
    });

    it('should return null for negative ID', async () => {
      const user = await userService.getUserById(-1);
      
      expect(user).toBeNull();
    });
  });

  describe('createUser', () => {
    it('should create a new user successfully', async () => {
      const newUserData = {
        name: 'Test User',
        email: 'test@example.com',
        isActive: true
      };

      const createdUser = await userService.createUser(newUserData);
      
      expect(createdUser).toBeDefined();
      expect(createdUser.id).toBeDefined();
      expect(createdUser.name).toBe(newUserData.name);
      expect(createdUser.email).toBe(newUserData.email);
      expect(createdUser.isActive).toBe(newUserData.isActive);
      expect(createdUser.createdAt).toBeInstanceOf(Date);
    });

    it('should assign unique IDs to new users', async () => {
      const userData1 = {
        name: 'User 1',
        email: 'user1@example.com',
        isActive: true
      };
      const userData2 = {
        name: 'User 2',
        email: 'user2@example.com',
        isActive: true
      };

      const user1 = await userService.createUser(userData1);
      const user2 = await userService.createUser(userData2);
      
      expect(user1.id).not.toBe(user2.id);
    });
  });

  describe('updateUser', () => {
    it('should update an existing user successfully', async () => {
      const updates = {
        name: 'Updated Name',
        isActive: false
      };

      const updatedUser = await userService.updateUser(1, updates);
      
      expect(updatedUser).toBeDefined();
      expect(updatedUser?.name).toBe(updates.name);
      expect(updatedUser?.isActive).toBe(updates.isActive);
      expect(updatedUser?.id).toBe(1);
    });

    it('should return null when updating non-existent user', async () => {
      const updates = { name: 'Updated Name' };
      const result = await userService.updateUser(999, updates);
      
      expect(result).toBeNull();
    });
  });

  describe('deleteUser', () => {
    it('should delete an existing user successfully', async () => {
      const result = await userService.deleteUser(1);
      
      expect(result).toBe(true);
      
      // Verify user is actually deleted
      const deletedUser = await userService.getUserById(1);
      expect(deletedUser).toBeNull();
    });

    it('should return false when deleting non-existent user', async () => {
      const result = await userService.deleteUser(999);
      
      expect(result).toBe(false);
    });
  });
});