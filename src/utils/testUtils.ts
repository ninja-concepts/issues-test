/**
 * Test utilities for AI workflow demonstration
 */

export interface TestResult {
  success: boolean;
  message: string;
  timestamp: Date;
}

/**
 * Validates AI workflow functionality
 */
export function validateWorkflow(workflowName: string): TestResult {
  const startTime = new Date();
  
  try {
    // Simulate workflow validation
    if (!workflowName || workflowName.trim().length === 0) {
      return {
        success: false,
        message: 'Workflow name is required',
        timestamp: startTime
      };
    }

    // Check for valid workflow patterns
    const validPatterns = ['ai-commit', 'ai-pr', 'ai-workflow'];
    const isValid = validPatterns.some(pattern => 
      workflowName.toLowerCase().includes(pattern)
    );

    return {
      success: isValid,
      message: isValid 
        ? `Workflow '${workflowName}' validated successfully` 
        : `Invalid workflow name: ${workflowName}`,
      timestamp: startTime
    };
  } catch (error) {
    return {
      success: false,
      message: `Validation failed: ${error instanceof Error ? error.message : 'Unknown error'}`,
      timestamp: startTime
    };
  }
}

/**
 * Formats test results for display
 */
export function formatTestResult(result: TestResult): string {
  const status = result.success ? '✅ PASS' : '❌ FAIL';
  const timestamp = result.timestamp.toISOString();
  
  return `[${timestamp}] ${status}: ${result.message}`;
}

/**
 * Runs a complete test suite
 */
export function runTestSuite(): TestResult[] {
  const tests = [
    'ai-commit workflow',
    'ai-pr workflow', 
    'ai-workflow complete',
    'invalid-workflow'
  ];

  return tests.map(test => validateWorkflow(test));
}