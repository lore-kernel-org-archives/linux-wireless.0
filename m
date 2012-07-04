Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:48920 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752938Ab2GDU7C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jul 2012 16:59:02 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Date: Wed, 4 Jul 2012 13:58:49 -0700
Subject: RE: [PATCH] wireless: fix leak found by coverity
Message-ID: <477F20668A386D41ADCC57781B1F7043083AA5506F@SC-VEXCH1.marvell.com> (sfid-20120704_225941_955780_2FE7FC3D)
References: <20120704153327.4012.76171.stgit@bluebook>
In-Reply-To: <20120704153327.4012.76171.stgit@bluebook>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgQWxhbiwNCg0KPiBTdWJqZWN0OiBbUEFUQ0hdIHdpcmVsZXNzOiBmaXggbGVhayBmb3VuZCBi
eSBjb3Zlcml0eQ0KDQpJJ3ZlIHNlbnQgYSBzaW1pbGFyIHBhdGNoIHRvIGxpbnV4LXdpcmVsZXNz
IGxpc3QuDQoNCltQQVRDSCAzLjVdIG13aWZpZXg6IGZpeCBDb3Zlcml0eSBTQ0FOIENJRCA3MDkw
Nzg6IFJlc291cmNlIGxlYWsgKFJFU09VUkNFX0xFQUspDQoNCmh0dHA6Ly9tYXJjLmluZm8vP2w9
bGludXgtd2lyZWxlc3MmbT0xMzQxMzU2NDM3Mjc0MjQmdz0yDQoNClRoYW5rcywNCkJpbmcNCg0K
PiANCj4gRnJvbTogQWxhbiBDb3ggPGFsYW5AbGludXguaW50ZWwuY29tPg0KPiANCj4gU2lnbmVk
LW9mZi1ieTogQWxhbiBDb3ggPGFsYW5AbGludXguaW50ZWwuY29tPg0KPiAtLS0NCj4gDQo+ICBk
cml2ZXJzL25ldC93aXJlbGVzcy9td2lmaWV4L2NmZzgwMjExLmMgfCAgICAxICsNCj4gIDEgZmls
ZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0
L3dpcmVsZXNzL213aWZpZXgvY2ZnODAyMTEuYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL213aWZp
ZXgvY2ZnODAyMTEuYw0KPiBpbmRleCA5N2RlNjUyLi40OTdhMDVhIDEwMDY0NA0KPiAtLS0gYS9k
cml2ZXJzL25ldC93aXJlbGVzcy9td2lmaWV4L2NmZzgwMjExLmMNCj4gKysrIGIvZHJpdmVycy9u
ZXQvd2lyZWxlc3MvbXdpZmlleC9jZmc4MDIxMS5jDQo+IEBAIC0xMDAzLDYgKzEwMDMsNyBAQCBz
dGF0aWMgaW50IG13aWZpZXhfY2ZnODAyMTFfc3RhcnRfYXAoc3RydWN0IHdpcGh5ICp3aXBoeSwN
Cj4gIAljYXNlIE5MODAyMTFfSElEREVOX1NTSURfWkVST19DT05URU5UUzoNCj4gIAkJLyogZmly
bXdhcmUgZG9lc24ndCBzdXBwb3J0IHRoaXMgdHlwZSBvZiBoaWRkZW4gU1NJRCAqLw0KPiAgCWRl
ZmF1bHQ6DQo+ICsJCWtmcmVlKGJzc19jZmcpOw0KPiAgCQlyZXR1cm4gLUVJTlZBTDsNCj4gIAl9
DQo+IA0KDQo=
