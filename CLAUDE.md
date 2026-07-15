# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project overview

Rails 8.1 app generated from the [lewagon/rails-templates](https://github.com/lewagon/rails-templates) boilerplate (Le Wagon coding bootcamp). It is currently a fresh skeleton: the only route is `root to: "pages#home"`, there are no models/migrations yet (`db/schema.rb` defines no tables), and no custom Stimulus controllers beyond the generated `hello_controller.js`.

Ruby version: 3.3.5 (see `.ruby-version`).

## Commands

- `bin/setup` — install dependencies, prepare the database, start the server (`--skip-server` to skip the last step).
- `bin/dev` — run the Rails server (`bin/rails server` under the hood).
- `bin/rails test` — run the test suite (Minitest, fixtures-based, parallelized across processors).
- `bin/rails test test/models/foo_test.rb` — run a single test file.
- `bin/rails test test/models/foo_test.rb:12` — run a single test at a given line.
- `bin/rails test:system` — run system tests (Capybara + Selenium); not part of `bin/ci` by default.
- `bin/rubocop` — lint Ruby (rubocop-rails-omakase base config, see `.rubocop.yml`).
- `bin/brakeman --quiet --no-pager --exit-on-warn --exit-on-error` — static security analysis.
- `bin/bundler-audit` — audit gems for known vulnerabilities.
- `bin/importmap audit` — audit importmap JS dependencies for vulnerabilities.
- `bin/ci` — runs the full CI pipeline defined in `config/ci.rb` (setup, rubocop, bundler-audit, importmap audit, brakeman, `bin/rails test`, then reseeds the test DB). Use this to reproduce CI locally before pushing.

## Architecture

- **Asset pipeline**: Propshaft + Sprockets (`sprockets-rails`), with Bootstrap 5.3, `autoprefixer-rails`, `font-awesome-sass`, and `sassc-rails` for SCSS. JavaScript is managed via `importmap-rails` (no bundler/webpack) with Turbo and Stimulus (Hotwire stack).
- **Forms**: `simple_form` (heartcombo fork via GitHub) is the form builder gem — prefer it over raw `form_with` when building forms.
- **Background jobs / cache / cable**: Rails 8's "solid" trio — `solid_queue` (jobs), `solid_cache` (cache), `solid_cable` (Action Cable) — all backed by the primary Postgres database via separate schemas (`db/queue_schema.rb`, `db/cache_schema.rb`, `db/cable_schema.rb`). No Redis dependency.
- **Database**: PostgreSQL only. Production splits into four physical databases (primary, cache, queue, cable) each with their own migration path (see `config/database.yml`).
- **Generators**: configured in `config/application.rb` to skip generating assets, helpers, and fixtures by default (`generate.assets false`, `generate.helper false`, `generate.test_framework :test_unit, fixture: false`).
- **Deployment**: Kamal (`config/deploy.yml`, `.kamal/`) deploying as a Docker container (`Dockerfile`), fronted by Thruster for asset caching/compression and X-Sendfile acceleration.
- **Testing**: Minitest with fixtures (despite the generator default above, `test_helper.rb` loads `fixtures :all`), parallelized by default. Capybara + Selenium available for system tests but not wired into `bin/ci`.

## Linting notes

`.rubocop.yml` excludes `bin/`, `db/`, `config/`, `script/`, `support/`, and `test/` from linting, and disables several omakase style cops (see the file for the full list) — notably line length is raised to 120 and frozen-string-literal comments are not required.
