const axios = require('axios');

const num1 = Math.floor(Math.random() * 100) + 1;
const num2 = Math.floor(Math.random() * 100) + 1;
const expected = num1 + num2;

(async () => {
  try {
    const res = await axios.post(
      'http://app.muratyurtdas.com/api/sum',
      { num1, num2 },
      { headers: { 'Content-Type': 'application/json' } }
    );

    if (res.status === 200 && res.data === expected) {
      console.log(`✅ E2E Test Passed: ${num1} + ${num2} = ${res.data}`);
      process.exit(0);
    } else {
      console.error(`❌ E2E Test Failed: ${num1} + ${num2} = ${res.data} (expected ${expected})`);
      process.exit(1);
    }
  } catch (err) {
    console.error('❌ E2E Test Error:', err.message);
    process.exit(1);
  }
})();
