// e2e/sum.test.js
const axios = require('axios');

(async () => {
  try {
    const res = await axios.post('https://app.muratyurtdas.com/api/sum', {
      a: 5,
      b: 8
    });

    if (res.status === 200 && res.data.result === 13) {
      console.log('✅ E2E Test Passed: 5 + 8 =', res.data.result);
      process.exit(0);
    } else {
      console.error('❌ E2E Test Failed: Unexpected result:', res.data);
      process.exit(1);
    }
  } catch (err) {
    console.error('❌ E2E Test Error:', err.message);
    process.exit(1);
  }
})();
