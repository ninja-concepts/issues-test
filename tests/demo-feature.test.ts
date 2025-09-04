import { DemoFeatureService } from '../src/demo-feature';

describe('DemoFeatureService', () => {
  let demoFeatureService: DemoFeatureService;

  beforeEach(() => {
    demoFeatureService = new DemoFeatureService();
  });

  describe('getAllFeatures', () => {
    it('should return all demo features', async () => {
      const features = await demoFeatureService.getAllFeatures();
      
      expect(features).toBeDefined();
      expect(Array.isArray(features)).toBe(true);
      expect(features.length).toBeGreaterThan(0);
      expect(features[0]).toHaveProperty('id');
      expect(features[0]).toHaveProperty('name');
      expect(features[0]).toHaveProperty('description');
      expect(features[0]).toHaveProperty('isEnabled');
      expect(features[0]).toHaveProperty('createdAt');
    });

    it('should return features with correct properties', async () => {
      const features = await demoFeatureService.getAllFeatures();
      
      features.forEach(feature => {
        expect(typeof feature.id).toBe('number');
        expect(typeof feature.name).toBe('string');
        expect(typeof feature.description).toBe('string');
        expect(typeof feature.isEnabled).toBe('boolean');
        expect(feature.createdAt).toBeInstanceOf(Date);
      });
    });
  });

  describe('getFeatureById', () => {
    it('should return a feature when valid ID is provided', async () => {
      const feature = await demoFeatureService.getFeatureById(1);
      
      expect(feature).toBeDefined();
      expect(feature?.id).toBe(1);
      expect(feature?.name).toBe('Git Flow Integration');
    });

    it('should return null when invalid ID is provided', async () => {
      const feature = await demoFeatureService.getFeatureById(999);
      
      expect(feature).toBeNull();
    });
  });

  describe('toggleFeature', () => {
    it('should toggle feature enabled state', async () => {
      // Get initial state
      const initialFeature = await demoFeatureService.getFeatureById(1);
      const initialEnabled = initialFeature?.isEnabled;
      
      // Toggle the feature
      const toggledFeature = await demoFeatureService.toggleFeature(1);
      
      expect(toggledFeature).toBeDefined();
      expect(toggledFeature?.isEnabled).toBe(!initialEnabled);
      expect(toggledFeature?.id).toBe(1);
    });

    it('should return null when toggling non-existent feature', async () => {
      const result = await demoFeatureService.toggleFeature(999);
      
      expect(result).toBeNull();
    });

    it('should persist toggle state', async () => {
      // Toggle feature
      const toggledFeature = await demoFeatureService.toggleFeature(2);
      const newState = toggledFeature?.isEnabled;
      
      // Get feature again to verify state persisted
      const retrievedFeature = await demoFeatureService.getFeatureById(2);
      
      expect(retrievedFeature?.isEnabled).toBe(newState);
    });
  });
});