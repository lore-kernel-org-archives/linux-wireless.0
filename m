Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:40409 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750818AbeANHWc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 14 Jan 2018 02:22:32 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: "luca@coelho.fi" <luca@coelho.fi>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Coelho, Luciano" <luciano.coelho@intel.com>
Subject: Re: [PATCH 0/5] iwlwifi: updates intended for v4.16 2017-12-23
Date: Sun, 14 Jan 2018 07:22:28 +0000
Message-ID: <1515914548.7436.1.camel@intel.com> (sfid-20180114_082411_852713_3C476DC7)
References: <20171223092200.30270-1-luca@coelho.fi>
         <871sivs48k.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <871sivs48k.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgS2FsZSwNCg0KT24gRnJpLCAyMDE4LTAxLTEyIGF0IDEzOjMxICswMjAwLCBLYWxsZSBWYWxv
IHdyb3RlOg0KPiBGcm9tOiBMdWNhIENvZWxobyA8bHVjaWFuby5jb2VsaG9AaW50ZWwuY29tPg0K
PiA+IA0KPiA+IEhpLA0KPiA+IA0KPiA+IEhlcmUncyB0aGUgZm91cnRoIGFuZCBwcm9iYWJseSBs
YXN0IGJhdGNoIG9mIHBhdGNoZXMgaW50ZW5kZWQgZm9yDQo+ID4gNC4xNi4gIE5vdGhpbmcgbWFq
b3IsIGp1c3QgY29udGludWVkIGRldmVsb3BtZW50LCBzb21lIGNsZWFudXBzIGFuZA0KPiA+IHNt
YWxsIGZpeGVzIGhlcmUgYW5kIHRoZXJlLg0KPiA+IA0KPiA+ICogRml4IGEgVUJTQU4gd2Fybmlu
ZzsNCj4gPiAqIEltcHJvdmVtZW50IGluIHRoZSBuZXQtc3RhY2svZHJpdmVyIGxvZyBzeW5jaW5n
DQo+ID4gKiBBbiBSQ1UgbG9jayBmaXggaW4gdGhlIG5ldyByYXRlLXNjYWxpbmcgY29kZTsNCj4g
PiAqIFNtYWxsIGNsZWFudXBzOw0KPiA+IA0KPiA+IEFzIHVzdWFsLCBJJ20gcHVzaGluZyB0aGlz
IHRvIGEgcGVuZGluZyBicmFuY2gsIGZvciBrYnVpbGQgYm90LCBhbmQNCj4gPiB3aWxsIHNlbmQg
YSBwdWxsLXJlcXVlc3QgbGF0ZXIuDQo+ID4gDQo+ID4gRllJLCBJJ2xsIGJlIG9uIGhvbGlkYXlz
L3ZhY2F0aW9ucyBmb3IgdGhlIG5leHQgZmV3IHdlZWtzLCBzbyB0aGVyZQ0KPiA+IHdpbGwgcHJv
YmFibHkgbm90IGJlIG11Y2ggYWN0aXZpdHkgaW4gdGhlIGl3bHdpZmkgZHJpdmVyIGNvZGUuDQo+
ID4gDQo+ID4gUGxlYXNlIHJldmlldy4NCj4gPiANCj4gPiBDaGVlcnMsDQo+ID4gTHVjYS4NCj4g
PiANCj4gPiANCj4gPiBMdWNhIENvZWxobyAoMSk6DQo+ID4gICBpd2x3aWZpOiBtdm06IGNoZWNr
IGlmIG1hYzgwMjExX3F1ZXVlIGlzIHZhbGlkIGluDQo+ID4gaXdsX212bV9kaXNhYmxlX3R4cQ0K
PiA+IA0KPiA+IE1vcmRlY2hheSBHb29kc3RlaW4gKDEpOg0KPiA+ICAgaXdsd2lmaTogc2V0IGRl
ZmF1bHQgdGltc3RhbXAgbWFya2VyIGNtZA0KPiA+IA0KPiA+IFNhcmEgU2hhcm9uICgzKToNCj4g
PiAgIGl3bHdpZmk6IG12bTogZmxpcCBBTVNEVSBhZGRyZXNzZXMgb25seSBmb3IgOTAwMCBmYW1p
bHkNCj4gPiAgIGl3bHdpZmk6IG12bTogdGFrZSBSQ1UgbG9jayBiZWZvcmUgZGVyZWZlcmVuY2lu
Zw0KPiA+ICAgaXdsd2lmaTogbXZtOiBtb3ZlIFRTTyBzZWdtZW50IHRvIGEgc2VwYXJhdGUgZnVu
Y3Rpb24NCj4gDQo+IE1vc3QgbGlrZWx5IHRoZSBtZXJnZSB3aW5kb3cgc3RhcnRzIGluIDkgZGF5
cyBzbyBJIG5lZWQgdG8gc3RhcnQNCj4gZ2V0dGluZw0KPiBwYXRjaGVzIHJlYWR5LiBBcyBMdWNh
IGlzIGF3YXkgc2hvdWxkIEkgYXBwbHkgdGhlc2UgcGF0Y2hlcyBkaXJlY3RseQ0KPiB0bw0KPiB3
aXJlbGVzcy1kcml2ZXJzLW5leHQ/DQo+IA0KDQpGaXJzdCBsZXQgbWUgdGhhbmsgeW91IGZvciB0
cmFja2luZyB0aGlzLg0KSSBkb24ndCBzZWUgYW55dGhpbmcgdGhhdCB3ZSByZWFsbHkgbmVlZCBp
biA0LjE2IGhlcmUuDQpCZXNpZGVzIEx1Y2EncyBVQlNBTiB3YXJuaW5nLCBhbGwgdGhlIHJlc3Qg
aXMgZm9yIGEgbmV3IGRldmljZQ0KZmFtaWx5IHdoaWNoIHdvbid0IGJlIHN1cHBvcnRlZCBpbiA0
LjE2IGFueXdheS4NCg0KU28gSSBvcHQgdG8gd2FpdCBmb3IgTHVjYSBoZXJlLg==
