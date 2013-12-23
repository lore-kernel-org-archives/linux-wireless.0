Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:10874 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932596Ab3LWX0X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Dec 2013 18:26:23 -0500
From: Bing Zhao <bzhao@marvell.com>
To: Ding Tianhong <dingtianhong@huawei.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Netdev <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 23 Dec 2013 15:26:01 -0800
Subject: RE: [PATCH 15/21] mwifiex: slight optimization of addr compare
Message-ID: <477F20668A386D41ADCC57781B1F70430F5334745F@SC-VEXCH1.marvell.com> (sfid-20131224_002648_461335_4E900F6F)
References: <52B7C5E6.7030807@huawei.com>
In-Reply-To: <52B7C5E6.7030807@huawei.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgRGluZywNCg0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvbXdpZmlleC8x
MW5fcnhyZW9yZGVyLmMNCj4gYi9kcml2ZXJzL25ldC93aXJlbGVzcy9td2lmaWV4LzExbl9yeHJl
b3JkZXIuYw0KPiBpbmRleCBhZGE4MDlmLi5hMTgwMjk4IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJz
L25ldC93aXJlbGVzcy9td2lmaWV4LzExbl9yeHJlb3JkZXIuYw0KPiArKysgYi9kcml2ZXJzL25l
dC93aXJlbGVzcy9td2lmaWV4LzExbl9yeHJlb3JkZXIuYw0KPiBAQCAtMTY0LDcgKzE2NCw3IEBA
IG13aWZpZXhfMTFuX2dldF9yeF9yZW9yZGVyX3RibChzdHJ1Y3QgbXdpZmlleF9wcml2YXRlICpw
cml2LCBpbnQgdGlkLCB1OCAqdGEpDQo+IA0KPiAgCXNwaW5fbG9ja19pcnFzYXZlKCZwcml2LT5y
eF9yZW9yZGVyX3RibF9sb2NrLCBmbGFncyk7DQo+ICAJbGlzdF9mb3JfZWFjaF9lbnRyeSh0Ymws
ICZwcml2LT5yeF9yZW9yZGVyX3RibF9wdHIsIGxpc3QpIHsNCj4gLQkJaWYgKCFtZW1jbXAodGJs
LT50YSwgdGEsIEVUSF9BTEVOKSAmJiB0YmwtPnRpZCA9PSB0aWQpIHsNCj4gKwkJaWYgKGV0aGVy
X2FkZHJfZXF1YWxfdW5hbGlnbmVkKHRibC0+dGEsIHRhKSAmJiB0YmwtPnRpZCA9PSB0aWQpIHsN
Cg0KY2hlY2twYXRjaC5wbCBmb3VuZCBzZXZlcmFsIHdhcm5pbmdzIGluIHRoaXMgcGF0Y2guDQpX
QVJOSU5HOiBsaW5lIG92ZXIgODAgY2hhcmFjdGVycw0KDQpDb3VsZCB5b3UgcGxlYXNlIGZpeCB0
aGVzZSB3YXJuaW5ncyBieSBzcGxpdHRpbmcgdGhlIGZ1bmN0aW9uIGFyZ3VtZW50cyBpbnRvIG11
bHRpcGxlIGxpbmVzPw0KDQpUaGFua3MsDQpCaW5nDQoNCg==
