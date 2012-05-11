Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:46458 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758396Ab2EKS5h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 May 2012 14:57:37 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 11 May 2012 11:57:26 -0700
Subject: RE: [PATCH] mwifiex: remove set_channel cfg80211 hook
Message-ID: <477F20668A386D41ADCC57781B1F7043083A57BA9D@SC-VEXCH1.marvell.com> (sfid-20120511_205741_738893_E9D6E80A)
References: <1336757074.12801.18.camel@jlt3.sipsolutions.net>
	 <477F20668A386D41ADCC57781B1F7043083A57BA86@SC-VEXCH1.marvell.com>
	 <1336760775.8739.1.camel@jlt3.sipsolutions.net>
	 (sfid-20120511_202625_610548_B0B58C36)
 <1336760829.8739.2.camel@jlt3.sipsolutions.net>
In-Reply-To: <1336760829.8739.2.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgSm9oYW5uZXMsDQoNCj4gPiA+ID4gRnJvbTogSm9oYW5uZXMgQmVyZyA8am9oYW5uZXMuYmVy
Z0BpbnRlbC5jb20+DQo+ID4gPiA+DQo+ID4gPiA+IFNpbmNlIG13aWZpZXggb25seSBzdXBwb3J0
cyBtYW5hZ2VkIGFuZCBJQlNTDQo+ID4gPiA+IG1vZGVzLCBpdCBkb2Vzbid0IG5lZWQgYSBzZXRf
Y2hhbm5lbCBjYWxsLiBUaGUNCj4gPiA+ID4gY2FsbGJhY2sgbWlnaHQgYmUgY2FsbGVkLCBidXQg
aXQgd29uJ3QgbWF0dGVyDQo+ID4gPiA+IGFzIG5vdGhpbmcgY2FuIHVzZSB0aGUgY2hhbm5lbC4N
Cj4gPiA+DQo+ID4gPiBXZSBzdGlsbCBuZWVkIHRoaXMgc2V0X2NoYW5uZWwgaGFuZGVyIGZvciBz
dGF0aW9uIElCU1MgbW9kZS4NCj4gPiA+IFVzZXIgbWF5IHdhbnQgdG8gdXNlICJpdyBtbGFuMCBz
ZXQgY2hhbm5lbCAxMSIgY29tbWFuZCB0byBjb25maWd1cmUgdGhlIGNoYW5uZWwgYmVmb3JlIHN0
YXJ0aW5nDQo+IGFuIElCU1MgbmV0d29yay4NCj4gPg0KPiA+IFRoYXQgZG9lc24ndCBtYWtlIHNl
bnNlIHRob3VnaCwgc2luY2UgeW91IHNob3VsZCBnaXZlIHRoZSBjaGFubmVsIHRvDQo+ID4gam9p
biB0aGUgSUJTUz8NCj4gPg0KPiA+IGl3IG1sYW4wIGlic3Mgam9pbiA8U1NJRD4gMjQ2Mg0KDQpI
bW0sIHRoYXQncyB0cnVlLg0KDQo+ID4NCj4gPiBTbyBtYXliZSBtd2lmaWV4X2NmZzgwMjExX2pv
aW5faWJzcygpIHNob3VsZCB1c2UgdGhlIGNoYW5uZWwgaXQgZ2V0cw0KPiA+IGluc3RlYWQuDQo+
IA0KPiBOZXZlciBtaW5kLCBpdCBhbHJlYWR5IGRvZXMuIEFuZCB0aGVyZWJ5IG92ZXJyaWRlcyBh
bnl0aGluZyB5b3UgZGlkIHdpdGgNCj4gIml3IG1sYW4wIHNldCBjaGFubmVsIDExIi4NCg0KSSds
bCBhY2sgeW91ciBwYXRjaCB0aGVuLg0KDQpUaGFua3MsDQpCaW5nDQoNCg0K
