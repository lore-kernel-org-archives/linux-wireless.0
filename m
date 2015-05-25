Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:48152 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbbEYI4d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 May 2015 04:56:33 -0400
Received: from epcpsbgr4.samsung.com
 (u144.gpu120.samsung.co.kr [203.254.230.144])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NOW02DPQE64ZX00@mailout1.samsung.com> for
 linux-wireless@vger.kernel.org; Mon, 25 May 2015 17:56:28 +0900 (KST)
Date: Mon, 25 May 2015 08:56:30 +0000 (GMT)
From: Rahul Jain <rahul.jain@samsung.com>
Subject: PATCH] cfg80211: moving up BAND_2GHZ above BAND_5GHZ regulatory class
 [EDT]
To: "johannes.berg@intel.com" <johannes.berg@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Reply-to: rahul.jain@samsung.com
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <629053294.30301432544190297.JavaMail.weblogic@epmlwas02a> (sfid-20150525_105637_628424_F5429D69)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RVAtRkVEQzc3MURGNEZGNDhBOTgyOUNCODUyNTRFMjlGRDMNCg0KaGVsbG8gSm9lLCBSYWZlbCwg
V2lyZWxlc3MgQ29tbXVuaXR5LA0KDQpJIGhhdmUgaW5jb3Jwb3JhdGVkIHlvdXIgcmV2aWV3IGNv
bW1lbnRzLiBQbGVhc2UgZmluZCB1cGRhdGVkIHBhdGNoLg0KDQpGcm9tIDMwZjRmYjcyYmNiMTBm
OWY2NTg5ZWEyMmUyNmUzNzYzMWYwN2Y4ZmUgTW9uIFNlcCAxNyAwMDowMDowMCAyMDAxDQpGcm9t
OiBSYWh1bCBKYWluIDxyYWh1bC5qYWluQHNhbXN1bmcuY29tPg0KRGF0ZTogTW9uLCAyNSBNYXkg
MjAxNSAxNDoxNTozNiArMDUzMA0KU3ViamVjdDogW1BBVENIXSBjZmc4MDIxMTogbW92aW5nIHVw
IEJBTkRfMkdIWiBhYm92ZSBCQU5EXzVHSFogcmVndWxhdG9yeQ0KIGNsYXNzDQoNCg0KU2lnbmVk
LW9mZi1ieTogUmFodWwgSmFpbiA8cmFodWwuamFpbkBzYW1zdW5nLmNvbT4NCi0tLQ0KIG5ldC93
aXJlbGVzcy91dGlsLmMgfCAgIDEyICsrKystLS0tLS0tLQ0KIDEgZmlsZSBjaGFuZ2VkLCA0IGlu
c2VydGlvbnMoKyksIDggZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9uZXQvd2lyZWxlc3Mv
dXRpbC5jIGIvbmV0L3dpcmVsZXNzL3V0aWwuYw0KaW5kZXggNzAwNTFhYi4uYjFhY2EzZSAxMDA2
NDQNCi0tLSBhL25ldC93aXJlbGVzcy91dGlsLmMNCisrKyBiL25ldC93aXJlbGVzcy91dGlsLmMN
CkBAIC0xMzM1LDE3ICsxMzM1LDEzIEBAIGJvb2wgaWVlZTgwMjExX29wZXJhdGluZ19jbGFzc190
b19iYW5kKHU4IG9wZXJhdGluZ19jbGFzcywNCiAJCQkJICAgICAgIGVudW0gaWVlZTgwMjExX2Jh
bmQgKmJhbmQpDQogew0KIAlzd2l0Y2ggKG9wZXJhdGluZ19jbGFzcykgew0KKwljYXNlIDgxIC4u
LiA4NDoNCisJCSpiYW5kID0gSUVFRTgwMjExX0JBTkRfMkdIWjsNCisJCXJldHVybiB0cnVlOw0K
IAljYXNlIDExMjoNCi0JY2FzZSAxMTUgLi4uIDEyNzoNCi0JY2FzZSAxMjggLi4uIDEzMDoNCisJ
Y2FzZSAxMTUgLi4uIDEzMDoNCiAJCSpiYW5kID0gSUVFRTgwMjExX0JBTkRfNUdIWjsNCiAJCXJl
dHVybiB0cnVlOw0KLQljYXNlIDgxOg0KLQljYXNlIDgyOg0KLQljYXNlIDgzOg0KLQljYXNlIDg0
Og0KLQkJKmJhbmQgPSBJRUVFODAyMTFfQkFORF8yR0haOw0KLQkJcmV0dXJuIHRydWU7DQogCWNh
c2UgMTgwOg0KIAkJKmJhbmQgPSBJRUVFODAyMTFfQkFORF82MEdIWjsNCiAJCXJldHVybiB0cnVl
Ow0KLS0gDQoxLjcuOS41DQoNCg0KVGhhbmtzDQotUmFodWwgSmFpbiANCg0K


