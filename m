Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:10209 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751814AbdIFHwF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Sep 2017 03:52:05 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        "luca@coelho.fi" <luca@coelho.fi>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Coelho, Luciano" <luciano.coelho@intel.com>
Subject: RE: [PATCH 06/10] cfg80211: honor NL80211_RRF_NO_HT40{MINUS,PLUS}
Date: Wed, 6 Sep 2017 07:51:20 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB3FF7DA58E@HASMSX112.ger.corp.intel.com> (sfid-20170906_095412_170103_E4F24ED7)
References: <20170805084438.12550-1-luca@coelho.fi>
         <20170805084438.12550-7-luca@coelho.fi>
         <1504621814.12380.23.camel@sipsolutions.net>
         <1504630175.23076.5.camel@intel.com>
 <1504682981.12380.28.camel@sipsolutions.net>
In-Reply-To: <1504682981.12380.28.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PiANCj4gT24gVHVlLCAyMDE3LTA5LTA1IGF0IDE2OjQ5ICswMDAwLCBHcnVtYmFjaCwgRW1tYW51
ZWwgd3JvdGU6DQo+ID4gT24gVHVlLCAyMDE3LTA5LTA1IGF0IDE2OjMwICswMjAwLCBKb2hhbm5l
cyBCZXJnIHdyb3RlOg0KPiA+ID4gT24gU2F0LCAyMDE3LTA4LTA1IGF0IDExOjQ0ICswMzAwLCBM
dWNhIENvZWxobyB3cm90ZToNCj4gPiA+DQo+ID4gPiA+ICsJcmVnZCA9IGdldF93aXBoeV9yZWdk
b20od2lwaHkpOw0KPiA+ID4gPiArCWlmIChyZWdkKSB7DQo+ID4gPiA+ICsJCWNvbnN0IHN0cnVj
dCBpZWVlODAyMTFfcmVnX3J1bGUgKnJlZ19ydWxlID0NCj4gPiA+ID4gKwkJCWZyZXFfcmVnX2lu
Zm9fcmVnZChNSFpfVE9fS0haKGNoYW5uZWwtDQo+ID4gPiA+ID4gY2VudGVyX2ZyZXEpLA0KPiA+
ID4gPg0KPiA+ID4gPiArCQkJCQnCoMKgwqByZWdkLA0KPiA+ID4gPiBNSFpfVE9fS0haKDIwKSk7
DQo+ID4gPiA+DQo+ID4gPg0KPiA+ID4gVGhpcyBjb3VsZCByZXR1cm4gYW4gZXJyb3IsIGhvdyBj
YW4geW91IGJlIHN1cmUgaXQgZG9lc24ndD8NCj4gPiA+DQo+ID4NCj4gPiBIbS4uLiBzbyBJIGd1
ZXNzIEkgY291bGQgY2hlY2sgdGhhdCBpdCBkaWRuJ3QgcmV0dXJuIGFueSBlcnJvciBhbmQgaWYN
Cj4gPiBpdCBkaWQsIHRoZW4gZmxhZ3MgPSAwPw0KPiA+DQo+ID4gU29tZXRoaW5nIGxpa2UgdGhp
cz8gKG9uIHRvcCBvZiB0aGlzIHBhdGNoKToNCj4gPiBbc25pcF0NCj4gDQo+IHllYWggdGhhdCdz
IG9idmlvdXNseSB0aGUgZWFzeSB0aGluZyB0byBkbyAtIEkganVzdCB3YXNuJ3Qgc3VyZSB0aGF0
IHlvdSBkaWRuJ3QNCj4gaGF2ZSBhIHJlYXNvbiB0byBiZWxpZXZlIGl0IGNvdWxkIG5ldmVyIGJl
IGFuIEVSUl9QVFIgOikNCj4NClRCSCwgSSBkb24ndCByZWFsbHkga25vdy4uLiBJIGRvbid0IGtu
b3cgaWYgKmFsbCogdGhlIGNoYW5uZWxzIGFyZSBjb3ZlcmVkIGJ5IHJ1bGVzLg0KRm9yIHN1cmUs
IGlmIHRoZXJlIGlzIG5vIHJ1bGUsIEkgY2FuIGFzc3VtZSB0aGF0IHRoZSBIVDQweyssLX0gYXJl
IG5vdCBzZXQuLi4gQnV0IEkgZG9uJ3Qga25vdyBpZiB0aGF0J3MgZXZlbiBwb3NzaWJsZS4NCg0K
