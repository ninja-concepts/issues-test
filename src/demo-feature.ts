export interface DemoFeature {
  id: number;
  name: string;
  description: string;
  isEnabled: boolean;
  createdAt: Date;
}

export class DemoFeatureService {
  private features: DemoFeature[] = [
    {
      id: 1,
      name: 'Git Flow Integration',
      description: 'Complete Git Flow workflow with branch protection',
      isEnabled: true,
      createdAt: new Date('2024-01-01')
    },
    {
      id: 2,
      name: 'CI/CD Pipeline',
      description: 'GitHub Actions with lint, test, build, and security checks',
      isEnabled: true,
      createdAt: new Date('2024-01-02')
    }
  ];

  async getAllFeatures(): Promise<DemoFeature[]> {
    return new Promise((resolve) => {
      setTimeout(() => resolve([...this.features]), 50);
    });
  }

  async getFeatureById(id: number): Promise<DemoFeature | null> {
    return new Promise((resolve) => {
      setTimeout(() => {
        const feature = this.features.find(f => f.id === id);
        resolve(feature || null);
      }, 50);
    });
  }

  async toggleFeature(id: number): Promise<DemoFeature | null> {
    return new Promise((resolve) => {
      setTimeout(() => {
        const featureIndex = this.features.findIndex(f => f.id === id);
        if (featureIndex === -1) {
          resolve(null);
          return;
        }

        this.features[featureIndex].isEnabled = !this.features[featureIndex].isEnabled;
        resolve(this.features[featureIndex]);
      }, 50);
    });
  }
}