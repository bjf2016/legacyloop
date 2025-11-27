## 2.4 Entry Image Attachment (MVP+)
Parents may optionally attach an image to any entry. Images are private and follow the same RLS rules as audio. Each entry may include one (1) image for MVP. The image enhances the emotional context of the memory and appears in both the Cast Entry list and entry detail card.

### Requirements
- Upload or capture image on mobile (file picker or camera API)
- Store in private Supabase bucket under `images/<uid>/<castId>/<entryId>.jpg`
- Signed URL TTL ≤ 15 minutes; no signed URLs persisted
- `entries.image_path` column added
- Only entry owner may upload/read image
- Thumbnail shown inline; full modal view on tap/click

### Future Enhancements (v1.4+)
- Up to 3 images per entry
- Optional AI caption generation for photos
- Combined “Moment Card” view (photo + audio + summary)
- Auto-generated fallback image if parent provides none
