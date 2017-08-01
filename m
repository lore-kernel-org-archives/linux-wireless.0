Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:28264 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751038AbdHAEs5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 Aug 2017 00:48:57 -0400
From: "Coelho, Luciano" <luciano.coelho@intel.com>
To: "kvalo@codeaurora.org" <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Subject: Re: [PATCH 19/24] iwlwifi: mvm: fix TCP CSUM offload with WEP and
 A000 series
Date: Tue, 1 Aug 2017 04:48:55 +0000
Message-ID: <1501562934.2588.39.camel@intel.com> (sfid-20170801_064900_280572_F48BBC18)
References: <20170728142337.19183-1-luca@coelho.fi>
         <20170728142337.19183-20-luca@coelho.fi>
In-Reply-To: <20170728142337.19183-20-luca@coelho.fi>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gRnJpLCAyMDE3LTA3LTI4IGF0IDE3OjIzICswMzAwLCBMdWNhIENvZWxobyB3cm90ZToNCj4g
RnJvbTogRW1tYW51ZWwgR3J1bWJhY2ggPGVtbWFudWVsLmdydW1iYWNoQGludGVsLmNvbT4NCj4g
DQo+IFdoZW4gd2UgZW5hYmxlZCBUQ1AgY2hlY2tzdW0gb2ZmbG9hZCwgd2UgbmVlZCB0byB0ZWxs
IHRoZQ0KPiBmaXJtd2FyZSB3aGVyZSB0aGUgSVAgaGVhZGVyIHN0YXJ0cy4gSWYgd2UgaGF2ZSBh
biBJViwgdGhlbg0KPiB3ZSBuZWVkIHRvIGFkYXB0IHRoYXQgdmFsdWUgc2luY2UgdGhlIElWIGlz
IHBsYWNlZCBiZWZvcmUNCj4gdGhlIFNOQVAgaGVhZGVyLiBUaGlzIGlzIHRydWUgb25seSBmb3Ig
Y2FzZXMgd2hlcmUgdGhlDQo+IGRyaXZlciBhZGRzIHRoZSBJViwgbm90IHRoZSBXRVAgY2FzZSBp
biB3aGljaCB0aGUgSVYgaXMNCj4gYWRkZWQgYnkgdGhlIGZpcm13YXJlIGl0c2VsZi4NCj4gDQo+
IE9uIEEwMDAgZGV2aWNlcyBzZXJpZXMsIHRoZSBJViBpcyBhbHdheXMgYWRkZWQgYnkgdGhlDQo+
IGRldmljZS4NCj4gDQo+IEZpeCB0aGlzLg0KPiANCj4gRml4ZXM6IDVlNmE5OGRjNDg2MyAoIml3
bHdpZmk6IG12bTogZW5hYmxlIFRDUC9VRFAgY2hlY2tzdW0gc3VwcG9ydCBmb3IgOTAwMCBmYW1p
bHkiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBFbW1hbnVlbCBHcnVtYmFjaCA8ZW1tYW51ZWwuZ3J1bWJh
Y2hAaW50ZWwuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBMdWNhIENvZWxobyA8bHVjaWFuby5jb2Vs
aG9AaW50ZWwuY29tPg0KPiAtLS0NCg0KRW1tYW51ZWwgYXNrZWQgbWUgdG8gc2VuZCB0aGlzIGZv
ciB0aGUgcmMtc2VyaWVzLCBzaW5jZSBpdCBmaXhlcyBvdXINCm5ld2x5IHN1cHBvcnRlZCA5MDAw
IGZhbWlseS4NCg0KLS0NCkx1Y2Eu
