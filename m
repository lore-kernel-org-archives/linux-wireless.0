Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:35983 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933102Ab0KQIZu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Nov 2010 03:25:50 -0500
From: "Gabay, Benzy" <benzyg@ti.com>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
CC: "luciano.coelho@nokia.com" <luciano.coelho@nokia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 17 Nov 2010 02:25:43 -0600
Subject: RE: [PATCH 1/2] wl1271: Prevent ad-hoc and active scanning on 11a
 DFS frequencies
Message-ID: <676FD6AA0F002F49B89E70F0C5EFD22C136DEA03CC@dlee04.ent.ti.com>
References: <1289384840-28305-1-git-send-email-juuso.oikarinen@nokia.com>
	 <676FD6AA0F002F49B89E70F0C5EFD22C136DEA03B9@dlee04.ent.ti.com>
 <1289977249.2522.148.camel@wimaxnb.nmp.nokia.com>
In-Reply-To: <1289977249.2522.148.camel@wimaxnb.nmp.nokia.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SnV1c28sDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPg0KPiA+IEkga25vdyBp
dCdzIGEgYml0IGxhdGUgYnV0Og0KPiA+IERvZXNuJ3QgdGhlIGZhY3QgdGhhdCB5b3VyIHJlZmVy
cmluZyBoZXJlIHRvIDEyNzEsIHdoaWNoIGlzIHN1cHBvcnQNCj4gMi40R2h6IGRldmljZSBvbmx5
IG1hdHRlciBoZXJlIHRvIGFueW9uZT8NCj4gPiBDb3JyZWN0IG1lIGlmIEknbSB3cm9uZyBoZXJl
IGJ1dCByYWRhciBkZXRlY3Rpb24gd2FzIG1lYW50IG9ubHkgZm9yDQo+IDUuMEdoeiBkZXZpY2Ug
dHlwZXMuDQo+ID4gU2hvdWxkIHRoaXMgcGF0Y2ggc2hvdWxkIGJlIGRvbmUgb24gMTI3MyBkZXZp
Y2UgdHlwZSBvciBhIGNoYW5nZSBpbg0KPiB0aGUgbmFtaW5nIGNvbnZlbnRpb24gc2hvdWxkIGJl
IGFwcGxpZWQgaGVyZS4NCj4gDQo+IFllcywgeW91IGFyZSBjb3JyZWN0IGluIHRoZSBmYWN0IHRo
ZSBuYW1pbmcgaGVyZSBpcyB3cm9uZy4gSSB1c2VkIGl0LA0KPiBiZWNhdXNlIGZvciBsZWdhY3kg
cmVhc29ucywgdGhlIGRyaXZlciB3YXMgc3RpbGwgY2FsbGVkIHdsMTI3MSBhdCB0aGUNCj4gdGlt
ZSBJIHdyb3RlIHRoZSBwYXRjaC4gQWx0aG91Z2ggdGhlIGRyaXZlciB3YXMgbmFtZWQgIndsMTI3
MSIgaXQgaXMNCj4gc3RpbGwgaW50ZW5kZWQgdG8gZHJpdmUgYWxzbyB0aGUgd2wxMjczLg0KPiAN
Cj4gUmVjZW50bHksIHdvcmsgaGFzIGJlZW4gb25nb2luZyB0byBjaGFuZ2UgdGhpcyBuYW1pbmcu
IFRoZSB3bDEyNzENCj4gZHJpdmVyDQo+IHdhcyByZW5hbWVkIHRvIHdsMTJ4eCB0byBiZXR0ZXIg
cmVmbGVjdCByZWFsaXR5LCBhcyB5b3UgaGF2ZSBwb3NzaWJseQ0KPiBub3RlZC4NCj4gDQo+IC1K
dXVzbw0KPiANCj4gPg0KDQpZZWFoIGp1c3Qgc2F3IGl0LCBhZnRlciBJJ3ZlIHBvc3RlZCB0aGUg
ZW1haWwgOi0pDQoNCllldCBhbm90aGVyIHF1ZXN0aW9uIG9uIHRoaXMgdG9waWMsDQpBZC1Ib2Mg
d2FzIGRlc2lnbmVkIG9yaWdpbmFsbHkgZm9yIEIgbW9kZSBvbmx5LiBTb21lIGNvbXBhbmllcyBl
eHRlbmRlZCBpdCB0byBHIGFsc28uIA0KRG8gd2UgaGF2ZSBNQUM4MDIuMTEgc3VwcG9ydCBmb3Ig
QWQtSG9jIG9uIDExYSBjaGFubmVscyB0aGVzZSBkYXlzPw0KDQpCZW56eQ0K
