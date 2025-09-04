import { User } from '../types/ApiResponse';

export class UserService {
  private users: User[] = [
    {
      id: 1,
      name: 'John Doe',
      email: 'john.doe@example.com',
      createdAt: new Date('2024-01-01'),
      isActive: true
    },
    {
      id: 2,
      name: 'Jane Smith',
      email: 'jane.smith@example.com',
      createdAt: new Date('2024-01-02'),
      isActive: true
    },
    {
      id: 3,
      name: 'Bob Johnson',
      email: 'bob.johnson@example.com',
      createdAt: new Date('2024-01-03'),
      isActive: false
    }
  ];

  async getAllUsers(): Promise<User[]> {
    // Simulate async database call
    return new Promise((resolve) => {
      setTimeout(() => resolve([...this.users]), 100);
    });
  }

  async getUserById(id: number): Promise<User | null> {
    // Simulate async database call
    return new Promise((resolve) => {
      setTimeout(() => {
        const user = this.users.find(u => u.id === id);
        resolve(user || null);
      }, 100);
    });
  }

  async createUser(userData: Omit<User, 'id' | 'createdAt'>): Promise<User> {
    return new Promise((resolve) => {
      setTimeout(() => {
        const newUser: User = {
          id: Math.max(...this.users.map(u => u.id)) + 1,
          createdAt: new Date(),
          ...userData
        };
        this.users.push(newUser);
        resolve(newUser);
      }, 100);
    });
  }

  async updateUser(id: number, updates: Partial<Omit<User, 'id' | 'createdAt'>>): Promise<User | null> {
    return new Promise((resolve) => {
      setTimeout(() => {
        const userIndex = this.users.findIndex(u => u.id === id);
        if (userIndex === -1) {
          resolve(null);
          return;
        }

        this.users[userIndex] = { ...this.users[userIndex], ...updates };
        resolve(this.users[userIndex]);
      }, 100);
    });
  }

  async deleteUser(id: number): Promise<boolean> {
    return new Promise((resolve) => {
      setTimeout(() => {
        const userIndex = this.users.findIndex(u => u.id === id);
        if (userIndex === -1) {
          resolve(false);
          return;
        }

        this.users.splice(userIndex, 1);
        resolve(true);
      }, 100);
    });
  }
}