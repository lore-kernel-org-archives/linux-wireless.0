Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:34743 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754652Ab1GNSij (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 14:38:39 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Frank Huang <frankh@marvell.com>
Date: Thu, 14 Jul 2011 11:36:56 -0700
Subject: RE: [PATCH] mwifiex: remove wireless.h inclusion and fix resulting
 bugs
Message-ID: <477F20668A386D41ADCC57781B1F704307FFB08EBD@SC-VEXCH1.marvell.com> (sfid-20110714_203842_684319_7AD89236)
References: <1310607514-30808-1-git-send-email-bzhao@marvell.com>
 <1310621575.3902.1.camel@jlt3.sipsolutions.net>
In-Reply-To: <1310621575.3902.1.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgSm9oYW5uZXMsDQoNCj4gPiAgCS8qIEFsbG9jYXRlIGJ1ZmZlciB0byBzdG9yZSB0aGUgQlNT
SUQgbGlzdCAqLw0KPiA+IC0JYnVmX3NpemUgPSBzaXplb2Yoc3RydWN0IG13aWZpZXhfYnNzZGVz
Y3JpcHRvcikgKiBJV19NQVhfQVA7DQo+ID4gKwlidWZfc2l6ZSA9IHNpemVvZihzdHJ1Y3QgbXdp
ZmlleF9ic3NkZXNjcmlwdG9yKSAqIE1XSUZJRVhfTUFYX0FQOw0KPiANCj4gQnkgdGhlIHdheSwg
d2h5IGRvZXMgbXdpZmlleCBzdG9yZSAidGhlIEJTU0lEIGxpc3QiIGluIGEgc3RhdGljYWxseQ0K
PiBzaXplZCB0YWJsZT8gSXQgc2VlbXMgdGhhdCB0aGlzIHNob3VsZG4ndCBiZSBuZWNlc3Nhcnkg
c2luY2UgY2ZnODAyMTENCj4gc3RvcmVzIGl0IGluIGEgZHluYW1pYyBsaXN0IGFuZCBsZXRzIGRy
aXZlcnMgZ2V0IGluZm9ybWF0aW9uIG91dCBhZ2Fpbg0KPiBhcyB3ZWxsLg0KDQpUaGFua3MgZm9y
IHlvdXIgY29tbWVudC4NCg0KSXQgc2VlbXMgdGhhdCB0aGUgZHluYW1pYyBsaXN0IGluIGNmZzgw
MjExIGNhbiBiZSB1c2VkIGZvciBzdG9yaW5nIG91ciBic3MgZW50cmllcy4gV2Ugd2lsbCB0cnkg
dG8gbWFrZSBjaGFuZ2VzIGluIG91ciBzY2FuL2Fzc29jaWF0aW9uIGhhbmRsaW5nIHRvIHV0aWxp
emUgY2ZnODAyMTEgYnNzIGxpc3QsIGFuZCBnZXQgcmlkIG9mIG13aWZpZXhfYnNzZGVzY3JpcHRv
ciB0YWJsZSBldmVudHVhbGx5Lg0KDQpUaGFua3MsDQpCaW5nDQoNCg==
