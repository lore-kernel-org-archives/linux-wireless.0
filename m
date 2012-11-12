Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:58330 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752219Ab2KLVlS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2012 16:41:18 -0500
From: Bing Zhao <bzhao@marvell.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Mon, 12 Nov 2012 13:38:44 -0800
Subject: RE: [PATCH v2] nl/cfg80211: advertise OBSS scan offload capability
Message-ID: <477F20668A386D41ADCC57781B1F7043083BBD7440@SC-VEXCH1.marvell.com> (sfid-20121112_224121_927231_575F656D)
References: <1352512290-7316-1-git-send-email-bzhao@marvell.com>
 <1352712697.9525.4.camel@jlt4.sipsolutions.net>
In-Reply-To: <1352712697.9525.4.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgSm9oYW5uZXMsDQoNCj4gPiBGcm9tOiBBbWl0a3VtYXIgS2Fyd2FyIDxha2Fyd2FyQG1hcnZl
bGwuY29tPg0KPiA+DQo+ID4gd3BhX3N1cHBsaWNhbnQgd2lsbCBkbyBPQlNTIHNjYW4gZm9yIGRy
aXZlcnMgdGhhdCBpbXBsZW1lbnQNCj4gPiBhdXRoL2Fzc29jIEFQSS4gRHJpdmVycyB0aGF0IGlt
cGxlbWVudCBubDgwMjExIGNvbm5lY3QgQVBJDQo+ID4gKHJhdGhlciB0aGFuIGF1dGgvYXNzb2Mp
IG1heSBuZWVkIHdwYV9zdXBwbGljYW50IHRvIGRvIHRoaXMNCj4gPiBhcyB3ZWxsLg0KPiA+DQo+
ID4gTmV3IGZsYWcgaXMgYWRkZWQgdG8gaW5mb3JtIHVzZXJzcGFjZSB0aGF0IHRoaXMgZHJpdmVy
IHdpbGwNCj4gPiBtYWtlIHVzZSBvZiB3cGFfc3VwcGxpY2FudCdzIE9CU1Mgc2NhbiBmZWF0dXJl
Lg0KPiANCj4gPiArICogQE5MODAyMTFfRkVBVFVSRV9PQlNTX1NDQU5fT0ZGTE9BRDogVGhlIGRy
aXZlciBleHBlY3RzIHVzZXIgc3BhY2UgdG8NCj4gPiArICoJcGVyZm9ybSBPQlNTIHNjYW4gYW5k
IGdlbmVyYXRlIDIwLzQwIEJTUyBjb2V4IHJlcG9ydHMuIFRoaXMgZmxhZyBpcw0KPiA+ICsgKglp
bnRlcmVzdGVkIGluIG9ubHkgaW4gdGhlIGNhc2Ugb2YgYSBkcml2ZXIgdGhhdCBoYXMgY29ubmVj
dCBBUEkuDQo+IA0KPiBBcHBsaWVkLCBidXQgSSBjaGFuZ2VkIGEgbG90IDstKQ0KPiANCj4gTm90
YWJseSwgSSByZXdvcmRlZCB0aGUgY29uc3RhbnQgbmFtZSB0byBiZQ0KPiBOTDgwMjExX0ZFQVRV
UkVfTkVFRF9PQlNTX1NDQU4sIHNpbmNlIHdlIHR5cGljYWxseSB1c2UgdGhlIHRlcm0NCj4gIm9m
ZmxvYWQiIHRvIG1lYW4gdGhhdCB0aGUgKmRldmljZSogZG9lcyBzb21ldGhpbmcsIG5vdCB0byBt
ZWFuIHRoYXQNCj4gKnVzZXJzcGFjZSogZG9lcyBzb21ldGhpbmcuDQoNClRoaXMgbWFrZXMgYSBs
b3QgbW9yZSBzZW5zZS4gVGhhbmtzIQ0KDQpJIHdpbGwgcmUtcG9zdCB0aGUgd3BhX3MgcGF0Y2gg
dG8gdXNlIHRoZSBuZXcgY29uc3RhbnQgbmFtZS4NCg0KVGhhbmtzLA0KQmluZw0KDQo=
