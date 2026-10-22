create table if not exists public.products (
  id text primary key,
  name text not null check (length(trim(name)) between 1 and 120),
  categories text[] not null default '{}',
  price integer not null check (price >= 0),
  image_url text not null,
  sort_order integer not null default 0,
  updated_at timestamptz not null default now()
);

alter table public.products enable row level security;
grant select on public.products to anon, authenticated;
grant insert, update on public.products to authenticated;
grant usage on schema public to anon, authenticated;

drop policy if exists "Products are visible to everyone" on public.products;
create policy "Products are visible to everyone"
  on public.products for select
  using (true);

drop policy if exists "Owner can insert products" on public.products;
create policy "Owner can insert products"
  on public.products for insert to authenticated
  with check (lower(coalesce(auth.jwt() ->> 'email', '')) = 'benedictabrenyah8@gmail.com');

drop policy if exists "Owner can update products" on public.products;
create policy "Owner can update products"
  on public.products for update to authenticated
  using (lower(coalesce(auth.jwt() ->> 'email', '')) = 'benedictabrenyah8@gmail.com')
  with check (lower(coalesce(auth.jwt() ->> 'email', '')) = 'benedictabrenyah8@gmail.com');

insert into public.products (id, name, categories, price, image_url, sort_order)
values
  ('i2', 'Black curly pixie wig', array['pixie','curly'], 500, 'Assets/WhatsApp Image 2026-10-22 at 10.52.49 AM (15).jpeg', 1),
  ('i11', 'Burgundy bob wig with dark roots', array['bob'], 1700, 'Assets/WhatsApp Image 2026-10-22 at 10.52.49 AM (6).jpeg', 2),
  ('i4', 'Deep curly bob wig', array['curly'], 900, 'Assets/WhatsApp Image 2026-10-22 at 10.52.49 AM (13).jpeg', 3),
  ('i5', 'Chestnut brown body wave wig', array['long'], 3500, 'Assets/WhatsApp Image 2026-10-22 at 10.52.49 AM (12).jpeg', 4),
  ('i3', 'Burgundy finger curl pixie wig', array['pixie','curly'], 550, 'Assets/WhatsApp Image 2026-10-22 at 10.52.49 AM (14).jpeg', 5),
  ('i7', 'Brown bob wig with bangs', array['bob'], 1700, 'Assets/WhatsApp Image 2026-10-22 at 10.52.49 AM (10).jpeg', 6),
  ('i6', 'Long silky straight wigs in black and caramel highlights', array['long'], 5500, 'Assets/WhatsApp Image 2026-10-22 at 10.52.49 AM (11).jpeg', 7),
  ('i12', 'Short black pixie cut wig', array['pixie'], 350, 'Assets/WhatsApp Image 2026-10-22 at 10.52.49 AM (5).jpeg', 8),
  ('i13', 'Sleek black lace bob wig', array['bob'], 800, 'Assets/WhatsApp Image 2026-10-22 at 10.52.49 AM (4).jpeg', 9),
  ('i8', 'Bouncy black bob wig', array['bob'], 1200, 'Assets/WhatsApp Image 2026-10-22 at 10.52.49 AM (8).jpeg', 10),
  ('i15', 'Black body wave lace wig', array['long'], 1800, 'Assets/WhatsApp Image 2026-10-22 at 10.52.49 AM (2).jpeg', 11),
  ('i14', 'Straight bob wig with full bangs', array['bob'], 700, 'Assets/WhatsApp Image 2026-10-22 at 10.52.49 AM (3).jpeg', 12),
  ('i16', 'Curly bob lace wig', array['curly'], 1800, 'Assets/WhatsApp Image 2026-10-22 at 10.52.49 AM (1).jpeg', 13),
  ('i10', 'Layered black lace bob wig', array['bob'], 1200, 'Assets/WhatsApp Image 2026-10-22 at 10.52.49 AM (7).jpeg', 14),
  ('i17', 'Black finger wave pixie wig', array['pixie','curly'], 400, 'Assets/WhatsApp Image 2026-10-22 at 10.52.49 AM.jpeg', 15)
on conflict (id) do nothing;

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('product-images', 'product-images', true, 8388608, array['image/jpeg','image/png','image/webp'])
on conflict (id) do update set
  public = excluded.public,
  file_size_limit = excluded.file_size_limit,
  allowed_mime_types = excluded.allowed_mime_types;

drop policy if exists "Product images are public" on storage.objects;
create policy "Product images are public"
  on storage.objects for select
  using (bucket_id = 'product-images');

drop policy if exists "Owner can upload product images" on storage.objects;
create policy "Owner can upload product images"
  on storage.objects for insert to authenticated
  with check (
    bucket_id = 'product-images'
    and lower(coalesce(auth.jwt() ->> 'email', '')) = 'benedictabrenyah8@gmail.com'
  );

drop policy if exists "Owner can update product images" on storage.objects;
create policy "Owner can update product images"
  on storage.objects for update to authenticated
  using (
    bucket_id = 'product-images'
    and lower(coalesce(auth.jwt() ->> 'email', '')) = 'benedictabrenyah8@gmail.com'
  )
  with check (
    bucket_id = 'product-images'
    and lower(coalesce(auth.jwt() ->> 'email', '')) = 'benedictabrenyah8@gmail.com'
  );

drop policy if exists "Owner can delete product images" on storage.objects;
create policy "Owner can delete product images"
  on storage.objects for delete to authenticated
  using (
    bucket_id = 'product-images'
    and lower(coalesce(auth.jwt() ->> 'email', '')) = 'benedictabrenyah8@gmail.com'
  );
