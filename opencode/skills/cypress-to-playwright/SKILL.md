---
name: cypress-to-playwright
description: "Convert Cypress tests in the Seneca web app to Playwright tests that match repository standards. Use when migrating files from cypress/e2e to playwright/tests, translating Cypress commands/assertions to Playwright APIs, and selecting auth strategy: persona for mocked non-e2e tests, or teacher/student/parent fixtures for real e2e tests."
metadata:
  author: js-williams
---

# Cypress to Playwright

## Conversion workflow

1. Classify the source test before writing code.
2. Create the target Playwright file in `playwright/tests/**` using existing folder conventions.
3. Port setup/auth/mocks first, then assertions/interactions.
4. Run only the migrated spec and fix locator or timing issues.
5. Remove Cypress-only patterns instead of shimming them.

## Decide test type first

Use this decision tree.

- If the test uses mocked API behavior, fixture data, or deterministic persona-style state, treat it as non-e2e and use `test.use({ persona: ... })`.
- If the test signs up/logs in a real user and exercises real backend flows, treat it as e2e and use one of the custom fixtures: `teacher`, `student`, or `parent`.

For non-e2e tests, choose persona values from `src/mocks/consts.ts` only:

- Student: `student-new`, `student-onboarded`, `student-premium`, `student-mis-onboarded`
- Teacher: `teacher-new`, `teacher-onboarded`, `teacher-revoked`, `teacher-mis-onboarded`, `teacher-mis-expired`, `school-teacher`, `teacher-premium`
- Parent: `parent-new`, `parent-onboarded`

## Required imports and structure

Always import Playwright primitives from `@/base`.

```ts
import { expect, test } from "@/base";
```

Common additional imports for mocked tests:

```ts
import { readFixture, url } from "@mocks/MockProvider";
import { http, HttpResponse } from "msw";
```

Keep file naming aligned with nearby tests in the same folder (`.spec.ts` in most cases).

## Auth patterns

Use one of these templates.

Mocked/non-e2e template:

```ts
import { expect, test } from "@/base";

test.use({ persona: "teacher-onboarded" });

test("...", async ({ page }) => {
  await page.goto("/teacher/classes");
  await expect(page.getByRole("heading", { name: "..." })).toBeVisible();
});
```

Real e2e template:

```ts
import { expect, test } from "@/base";

test("...", async ({ teacher: { page, userInfo } }) => {
  await page.goto("/teacher/home");
  await expect(page.getByText(userInfo.givenName)).toBeVisible();
});
```

Swap `teacher` for `student` or `parent` when appropriate.

## Command and assertion mapping

Use these direct translations as defaults.

- `cy.visit("/x")` -> `await page.goto("/x")`
- `cy.location("pathname").should("eq", "/x")` -> `await expect(page).toHaveURL("/x")`
- `cy.contains("text")` -> `page.getByText("text")` or role-based locator
- `cy.contains("button", "Save").click()` -> `await page.getByRole("button", { name: "Save" }).click()`
- `cy.get("[data-testid=a]")` -> `page.getByTestId("a")` (or semantic locator if possible)
- `cy.get("...").should("be.visible")` -> `await expect(locator).toBeVisible()`
- `cy.get("...").should("not.exist")` -> `await expect(locator).toHaveCount(0)`
- `cy.wait("@alias")` -> wait for request/response explicitly (`page.waitForRequest`, `page.waitForResponse`) only when needed
- `cy.intercept(...)` -> `mockEndpoints([http.get/post/...])`

Prefer semantic selectors (`getByRole`, `getByLabel`, `getByText`) over CSS selectors.

## Mocking conversion rules

When replacing `cy.intercept`:

1. Add `mockEndpoints` to the test args or `beforeEach` args.
2. Register handlers with MSW `http.*` APIs.
3. Use `url("service", "path")` from `@mocks/MockProvider` for internal endpoints.
4. Use `readFixture(...)` for existing JSON fixture payloads when possible.

Example:

```ts
test.beforeEach(async ({ mockEndpoints }) => {
  await mockEndpoints([
    http.get(url("userService", "user-info/me"), async () =>
      HttpResponse.json(
        await readFixture(
          "personas/teacher-onboarded/api/user-info/me/GET.json",
        ),
      ),
    ),
  ]);
});
```

## Behavior standards

- Preserve test intent, not Cypress syntax.
- Follow Playwright best practices for resilient tests (web-first assertions, semantic locators, and minimal hard-coded waits).
- Remove a single top-level `test.describe` wrapper when it is only grouping the file and adds no setup/options/shared context; rely on the file name to describe the suite.
- Avoid force-click migration patterns; use valid user interactions (`hover`, visible enabled controls, role-based locators).
- Keep assertions user-visible and deterministic.
- Avoid flaky timing assumptions. Prefer auto-waiting locators and explicit readiness checks over fixed sleeps/timeouts.
- Keep `test.describe`, `test.beforeEach`, and shared helpers when they improve readability.
- Keep static copy assertions aligned to product copy in this codebase.
- Test names should start with a lowercase letter and describe behavior, not implementation details.
- Test files should be in kebab-case and end with `.spec.ts`.

## Completion checklist

Before finishing a migration:

1. Confirm import is from `@/base`.
2. Confirm auth strategy is correct (`persona` for non-e2e, `teacher`/`student`/`parent` fixture for e2e).
3. Confirm persona string exists in `src/mocks/consts.ts`.
4. Confirm locators are semantic where practical.
5. Run the migrated test file at least 5 times and ensure it passes consistently (no flaky failures).
6. Delete the original Cypress spec only after the migrated Playwright spec is passing and covers the same behavior.
