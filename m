Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:64406 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752299AbbG1LfL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2015 07:35:11 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	"Sharon, Sara" <sara.sharon@intel.com>
Subject: RE: [RFC 02/10] mac80211: allow to transmit A-MSDU within A-MPDU
Date: Tue, 28 Jul 2015 11:35:07 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB32E7D9B01@hasmsx107.ger.corp.intel.com> (sfid-20150728_133515_664955_0CFE8D3A)
References: <1437421384-19884-1-git-send-email-emmanuel.grumbach@intel.com>
 <1437421384-19884-3-git-send-email-emmanuel.grumbach@intel.com>
 <CABPxzYKKCLDaoAyE0VR66ynAxnm9Ob5m6T0ADbH415J6-i=6WA@mail.gmail.com>
In-Reply-To: <CABPxzYKKCLDaoAyE0VR66ynAxnm9Ob5m6T0ADbH415J6-i=6WA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PiANCj4gT24gVHVlLCBKdWwgMjEsIDIwMTUgYXQgMToxMiBBTSwgRW1tYW51ZWwgR3J1bWJhY2gN
Cj4gPGVtbWFudWVsLmdydW1iYWNoQGludGVsLmNvbT4gd3JvdGU6DQo+ID4NCj4gPiBkaWZmIC0t
Z2l0IGEvbmV0L21hYzgwMjExL2FnZy10eC5jIGIvbmV0L21hYzgwMjExL2FnZy10eC5jIGluZGV4
DQo+ID4gYzhiYTJlNy4uYTc1OGViODQgMTAwNjQ0DQo+ID4gLS0tIGEvbmV0L21hYzgwMjExL2Fn
Zy10eC5jDQo+ID4gKysrIGIvbmV0L21hYzgwMjExL2FnZy10eC5jDQo+ID4gQEAgLTk3LDcgKzk3
LDggQEAgc3RhdGljIHZvaWQgaWVlZTgwMjExX3NlbmRfYWRkYmFfcmVxdWVzdChzdHJ1Y3QNCj4g
aWVlZTgwMjExX3N1Yl9pZl9kYXRhICpzZGF0YSwNCj4gPiAgICAgICAgIG1nbXQtPnUuYWN0aW9u
LnUuYWRkYmFfcmVxLmFjdGlvbl9jb2RlID0NCj4gPiBXTEFOX0FDVElPTl9BRERCQV9SRVE7DQo+
ID4NCj4gPiAgICAgICAgIG1nbXQtPnUuYWN0aW9uLnUuYWRkYmFfcmVxLmRpYWxvZ190b2tlbiA9
IGRpYWxvZ190b2tlbjsNCj4gPiAtICAgICAgIGNhcGFiID0gKHUxNikoMSA8PCAxKTsgICAgICAg
ICAgLyogYml0IDEgYWdncmVnYXRpb24gcG9saWN5ICovDQo+ID4gKyAgICAgICBjYXBhYiA9ICh1
MTYpKDEgPDwgMCk7ICAgICAgICAgIC8qIGJpdCAwIEEtTVNEVSBzdXBwb3J0ICovDQo+IA0KPiBT
aG91bGRuJ3QgdGhpcyBiZSBiYXNlZCBvbiBIVyBjYXBhYmlsaXR5PyBXZSBjYW4gYWRkIGNvdXBs
ZSBvZiBtb3JlIF9IV18NCj4gZmxhZ3MgZm9yIFRYIGFuZCBSWCBhbmQgcG9wdWxhdGUgdGhpcyBi
YXNlZCBvbiB0aGF0Pw0KDQpXaHk/DQpXaGF0IHdpbGwgaGFwcGVuIGlmIHdlIGFzayBmb3IgQS1N
U0RVIGluc2lkZSBBLU1QRFUgYW5kIHdlIHdvbid0IGRvIEEtTVNEVT8NCldvcnN0IGNhc2UsIHRo
ZSBBUCB3aWxsIGRlbnkgdGhpcyBhbmQgd2lsbCBjbGVhciB0aGF0IGJpdCBpbiBpdHMgcmVzcG9u
c2UuDQoNCj4gDQo+ID4NCj4gPiArICAgICAgIGNhcGFiIHw9ICh1MTYpKDEgPDwgMSk7ICAgICAg
ICAgLyogYml0IDEgYWdncmVnYXRpb24gcG9saWN5ICovDQo+ID4gICAgICAgICBjYXBhYiB8PSAo
dTE2KSh0aWQgPDwgMik7ICAgICAgIC8qIGJpdCA1OjIgVElEIG51bWJlciAqLw0KPiA+ICAgICAg
ICAgY2FwYWIgfD0gKHUxNikoYWdnX3NpemUgPDwgNik7ICAvKiBiaXQgMTU6NiBtYXggc2l6ZSBv
Zg0KPiA+IGFnZ2VyZ2F0aW9uICovDQo=
