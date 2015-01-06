Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:21992 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753292AbbAFL2J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2015 06:28:09 -0500
From: "Peer, Ilan" <ilan.peer@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"mcgrof@suse.com" <mcgrof@suse.com>
Subject: RE: [PATCH v2 2/2] cfg80211: Schedule timeout for all CRDA calls
Date: Tue, 6 Jan 2015 11:28:05 +0000
Message-ID: <CB3B3D4774441E42AA3EA0E1BA8230A04CFC54FC@HASMSX106.ger.corp.intel.com> (sfid-20150106_122816_019402_1DE1EA59)
References: <1420519942-16109-1-git-send-email-ilan.peer@intel.com>
	 <1420519942-16109-2-git-send-email-ilan.peer@intel.com>
	 (sfid-20150106_115607_476225_0D1289F9)
 <1420541961.1966.20.camel@sipsolutions.net>
In-Reply-To: <1420541961.1966.20.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKb2hhbm5lcyBCZXJnIFttYWls
dG86am9oYW5uZXNAc2lwc29sdXRpb25zLm5ldF0NCj4gU2VudDogVHVlc2RheSwgSmFudWFyeSAw
NiwgMjAxNSAxMjo1OQ0KPiBUbzogUGVlciwgSWxhbg0KPiBDYzogbGludXgtd2lyZWxlc3NAdmdl
ci5rZXJuZWwub3JnOyBtY2dyb2ZAc3VzZS5jb20NCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2MiAy
LzJdIGNmZzgwMjExOiBTY2hlZHVsZSB0aW1lb3V0IGZvciBhbGwgQ1JEQSBjYWxscw0KPiANCj4g
T24gTW9uLCAyMDE1LTAxLTA1IGF0IDIzOjUyIC0wNTAwLCBJbGFuIFBlZXIgd3JvdGU6DQo+ID4g
VGltZW91dCB3YXMgc2NoZWR1bGVkIG9ubHkgaW4gY2FzZSBDUkRBIHdhcyBjYWxsZWQgZHVlIHRv
IHVzZXIgaGludHMsDQo+ID4gYnV0IHdhcyBub3Qgc2NoZWR1bGVkIGZvciBvdGhlciBjYXNlcy4g
VGhpcyBjYW4gcmVzdWx0IGluIHJlZ3VsYXRvcnkNCj4gPiBoaW50IHByb2Nlc3NpbmcgZ2V0dGlu
ZyBzdHVjayBpbiBjYXNlIHRoYXQgdGhlcmUgaXMgbm8gQ1JEQSBjb25maWd1cmVkLg0KPiANCj4g
SSBjYW4gdW5kZXJzdGFuZCB0aGlzIHBhcnQuDQo+IA0KPiA+IENoYW5nZSB0aGlzIGJ5IHNjaGVk
dWxpbmcgYSB0aW1lb3V0IGV2ZXJ5IHRpbWUgQ1JEQSBpcyBjYWxsZWQuIEluDQo+ID4gYWRkaXRp
b24sIGluIHJlc3RvcmVfcmVndWxhdG9yeV9zZXR0aW5ncygpIGFsbCBwZW5kaW5nIHJlcXVlc3Rz
IGFyZQ0KPiA+IHJlc3RvcmVkIChhbmQgbm90IG9ubHkgdGhlIHVzZXIgb25lcykuDQo+IA0KPiBD
YXJlIHRvIGV4cGxhaW4gd2h5LCBhbmQgd2h5IHRoaXMgc2hvdWxkIGJlIGluIHRoZSBzYW1lIHBh
dGNoPw0KDQpQcmV2aW91c2x5IG9ubHkgdGhlIHBlbmRpbmcgdXNlciBoaW50cyB3ZXJlIHJlc3Rv
cmVkIChub3Qgc3VyZSB3aHksIGJ1dCBtYXliZSB0aGVyZSB3YXMgYW4gYXNzdW1wdGlvbiB0aGF0
IHRoZSB0aW1lb3V0IHdhcyBvbmx5IHNjaGVkdWxlZCBmb3IgdXNlciBoaW50cz8pLiBXYXMgbm90
IHN1cmUgd2h5IGFsbCBvdGhlciBoaW50IHR5cGVzIHdlcmUgbm90IHJlc3RvcmVkLiBJIGNhbiBt
b3ZlIHRoaXMgdG8gYW5vdGhlciBwYXRjaCBpdCB0aGlzIGlzIHN0aWxsIHJlYXNvbmFibGUuDQoN
CklsYW4uDQo=
