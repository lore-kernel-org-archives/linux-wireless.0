Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:46124 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbaEOJwB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 05:52:01 -0400
From: "Coelho, Luciano" <luciano.coelho@intel.com>
To: "johannes@sipsolutions.net" <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"janusz.dziedzic@tieto.com" <janusz.dziedzic@tieto.com>,
	"eliad@wizery.com" <eliad@wizery.com>
Subject: Re: [PATCH] cfg80211: fix start_radar_detection issue
Date: Thu, 15 May 2014 09:51:54 +0000
Message-ID: <1400147514.4521.10.camel@dubbel> (sfid-20140515_115205_847210_DFD46FD9)
References: <1400066704-7286-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1400078561.4759.12.camel@jlt4.sipsolutions.net>
	 <CAB3XZEcixQDE7FbvJ2k3jw501BjS2_LkKG72zYok6WbmzCxq5A@mail.gmail.com>
	 (sfid-20140515_112846_166140_C2756793)
 <1400146757.4146.1.camel@jlt4.sipsolutions.net>
In-Reply-To: <1400146757.4146.1.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gVGh1LCAyMDE0LTA1LTE1IGF0IDExOjM5ICswMjAwLCBKb2hhbm5lcyBCZXJnIHdyb3RlOg0K
PiBPbiBUaHUsIDIwMTQtMDUtMTUgYXQgMTI6MjggKzAzMDAsIEVsaWFkIFBlbGxlciB3cm90ZToN
Cj4gPiBPbiBXZWQsIE1heSAxNCwgMjAxNCBhdCA1OjQyIFBNLCBKb2hhbm5lcyBCZXJnDQo+ID4g
PGpvaGFubmVzQHNpcHNvbHV0aW9ucy5uZXQ+IHdyb3RlOg0KPiA+ID4gT24gV2VkLCAyMDE0LTA1
LTE0IGF0IDEzOjI1ICswMjAwLCBKYW51c3ogRHppZWR6aWMgd3JvdGU6DQo+ID4gPj4gQWZ0ZXIg
cGF0Y2g6DQo+ID4gPj4gY2ZnODAyMTEvbWFjODAyMTE6IHJlZmFjdG9yIGNmZzgwMjExX2NoYW5k
ZWZfZGZzX3JlcXVpcmVkKCkNCj4gPiA+Pg0KPiA+ID4+IHN0YXJ0X3JhZGFyX2RldGVjdGlvbiBh
bHdheXMgZmFpbCB3aXRoIC1FSU5WQUwuDQo+ID4gPg0KPiA+ID4gQXBwbGllZCwgdGhhbmtzLg0K
PiA+ID4NCj4gPiBwcm9iYWJseSBhIGJpdCBsYXRlLCBidXQgaSBkb24ndCByZWFsbHkgc2VlIHdo
eSBwYXNzaW5nDQo+ID4gTkw4MDIxMV9JRlRZUEVfVU5TUEVDSUZJRUQgYXQgYWxsLCBpbnN0ZWFk
IG9mIHRoZSBpZnR5cGU/DQo+IA0KPiBJIGRpZCBicmllZmx5IHdvbmRlciBhYm91dCB0aGUgc2Ft
ZSwgYnV0IGRlY2lkZWQgTHVjYSBwcm9iYWJseSBrbmV3DQo+IGJldHRlciA6KQ0KDQpBY3R1YWxs
eSBJIGFsc28gdGhvdWdodCB0aGUgc2FtZSB0aGluZywgYnV0IGhhZCB0aGUgaW1wcmVzc2lvbiB0
aGF0DQp0aGVyZSB3ZXJlIGNhc2VzIHdoZW4gd2Ugd291bGRuJ3QgaGF2ZSB0aGUgaWZ0eXBlIHdo
ZW4gY2FsbGluZyB0aGlzLg0KQnV0IG5vdyBJIGNoZWNrZWQgYm90aCBjYXNlcyB3aGVyZSB3ZSB1
c2UgTkw4MDIxMV9JRlRZUEVfVU5TUEVDSUZJRUQgYW5kDQppdCBzZWVtcyB0aGF0IHdlIHJlYWxs
eSBkb24ndCBuZWVkIGl0Lg0KDQpJJ2xsIHNlbmQgYSBwYXRjaCB0byBmaXggdGhpcyBhbmQgcmV2
ZXJ0IEphbnVzeidzIGNoYW5nZSAodW5sZXNzDQpKb2hhbm5lcyB3YW50cyB0byByZWJhc2UgdGhl
IG1hYzgwMjExLW5leHQgdHJlZSkuDQoNClNvcnJ5IGZvciB0aGUgdHJvdWJsZS4NCg0KLS0NCkx1
Y2EuDQo=
