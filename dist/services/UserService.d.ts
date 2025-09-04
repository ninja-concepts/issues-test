import { User } from '../types/ApiResponse';
export declare class UserService {
    private users;
    getAllUsers(): Promise<User[]>;
    getUserById(id: number): Promise<User | null>;
    createUser(userData: Omit<User, 'id' | 'createdAt'>): Promise<User>;
    updateUser(id: number, updates: Partial<Omit<User, 'id' | 'createdAt'>>): Promise<User | null>;
    deleteUser(id: number): Promise<boolean>;
}
//# sourceMappingURL=UserService.d.ts.map