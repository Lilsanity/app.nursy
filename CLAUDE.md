# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project overview

Nursy is a Rails 8.1 app for finding and booking home-visit nurses ("infirmières à domicile"), built on the [lewagon/rails-templates](https://github.com/lewagon/rails-templates) boilerplate (Le Wagon coding bootcamp). Domain logic, UI copy, and commit messages are in French.

Ruby version: 3.3.5 (see `.ruby-version`).

## Commands

- `bin/setup` — install dependencies, prepare the database, start the server (`--skip-server` to skip the last step).
- `bin/dev` — run the Rails server (`bin/rails server` under the hood).
- `bin/rails test` — run the test suite (Minitest, fixtures-based, parallelized across processors).
- `bin/rails test test/models/nurse_test.rb` — run a single test file.
- `bin/rails test test/models/nurse_test.rb:12` — run a single test at a given line.
- `bin/rails test:system` — run system tests (Capybara + Selenium); not part of `bin/ci` by default.
- `bin/rubocop` — lint Ruby (rubocop-rails-omakase base config, see `.rubocop.yml`).
- `bin/brakeman --quiet --no-pager --exit-on-warn --exit-on-error` — static security analysis.
- `bin/bundler-audit` — audit gems for known vulnerabilities.
- `bin/importmap audit` — audit importmap JS dependencies for vulnerabilities.
- `bin/ci` — runs the full CI pipeline defined in `config/ci.rb` (setup, rubocop, bundler-audit, importmap audit, brakeman, `bin/rails test`, then reseeds the test DB). Use this to reproduce CI locally before pushing.
- `bin/rails db:seed` — seed the database with sample communes, specialties, a test user, and nurses (see `db/seeds.rb`).

## Architecture

- **Domain model**: `User` (client, Devise-authenticated) books an `Appointment` with a `Nurse` for one of the nurse's `Availability` slots; a `Review` can follow an appointment. Nurses belong to a `Commune` (French town/postal code, with lat/lng) and have many `Specialty` records through the `NurseSpecialty` join model. See `db/schema.rb` for the full column list.
- **Auth**: Devise on `User` only (`database_authenticatable, registerable, recoverable, rememberable, validatable`). Permitted sign-up/account-update params (`first_name`, `last_name`) are configured in `ApplicationController#configure_permitted_parameters`. Nurses are not a Devise-authenticatable model — they're managed as plain records.
- **Search**: `Nurse` uses Searchkick (`searchkick locations: [:location]`) backed by Elasticsearch, indexing `first_name`, `last_name`, and a `location` lat/lon derived from the nurse's commune. `NursesController#index` and `PagesController#home` both do a geo search — `Nurse.search("*", where: { location: { near: {...}, within: "30km" } })` — around a commune resolved via `Commune.find_by("name ILIKE ?", params[:commune])`. Elasticsearch must be running locally for search-backed pages/tests to work (no `docker-compose.yml` is checked in yet — start/connect to ES via whatever local method you're using).
- **Asset pipeline**: Propshaft + Sprockets (`sprockets-rails`), with Bootstrap 5.3, `autoprefixer-rails`, `font-awesome-sass`, and `sassc-rails` for SCSS. JavaScript is managed via `importmap-rails` (no bundler/webpack) with Turbo and Stimulus (Hotwire stack).
- **Forms**: `simple_form` (heartcombo fork via GitHub) is the form builder gem — prefer it over raw `form_with` when building forms. Bootstrap form styling is wired up in `config/initializers/simple_form_bootstrap.rb`.
- **Background jobs / cache / cable**: Rails 8's "solid" trio — `solid_queue` (jobs), `solid_cache` (cache), `solid_cable` (Action Cable) — all backed by the primary Postgres database via separate schemas (`db/queue_schema.rb`, `db/cache_schema.rb`, `db/cable_schema.rb`). No Redis dependency.
- **Database**: PostgreSQL only. Production splits into four physical databases (primary, cache, queue, cable) each with their own migration path (see `config/database.yml`).
- **Generators**: configured in `config/application.rb` to skip generating assets, helpers, and fixtures by default (`generate.assets false`, `generate.helper false`, `generate.test_framework :test_unit, fixture: false`).
- **Deployment**: Kamal (`config/deploy.yml`, `.kamal/`) deploying as a Docker container (`Dockerfile`), fronted by Thruster for asset caching/compression and X-Sendfile acceleration.
- **Testing**: Minitest with fixtures (despite the generator default above, `test_helper.rb` loads `fixtures :all`), parallelized by default. Capybara + Selenium available for system tests but not wired into `bin/ci`. Controller/model tests exist for the current domain models (`test/models/*`, `test/controllers/nurses_controller_test.rb`); tests exercising `NursesController#index`/`PagesController#home` depend on Elasticsearch being reachable.

## Linting notes

`.rubocop.yml` excludes `bin/`, `db/`, `config/`, `script/`, `support/`, and `test/` from linting, and disables several omakase style cops (see the file for the full list) — notably line length is raised to 120 and frozen-string-literal comments are not required.
