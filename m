Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-db5eur01on0093.outbound.protection.outlook.com ([104.47.2.93]:48688
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751793AbeBZKWk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Feb 2018 05:22:40 -0500
From: Jean Pierre TOSONI <jp.tosoni@acksys.fr>
To: Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] mac80211: inform wireless layer when frame RSSI is
 invalid
Date: Mon, 26 Feb 2018 10:22:36 +0000
Message-ID: <AM4PR0101MB230507FA449DF625F117600FE4C10@AM4PR0101MB2305.eurprd01.prod.exchangelabs.com> (sfid-20180226_112244_829564_7357C67F)
References: <AM4PR0101MB2305288C51F159AE69BD78CCE4F50@AM4PR0101MB2305.eurprd01.prod.exchangelabs.com>
 <1519043716.16723.1.camel@sipsolutions.net>
In-Reply-To: <1519043716.16723.1.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

DQo+IC0tLS0tTWVzc2FnZSBkJ29yaWdpbmUtLS0tLQ0KPiBEZcKgOiBKb2hhbm5lcyBCZXJnIFtt
YWlsdG86am9oYW5uZXNAc2lwc29sdXRpb25zLm5ldF0NCj4gRW52b3nDqcKgOiBsdW5kaSAxOSBm
w6l2cmllciAyMDE4IDEzOjM1DQo+IMOAwqA6IEplYW4gUGllcnJlIFRPU09OSTsgbGludXgtd2ly
ZWxlc3NAdmdlci5rZXJuZWwub3JnDQo+IE9iamV0wqA6IFJlOiBbUEFUQ0hdIG1hYzgwMjExOiBp
bmZvcm0gd2lyZWxlc3MgbGF5ZXIgd2hlbiBmcmFtZSBSU1NJDQo+IGlzIGludmFsaWQNCj4gDQoo
Li4uKQ0KPiANCj4gPiAgCS8qIFRyYWNrIGF2ZXJhZ2UgUlNTSSBmcm9tIHRoZSBCZWFjb24gZnJh
bWVzIG9mIHRoZSBjdXJyZW50IEFQDQo+ICovDQo+ID4gKwlpZiAocnhfc3RhdHVzLT5mbGFnICYg
UlhfRkxBR19OT19TSUdOQUxfVkFMKQ0KPiA+ICsJCWdvdG8gc2tpcF9zaWduYWxfcHJvY2Vzc2lu
ZzsNCj4gPiAgCWlmIChpZm1nZC0+ZmxhZ3MgJiBJRUVFODAyMTFfU1RBX1JFU0VUX1NJR05BTF9B
VkUpIHsNCj4gPiAgCQlpZm1nZC0+ZmxhZ3MgJj0gfklFRUU4MDIxMV9TVEFfUkVTRVRfU0lHTkFM
X0FWRTsNCj4gPiAgCQlld21hX2JlYWNvbl9zaWduYWxfaW5pdCgmaWZtZ2QtPmF2ZV9iZWFjb25f
c2lnbmFsKTsNCj4gPiBAQCAtMzQ1NCw2ICszNDU2LDcgQEAgc3RhdGljIHZvaWQgaWVlZTgwMjEx
X3J4X21nbXRfYmVhY29uKHN0cnVjdA0KPiBpZWVlODAyMTFfc3ViX2lmX2RhdGEgKnNkYXRhLA0K
PiA+ICAJCQkJc2lnLCBHRlBfS0VSTkVMKTsNCj4gPiAgCQl9DQo+ID4gIAl9DQo+ID4gK3NraXBf
c2lnbmFsX3Byb2Nlc3Npbmc6DQo+IA0KPiBDYW4ndCBzYXkgSSBsaWtlIHRoaXMgLSBob3cgYWJv
dXQgd2UgcHVsbCBvdXQgdGhlIGFjdHVhbCBwcm9jZXNzaW5nDQo+IGludG8gYSBoZWxwZXIgZnVu
Y3Rpb24sIGFuZCB0aGVuIGFib3J0IHRoYXQgZnVuY3Rpb24gZWFybHkgaWYgdGhlDQo+IE5PX1NJ
R05BTF9WQUwgZmxhZyBpcyBzZXQuDQo+IA0KDQpTaW5jZSBJIGFtIHdvcmtpbmcgb24gYW4gb2xk
ZXIgdmVyc2lvbiBvZiBtYWM4MDIxMSwgSSB3YXMgYWltaW5nIHRvDQprZWVwIGNoYW5nZXMgbWlu
aW1hbCB0byBhdm9pZCBicmVha2luZyBzb21ldGhpbmcgSSBjb3VsZCBub3QgdGVzdC4uLg0KSSds
bCBoYXZlIGEgbG9vayB0byB5b3VyIHN1Z2dlc3Rpb24uDQoNCj4gam9oYW5uZXMNCg==
