# Rubbert

This repository contains Rubbert, a Q*bert-like developed using DragonRuby. This
is my first campaign in video game development. I'm using this project to start
to learn about the kinds of problems game developers must face when starting a
greenfield project.

## Quick links

- [DragonRuby][dr] ([documentation][dr-docs])
- [Q*bert][qb]

[dr]: https://dragonruby.org
[dr-docs]: https://docs.dragonruby.org
[qb]: https://en.wikipedia.org/wiki/Q*bert

## Development

This repository should be fully portable, containing everything you need to run
or start developing the game. You can use the binstubs provided in `bin/` to run
the game via DragonRuby or run tests:

  - `bin/dev`: Runs the game as inteneded to play by end-users (someday).
  - `bin/tests`: Run the entire test suite.

If you want to bypass the DragonRuby binaries committed to the codebase, you can
create an `.env` file at the project root and set `DRAGONRUBY_EXEC` as a path to
another DragonRuby binary:

    DRAGONRUBY_EXEC=/path/to/my/custom/dragonruby-binary

Right now it's as simple as that. Though, as the test suite grows I would like
to provide ergonomic ways to run individual tests or test files.
