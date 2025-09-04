export interface ValidationResult {
    isValid: boolean;
    errors: string[];
}
export declare class Validator {
    static validateEmail(email: string): boolean;
    static validateUserData(data: {
        name?: string;
        email?: string;
        isActive?: boolean;
    }): ValidationResult;
    static validateId(id: number): ValidationResult;
}
//# sourceMappingURL=validation.d.ts.map