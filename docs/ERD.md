# Ear Trainer — Database ERD

SQLite database: `ear_trainer.db` (version 4)

## Mermaid ERD

```mermaid
erDiagram

    quiz_progress {
        TEXT exercise PK
        INTEGER score
        INTEGER streak
        INTEGER question
        INTEGER last_correct
    }

    answer_history {
        INTEGER id PK
        TEXT exercise FK
        INTEGER correct
        INTEGER answered_at
    }

    achievements {
        TEXT id PK
        INTEGER unlocked
    }

    exercises {
        TEXT id PK
        INTEGER used
    }

    seen_pages {
        TEXT page PK
        INTEGER seen
    }

    quiz_progress ||--o{ answer_history : "exercise"
```

## Notes

- **quiz_progress ↔ answer_history**: Logical relationship via shared `exercise` key. One quiz_progress row has many answer_history rows. No SQL foreign key enforced (sqflite).
- **achievements**: Standalone. `id` values: `first_note`, `perfect_pitch`, `pitch_veteran`, `ear_opening`, `interval_instinct`, `all_rounder`, `flawless`, `completionist`.
- **exercises**: Standalone. Tracks which exercises used. `id` values: `pitch`, `interval`, `scale`.
- **seen_pages**: Standalone. Tracks first-visit per page for onboarding.
- **Note** (`lib/models/note.dart`): Static const list, no DB table.
- All `INTEGER` boolean fields use 0/1.
- `answered_at`: epoch milliseconds.
