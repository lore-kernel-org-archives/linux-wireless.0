Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:3543 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725955AbeICNsT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Sep 2018 09:48:19 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        Luca Coelho <luca@coelho.fi>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Coelho, Luciano" <luciano.coelho@intel.com>
Subject: RE: [PATCH 09/28] mac80211: pass the TWT support bits in extended
 caps to the driver
Date: Mon, 3 Sep 2018 09:28:51 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB30126D281A5@HASMSX112.ger.corp.intel.com> (sfid-20180903_112904_557746_D2AB9DD8)
References: <20180831083130.15525-1-luca@coelho.fi>
         <20180831083130.15525-10-luca@coelho.fi>
         (sfid-20180831_103155_573128_7D703B85)
 <1535964771.3437.17.camel@sipsolutions.net>
In-Reply-To: <1535964771.3437.17.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PiANCj4gPiBTaW5jZSB0aG9zZSBiaXRzIGFyZSBwcmVzZW50IGluIHRoZSBIRSBDYXAgYXMgd2Vs
bCwgd2UgY2FuIHNldCB0aGUNCj4gPiBjYXBhYmlsaXR5IGJpdHMgaW4gdGhlIEV4dGVuZGVkIENh
cGFiaWxpdGllcyBJRSBiYXNlZCBvbiB3aGF0IGlzDQo+ID4gYWR2ZXJ0aXNlZCBpbiB0aGUgSEUg
Q2FwIElFLg0KPiANCj4gSXQncyBub3QgY2xlYXIgdG8gbWUgd2hhdCB0aGlzIGlzIHRyeWluZyB0
byBzYXksIHlvdSBkb24ndCBzZWVtIHRvIGRvIGFueXRoaW5nDQo+IHdpdGggdGhlIEhFIGNhcGFi
aWxpdGllcyBpbiB0aGUgcGF0Y2guDQo+DQoNCllvdSBhcmUgcmlnaHQuIFlvdSBjYW4gZHJvcCB0
aGlzIHBhcnQgb2YgdGhlIGNvbW1pdCBsb2cuIEkgZ3Vlc3MgSSB3cm90ZSB0aGF0DQpmb3IgdGhl
IEFQIG1vZGUgYnV0IGluIHRoZSBBUCBtb2RlIHRoaXMgaXMgbm90IHJlbGV2YW50IHNpbmNlIHRo
ZSBiZWFjb24gaXMNCmJ1aWx0IGJ5IGhvc3RhcGQuDQpGb3IgbWFuYWdlZCBtb2RlLCB0aGUgZHJp
dmVyIHdpbGwgbmVlZCB0byBjaGVjayB0aGUgSEUgY2FwIGFsb25nIHdpdGggdGhlDQpleHRlbmRl
ZCBjYXBhYmlsaXRpZXMgdG8gZGV0ZXJtaW5lIHdoZXRoZXIgQVAgc3VwcG9ydHMgVFdUIG9yIG5v
dC4NCg==
