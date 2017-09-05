Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:17218 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750858AbdIEQtl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Sep 2017 12:49:41 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: "luca@coelho.fi" <luca@coelho.fi>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Coelho, Luciano" <luciano.coelho@intel.com>
Subject: Re: [PATCH 06/10] cfg80211: honor NL80211_RRF_NO_HT40{MINUS,PLUS}
Date: Tue, 5 Sep 2017 16:49:37 +0000
Message-ID: <1504630175.23076.5.camel@intel.com> (sfid-20170905_184952_864260_B2BA45BD)
References: <20170805084438.12550-1-luca@coelho.fi>
         <20170805084438.12550-7-luca@coelho.fi>
         <1504621814.12380.23.camel@sipsolutions.net>
In-Reply-To: <1504621814.12380.23.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gVHVlLCAyMDE3LTA5LTA1IGF0IDE2OjMwICswMjAwLCBKb2hhbm5lcyBCZXJnIHdyb3RlOg0K
PiBPbiBTYXQsIDIwMTctMDgtMDUgYXQgMTE6NDQgKzAzMDAsIEx1Y2EgQ29lbGhvIHdyb3RlOg0K
PiANCj4gPiArCXJlZ2QgPSBnZXRfd2lwaHlfcmVnZG9tKHdpcGh5KTsNCj4gPiArCWlmIChyZWdk
KSB7DQo+ID4gKwkJY29uc3Qgc3RydWN0IGllZWU4MDIxMV9yZWdfcnVsZSAqcmVnX3J1bGUgPQ0K
PiA+ICsJCQlmcmVxX3JlZ19pbmZvX3JlZ2QoTUhaX1RPX0tIWihjaGFubmVsLQ0KPiA+ID4gY2Vu
dGVyX2ZyZXEpLA0KPiA+IA0KPiA+ICsJCQkJCcKgwqDCoHJlZ2QsIE1IWl9UT19LSFooMjApKTsN
Cj4gPiANCj4gDQo+IFRoaXMgY291bGQgcmV0dXJuIGFuIGVycm9yLCBob3cgY2FuIHlvdSBiZSBz
dXJlIGl0IGRvZXNuJ3Q/DQo+IA0KDQpIbS4uLiBzbyBJIGd1ZXNzIEkgY291bGQgY2hlY2sgdGhh
dCBpdCBkaWRuJ3QgcmV0dXJuIGFueSBlcnJvciBhbmQgaWYNCml0IGRpZCwgdGhlbiBmbGFncyA9
IDA/DQoNClNvbWV0aGluZyBsaWtlIHRoaXM/IChvbiB0b3Agb2YgdGhpcyBwYXRjaCk6DQoNCkBA
IC0xNTA2LDE1ICsxNTA2LDE1IEBAIHN0YXRpYyB2b2lkIHJlZ19wcm9jZXNzX2h0X2ZsYWdzX2No
YW5uZWwoc3RydWN0IHdpcGh5ICp3aXBoeSwNCiAgICAgICAgICAgICAgICAgICAgICAgIGNoYW5u
ZWxfYWZ0ZXIgPSBjOw0KICAgICAgICB9DQogDQorICAgICAgIGZsYWdzID0gMDsNCiAgICAgICAg
cmVnZCA9IGdldF93aXBoeV9yZWdkb20od2lwaHkpOw0KICAgICAgICBpZiAocmVnZCkgew0KICAg
ICAgICAgICAgICAgIGNvbnN0IHN0cnVjdCBpZWVlODAyMTFfcmVnX3J1bGUgKnJlZ19ydWxlID0N
CiAgICAgICAgICAgICAgICAgICAgICAgIGZyZXFfcmVnX2luZm9fcmVnZChNSFpfVE9fS0haKGNo
YW5uZWwtPmNlbnRlcl9mcmVxKSwNCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICByZWdkLCBNSFpfVE9fS0haKDIwKSk7DQogDQotICAgICAgICAgICAgICAgZmxhZ3Mg
PSByZWdfcnVsZS0+ZmxhZ3M7DQotICAgICAgIH0gZWxzZSB7DQotICAgICAgICAgICAgICAgZmxh
Z3MgPSAwOw0KKyAgICAgICAgICAgICAgIGlmICghSVNfRVJSKHJlZ19ydWxlKSkNCisgICAgICAg
ICAgICAgICAgICAgICAgIGZsYWdzID0gcmVnX3J1bGUtPmZsYWdzOw0KICAgICAgICB9DQogDQog
ICAgICAgIC8q
