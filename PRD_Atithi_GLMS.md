# PRD — Guest Lifecycle Management System
**Client:** Event Hospitality Planner
**Platform:** Native Mobile (iOS & Android) — Standalone, No Internet Required
**Version:** 2.1
**Status:** Finalized

---

## 1. Problem Statement

The client manages hospitality for large-scale events across multiple hotels. Everything is currently tracked in Excel sheets, causing sync issues, no real-time visibility, and error-prone billing at checkout.

---

## 2. Goals

- Single device, single user app for the coordinator
- Full guest and room management across all hotels for an event
- Accurate per-guest service billing
- Excel export as the primary output

---

## 3. User

Single user — **Coordinator**. No login, no auth required (standalone, personal device).

---

## 4. Core Concepts

- **Event** — Wedding or corporate. Has a guest list and one or more hotels.
- **Hotel** — Has rooms by category. Belongs to an event.
- **Room** — Belongs to a hotel. Has a category and status (available/occupied/maintenance).
- **Guest** — Has a pre-assigned room category. Can be checked in, transferred, or checked out. Can stay across multiple hotels in sequence.
- **Service Charge** — Billable service logged against a guest (minibar, laundry, etc.)

---

## 5. Features

### 5.1 Event Setup
- Create event (name, type: wedding/corporate, dates)
- Add multiple hotels to an event
- Import guest list via CSV/Excel (name, room category, any metadata)
- Manually enter room inventory per hotel (room number, category, status)
- Configure service types per event (e.g., minibar, laundry, room service)
- Duplicate a past event as a template for a new one

### 5.2 Room & Inventory Management
- View all hotels and their room inventory in one place
- Filter rooms by hotel, category, status (available/occupied/maintenance)
- Edit room status manually (e.g., mark under maintenance)
- At-a-glance count: total, occupied, available per hotel and per category

### 5.3 Guest Management
- View full guest list with current hotel, room, and status
- Search guests by name
- Guest tags: VIP flag, Close Relative flag, Special Requests (free text) — informational only
- Check in guest → select hotel → select available room matching category → confirm
- Room change → move guest to another room within same or different hotel
- Guest transfer between hotels → billing history carries over
- Check out guest → room freed, bill locked
- **Undo checkout** — available for 5 minutes post-action with a visible countdown; after 5 minutes action is permanent

### 5.4 Service Billing
- Log service charge against any checked-in guest (type, amount, date/time)
- Running bill visible per guest at any time
- Bill editable before checkout, locked after

### 5.5 Dashboard
- Across all hotels: total/occupied/available, breakdown by category
- Full guest list: current hotel, room, status, running bill total
- Guest tags visible on list
- Quick filters: by hotel, by room status, by guest status, by tag (VIP, close relative)

### 5.6 Export
- Per-guest itemized bill
- Per-hotel billing summary
- Consolidated event billing report
- Full guest movement and room history
- All exports in Excel (.xlsx)
- Shared via native share sheet (WhatsApp, AirDrop, email, etc.)

---

## 6. Data & Storage

- All data stored locally on device (SQLite or equivalent)
- No backend, no sync, no internet dependency
- Data persists until manually deleted by user
- Past events viewable and archived on device
- Past events can be duplicated as templates

---

## 7. User Flows

**Event Setup:**
Create event → add hotels → enter room inventory per hotel → import guest list → configure service types

**Check-in:**
Search guest → select hotel → assign available room → confirm → room marked occupied

**Room Change:**
Select guest → change room (same or different hotel) → confirm → old room freed

**Guest Transfer:**
Select guest → assign to new hotel → select room → confirm → stay history updated, billing carries over

**Service Logging:**
Select checked-in guest → add service (type + amount) → saved with timestamp

**Checkout:**
Select guest → checkout → 5 min undo window with countdown → bill locked after window expires

**Undo Checkout:**
Within 5 minutes → tap undo on countdown prompt → guest reinstated, room re-occupied, bill unlocked

**Export:**
Go to event → export → select report type → share via native share sheet

---

## 8. Data Model (High Level)

```
Event
  └── Hotels
        └── Rooms (number, category, status)
  └── Guests
        └── Tags (VIP, close relative, special requests)
        └── StaySegments (hotel, room, check-in, check-out) — multiple per guest
        └── ServiceCharges (type, amount, timestamp)
        └── Bill (aggregated, locked on checkout)
  └── ServiceTypes (configurable per event)
```

---

## 9. Non-Functional Requirements

- **Platform:** iOS & Android, built simultaneously
- **Connectivity:** Fully offline, zero internet dependency
- **Storage:** Local only, no cloud backup
- **Single user:** No auth, no roles
- **Export:** .xlsx via native share sheet
- **Guest scale:** Up to 2000 guests per event
- **Undo window:** 5 minutes post-action with visible countdown

---

## 10. Out of Scope (v1)

- Internet/backend/sync
- Multi-user or role-based access
- Web app
- Room rent/booking cost billing
- Hotel PMS integration
- Payment processing
- Guest-facing portal
- Push notifications
- Cloud backup or data recovery

---

## 11. Screen Inventory

| # | Screen | Description |
|---|---|---|
| 1 | Home | List of all events (active + archived). CTA: Create new event, Duplicate past event |
| 2 | Event Dashboard | Summary cards, quick filters, CTAs to guests/hotels/export |
| 3 | Event Setup | Create/edit event — name, type, dates, add hotels |
| 4 | Hotel Setup | Create/edit hotel — name, room inventory entry |
| 5 | Room Inventory View | Filterable list/grid by hotel, category, status |
| 6 | Guest List | Searchable, filterable, tags visible inline |
| 7 | Guest Detail | Info, tags, stay history, running bill, all action CTAs |
| 8 | Check-in Flow | Select hotel → select room → confirm |
| 9 | Room Change Flow | Current room → select new room → confirm |
| 10 | Guest Transfer Flow | Select destination hotel → select room → confirm |
| 11 | Checkout Flow | Bill summary → confirm → 5 min undo countdown |
| 12 | Service Logging | Select service type → enter amount → confirm |
| 13 | Billing View | Itemized charges per guest, total, locked/open status |
| 14 | Export Screen | Select report type → preview → share via share sheet |
| 15 | Service Type Config | Per-event service types — add, edit, delete |

**Total: 15 screens**
