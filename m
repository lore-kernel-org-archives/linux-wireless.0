Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:29681 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752262AbaFFHBt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jun 2014 03:01:49 -0400
From: "Coelho, Luciano" <luciano.coelho@intel.com>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>
Subject: Re: [PATCH 2/3] mac80211: add functions to stop and wake all queues
 assigned to a vif
Date: Fri, 6 Jun 2014 07:01:35 +0000
Message-ID: <1402038095.2004.17.camel@dubbel> (sfid-20140606_090209_863224_97F1E479)
References: <1401985567-27336-2-git-send-email-emmanuel.grumbach@intel.com>
In-Reply-To: <1401985567-27336-2-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gVGh1LCAyMDE0LTA2LTA1IGF0IDE5OjI2ICswMzAwLCBFbW1hbnVlbCBHcnVtYmFjaCB3cm90
ZToNCj4gRnJvbTogTHVjaWFubyBDb2VsaG8gPGx1Y2lhbm8uY29lbGhvQGludGVsLmNvbT4NCj4g
DQo+IEluIHNvbWUgY2FzZXMgd2UgbWF5IHdhbnQgdG8gc3RvcCB0aGUgcXVldWVzIG9mIGEgc2lu
Z2xlIHZpZiAoZm9yDQo+IGluc3RhbmNlIGR1cmluZyBhIGNoYW5uZWwtc3dpdGNoKS4gIEFkZCBh
IGZ1bmN0aW9uIHRoYXQgc3RvcHMgYWxsIHRoZQ0KPiBxdWV1ZXMgdGhhdCBhcmUgYXNzaWduZWQg
dG8gYSB2aWYuICBJZiBhIHF1ZXVlIGlzIGFzc2lnbmVkIHRvIG1vcmUNCj4gdGhhbiBvbmUgdmlm
LCB0aGUgY29ycmVzcG9uZGluZyBuZXRkZXYgc3VicXVldWUgb2YgdGhlIG90aGVyIHZpZihzKQ0K
PiB3aWxsIGFsc28gYmUgc3RvcHBlZC4gIElmIHRoZSBIVyBkb2Vzbid0IHNldCB0aGUNCj4gSUVF
RTgwMjExX0hXX1FVRVVFX0NPTlRST0wgZmxhZywgdGhlbiBhbGwgcXVldWVzIGFyZSBzdG9wcGVk
Lg0KPiANCj4gQWxzbyBhZGQgYSBjb3JyZXNwb25kaW5nIGZ1bmN0aW9uIHRvIHdha2UgdGhlIHF1
ZXVlcyBvZiBhIHZpZiBiYWNrLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogTHVjaWFubyBDb2VsaG8g
PGx1Y2lhbm8uY29lbGhvQGludGVsLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogRW1tYW51ZWwgR3J1
bWJhY2ggPGVtbWFudWVsLmdydW1iYWNoQGludGVsLmNvbT4NCj4gLS0tDQoNClsuLi5dDQoNCj4g
K3ZvaWQgaWVlZTgwMjExX3dha2VfdmlmX3F1ZXVlcyhzdHJ1Y3QgaWVlZTgwMjExX2xvY2FsICps
b2NhbCwNCj4gKwkJCSAgICAgICBzdHJ1Y3QgaWVlZTgwMjExX3N1Yl9pZl9kYXRhICpzZGF0YSwN
Cj4gKwkJCSAgICAgICBlbnVtIHF1ZXVlX3N0b3BfcmVhc29uIHJlYXNvbikNCj4gK3sNCj4gKwlp
ZWVlODAyMTFfd2FrZV9xdWV1ZXNfYnlfcmVhc29uKCZsb2NhbC0+aHcsDQo+ICsJCQkJCWllZWU4
MDIxMV9nZXRfdmlmX3F1ZXVlcyhsb2NhbCwgc2RhdGEpLA0KPiArCQkJCQlJRUVFODAyMTFfUVVF
VUVfU1RPUF9SRUFTT05fRFJJVkVSKTsNCg0KT29vcHMsIHRoaXMgaXMgd3JvbmcsIGl0IHNob3Vs
ZCBiZSByZWFzb24gaW5zdGVhZC4NCg0KLS0NCkx1Y2EuDQo=
