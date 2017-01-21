Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:55904 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750717AbdAUKyd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 21 Jan 2017 05:54:33 -0500
From: "Coelho, Luciano" <luciano.coelho@intel.com>
To: "kvalo@codeaurora.org" <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Coelho, Luciano" <luciano.coelho@intel.com>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Subject: Re: iwlwifi: fix kernel crash when unregistering thermal zone
Date: Sat, 21 Jan 2017 10:54:30 +0000
Message-ID: <1484996068.2774.23.camel@intel.com> (sfid-20170121_115436_088654_F45AE899)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

KHJlc2VuZGluZywgc29ycnkgZm9yIHRoZSBIVE1MIHZlcnNpb24gbXkgcGhvbmUgZGVjaWRlZCB0
byB1c2UgZm9yIHRoaXMpDQoNCk9uIEphbiAyMSwgMjAxNyAwOTo1NiwgS2FsbGUgVmFsbyA8a3Zh
bG9AY29kZWF1cm9yYS5vcmc+IHdyb3RlOg0KSmVucyBBeGJvZSA8YXhib2VAa2VybmVsLmRrPiB3
cml0ZXM6IA0KPiA+IEEgcmVjZW50IGZpcm13YXJlIGNoYW5nZSBzZWVtcyB0byBoYXZlIGVuYWJs
ZWQgdGhlcm1hbCB6b25lcyBvbiB0aGUgDQo+ID4gaXdsd2lmaSBkcml2ZXIuIFVuZm9ydHVuYXRl
bHksIG15IGRldmljZSBmYWlscyB3aGVuIHJlZ2lzdGVyaW5nIHRoZSANCj4gPiB0aGVybWFsIHpv
bmUuIFRoaXMgZG9lc24ndCBzdG9wIHRoZSBkcml2ZXIgZnJvbSBhdHRlbXB0aW5nIHRvIHVucmVn
aXN0ZXIgDQo+ID4gdGhlIHRoZXJtYWwgem9uZSBhdCB1bmxvYWQgdGltZSwgdHJpZ2dlcmluZyBh
IE5VTEwgcG9pbnRlciBkZWZlcmVuY2UgaW4gDQo+ID4gc3RybGVuKCkgb2ZmIHRoZSB0aGVybWFs
X3pvbmVfZGV2aWNlX3VucmVnaXN0ZXIoKSBwYXRoLiANCj4gPiANCj4gPiBEb24ndCB1bnJlZ2lz
dGVyIGlmIG5hbWUgaXMgTlVMTCwgZm9yIHRoYXQgY2FzZSB3ZSBmYWlsZWQgcmVnaXN0ZXJpbmcu
IA0KPiA+IERvIHRoZSBzYW1lIGZvciB0aGUgY29vbGluZyB6b25lLiANCj4gPiANCj4gPiBTaWdu
ZWQtb2ZmLWJ5OiBKZW5zIEF4Ym9lIDxheGJvZUBmYi5jb20+IA0KPiA+IA0KPiA+IC0tLSANCj4g
PiANCj4gPiBXb3VsZCBiZSBncmVhdCBpZiB0aGlzIGNvdWxkIGdvIGludG8gdGhlIGN1cnJlbnQg
c2VyaWVzLCBhcyBzb21ldGltZXMgSSANCj4gPiBoYXZlIHRvIHJlbG9hZCB0aGUgZHJpdmVyLiBS
aWdodCBub3cgSSBjYW4ndCwgc2luY2UgaXQgY3Jhc2hlcy4uLiANCj4gDQo+IEx1Y2EsIGNhbiBJ
IHRha2UgdGhpcyBkaXJlY3RseSB0byB3aXJlbGVzcy1kcml2ZXJzPyBUaGlzIGlzIGFuIGltcG9y
dGFudCANCj4gZml4IGFuZCB3ZSBzaG91bGQgZ2V0IGl0IHRvIExpbnVzJyB0cmVlIEFTQVAuDQoN
ClllcywgcGxlYXNlIGdvIGFoZWFkIGFuZCB0YWtlIGl0IGRpcmVjdGx5Lg0KDQpBY2tlZC1ieTog
THVjYSBDb2VsaG8gPGx1Y2lhbm8uY29lbGhvQGludGVsLmNvbT4NCg0KVGhhbmtzIQ0KDQotLQ0K
Q2hlZXJzLA0KTHVjYS4=
