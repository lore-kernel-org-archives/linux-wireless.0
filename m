Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:41024 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933467Ab1CXAt7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Mar 2011 20:49:59 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Ramesh Radhakrishnan <rramesh@marvell.com>,
	Frank Huang <frankh@marvell.com>
Date: Wed, 23 Mar 2011 17:47:44 -0700
Subject: RE: [PATCH v3] wireless: mwifiex: initial commit for Marvell
 mwifiex driver
Message-ID: <477F20668A386D41ADCC57781B1F704307FA79180F@SC-VEXCH1.marvell.com>
References: <1300755650-21740-1-git-send-email-bzhao@marvell.com>
	 <1300884446.3790.38.camel@jlt3.sipsolutions.net>
	 <477F20668A386D41ADCC57781B1F704307FA7916C7@SC-VEXCH1.marvell.com>
 <1300907864.3790.43.camel@jlt3.sipsolutions.net>
In-Reply-To: <1300907864.3790.43.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgSm9oYW5uZXMsDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogbGlu
dXgtd2lyZWxlc3Mtb3duZXJAdmdlci5rZXJuZWwub3JnIFttYWlsdG86bGludXgtd2lyZWxlc3Mt
b3duZXJAdmdlci5rZXJuZWwub3JnXSBPbiBCZWhhbGYgT2YNCj4gSm9oYW5uZXMgQmVyZw0KPiBT
ZW50OiBXZWRuZXNkYXksIE1hcmNoIDIzLCAyMDExIDEyOjE4IFBNDQo+IFRvOiBCaW5nIFpoYW8N
Cj4gQ2M6IGxpbnV4LXdpcmVsZXNzQHZnZXIua2VybmVsLm9yZzsgSm9obiBXLiBMaW52aWxsZTsg
TmlzaGFudCBTYXJtdWthZGFtOyBBbWl0a3VtYXIgS2Fyd2FyOyBLaXJhbg0KPiBEaXZla2FyOyBZ
b2dlc2ggUG93YXI7IE1hcmMgWWFuZzsgUmFtZXNoIFJhZGhha3Jpc2huYW47IEZyYW5rIEh1YW5n
DQo+IFN1YmplY3Q6IFJFOiBbUEFUQ0ggdjNdIHdpcmVsZXNzOiBtd2lmaWV4OiBpbml0aWFsIGNv
bW1pdCBmb3IgTWFydmVsbCBtd2lmaWV4IGRyaXZlcg0KPiANCj4gSGV5LA0KPiANCj4gPiA+IElu
IGl3bHdpZmksIHdlIGp1c3QgaGF2ZSBpd2xfc2VuZF9jbWRfc3luYygpLCB3aGljaCBkb2VzIGFs
bCB0aGUgd2FpdC4NCj4gPiA+IFRoYXQgYWxzbyBoYXMgdGhlIGFkZGVkIGJlbmVmaXQgdGhhdCB0
aGUgd2FpdCBxdWV1ZSBkb2Vzbid0IG5lZWQgdG8gYmUNCj4gPiA+IGR5bmFtaWNhbGx5IGFsbG9j
YXRlZCwgaXQgY2FuIGp1c3QgYmUgb24gdGhlIHN0YWNrLiBBbHNvLCB5b3VyIGR5bmFtaWMNCj4g
PiA+IGFsbG9jYXRpb25zIGZvciB0aGF0IGRvbid0IHJlYWxseSBzZWVtIHRvIHJlcXVpcmUgR0ZQ
X0FUT01JQyBpbiBtb3N0DQo+ID4gPiBwbGFjZXMsIGJ1dCB0aGF0J3MgcHJvYmFibHkgdGhlIGxl
YXN0IG9mIHRoZSB3b3JyaWVzIGhlcmUuDQo+ID4NCj4gPiBJIHdpbGwgc3R1ZHkgdGhlIGl3bF9z
ZW5kX2NtZF9zeW5jKCkgaW1wbGVtZW50YXRpb24uIEFuZCBoYXZlIG13aWZpZXgNCj4gPiB1c2Ug
dGhlIHNhbWUgd2F5IHRvIHNlbmQgY29tbWFuZHMgYXMgaXdsd2lmaSBkcml2ZXIgZG9lcy4NCj4g
DQo+IEknbSBub3Qgc2F5aW5nIHRoYXQgeW91IG5lZWQgdG8gZG8gdGhhdCBleGFjdGx5IGluIHRo
ZSBzYW1lIHdheS4gSXQncw0KPiBqdXN0IHRoYXQgYWxsb2NhdGluZyB0aGUgd2FpdCBxdWV1ZSBk
eW5hbWljYWxseSBhbmQgdGhlbiBwYXNzaW5nIGl0DQo+IGFjcm9zcyBhIGZldyBmdW5jdGlvbnMg
c2VlbXMgdG8gYmxvYXQgdGhlIGNvZGUgYW5kIEkgYWxzbyB0aGluayBpdCdzDQo+IG1vcmUgZXJy
b3IgcHJvbmUuDQoNClRoYW5rIHlvdSBmb3IgdGhlIGNsYXJpZmljYXRpb24uDQoNCj4gDQo+IEFy
ZSB0aGVyZSBhbnkgYXN5bmNocm9ub3VzIGNvbW1hbmRzIGF0IGFsbCBhbnl3YXk/DQoNClllcy4g
VGhlcmUgYXJlIGEgY291cGxlIHN5bmNocm9ub3VzIGNvbW1hbmRzLg0KSSB0aGluayBJIGNhbiBp
bXBsZW1lbnQgdHdvIGZ1bmN0aW9ucyBmb3Igc2VuZGluZyB0aGUgY29tbWFuZHMuDQpPbmUgZm9y
IHN5bmNocm9ub3VzIGNvbW1hbmRzIGFuZCB0aGUgb3RoZXIgZm9yIGFzeW5jaHJvbm91cyBjb21t
YW5kcw0KDQpUaGFua3MsDQoNCkJpbmcNCg0K
