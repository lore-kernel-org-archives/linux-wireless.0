Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:5985 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992AbbCBGYs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2015 01:24:48 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: "julian.calaby@gmail.com" <julian.calaby@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Coelho, Luciano" <luciano.coelho@intel.com>
Subject: Re: [PATCH 19/31] iwlwifi: mvm: don't iterate interfaces to
 disconnect in net-detect
Date: Mon, 2 Mar 2015 06:24:40 +0000
Message-ID: <1425277477.9744.1.camel@egrumbacBox> (sfid-20150302_072453_376206_D1210551)
References: <1425238186.30202.5.camel@egrumbacBox>
	 <1425238304-498-19-git-send-email-emmanuel.grumbach@intel.com>
	 <CAGRGNgXe0v7Xro3RgyeHWMOhMQiNkn7vPhgQM4j6VpNP7-yTrA@mail.gmail.com>
In-Reply-To: <CAGRGNgXe0v7Xro3RgyeHWMOhMQiNkn7vPhgQM4j6VpNP7-yTrA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gTW9uLCAyMDE1LTAzLTAyIGF0IDA5OjIzICsxMTAwLCBKdWxpYW4gQ2FsYWJ5IHdyb3RlOg0K
PiBIaSBFbW1hbnVlbCwNCj4gDQo+IE9uIE1vbiwgTWFyIDIsIDIwMTUgYXQgNjozMSBBTSwgRW1t
YW51ZWwgR3J1bWJhY2gNCj4gPGVtbWFudWVsLmdydW1iYWNoQGludGVsLmNvbT4gd3JvdGU6DQo+
ID4gRnJvbTogTHVjaWFubyBDb2VsaG8gPGx1Y2lhbm8uY29lbGhvQGludGVsLmNvbT4NCj4gPg0K
PiA+IFdlIHNob3VsZG4ndCBjYWxsIGl3bF9tdm1fZDNfZGlzY29ubmVjdF9pdGVyKCkgb24gdGhl
IHJ1bm5pbmcNCj4gPiBpbnRlcmZhY2VzIHdoZW4gd2UgYXJlIHdva2VuIHVwIGR1ZSB0byBuZXQt
ZGV0ZWN0LCBiZWNhdXNlIGl0IGRvZXNuJ3QNCj4gPiBtYWtlIHNlbnNlLiAgQWRkaXRpb25hbGx5
LCB0aGlzIHNlZW1zIHRvIHNldCB0aGUNCj4gPiBJRUVFODAyMTFfU0RBVEFfRElTQ09OTkVDVF9S
RVNVTUUgZmxhZyB0aGF0IHdpbGwgY2F1c2UgYSBkaXNjb25uZWN0aW9uDQo+ID4gb24gdGhlIG5l
eHQgcmVzdW1lIChpZiBhIG5vcm1hbCBXb1dMQU4gaXMgdXNlZCkuDQo+ID4NCj4gPiBUbyBzb2x2
ZSB0aGlzLCBza2lwIHRoZSBpdGVyYXRpb24gbG9vcCB3aGVuIG5ldC1kZXRlY3QgaXMgc2V0Lg0K
PiA+DQo+ID4gUmVwb3J0ZWQtYnk6IFNhbXVlbCBUYW4gPHNhbXVlbHRhbkBjaHJvbWl1bS5vcmc+
DQo+ID4gUmV2aWV3ZWQtYnk6IEpvaGFubmVzIEJlcmcgPGpvaGFubmVzLmJlcmdAaW50ZWwuY29t
Pg0KPiA+IFNpZ25lZC1vZmYtYnk6IEVtbWFudWVsIEdydW1iYWNoIDxlbW1hbnVlbC5ncnVtYmFj
aEBpbnRlbC5jb20+DQo+IA0KPiBTaG91bGRuJ3QgdGhpcyBiZSBzaWduZWQgb2ZmIGJ5IEx1Y2lh
bm8gdG9vPw0KPiANCg0KUmlnaHQgLSBJIHJlbW92ZWQgaXQgYnkgbWlzdGFrZSB3aGlsZSByZW1v
dmluZyBvdGhlciB1bm5lZWRlZCBzdHVmZiBpbg0KdGhlIHNhbWUgYXJlYS4gSSB1cGRhdGVkIHRo
ZSB0cmVlIGFuZCB0aGUgdGFnLg0KVGhhbmtzLg0KDQo+IFRoYW5rcywNCj4gDQoNCg==
