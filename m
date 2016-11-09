Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:56807 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751372AbcKIGaZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Nov 2016 01:30:25 -0500
From: "Coelho, Luciano" <luciano.coelho@intel.com>
To: "kirtika.ruchandani@gmail.com" <kirtika.ruchandani@gmail.com>
CC: "Kaufman, Liad" <liad.kaufman@intel.com>,
        "Bondar, Alexander" <alexander.bondar@intel.com>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "eran.harary@intel.com" <eran.harary@intel.com>,
        "eyal@wizery.com" <eyal@wizery.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "Sharon, Sara" <sara.sharon@intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Subject: Re: [PATCH v2 0/3] Fix -Wunused-but-set-variable in
 iwlwifi/pcie/trans and iwlwifi/mvm/rs
Date: Wed, 9 Nov 2016 06:30:21 +0000
Message-ID: <1478673020.3313.8.camel@intel.com> (sfid-20161109_073028_880867_909DBF19)
References: <20161109054930.GA26716@google.com>
In-Reply-To: <20161109054930.GA26716@google.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gVHVlLCAyMDE2LTExLTA4IGF0IDIxOjQ5IC0wODAwLCBLaXJ0aWthIFJ1Y2hhbmRhbmkgd3Jv
dGU6DQo+IFRoaXMgcGF0Y2hzZXQgaXMgcGFydCBvZiB0aGUgZWZmb3J0IGxlZCBieSBBcm5kIEJl
cmdtYW5uIHRvIGNsZWFuIHVwDQo+IHdhcm5pbmdzIGluIHRoZSBrZXJuZWwuIFRoaXMgYW5kIGZv
bGxvd2luZyBwYXRjaHNldHMgd2lsbCBmb2N1cyBvbiANCj4gIi1XdW51c2VkLWJ1dC1zZXQtdmFy
aWFibGUiIGFzIGl0IGFtb25nIHRoZSBub2lzaWVyIG9uZXMuIFRoZXNlIHdlcmUNCj4gZm91bmQg
Y29tcGlsaW5nIHdpdGggVz0xLg0KPiANCj4gLS0gDQo+IENoYW5nZXMgaW4gdjI6DQo+IC0gTWFk
ZSB0aGUgZm9sbG93aW5nIGNoYW5nZXMgc3VnZ2VzdGVkIGJ5IEFybmQgaW4gYWxsIDMgcGF0Y2hl
cw0KPiAgIDEuIEVhY2ggcGF0Y2ggaGFzIGEgdW5pcXVlIHN1YmplY3QgbGluZS4NCj4gICAyLiBB
ZGQgdGhlIGNvbW1pdCB0aGF0IGludHJvZHVjZWQvbGVkIHRvIHRoZSB3YXJuaW5nIHdpdGggdGhl
ICJGaXhlczoiIGxpbmUuDQo+ICAgMy4gY2MgbGludXgtd2lyZWxlcywgY2MgY29tbWl0IGF1dGhv
cnMuDQo+IA0KPiBLaXJ0aWthIFJ1Y2hhbmRhbmkgKDMpOg0KPiAgIGl3bHdpZmk6IG12bTogcnM6
IFJlbW92ZSB1bnVzZWQgJ212bXZpZicvJ212bXN0YScgdmFyaWFibGVzDQo+ICAgaXdsd2lmaTog
bXZtOiByczogUmVtb3ZlIHVudXNlZCAnbWNzJyB2YXJpYWJsZQ0KPiAgIGl3bHdpZmk6IHBjaWU6
IHRyYW5zOiBSZW1vdmUgdW51c2VkICdzaGlmdF9wYXJhbScNCj4gDQo+ICBkcml2ZXJzL25ldC93
aXJlbGVzcy9pbnRlbC9pd2x3aWZpL212bS9ycy5jICAgICB8IDEwICstLS0tLS0tLS0NCj4gIGRy
aXZlcnMvbmV0L3dpcmVsZXNzL2ludGVsL2l3bHdpZmkvcGNpZS90cmFucy5jIHwgIDMgLS0tDQo+
ICAyIGZpbGVzIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxMiBkZWxldGlvbnMoLSkNCg0KVGhh
bmtzLCBLaXJ0aWthISBJJ2xsIHB1c2ggdGhlc2UgcGF0Y2hlcyB2aWEgb3VyIGludGVybmFsIHRy
ZWUgYW5kDQppbmNsdWRlIHRoZW0gaW4gbXkgbmV4dCBwdWxsIHJlcXVlc3QgdG8gS2FsbGUuDQoN
Ci0tIA0KQ2hlZXJzLA0KTHVjYS4=
