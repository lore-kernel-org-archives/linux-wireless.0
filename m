Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:35790 "EHLO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753978Ab2JETfM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Oct 2012 15:35:12 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Joe Perches <joe@perches.com>
CC: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 5 Oct 2012 12:35:06 -0700
Subject: RE: [PATCH] mwifiex: Using %*phD instead of print_hex_dump_bytes
Message-ID: <477F20668A386D41ADCC57781B1F7043083B65769C@SC-VEXCH1.marvell.com> (sfid-20121005_213529_552376_EBFE2367)
References: <1349342161-27008-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
	 <1349368379.2008.16.camel@joe-AO722> <1349419996.10584.5.camel@smile>
In-Reply-To: <1349419996.10584.5.camel@smile>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgQW5keSwNCg0KPiA+IFdoZW4gdGhlIG51bWJlciBvZiBieXRlcyBpcyBmaXhlZCwgaXQgbWln
aHQgYmUgbmljZXINCj4gPiB0byB1c2UgYSBmb3JtYXQgbGlrZSAiJTxudW0+cGgiIHNvIHRoYXQg
dGhlIGZ1bmN0aW9uDQo+ID4gYXJndW1lbnQgc3RhY2sgZG9lc24ndCBoYXZlIHRoZSB3aWR0aCBw
dXNoZWQgYnV0IGl0J3MNCj4gPiBmaXhlZCBpbiB0aGUgZm9ybWF0Lg0KPiA+DQo+ID4gVGhpcyBj
YXNlIHdvdWxkIGRlZmluaXRlbHkgbm90IHdvcmsgd2VsbCB0aG91Z2ggYXMgaXQncw0KPiA+IGEg
I2RlZmluZSByYXRoZXIgdGhhbiBhIHNpbXBsZSBudW1iZXIgYW5kIEkgdGhpbmsNCj4gPiB1c2lu
ZyAiJSIgc3RyaW5naXplKHNvbWVfZGVmaW5lKSAicGgiIGlzIG5vdCBuaWNlLg0KPiA+DQo+ID4g
TWF5YmUgdGhpcyBjYXNlIGFyZ3VlcyBtb3JlIGZvciBhbHdheXMgdXNpbmcgIiUqcGgiLg0KPiA+
IEF0IGxlYXN0IHRoYXQncyBlYXNpbHkgZ3JlcHBhYmxlLg0KPiA+DQo+ID4gQW5keT8NCj4gRmly
c3Qgb2YgYWxsLCB0aGUgY3VycmVudCBsaW51eC1uZXh0IGhhcyBhdCBsZWFzdCB0d28gZGVmaW5p
dGlvbnMgb2YNCj4gdGhhdCBjb25zdGFudDoNCj4gZHJpdmVycy9uZXQvd2lyZWxlc3MvbXdpZmll
eC9pb2N0bC5oOjE3NTojZGVmaW5lIERCR19DTURfTlVNICAgIDUNCj4gZHJpdmVycy9uZXQvd2ly
ZWxlc3MvbXdpZmlleC9tYWluLmg6MTE4OiNkZWZpbmUgREJHX0NNRF9OVU0gNQ0KDQpJIGNhbiBm
aXggdGhhdC4NCg0KPiANCj4gSSBjaGVja2VkIGJyaWVmbHkgdGhlIGNvZGUgYW5kIGZvdW5kIHRo
YXQgdGhlIGNvbnN0YW50IGlzIGhlYXZpbHkgdXNlZA0KPiBhcyBhIGRlZmluaXRpb24gZm9yIHRo
ZSBsZW5ndGggb2Ygc3RhdGljIGJ5dGUgYXJyYXlzLiBTbywgaW4gdGhhdCBjYXNlDQo+IHByb2Jh
Ymx5IGJldHRlciB0byB1c2UgJSpwaCwgYnV0IGFwcGx5IHNpemVvZihjb29sX3ZhcikgaW5zdGVh
ZCBvZg0KPiBwdXR0aW5nIGNvbnN0YW50IHRoZXJlLg0KDQpBZ3JlZS4gKGludClzaXplb2YoY29v
bF92YXIpIHNob3VsZCBiZSB1c2VkIGZvciB0aGUgJSpwaC4NCg0KSSB3aWxsIHNlbmQgYSBwYXRj
aCBmb3IgdGhpcy4NCg0KVGhhbmtzLA0KQmluZw0K
