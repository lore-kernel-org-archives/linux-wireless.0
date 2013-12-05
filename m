Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:27986 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757305Ab3LESxK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 13:53:10 -0500
From: "Coelho, Luciano" <luciano.coelho@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"sw@simonwunderlich.de" <sw@simonwunderlich.de>,
	"yeohchunyeow@gmail.com" <yeohchunyeow@gmail.com>,
	"yeohchunyeow@cozybit.com" <yeohchunyeow@cozybit.com>,
	"Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>
Subject: Re: [PATCH v8 4/5] mac80211: align ieee80211_mesh_csa_beacon() with
 ieee80211_csa_beacon()
Date: Thu, 5 Dec 2013 18:53:06 +0000
Message-ID: <1386269585.3878.21.camel@porter.coelho.fi> (sfid-20131205_195317_409905_942C39AA)
References: <1386257143-29840-1-git-send-email-luciano.coelho@intel.com>
	 <1386257143-29840-5-git-send-email-luciano.coelho@intel.com>
	 (sfid-20131205_162554_500402_7BA9FCA3)
 <1386259467.4182.13.camel@jlt4.sipsolutions.net>
In-Reply-To: <1386259467.4182.13.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gVGh1LCAyMDEzLTEyLTA1IGF0IDE3OjA0ICswMTAwLCBKb2hhbm5lcyBCZXJnIHdyb3RlOg0K
PiBPbiBUaHUsIDIwMTMtMTItMDUgYXQgMTc6MjUgKzAyMDAsIEx1Y2lhbm8gQ29lbGhvIHdyb3Rl
Og0KPiA+IFRoZSByZXR1cm4gdmFsdWUgb2YgaWVlZTgwMjExX21lc2hfY3NhX2JlYWNvbiBpcyBu
b3QgYWxpZ25lZCB3aXRoIHRoZQ0KPiA+IHJldHVybiB2YWx1ZSBvZiBpZWVlODAyMTFfY3NhX2Jl
YWNvbigpIGFuZA0KPiA+IGllZWU4MDIxMV9pYnNzX2NzYV9iZWFjb24oKS4gIEZvciBjb25zaXN0
ZW5jeSBhbmQgdG8gYmUgYWJsZSB0byB1c2UNCj4gPiBib3RoIGZ1bmN0aW9ucyB3aXRoIHNpbWls
YXIgY29kZSwgY2hhbmdlIGllZWU4MDIxMV9tZXNoX2NzYV9iZWFjb24oKQ0KPiA+IG5vdCB0byBz
ZW5kIHRoZSBic3MgY2hhbmdlZCBub3RpZmljYXRpb24gaXRzZWxmLCBidXQgcmV0dXJuIHdoYXQg
aGFzDQo+ID4gY2hhbmdlZCBzbyB0aGUgY2FsbGVyIGNhbiBzZW5kIHRoZSBub3RpZmljYXRpb24g
aW5zdGVhZC4NCj4gDQo+IEl0IHNlZW1zIHRvIG1lIHRoYXQgdGhlIGNhbGxlciBzaG91bGQgYmUg
dXBkYXRlZD8NCg0KV2l0aCB0aGlzIHBhdGNoIG9ubHksIHRoZSBjYWxsZXIganVzdCBjaGVja3Mg
aWYgdGhlIHJldHVybiB2YWx1ZSBpcyA8IDANCihpZS4gYW4gZXJyb3IpLCBvdGhlcndpc2UgaXQg
YXNzdW1lcyBpdCB3YXMgb2theS4gIFdpdGggdGhpcyBwYXRjaCwgd2UNCnN0aWxsIHJldHVybiA8
IDAgb24gZXJyb3JzLCBidXQgd2UgcmV0dXJuIHBvc2l0aXZlLCBzYXlpbmcgdGhhdCB0aGUNCmJl
YWNvbiBoYXMgY2hhbmdlZC4NCg0KTXkgbmV4dCBwYXRjaCAoNS81KSBjaGFuZ2VzIHRoZSBjYWxs
ZXIgc28gdGhhdCB0aGUgdmFsdWUgaXMgdXNlZA0KcHJvcGVybHkgKGllLiBPUmluZyB0aGUgcmV0
dXJuIHZhbHVlIHRvIHRoZSBjaGFuZ2VkIHZhcmlhYmxlKS4NCg0KLS0NCkx1Y2EuDQo=
