export interface ValidationResult {
  isValid: boolean;
  errors: string[];
}

export class Validator {
  static validateEmail(email: string): boolean {
    const emailRegex = /^[^\s@.]+[^\s@]*@[^\s@]+\.[^\s@.]+[^\s@]*$/;
    return emailRegex.test(email);
  }

  static validateUserData(data: {
    name?: string;
    email?: string;
    isActive?: boolean;
  }): ValidationResult {
    const errors: string[] = [];

    if (data.name !== undefined) {
      if (!data.name || data.name.trim().length === 0) {
        errors.push('Name is required and cannot be empty');
      }
      if (data.name && data.name.length > 100) {
        errors.push('Name must be less than 100 characters');
      }
    }

    if (data.email !== undefined) {
      if (!data.email || data.email.trim().length === 0) {
        errors.push('Email is required and cannot be empty');
      }
      if (data.email && !this.validateEmail(data.email)) {
        errors.push('Email format is invalid');
      }
    }

    if (data.isActive !== undefined && typeof data.isActive !== 'boolean') {
      errors.push('isActive must be a boolean value');
    }

    return {
      isValid: errors.length === 0,
      errors
    };
  }

  static validateId(id: number): ValidationResult {
    const errors: string[] = [];

    if (!Number.isInteger(id)) {
      errors.push('ID must be an integer');
    }

    if (id <= 0) {
      errors.push('ID must be a positive number');
    }

    return {
      isValid: errors.length === 0,
      errors
    };
  }
}