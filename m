Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:60576 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751653Ab1HYTkX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 15:40:23 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Joe Perches <joe@perches.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Frank Huang <frankh@marvell.com>, Walter Harms <wharms@bfs.de>
Date: Thu, 25 Aug 2011 12:39:58 -0700
Subject: RE: [PATCH] mwifiex: replace kmalloc & memcpy sequences with kmemdup
Message-ID: <477F20668A386D41ADCC57781B1F70430802EEF288@SC-VEXCH1.marvell.com> (sfid-20110825_214026_199547_8DD3FF5B)
References: <1314244350-13347-1-git-send-email-bzhao@marvell.com>
 <1314245956.15882.30.camel@Joe-Laptop>
In-Reply-To: <1314245956.15882.30.camel@Joe-Laptop>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgSm9lLA0KDQpUaGFua3MgZm9yIHlvdXIgY29tbWVudC4NCg0KPiBTdWJqZWN0OiBSZTogW1BB
VENIXSBtd2lmaWV4OiByZXBsYWNlIGttYWxsb2MgJiBtZW1jcHkgc2VxdWVuY2VzIHdpdGgga21l
bWR1cA0KPiANCj4gT24gV2VkLCAyMDExLTA4LTI0IGF0IDIwOjUyIC0wNzAwLCBCaW5nIFpoYW8g
d3JvdGU6DQo+ID4gU2VxdWVuY2VzIG9mIGttYWxsb2Mva3phbGxvYyBhbmQgbWVtY3B5IGFyZSBy
ZXBsYWNlZCB3aXRoDQo+ID4ga21lbWR1cHMuDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0
L3dpcmVsZXNzL213aWZpZXgvam9pbi5jIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvbXdpZmlleC9q
b2luLmMNCj4gW10NCj4gPiAtCXRtcCA9IGttYWxsb2MocmF0ZTFfc2l6ZSwgR0ZQX0tFUk5FTCk7
DQo+ID4gKwl0bXAgPSBrbWVtZHVwKHJhdGUxLCByYXRlMV9zaXplLCBHRlBfS0VSTkVMKTsNCj4g
PiAgCWlmICghdG1wKSB7DQo+ID4gLQkJZGV2X2Vycihwcml2LT5hZGFwdGVyLT5kZXYsICJmYWls
ZWQgdG8gYWxsb2MgdG1wIGJ1ZlxuIik7DQo+ID4gKwkJZGV2X2Vycihwcml2LT5hZGFwdGVyLT5k
ZXYsICJmYWlsZWQgdG8gZHVwbGljYXRlIHJhdGUgYnVmXG4iKTsNCj4gDQo+IEkgd291bGRuJ3Qg
bW9kaWZ5IGFueSBPT00gbWVzc2FnZS4NCj4gVGhlc2UgX2FyZV8gYWxsb2NzIGZhaWx1cmVzLg0K
DQpWMiBwYXRjaCBoYXMgYmVlbiBzZW50Lg0KDQpUaGFua3MsDQpCaW5nDQoNCj4gDQo+IFthbGwg
dGhlIG90aGVycyByZW1vdmVkXQ0KDQo=
