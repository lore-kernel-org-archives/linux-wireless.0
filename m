Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:46317 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751965AbeCaOCL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 31 Mar 2018 10:02:11 -0400
From: Pkshih <pkshih@realtek.com>
To: "huxm@marvell.com" <huxm@marvell.com>,
        "gbhat@marvell.com" <gbhat@marvell.com>,
        "jussi.kivilinna@iki.fi" <jussi.kivilinna@iki.fi>,
        "nishants@marvell.com" <nishants@marvell.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "joe@perches.com" <joe@perches.com>,
        "amitkarwar@gmail.com" <amitkarwar@gmail.com>,
        "chunkeey@googlemail.com" <chunkeey@googlemail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>
Subject: Re: [PATCH 06/12] wireless: Convert simple uses of a static const Ethernet broadcast address
Date: Sat, 31 Mar 2018 14:01:12 +0000
Message-ID: <1522504872.1910.17.camel@realtek.com> (sfid-20180331_160232_149143_0CB25E18)
References: <cover.1522479607.git.joe@perches.com>
         <79196f134a513d50968e8e208a0e56b3c0236ee3.1522479607.git.joe@perches.com>
In-Reply-To: <79196f134a513d50968e8e208a0e56b3c0236ee3.1522479607.git.joe@perches.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gU2F0LCAyMDE4LTAzLTMxIGF0IDAwOjA1IC0wNzAwLCBKb2UgUGVyY2hlcyB3cm90ZToNCj4g
VXNlIHRoZSBuZXcgZXRoZXJfYnJvYWRjYXN0X2FkZHIgZ2xvYmFsIGluc3RlYWQgdG8gc2F2ZSBz
b21lIG9iamVjdCBjb2RlLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogSm9lIFBlcmNoZXMgPGpvZUBw
ZXJjaGVzLmNvbT4NCj4gLS0tDQo+IMKgZHJpdmVycy9uZXQvd2lyZWxlc3MvYWRtdGVrL2FkbTgy
MTEuY8KgwqDCoMKgwqDCoMKgwqDCoMKgwqB8IDMgKy0tDQo+IMKgZHJpdmVycy9uZXQvd2lyZWxl
c3MvYXRoL2Nhcmw5MTcwL21hYy5jwqDCoMKgwqDCoMKgwqDCoMKgfCA0ICstLS0NCj4gwqBkcml2
ZXJzL25ldC93aXJlbGVzcy9icm9hZGNvbS9iNDMvbWFpbi5jwqDCoMKgwqDCoMKgwqDCoHwgMyAr
LS0NCj4gwqBkcml2ZXJzL25ldC93aXJlbGVzcy9tYXJ2ZWxsL213aWZpZXgvY2ZnODAyMTEuYyB8
IDMgKy0tDQo+IMKgZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL2NvcmUuY8Kg
wqDCoMKgwqB8IDUgKystLS0NCj4gwqBkcml2ZXJzL25ldC93aXJlbGVzcy9ybmRpc193bGFuLmPC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB8IDYgKy0tLS0tDQo+IMKgZHJpdmVycy9uZXQv
d2lyZWxlc3MvdGkvd2wxMjUxL21haW4uY8KgwqDCoMKgwqDCoMKgwqDCoMKgwqB8IDUgKy0tLS0N
Cj4gwqBkcml2ZXJzL25ldC93aXJlbGVzcy90aS93bGNvcmUvbWFpbi5jwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoHwgNSArLS0tLQ0KPiDCoDggZmlsZXMgY2hhbmdlZCwgOSBpbnNlcnRpb25zKCspLCAy
NSBkZWxldGlvbnMoLSkNCj4gDQo+IMKgDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJl
bGVzcy9yZWFsdGVrL3J0bHdpZmkvY29yZS5jDQo+IGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVh
bHRlay9ydGx3aWZpL2NvcmUuYw0KPiBpbmRleCBjZmVhNTdlZmE3ZjQuLjhjNTM0YTkzZGFkNSAx
MDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL2NvcmUu
Yw0KPiArKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvY29yZS5jDQo+
IEBAIC0xNTI3LDcgKzE1MjcsNiBAQCBzdGF0aWMgaW50IHJ0bF9vcF9zZXRfa2V5KHN0cnVjdCBp
ZWVlODAyMTFfaHcgKmh3LCBlbnVtIHNldF9rZXlfY21kIGNtZCwNCj4gwqAJYm9vbCB3ZXBfb25s
eSA9IGZhbHNlOw0KPiDCoAlpbnQgZXJyID0gMDsNCj4gwqAJdTggbWFjX2FkZHJbRVRIX0FMRU5d
Ow0KPiAtCXU4IGJjYXN0X2FkZHJbRVRIX0FMRU5dID0geyAweGZmLCAweGZmLCAweGZmLCAweGZm
LCAweGZmLCAweGZmIH07DQo+IMKgDQo+IMKgCXJ0bHByaXYtPmJ0Y29leGlzdC5idGNfaW5mby5p
bl80d2F5ID0gZmFsc2U7DQo+IMKgDQo+IEBAIC0xNTQ0LDcgKzE1NDMsNyBAQCBzdGF0aWMgaW50
IHJ0bF9vcF9zZXRfa2V5KHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LCBlbnVtIHNldF9rZXlfY21k
IGNtZCwNCj4gwqAJUlRfVFJBQ0UocnRscHJpdiwgQ09NUF9TRUMsIERCR19ETUVTRywNCj4gwqAJ
CcKgIiVzIGhhcmR3YXJlIGJhc2VkIGVuY3J5cHRpb24gZm9yIGtleWlkeDogJWQsIG1hYzogJXBN
XG4iLA0KPiDCoAkJwqDCoGNtZCA9PSBTRVRfS0VZID8gIlVzaW5nIiA6ICJEaXNhYmxpbmciLCBr
ZXktPmtleWlkeCwNCj4gLQkJwqDCoHN0YSA/IHN0YS0+YWRkciA6IGJjYXN0X2FkZHIpOw0KPiAr
CQnCoMKgc3RhID8gc3RhLT5hZGRyIDogZXRoZXJfYnJvYWRjYXN0X2FkZHIpOw0KPiDCoAlydGxw
cml2LT5zZWMuYmVpbmdfc2V0a2V5ID0gdHJ1ZTsNCj4gwqAJcnRsX2lwc19uaWNfb24oaHcpOw0K
PiDCoAltdXRleF9sb2NrKCZydGxwcml2LT5sb2Nrcy5jb25mX211dGV4KTsNCj4gQEAgLTE2NDks
NyArMTY0OCw3IEBAIHN0YXRpYyBpbnQgcnRsX29wX3NldF9rZXkoc3RydWN0IGllZWU4MDIxMV9o
dyAqaHcsIGVudW0gc2V0X2tleV9jbWQgY21kLA0KPiDCoAkJCW1lbWNweShydGxwcml2LT5zZWMu
a2V5X2J1ZltrZXlfaWR4XSwNCj4gwqAJCQnCoMKgwqDCoMKgwqDCoGtleS0+a2V5LCBrZXktPmtl
eWxlbik7DQo+IMKgCQkJcnRscHJpdi0+c2VjLmtleV9sZW5ba2V5X2lkeF0gPSBrZXktPmtleWxl
bjsNCj4gLQkJCW1lbWNweShtYWNfYWRkciwgYmNhc3RfYWRkciwgRVRIX0FMRU4pOw0KPiArCQkJ
bWVtY3B5KG1hY19hZGRyLCBldGhlcl9icm9hZGNhc3RfYWRkciwgRVRIX0FMRU4pOw0KDQpVc2XC
oGV0aGVyX2FkZHJfY29weShtYWNfYWRkciwgZXRoZXJfYnJvYWRjYXN0X2FkZHIpID8NCg0KDQo+
IMKgCQl9IGVsc2UgewkvKiBwYWlyd2lzZSBrZXkgKi8NCj4gwqAJCQlSVF9UUkFDRShydGxwcml2
LCBDT01QX1NFQywgREJHX0RNRVNHLA0KPiDCoAkJCQnCoCJzZXQgcGFpcndpc2Uga2V5XG4iKTsN
Cg==
