Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:17441 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932236AbdABL2H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Jan 2017 06:28:07 -0500
From: "Peer, Ilan" <ilan.peer@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "masashi.honma@gmail.com" <masashi.honma@gmail.com>
Subject: RE: [PATCH] mac80211: Fix addition of mesh configuration element
Date: Mon, 2 Jan 2017 11:28:03 +0000
Message-ID: <CB3B3D4774441E42AA3EA0E1BA8230A0615E3C59@HASMSX110.ger.corp.intel.com> (sfid-20170102_122811_019633_9282F95E)
References: <1482769056-28577-1-git-send-email-ilan.peer@intel.com>
         (sfid-20161226_151931_342648_794604E1)
 <1483354796.4596.9.camel@sipsolutions.net>
In-Reply-To: <1483354796.4596.9.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKb2hhbm5lcyBCZXJnIFttYWls
dG86am9oYW5uZXNAc2lwc29sdXRpb25zLm5ldF0NCj4gU2VudDogTW9uZGF5LCBKYW51YXJ5IDAy
LCAyMDE3IDEzOjAwDQo+IFRvOiBQZWVyLCBJbGFuIDxpbGFuLnBlZXJAaW50ZWwuY29tPg0KPiBD
YzogbGludXgtd2lyZWxlc3NAdmdlci5rZXJuZWwub3JnOyBtYXNhc2hpLmhvbm1hQGdtYWlsLmNv
bQ0KPiBTdWJqZWN0OiBSZTogW1BBVENIXSBtYWM4MDIxMTogRml4IGFkZGl0aW9uIG9mIG1lc2gg
Y29uZmlndXJhdGlvbiBlbGVtZW50DQo+IA0KPiBPbiBNb24sIDIwMTYtMTItMjYgYXQgMTg6MTcg
KzAyMDAsIElsYW4gUGVlciB3cm90ZToNCj4gPiBUaGUgY29kZSB3YXMgc2V0dGluZyB0aGUgY2Fw
YWJpbGl0aWVzIGJ5dGUgdG8gemVybywgYWZ0ZXIgaXQgd2FzDQo+ID4gYWxyZWFkeSBwcm9wZXJs
eSBzZXQgcHJldmlvdXNseS4gRml4IGl0Lg0KPiA+DQo+ID4gVGhlIGJ1ZyB3YXMgZm91bmQgd2hp
bGUgZGVidWdnaW5nIGh3c2ltIG1lc2ggdGVzdHMgZmFpbHVyZXMgdGhhdA0KPiA+IGhhcHBlbmVk
IGluIGNvbW1pdCA3NmY0M2I0IChtYWM4MDIxMTogUmVtb3ZlIGludmFsaWQgZmxhZyBvcGVyYXRp
b25zDQo+ID4gaW4gbWVzaCBUU0Ygc3luY2hyb25pemF0aW9uKS4NCj4gPg0KPiBBcHBsaWVkLCB0
aGFua3MuDQo+IA0KPiBXaGVuIHlvdSBoYXZlIHRoZSBjb21taXQgYWxyZWFkeSwgcGxlYXNlIGFk
ZCBhIEZpeGVzIHRhZywgYW5kIGFsc28gdXNlDQo+IDEyIGhleCBkaWdpdHMgdG8gYWJicmV2aWF0
ZSBTSEExcyBwbGVhc2UuIChJJ3ZlIGRvbmUgdGhhdCBub3cpDQo+IA0KDQpTdXJlLiBUaGFua3Mu
DQoNCklsYW4uDQo=
