Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:59431 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756389Ab3KFMXC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 07:23:02 -0500
From: "Coelho, Luciano" <luciano.coelho@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Simon Wunderlich <sw@simonwunderlich.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC v2 2/2] mac80211: only set CSA beacon when at least one
 beacon must be transmitted
Date: Wed, 6 Nov 2013 12:22:07 +0000
Message-ID: <1383740486.4256.65.camel@porter.coelho.fi> (sfid-20131106_132308_585574_FEC1E189)
References: <1383684854-21663-1-git-send-email-luciano.coelho@intel.com>
	 <1383684854-21663-2-git-send-email-luciano.coelho@intel.com>
	 <201311061247.48777.sw@simonwunderlich.de>
	 <1383739343.4256.58.camel@porter.coelho.fi>
	 <1383739595.14307.41.camel@jlt4.sipsolutions.net>
In-Reply-To: <1383739595.14307.41.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gV2VkLCAyMDEzLTExLTA2IGF0IDEzOjA2ICswMTAwLCBKb2hhbm5lcyBCZXJnIHdyb3RlOg0K
PiBPbiBXZWQsIDIwMTMtMTEtMDYgYXQgMTI6MDMgKzAwMDAsIENvZWxobywgTHVjaWFubyB3cm90
ZToNCj4gDQo+ID4gPiBFdmVuIGlmIHdlIGRvbid0IGFsbG93IGNvdW50IDw9MSBmcm9tIHVzZXJz
cGFjZSBhcyBKb2hhbm5lcyBzdWdnZXN0ZWQsDQo+ID4gDQo+ID4gQWgsIEkgaGFkIG1pc3VuZGVy
c3Rvb2QgSm9oYW5uZXMuICBJIHRob3VnaHQgaGUgbWVhbnQgdG8gcmVqZWN0IHRoZQ0KPiA+IHBh
dGNoLiA6UA0KPiA+IA0KPiA+IFJlamVjdGluZyBjb3VudCA8PSAxIGNvdWxkIGJlIGEgdGVtcG9y
YXJ5IHNvbHV0aW9uIHVudGlsIHdlIGltcGxlbWVudA0KPiA+IHRoZSBhY3Rpb24gZnJhbWVzIHBy
b3Blcmx5LiAgVW5sZXNzIHdlIGRlY2lkZSB0aGF0IHRoZSBhY3Rpb24gZnJhbWVzDQo+ID4gc2hv
dWxkIGJlIGhhbmRsZWQgaW4gdXNlcnNwYWNlIGFzIHlvdSBwcm9wb3NlZC4NCj4gDQo+IFdlbGwg
ZXZlbiB0aGVuIC0gdGhlIHF1ZXN0aW9uIGlzIHdobyB3b3VsZCBldmVyIHdhbnQgdG8gdXNlIGFu
ZCB0ZXN0DQo+IGNvdW50PD0xPw0KDQpJIGd1ZXNzIHRoZSByZWFzb24gdG8gaGF2ZSB0aGlzIGlz
IHdoZW4geW91IG11c3QgZXZhY3VhdGUgdGhlIGNoYW5uZWwNCmltbWVkaWF0ZWx5LCBzbyB5b3Ug
dHJhbnNtaXQgdGhlIGFjdGlvbiBmcmFtZSBhbmQganVtcCBvdXQuICBJZiB5b3VyDQpiZWFjb24g
aW50ZXJ2YWwgaXMgbG9uZyAoZm9yIHdoYXRldmVyIHJlYXNvbiksIHdhaXRpbmcgZm9yIHRoZSBu
ZXh0IFRCVFQNCnRvIGFubm91bmNlIHRoZSBDU0EgbWF5IHRha2UgbG9uZ2VyIHRoYW4gdGhlIHRp
bWUgcmVxdWlyZWQgdG8gc3RvcA0KdHJhbnNtaXR0aW5nLg0KDQpBbHNvLCBpbiBhICJzdG9wIHRy
YW5zbWl0dGluZyBpbW1lZGlhdGVseSIgc2NlbmFyaW8sIHVzaW5nIGFuIGFjdGlvbg0KZnJhbWUg
d2l0aCBjb3VudCA8PSAxIGhlbHBzIHJlZHVjZSBkYXRhIGhpY2N1cHMgdGhhdCB3b3VsZCBoYXBw
ZW4gaWYNCmNvdW50ID4gMSBhbmQgdGhlIGNoYW5uZWwgc3dpdGNoIG1vZGUgaXMgImRvbid0IHRy
YW5zbWl0Ii4NCg0KLS0NCkx1Y2EuDQo=
