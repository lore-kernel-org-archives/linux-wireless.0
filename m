Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:47274 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752860AbaD0Jdm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Apr 2014 05:33:42 -0400
From: "Peer, Ilan" <ilan.peer@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"mcgrof@do-not-panic.com" <mcgrof@do-not-panic.com>
Subject: RE: [PATCH] cfg80211: Fix GO Concurrent relaxation on UNII-3
Date: Sun, 27 Apr 2014 09:33:38 +0000
Message-ID: <CB3B3D4774441E42AA3EA0E1BA8230A0333EC082@HASMSX106.ger.corp.intel.com> (sfid-20140427_113409_370644_27464A42)
References: <1398234178-24685-1-git-send-email-ilan.peer@intel.com>
	 (sfid-20140423_092926_556077_B4B8B67A)
 <1398437216.4152.7.camel@jlt4.sipsolutions.net>
In-Reply-To: <1398437216.4152.7.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PiBPbiBXZWQsIDIwMTQtMDQtMjMgYXQgMDk6MjIgKzAzMDAsIElsYW4gUGVlciB3cm90ZToNCj4g
PiBBdCBzb21lIGxvY2F0aW9ucywgY2hhbm5lbHMgMTQ5LTE2NSBhcmUgY29uc2lkZXJlZCBhIHNp
bmdsZSBidW5kbGUsDQo+ID4gd2hpbGUgYXQgc29tZSBvdGhlciBsb2NhdGlvbnMsIGUuZy4sIElu
ZG9uZXNpYSwgY2hhbm5lbHMNCj4gPiAxNDktMTYxIGFyZSBjb25zaWRlcmVkIGEgc2luZ2xlIGJ1
bmRsZSwgd2hpbGUgY2hhbm5lbCAxNjUgYmVsb25ncyB0byBhDQo+ID4gZGlmZmVyZW50IGJ1bmRs
ZS4gVGhpcyBtZWFucyB0aGF0Og0KPiA+DQo+ID4gMS4gQSBzdGF0aW9uIGludGVyZmFjZSBjb25u
ZWN0aW9uIHRvIGFuIEFQIG9uIGNoYW5uZWwgMTY1IGFsbG93cw0KPiA+ICAgIHRoZSBpbnN0YW50
aWF0aW9uIG9mIGEgUDJQIEdPIG9uIGNoYW5uZWxzIDE0OS0xNjUuDQo+ID4gMi4gQSBzdGF0aW9u
IGludGVyZmFjZSBjb25uZWN0aW9uIHRvIGFuIEFQIG9uIGNoYW5uZWxzIDE0OS0xNjENCj4gPiAg
ICBkb2VzIE5PVCBhbGxvdyB0aGUgaW5zdGFudGlhdGlvbiBvZiBhIFAyUCBHTyBvbiBjaGFubmVs
IDE2NS4NCj4gPg0KPiA+IEZpeCB0aGlzLg0KPiANCj4gSSdsbCBhcHBseSB0aGlzLCBidXQgSSdt
IG5vdCBhIGJpZyBmYW4gb2YgaXQuIFBsZWFzZSB3b3JrIHdpdGggTHVpcyB0byBnZXQgc29tZQ0K
PiBpbmZvcm1hdGlvbiBpbnRvIHRoZSByZWd1bGF0b3J5IGRhdGFiYXNlLg0KPiANCg0KU3VyZS4g
THVpcywgaG93IHdvdWxkIGxpa2UgbWUgdG8gYWRkcmVzcyB0aGlzPyANCg0KPiBMdWlzIHBvaW50
ZWQgdGhpcyBvdXQgb3JpZ2luYWxseSBbMV0gd2hlbiB5b3Ugd2VyZSBhZGRpbmcgdGhlIFVOSUkt
MS8yLzMNCj4gdGhpbmdzIHRvIHRoZSBrZXJuZWwgdGhhdCBoZSBkaWRuJ3QgdGhpbmsgdGhleSdk
IGJlIHVuaXZlcnNhbGx5IGFwcGxpY2FibGUsIGJ1dA0KPiB5b3Ugc2FpZCB0aGV5IHdlcmUgLi4u
IEkgZ3Vlc3MgTHVpcyBhbHNvIHRob3VnaHQgaXQgd2FzIHRydWUgdGhvdWdoLCBhbmQgaXQNCj4g
ZG9lc24ndCBzZWVtIHRvIGJlICh3aGljaCBzZWVtcyB0byBiZSBiZWNhdXNlIG9mIHRoZSA4ME1I
eiB0aGluZyB3aXRoDQo+IGNoYW5uZWwgMTY1IEkgZ3Vlc3MpDQo+IA0KDQpTb3JyeSBmb3IgdGhp
cy4gQXQgdGhlIHRpbWUgSSB3YXMgdW5kZXIgdGhlIHVuZGVyc3RhbmRpbmcgdGhhdCB0aGVzZSB3
ZXJlIHVuaXZlcnNhbGx5IHRydWUuDQoNClJlZ2FyZHMsDQoNCklsYW4uDQo=
