Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:59372 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027Ab3KFHKh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 02:10:37 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: wzyboy <wzyboy@wzyboy.org>
CC: "ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [Ilw] Intel Wireless 7260 hardware timed out randomly
Date: Wed, 6 Nov 2013 07:10:28 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB301DEA097@HASMSX103.ger.corp.intel.com> (sfid-20131106_081039_822945_A7EBB44D)
References: <5276134B.8070808@wzyboy.org>
 <0BA3FCBA62E2DC44AF3030971E174FB301DE75AE@HASMSX103.ger.corp.intel.com>
 <CALkVjQYh-SUte4S6LdqOc3KSc3_pDU6jz1KXp+Jsd5_RFPXSqA@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301DE8338@HASMSX103.ger.corp.intel.com>
 <CALkVjQb7fCMFpqhdUs8w-Mx_Y0RtAYYFtKxXkqyrCQ39UFGxKg@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301DE960E@HASMSX103.ger.corp.intel.com>
 <CALkVjQbW8FeiEh8pBZ=KQFD9+8AdjgT0G_RG7qJe0MRdBvMD-A@mail.gmail.com>
 <CALkVjQaLx2spaOqUPcs_EwMkU7npMki1Reo1MeZwxB7m=c24=g@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301DE9FC6@HASMSX103.ger.corp.intel.com>
 <CALkVjQZDNSgUUFyi94Y8da_NDzW61rCvaMrZpUugFKW_LRNFFA@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301DEA052@HASMSX103.ger.corp.intel.com>
 <CALkVjQZRJw7ghjBa1aPKNKe3Zj2B1Mhk5bWVaRdcCYzfoLRovg@mail.gmail.com>
 <CALkVjQY7r=YKhsgDKR0mnYVtZy5BAdj83nY2jL0VFaiew6ha7A@mail.gmail.com>
In-Reply-To: <CALkVjQY7r=YKhsgDKR0mnYVtZy5BAdj83nY2jL0VFaiew6ha7A@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PiANCj4gMjAxMy8xMS82IHd6eWJveSA8d3p5Ym95QHd6eWJveS5vcmc+Og0KPiA+IEkndmUgYXR0
YWNoZWQgdGhlIG91dHB1dCBvZiBgbHNwY2kgLXh4eCcuIFRoZSBuZXh0IHRpbWUgdGhpcyBidWcN
Cj4gPiBvY2N1cnMgSSB3aWxsIHJ1biBpdCBhZ2FpbiBhbmQgc2VuZCB0aGUgb3V0cHV0IHRvIHlv
dS4NCj4gDQo+IA0KPiBTbyBkcmFtYXRpY2FsIGl0IHdhcy4gU2V2ZXJhbCBtaW51dGVzIGFnbyBJ
IGNsaWNrZWQgb24gIlNlbmRlbiINCj4gKEdlcm1hbiBmb3IgIlNlbmQiKSBidXR0b24gdG8gc2Vu
ZCB0aGF0IGVtYWlsLiBBZnRlciB0aGUgbWFpbCB3YXMgc2VudCwgSQ0KPiBvcGVuZWQgYSBuZXcg
dGFiIGluIHRoZSBicm93c2VyLCB0cnlpbmcgdG8gZ29vZ2xlIHNvbWV0aGluZyBhbmQgZm91bmQg
dGhlDQo+IEludGVybmV0IGNvbm5lY3Rpb24gaXMgbG9zdC4gLS0gVGhlIGJ1ZyBvY2N1cmVkIGFn
YWluIQ0KPiANCj4gU28gSSByYW4gYGxjcGNpIC14eHgiIGFuZCBzYXZlZCB0aGUgb3V0cHV0IGFs
b25nIHdpdGggdGhlIGtlcm5lbCBsb2dzLiBJJ20NCj4gc2hvY2tlZCB0aGF0IHRoZSBoZXggc3Ry
aW5ncyBhcmUgYWxsICIwMCIuDQoNCldhaXQgLSB5b3UgbWVhbiB0aGF0IGFmdGVyIHRoZSBidWcg
b2NjdXJyZWQgYmVmb3JlIHlvdSByZWJvb3RlZCwgbHNwY2kgLXh4eCBzaG93IGFsbCAwMD8NCkkg
Y2FuIHNlZSAweGZmIGhlcmUuDQpBbnl3YXkgLSB0aGlzIGlzIHZlcnkgYmFkLi4uIGNoZWNraW5n
IHdpdGggSFcgZ3V5cy4uLg0KDQo+IA0KPiBJIHJlYm9vdGVkIG15IGxhcHRvcCBhbmQgdHJ5IHRv
IHNlbmQgeW91IHRoZSBsb2dzIGFuZCB0aGUgYnVnIG9jY3VycyBhZ2Fpbi4uLg0KPiAtLSBzZWVt
cyBtb3JlIGFuZCBtb3JlIGZyZXVxdWVudCAtLSBhbmQgSSBoYWQgdG8gcmVib290IC4uLg0KPiAN
Cj4gSGVyZSBhcmUgdGhlIGxvZ3MgLi4uIGZpbmFsbHkuDQo+IA0KPiAtLQ0KPiB3enlib3kNCg==
