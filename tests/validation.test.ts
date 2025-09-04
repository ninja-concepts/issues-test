import { Validator } from '../src/utils/validation';

describe('Validator', () => {
  describe('validateEmail', () => {
    it('should validate correct email formats', () => {
      const validEmails = [
        'test@example.com',
        'user.name@domain.co.uk',
        'firstname+lastname@example.org',
        'email@123.123.123.123'
      ];

      validEmails.forEach(email => {
        expect(Validator.validateEmail(email)).toBe(true);
      });
    });

    it('should reject invalid email formats', () => {
      const invalidEmails = [
        'invalid-email',
        '@missingdomain.com',
        'user@',
        'user..name@example.com',
        'user name@example.com'
      ];

      invalidEmails.forEach(email => {
        expect(Validator.validateEmail(email)).toBe(false);
      });
    });
  });

  describe('validateUserData', () => {
    it('should validate correct user data', () => {
      const validData = {
        name: 'John Doe',
        email: 'john@example.com',
        isActive: true
      };

      const result = Validator.validateUserData(validData);
      expect(result.isValid).toBe(true);
      expect(result.errors).toHaveLength(0);
    });

    it('should reject empty name', () => {
      const invalidData = {
        name: '',
        email: 'john@example.com',
        isActive: true
      };

      const result = Validator.validateUserData(invalidData);
      expect(result.isValid).toBe(false);
      expect(result.errors).toContain('Name is required and cannot be empty');
    });

    it('should reject invalid email', () => {
      const invalidData = {
        name: 'John Doe',
        email: 'invalid-email',
        isActive: true
      };

      const result = Validator.validateUserData(invalidData);
      expect(result.isValid).toBe(false);
      expect(result.errors).toContain('Email format is invalid');
    });

    it('should reject name longer than 100 characters', () => {
      const longName = 'a'.repeat(101);
      const invalidData = {
        name: longName,
        email: 'john@example.com',
        isActive: true
      };

      const result = Validator.validateUserData(invalidData);
      expect(result.isValid).toBe(false);
      expect(result.errors).toContain('Name must be less than 100 characters');
    });
  });

  describe('validateId', () => {
    it('should validate positive integers', () => {
      const validIds = [1, 2, 100, 9999];
      
      validIds.forEach(id => {
        const result = Validator.validateId(id);
        expect(result.isValid).toBe(true);
        expect(result.errors).toHaveLength(0);
      });
    });

    it('should reject zero and negative numbers', () => {
      const invalidIds = [0, -1, -100];
      
      invalidIds.forEach(id => {
        const result = Validator.validateId(id);
        expect(result.isValid).toBe(false);
        expect(result.errors).toContain('ID must be a positive number');
      });
    });

    it('should reject non-integer numbers', () => {
      const invalidIds = [1.5, 2.7, 3.14];
      
      invalidIds.forEach(id => {
        const result = Validator.validateId(id);
        expect(result.isValid).toBe(false);
        expect(result.errors).toContain('ID must be an integer');
      });
    });
  });
});