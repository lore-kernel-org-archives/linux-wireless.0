Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:15965 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751641Ab3KLIJq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Nov 2013 03:09:46 -0500
From: "Coelho, Luciano" <luciano.coelho@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"sw@simonwunderlich.de" <sw@simonwunderlich.de>
Subject: Re: [RFC v3 1/4] mac80211: don't transmit beacon with CSA count 0
Date: Tue, 12 Nov 2013 08:09:10 +0000
Message-ID: <1384243717.12583.38.camel@porter.coelho.fi> (sfid-20131112_090949_574622_A9B65818)
References: <1383921579-22373-1-git-send-email-luciano.coelho@intel.com>
	 <1384178360.14334.18.camel@jlt4.sipsolutions.net>
In-Reply-To: <1384178360.14334.18.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gTW9uLCAyMDEzLTExLTExIGF0IDE0OjU5ICswMTAwLCBKb2hhbm5lcyBCZXJnIHdyb3RlOg0K
PiBPbiBGcmksIDIwMTMtMTEtMDggYXQgMTY6MzkgKzAyMDAsIEx1Y2lhbm8gQ29lbGhvIHdyb3Rl
Og0KPiA+IEEgYmVhY29uIHNob3VsZCBuZXZlciBoYXZlIGEgQ2hhbm5lbCBTd2l0Y2ggQW5ub3Vu
Y2VtZW50IGluZm9ybWF0aW9uDQo+ID4gZWxlbWVudCB3aXRoIGEgY291bnQgb2YgMCwgYmVjYXVz
ZSBhIGNvdW50IG9mIDEgbWVhbnMgc3dpdGNoIGp1c3QNCj4gPiBiZWZvcmUgdGhlIG5leHQgYmVh
Y29uLiAgU28sIGlmIGEgY291bnQgb2YgMCB3YXMgdmFsaWQgaW4gYSBiZWFjb24sIGl0DQo+ID4g
d291bGQgaGF2ZSBiZWVuIHRyYW5zbWl0dGVkIGluIHRoZSBuZXh0IGNoYW5uZWwgYWxyZWFkeSwg
d2hpY2ggaXMNCj4gPiB1c2VsZXNzLiAgQSBDU0EgY291bnQgZXF1YWwgdG8gemVybyBpcyBvbmx5
IG1lYW5pbmdmdWwgaW4gYWN0aW9uDQo+ID4gZnJhbWVzIG9yIHByb2JlX3Jlc3BvbnNlcy4NCj4g
PiANCj4gPiBGaXggdGhlIGllZWU4MDIxMV9jc2FfaXNfY29tcGxldGUoKSBhbmQgaWVlZTgwMjEx
X3VwZGF0ZV9jc2EoKQ0KPiA+IGZ1bmN0aW9ucyBhY2NvcmRpbmdseS4NCj4gDQo+IFRoZXNlIHNl
ZW0gZmluZSB0byBtZSAtIG1heWJlIHdlIHNob3VsZCBoYXZlIHNvbWUgQ1NBIHRlc3RzIGluIEpv
dW5pJ3MNCj4gaHdzaW0gdGVzdCBzY3JpcHRzLCBmb3IgdGhlIHZhcmlvdXMgY2FzZXM/IDopDQoN
CkNvb2wgdGhhdCB0aGlzIGlzIGZpbmUgd2l0aCB5b3UuICBJIGNhbiBwcm9jZWVkIG1ha2luZyB0
aGUgZmluYWwgY2hhbmdlcw0KZm9yIHY0IHRoZW4uIDspDQoNCkknbGwgdGFrZSBhIGxvb2sgaW50
byB0aGUgaHdzaW0gdGVzdCBzY3JpcHRzLg0KDQotLQ0KQ2hlZXJzLA0KTHVjYS4NCg==
