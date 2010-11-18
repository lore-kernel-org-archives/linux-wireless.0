Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:40605 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab0KRFSa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 00:18:30 -0500
From: "Krakowski, Oz" <ozk@ti.com>
To: "Gabay, Benzy" <benzyg@ti.com>,
	Luciano Coelho <luciano.coelho@nokia.com>
CC: =?utf-8?B?ZXh0IEfDoWJvciBTdGVmYW5paw==?= <netrolller.3d@gmail.com>,
	ext Grazvydas Ignotas <notasas@gmail.com>,
	"Levi, Shahar" <shahar_levi@ti.com>, Kalle Valo <kvalo@adurom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 17 Nov 2010 23:18:17 -0600
Subject: RE: [PATCH v4] wl1271: Change wl12xx Files Names
Message-ID: <B3E8D1AE4503414CAFD215C4B3688A0501EF42D70641@dlee07.ent.ti.com>
References: <1288883257-30060-1-git-send-email-shahar_levi@ti.com>
	 <AANLkTincpxdpmf5J38LiGsF-d9dG7sG9-bjbkH-B8Ld0@mail.gmail.com>
	 <1288891196.17643.6.camel@powerslave>
	 <AANLkTi=Luv2+5Hys2PcrH+G8jmc4vwz8PM0LFKm+fTt8@mail.gmail.com>
	 <1288907555.17643.14.camel@powerslave>
	 <676FD6AA0F002F49B89E70F0C5EFD22C136DEA0A14@dlee04.ent.ti.com>
 <1290019712.28892.5.camel@powerslave>
 <676FD6AA0F002F49B89E70F0C5EFD22C136DEA102C@dlee04.ent.ti.com>
In-Reply-To: <676FD6AA0F002F49B89E70F0C5EFD22C136DEA102C@dlee04.ent.ti.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

QmVuenksDQoNCg0KPiA+IERvZXNuJ3QgaGVscCBtdWNoLiAgVGhlIHByb2JsZW0gaXMgdGhhdCB0
aGUgZHJpdmVyIHdoaWNoIGlzIG5vdyBjYWxsZWQNCj4gPiB3bDEyeHggYWxyZWFkeSBzdXBwb3J0
IHdsMTI3MSBhbmQgd2wxMjczLiAgSW4gdGhlIG5lYXIgZnV0dXJlLCBpdCB3aWxsDQo+ID4gYWxz
byBzdXBwb3J0IHdsMTI4MSBhbmQgd2wxMjgzLCBzbyB0aGUgd2w2IG9yIHdpbGluazYgc2NoZW1l
IHdvdWxkDQo+ID4gYnJlYWsNCj4gPiBhbHJlYWR5Lg0KPiA+DQo+ID4gVGhlIHdsMTI1MSBkcml2
ZXIsIGF0IGxlYXN0IGF0IHRoZSBtb21lbnQsIG9ubHkgc3VwcG9ydHMgd2wxMjUxLCBpdA0KPiA+
IGRvZXNuJ3QgaGF2ZSB0aGUgMTFhIGltcGxlbWVudGF0aW9uLiAgSWYgaW4gdGhlIGZ1dHVyZSBz
b21lb25lIGFkZHMNCj4gPiBzdXBwb3J0IGZvciB3bDEyNTMsIGl0IGNvdWxkIGJlIHJlbmFtZWQg
dG8gd2wxMjV4Lg0KPiA+DQo+ID4gSW4gYW55IGNhc2UsIEkgdGhpbmsgdGhlIG5hbWUgb2YgdGhl
IGRyaXZlciBpcyBub3QgdGhhdCBpbXBvcnRhbnQsIGFzDQo+ID4gbG9uZyBhcyB3ZSdyZSBjbGVh
ciBhYm91dCB3aGljaCBjaGlwcyBlYWNoIG9uZSBvZiB0aGVtIHN1cHBvcnRzIGluIHRoZQ0KPiA+
IEtjb25maWcgZGVzY3JpcHRpb24uDQo+ID4NCj4gPiBSZW5hbWluZyB0aGUgZHJpdmVyIGFsbCB0
aGUgdGltZSAod2UgYWxyZWFkeSBkaWQgaXQgdHdpY2UpLCBlbmRzIHVwDQo+ID4gY29uZnVzaW5n
IG1vcmUgdGhhbiBjbGFyaWZ5aW5nIHRoaW5ncy4NCj4gPg0KPiA+IC0tDQo+ID4gQ2hlZXJzLA0K
PiA+IEx1Y2EuDQo+IA0KPiBtbW0uLi4NCj4gDQo+IEluIHRoYXQgY2FzZSwgYW5vdGhlciBpZGVh
Og0KPiAxLiB3aHkgbm90IGNyZWF0ZSBuZXcgZHJpdmVyIHNvdXJjZSBjb2RlIHdoaWNoIHdpbGwg
ZGVzaWduYXRlZCBmb3IgMTI4eC4NCj4gMi4gSWYgd2UgaGF2ZSBhIHByb2JsZW0gd2l0aCB1bmlm
aWVkIDEyeHggdGhlbiBsZXRzIGRpdmVkIGl0IGNvbXBsZXRlbHkgdG8gc3ViIGRyaXZlcnMgYW5k
DQo+IGhhdmUgb25seSBjb21tb24gcGFydCBhcyBhIHVuaWZpZWQgZHJpdmVyLiBUaGF0IHdheSB5
b3UgZ2V0IHRvIGtlZXAgdGhlIG9sZCBuYW1lcyBhbmQNCj4ganVzdCBkaXZpZGUgdGhlIGZpbGVz
IGNvbnRlbnQgdG8gYSBuZXcgZmlsZSBuYW1lIHdsMTJ4eC5jLg0KPiANCj4gZS5nOg0KPiB3bDEy
NTEuYyB3bDEyNTMuYyAgY29tbW9uIHBhcnQNCj4gd2wxMjcxLmMgd2wxMjczLmMgIC0tLS0tLS0t
LS0+ICB3bDEyeHguYw0KPiB3bDEyODEuYyB3bDEyODMuYw0KPiANCg0KSSBhZ3JlZSB3aXRoIEx1
Y2EgaGVyZS4gVGhlIG5hbWVzIGhhdmUgYmVlbiBjaGFuZ2VkIHJlY2VudGx5IGFuZCBhbnl3YXkg
cmVwcmVzZW50IGJvdGggY2hpcHNldHMgKDEyN3ggYW5kIDEyOHgpIGluIGEgd2F5IHRoYXQgbWFr
ZXMgc2Vuc2UuIEkgZG9uJ3QgdGhpbmsgd2Ugc2hvdWxkIG1ha2UgYW55IGNoYW5nZXMgdG8gdGhh
dC4gDQpBbHNvIHJlLXdyaXRpbmcgdGhlIGRyaXZlciBpbnRvIGEgbmV3IHBhcnRpdGlvbmluZyBk
b2VzIG5vdCBzZXJ2ZSBhbnkgc3BlY2lhbCBuZWVkIElNTy4gRXNwZWNpYWxseSBzaW5jZSB3aWxp
bms2IGFuZCB3aWxpbms3IHNoYXJlIHRoZSBzYW1lIGRyaXZlciBlc3NlbnRpYWxseS4NCg0KDQpS
ZWdhcmRzLA0KT3ouDQoNCg==
