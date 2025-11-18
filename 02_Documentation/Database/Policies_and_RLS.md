-- Option A (used for local dev on rules linking): disable RLS temporarily
alter table public.rules disable row level security;
alter table public.entry_rule_links disable row level security;

-- Option B (keep RLS on entries but allow first-time duration write)
alter table public.entries enable row level security;

drop policy if exists dev_allow_first_duration_update on public.entries;

create policy dev_allow_first_duration_update
on public.entries
for update
to anon
using (duration_ms is null)
with check (duration_ms is not null);
