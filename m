Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:56092 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752990Ab2JMBvd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Oct 2012 21:51:33 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Sam Leffler <sleffler@chromium.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>
Date: Fri, 12 Oct 2012 18:51:24 -0700
Subject: RE: [PATCH v4 0/5] add scan flags support
Message-ID: <477F20668A386D41ADCC57781B1F7043083B80D8BA@SC-VEXCH1.marvell.com> (sfid-20121013_035137_787181_97F1AABB)
References: <1350014615-14762-1-git-send-email-bzhao@marvell.com>
 <1350032395.10420.1.camel@jlt4.sipsolutions.net>
In-Reply-To: <1350032395.10420.1.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgSm9oYW5uZXMsDQoNCj4gPiBUaGlzIGlzIHRoZSB2NCBzZXJpZXMgcHJlcGFyZWQgYnkgQW1p
dGt1bWFyIEthcndhci4NCj4gPg0KPiA+IDEpICJ3aXBoeS0+ZmVhdHVyZXMiIGlzIHVzZWQgaW5z
dGVhZCBvZiAid2lwaHktPmZsYWdzIiB0byBhZHZlcnRpc2UNCj4gPiAgICBzY2FuIGZlYXR1cmVz
LiAoSm9oYW5uZXMgQmVyZykNCj4gPiAyKSBBZGRlZCBzdXBwb3J0IHRvIGRpc2FibGUgc2NhbiBm
bHVzaCBpZiBkcml2ZXIgcmVxdWVzdHMgZm9yIGl0DQo+ID4gICAgZXhwbGljaXRseS4gKEpvaGFu
bmVzIEJlcmcpDQo+ID4gMykgVXNlZCBtc2Vjc190b19qaWZmaWVzKCkgdG8gY29udmVydCB0aW1l
IGludGVydmFsIGludG8gamlmZmllcw0KPiA+ICAgIGZvciBjb21wYXJpc29uIChKb2hhbm5lcyBC
ZXJnKQ0KPiANCj4gT2ssIGFwcGxpZWQuDQo+IA0KPiBJIG1hZGUgdHdvIHNtYWxsIGNoYW5nZXMg
KGFuZCBpbnNlcnRlZCBhIHBhdGNoIGluIHRoZSBtaWRkbGUgdG8gYWxsb3cNCj4gZm9yIHRob3Nl
IGNoYW5nZXMpLg0KDQpUaGFua3MuDQoNCj4gDQo+IE9uZSBjaGFuZ2UgaXMgdGhhdCBJIGludmVy
dGVkIHRoZSBwb2xhcml0eSBvZiB0aGUgImZsdXNoIiBmZWF0dXJlIGZsYWcNCj4gc28gdGhhdCB1
c2Vyc3BhY2UgY2FuIGNoZWNrIGlmIGl0J3Mgc3VwcG9ydGVkIHdpdGhvdXQgaGF2aW5nIHRvIHdv
cnJ5DQo+IGFib3V0IHRoZSBrZXJuZWwgdmVyc2lvbi4NCj4gDQo+IFRoZSBvdGhlciBjaGFuZ2Ug
aXMgYSBmaXggaW4gbWFjODAyMTEgdG8gb25seSBzZXQgdGhlICJsb3cgcHJpbyIgc3VwcG9ydA0K
PiBmbGFnIGlmICpzb2Z0d2FyZSogc2NhbiBpcyB1c2VkLCBub3QgdW5jb25kaXRpb25hbGx5Lg0K
DQpNYWtlIHNlbnNlLg0KDQo+IA0KPiBQbGVhc2UgbWFrZSBzdXJlIHRob3NlIHN0aWxsIHdvcmsg
Zm9yIHlvdSwgSSBoYXZlbid0IHRlc3RlZCBpdC4NCg0KV2lsbCB0ZXN0IGFuZCBsZXQgeW91IGtu
b3cgaWYgYW55IHByb2JsZW0uDQoNCj4gDQo+IEl0IG1pZ2h0IGJlIG5pY2UgdG8gYWxzbyBoYXZl
IGEgbG93LXByaW8vZmx1c2ggZmxhZ3MgcGF0Y2ggZm9yIGl3IGFzDQo+IHdlbGwgaWYgeW91IGZp
bmQgdGhlIHRpbWUuDQoNClNhbSB3aWxsIHRha2UgY2FyZSBvZiB0aGUgaXcgcGF0Y2guDQoNClRo
YW5rcywNCkJpbmcNCg0KPiANCj4gam9oYW5uZXMNCj4gDQo=
