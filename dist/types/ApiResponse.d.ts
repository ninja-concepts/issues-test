export interface ApiResponse<T> {
    success: boolean;
    data: T;
    message: string;
    error?: string;
}
export interface User {
    id: number;
    name: string;
    email: string;
    createdAt: Date;
    isActive: boolean;
}
//# sourceMappingURL=ApiResponse.d.ts.map