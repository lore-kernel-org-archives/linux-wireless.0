Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:23803 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751270AbbBWHrr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2015 02:47:47 -0500
From: Avinash Patil <patila@marvell.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
	Li Long <longli@marvell.com>
Date: Sun, 22 Feb 2015 23:47:39 -0800
Subject: RE: [PATCH 1/3] mwifiex: add cfg80211 set_default_mgmt_key handler
Message-ID: <CBACCFA0AEB13A41977475BCF3E896FC66744F6E60@SC-VEXCH2.marvell.com> (sfid-20150223_084750_700533_8AB01B18)
References: <1423764954-30412-1-git-send-email-patila@marvell.com>
	 (sfid-20150212_134627_640778_2A1810BC)
 <1423850815.2936.4.camel@sipsolutions.net>
In-Reply-To: <1423850815.2936.4.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEpvaGFubmVzIEJlcmcgW21h
aWx0bzpqb2hhbm5lc0BzaXBzb2x1dGlvbnMubmV0XQ0KPiBTZW50OiBGcmlkYXksIEZlYnJ1YXJ5
IDEzLCAyMDE1IDExOjM3IFBNDQo+IFRvOiBBdmluYXNoIFBhdGlsDQo+IENjOiBsaW51eC13aXJl
bGVzc0B2Z2VyLmtlcm5lbC5vcmc7IEFtaXRrdW1hciBLYXJ3YXI7IENhdGh5IEx1bzsgWGlubWlu
ZyBIdTsNCj4gTGkgTG9uZw0KPiBTdWJqZWN0OiBSZTogW1BBVENIIDEvM10gbXdpZmlleDogYWRk
IGNmZzgwMjExIHNldF9kZWZhdWx0X21nbXRfa2V5IGhhbmRsZXINCj4gDQo+IE9uIFRodSwgMjAx
NS0wMi0xMiBhdCAyMzo0NSArMDUzMCwgQXZpbmFzaCBQYXRpbCB3cm90ZToNCj4gPiBGcm9tOiBY
aW5taW5nIEh1IDxodXhtQG1hcnZlbGwuY29tPg0KPiA+DQo+ID4gSXQgaXMgb2JzZXJ2ZWQgdGhh
dCBob3N0YXBkIGZhaWxlZCB0byBzZXR1cCB3aXRoIG1hbmFnZW1lbnQgZnJhbWUNCj4gPiBwcm90
ZWN0aW9uIG1vZGUgZW5hYmxlZCB3aGVuIHVzaW5nIG13aWZpZXguDQo+ID4NCj4gPiBUaGlzIGlz
IGJlY2F1c2UgaG9zdGFwZCB3aWxsIHRyeSB0byBpbnN0YWxsIElHVEsgdXNpbmcNCj4gPiBjZmc4
MDIxMSBzZXRfZGVmYXVsdF9tZ210X2tleSBoYW5kbGVyLg0KPiA+DQo+ID4gd2UgaGF2ZSBhbHJl
YWR5IHN1cHBvcnQgSUdUSyBpbnN0YWxsIGluIHNldF9rZXkgaGFuZGxlciwgc28ganVzdCB3b3Jr
DQo+ID4gYXJvdW5kIHRoaXMgaXNzdWUgYnkgYWRkIGFuIGVtcHR5IGNmZzgwMjExX3NldF9kZWZh
dWx0X21nbXRfa2V5IGhhbmRsZXIuDQo+IA0KPiBJIGJlbGlldmUgdGhhdCB0aGlzIGlzIGluY29y
cmVjdCBzaW5jZSB0aGUga2V5IHNob3VsZCBvbmx5IGJlIGluc3RhbGxlZCBmb3IgVFgNCj4gYWZ0
ZXIgdGhpcyBoYW5kbGVyLCBub3QgaW4gdGhlIHNldF9rZXkgaGFuZGxlci4gVGhpcyBzaG91bGQg
bWFrZSBhIGRpZmZlcmVuY2UNCj4gaW4gdGhlIGNhc2Ugb2YgcmVrZXlpbmc/IFBlcmhhcHMgaG9z
dGFwZCBkb2Vzbid0IGFjdHVhbGx5IHByb2dyYW0gdGhlIGtleQ0KPiB1bnRpbCByZWtleWluZyB3
aXRoIGFsbCBzdGF0aW9ucyBmaW5pc2hlcyB0aG91Z2guDQo+IA0KPiBqb2hhbm5lcw0KDQpUaGFu
a3MgZm9yIHJldmlldyBjb21tZW50cywgSm9oYW5uZXMuDQpXZSB3aWxsIGltcGxlbWVudCBkZWZh
dWx0X21nbXQgaGFuZGxlciBpbiBhIHdheSB5b3UgaGF2ZSBzdWdnZXN0ZWQgYW5kIHNlbmQgdjIu
DQoNClJlZ2FyZHMsDQpBdmluYXNoLg0K
