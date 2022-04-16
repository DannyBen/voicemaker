# Testing Notes

## Basics

1. We are using RSpec, [Runfile][1] and [RSpec Approvals][2].
2. Run tests with `run spec`.

## Philosophy

1. The tests are designed to work without an API key.
2. To achieve this, we work against a mock API that responds with the expected
   responses.
3. The mock server must run before running tests (`run mockserver`).
4. The integration tests are designed to run if an API key is defined in the
   `VOICEMAKER_TEST_API_KEY` environment variable. These tests go end to end
   with the real API.
5. Full test coverage is still achieved even without the integration tests.


[1]: https://github.com/DannyBen/runfile
[2]: https://github.com/DannyBen/rspec_approvals/