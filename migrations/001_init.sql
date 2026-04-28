CREATE TABLE IF NOT EXISTS task (
  id UUID PRIMARY KEY,
  task_name TEXT NOT NULL,
  queue TEXT NOT NULL DEFAULT 'default',
  payload JSONB NOT NULL DEFAULT '{}'::jsonb,
  state TEXT NOT NULL,
  priority INT NOT NULL DEFAULT 0,
  run_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  lease_expires_at TIMESTAMPTZ NULL,
  attempt INT NOT NULL DEFAULT 0,
  max_attempts INT NOT NULL DEFAULT 25,
  last_error TEXT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
); 

CREATE INDEX IF NOT EXISTS idx_tasks_runnable
  ON tasks (queue, state, run_at, priority DESC);

CREATE INDEX IF NOT EXISTS idx_tasks_lease_expires
  ON tasks (lease_expires_at);

CREATE TABLE IF NOT EXISTS invoices (
    id UUID PRIMARY KEY,
    customer_id TEXT NOT NULL,
    amount_cents BIGINT NOT NULL,
    currency TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
  );

CREATE TABLE IF NOT EXISTS outbox_messages (
  id UUID PRIMARY KEY,
  event_type TEXT NOT NULL,
  destination TEXT NOT NULL,
  payload JSONB NOT NULL DEFAULT '{}'::jsonb,
  dedupe_key TEXT NOT NULL,

  state TEXT NOT NULL,
  attempt INT NOT NULL DEFAULT 0,
  max_attempts INT NOT NULL DEFAULT 25,
  next_attempt_at TIMESTAMPTZ NO NULL DEFAULT now(),
  locked_until TIMESTAMPTZ NULL,
  last_error TEXT NULL,

  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
);

CREATE UNIQUE INDEX IF NOT EXISTS uq_outbox_destination_dedupe
  ON outbox_messages (destination, dedupe_key);

CREATE INDEX IF NOT EXISTS idx_outbox_pending
  ON outbox_messages (state, next_attempt_at);

CREATE INDEX IF NOT EXISTS idx_outbox_locked_until
  ON outbox_messages (locked_until);
