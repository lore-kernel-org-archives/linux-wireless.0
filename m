Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:60169 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754711AbbAFK2x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2015 05:28:53 -0500
From: "Peer, Ilan" <ilan.peer@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"mcgrof@suse.com" <mcgrof@suse.com>,
	ArikX Nemtsov <arik@wizery.com>
Subject: RE: [PATCH 1/2] cfg80211: Add API to change the indoor regulatory
 setting
Date: Tue, 6 Jan 2015 10:28:49 +0000
Message-ID: <CB3B3D4774441E42AA3EA0E1BA8230A04CFC529F@HASMSX106.ger.corp.intel.com> (sfid-20150106_112912_024097_895EE7E4)
References: <1420338556-11901-1-git-send-email-ilan.peer@intel.com>
	 (sfid-20150104_092713_237890_C4245926)
 <1420539068.1966.8.camel@sipsolutions.net>
In-Reply-To: <1420539068.1966.8.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSm9oYW5uZXMgQmVyZyBb
bWFpbHRvOmpvaGFubmVzQHNpcHNvbHV0aW9ucy5uZXRdDQo+IFNlbnQ6IFR1ZXNkYXksIEphbnVh
cnkgMDYsIDIwMTUgMTI6MTENCj4gVG86IFBlZXIsIElsYW4NCj4gQ2M6IGxpbnV4LXdpcmVsZXNz
QHZnZXIua2VybmVsLm9yZzsgbWNncm9mQHN1c2UuY29tOyBBcmlrWCBOZW10c292DQo+IFN1Ympl
Y3Q6IFJlOiBbUEFUQ0ggMS8yXSBjZmc4MDIxMTogQWRkIEFQSSB0byBjaGFuZ2UgdGhlIGluZG9v
ciByZWd1bGF0b3J5DQo+IHNldHRpbmcNCj4gDQo+IE9uIFNhdCwgMjAxNS0wMS0wMyBhdCAyMToy
OSAtMDUwMCwgSWxhbiBQZWVyIHdyb3RlOg0KPiA+IEFzIHRoZSBvcGVyYXRpbmcgZW52aXJvbm1l
bnQgb2YgYSBkZXZpY2UgY2FuIGNoYW5nZSwgYWRkIEFQSSBmb3IgdXNlcg0KPiA+IHNwYWNlIHRv
IGluZGljYXRlIGEgY2hhbmdlIG9mIGluZG9vciBzZXR0aW5ncy4NCj4gPiBJbiBhZGRpdGlvbiBt
b2RpZnkgdGhlIGhhbmRsaW5nIG9mIHRoZSBpbmRvb3IgcHJvY2Vzc2luZyBhcw0KPiA+IGZvbGxv
d3M6DQo+ID4NCj4gPiAxLiBEaXJlY3RseSB1cGRhdGUgdGhlIGluZG9vciBzZXR0aW5nIHdpdGhv
dXQgd3JhcHBpbmcgaXQgYXMgYQ0KPiA+ICAgIHJlZ3VsYXRvcnkgcmVxdWVzdC4NCj4gPiAyLiBU
cmFjayB0aGUgc29ja2V0IG9uIHdoaWNoIHRoZSBpbmRvb3IgaGludCBpcyBpc3N1ZWQsIGFuZCBy
ZXNldA0KPiA+ICAgIGluZG9vciBzZXR0aW5nIGlmIHRoZSBzb2NrZXQgd2FzIHJlbGVhc2VkLg0K
PiA+IDMuIERvIG5vdCByZXNldCB0aGUgaW5kb29yIHNldHRpbmcgd2hlbiByZXN0b3JpbmcgdGhl
IHJlZ3VsYXRvcnkNCj4gPiAgICBzZXR0aW5ncyBhcyBpdCBoYXMgbm90aGluZyB0byBkbyB3aXRo
IENSREEgb3IgaW50ZXJmYWNlDQo+ID4gICAgZGlzY29ubmVjdGlvbi4NCj4gPg0KPiA+IFNpZ25l
ZC1vZmYtYnk6IElsYW4gUGVlciA8aWxhbi5wZWVyQGludGVsLmNvbT4NCj4gPiBTaWduZWQtb2Zm
LWJ5OiBBcmlrWCBOZW10c292IDxhcmlrQHdpemVyeS5jb20+DQo+IA0KPiBUaGlzIGRvZXNuJ3Qg
YXBwbHkgb24gbWFjODAyMTEtbmV4dC4gQWxzbywgeW91IHNob3VsZCBzaWduIG9mZiBhZnRlciBB
cmlrIChhbmQNCj4gaG93IGRpZCBoZSBtYW5hZ2UgdG8gZ2V0IHRoYXQgWCB0aGVyZT8pDQo+IA0K
DQpUaGUgcGF0Y2ggd2FzIG9uIHdpcmVsZXNzLXRlc3RpbmcgLi4uIHdpbGwgZml4Lg0KDQpJbGFu
Lg0K
