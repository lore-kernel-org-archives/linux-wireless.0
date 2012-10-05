Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:33245 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964814Ab2JETnr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Oct 2012 15:43:47 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Joe Perches <joe@perches.com>
CC: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 5 Oct 2012 12:43:40 -0700
Subject: RE: [PATCH] mwifiex: Using %*phD instead of print_hex_dump_bytes
Message-ID: <477F20668A386D41ADCC57781B1F7043083B6576A0@SC-VEXCH1.marvell.com> (sfid-20121005_214431_076485_4EE1BFBE)
References: <1349342161-27008-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
	 <1349368379.2008.16.camel@joe-AO722> <1349419996.10584.5.camel@smile>
 <1349420428.10584.8.camel@smile>
In-Reply-To: <1349420428.10584.8.camel@smile>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgQW5keSwNCg0KPiA+IEkgY2hlY2tlZCBicmllZmx5IHRoZSBjb2RlIGFuZCBmb3VuZCB0aGF0
IHRoZSBjb25zdGFudCBpcyBoZWF2aWx5IHVzZWQNCj4gPiBhcyBhIGRlZmluaXRpb24gZm9yIHRo
ZSBsZW5ndGggb2Ygc3RhdGljIGJ5dGUgYXJyYXlzLiBTbywgaW4gdGhhdCBjYXNlDQo+ID4gcHJv
YmFibHkgYmV0dGVyIHRvIHVzZSAlKnBoLCBidXQgYXBwbHkgc2l6ZW9mKGNvb2xfdmFyKSBpbnN0
ZWFkIG9mDQo+IChpbnQpc2l6ZW9mKGNvb2xfdmFyKSBvZiBjb3Vyc2UNCj4gDQo+ID4gcHV0dGlu
ZyBjb25zdGFudCB0aGVyZS4NCj4gDQo+IEFuZCBvbmUgZmluZGluZyBtb3JlOiBidWZmZXJzIGFy
ZSBkZWZpbmVkIGFzIHUxNi4gSSdtIGFmcmFpZCB0aGUgYm90aA0KPiBwcmV2aW91cyBhbmQgcHJv
cG9zZWQgdmVyc2lvbnMgYXJlIHByaW50aW5nIHNvbWV0aGluZyBpbnRlcmVzdGluZywgbGlrZQ0K
PiBvbmx5IGhhbGYgb2YgdGhlIGRlZmluZWQgZGF0YS4NCg0KWW91IGFyZSByaWdodC4gVGhlIG9y
aWdpbmFsIGNvZGUgc2hvdWxkIGJlIGxpa2UgdGhpczoNCg0KICAgICAgICAgICAgICAgIHByaW50
X2hleF9kdW1wX2J5dGVzKCJsYXN0X2NtZF9pZDogIiwgRFVNUF9QUkVGSVhfT0ZGU0VULA0KLSAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGFkYXB0ZXItPmRiZy5sYXN0X2NtZF9p
ZCwgREJHX0NNRF9OVU0pOw0KKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGFk
YXB0ZXItPmRiZy5sYXN0X2NtZF9pZCwNCisgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICBzaXplb2YoYWRhcHRlci0+ZGJnLmxhc3RfY21kX2lkKSk7DQoNCmFuZCB0aGVuIGluIEFu
ZHJlaSdzIHBhdGNoOg0KDQoJCWRldl9lcnIoYWRhcHRlci0+ZGV2LCAibGFzdF9jbWRfaWQ6ICUq
cGhcbiIsDQoJCQkoaW50KXNpemVvZihhZGFwdGVyLT5kYmcubGFzdF9jbWRfaWQpKSwNCgkJCWFk
YXB0ZXItPmRiZy5sYXN0X2NtZF9pZCk7DQoNCkkgd2lsbCBzZW5kIGEgcGF0Y2ggdG8gZml4IHRo
ZSBvcmlnaW5hbCBjb2RlLg0KDQpUaGFua3MsDQpCaW5nDQoNCg==
