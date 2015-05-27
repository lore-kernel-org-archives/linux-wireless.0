Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:40085 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbbE0KqW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 May 2015 06:46:22 -0400
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NP002CXN8L40M40@mailout1.samsung.com> for
 linux-wireless@vger.kernel.org; Wed, 27 May 2015 19:46:16 +0900 (KST)
Date: Wed, 27 May 2015 10:46:19 +0000 (GMT)
From: Rahul Jain <rahul.jain@samsung.com>
Subject: [PATCH] cfg80211: moving up BAND_2GHZ above BAND_5GHZ regulatory class
 [EDT]
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: "johannes.berg@intel.com" <johannes.berg@intel.com>,
	=?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Reply-to: rahul.jain@samsung.com
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <157397585.158001432723579684.JavaMail.weblogic@epmlwas02d> (sfid-20150527_124626_418276_6033909A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RVAtRkVEQzc3MURGNEZGNDhBOTgyOUNCODUyNTRFMjlGRDMNCg0KaGVsbG8gSm9lLCBSYWZlbCwg
V2lyZWxlc3MgQ29tbXVuaXR5LA0KDQpJIGhhdmUgaW5jb3Jwb3JhdGVkIHlvdXIgcmV2aWV3IGNv
bW1lbnRzLiBQbGVhc2UgZmluZCB1cGRhdGVkIHBhdGNoLg0KDQpGcm9tIDMwZjRmYjcyYmNiMTBm
OWY2NTg5ZWEyMmUyNmUzNzYzMWYwN2Y4ZmUgTW9uIFNlcCAxNyAwMDowMDowMCAyMDAxDQpGcm9t
OiBSYWh1bCBKYWluIA0KRGF0ZTogTW9uLCAyNSBNYXkgMjAxNSAxNDoxNTozNiArMDUzMA0KU3Vi
amVjdDogW1BBVENIXSBjZmc4MDIxMTogbW92aW5nIHVwIEJBTkRfMkdIWiBhYm92ZSBCQU5EXzVH
SFogcmVndWxhdG9yeQ0KY2xhc3MNCg0KDQpTaWduZWQtb2ZmLWJ5OiBSYWh1bCBKYWluIA0KLS0t
DQpuZXQvd2lyZWxlc3MvdXRpbC5jIHwgICAxMiArKysrLS0tLS0tLS0NCjEgZmlsZSBjaGFuZ2Vk
LCA0IGluc2VydGlvbnMoKyksIDggZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9uZXQvd2ly
ZWxlc3MvdXRpbC5jIGIvbmV0L3dpcmVsZXNzL3V0aWwuYw0KaW5kZXggNzAwNTFhYi4uYjFhY2Ez
ZSAxMDA2NDQNCi0tLSBhL25ldC93aXJlbGVzcy91dGlsLmMNCisrKyBiL25ldC93aXJlbGVzcy91
dGlsLmMNCkBAIC0xMzM1LDE3ICsxMzM1LDEzIEBAIGJvb2wgaWVlZTgwMjExX29wZXJhdGluZ19j
bGFzc190b19iYW5kKHU4IG9wZXJhdGluZ19jbGFzcywNCiAgICAgICBlbnVtIGllZWU4MDIxMV9i
YW5kICpiYW5kKQ0Kew0Kc3dpdGNoIChvcGVyYXRpbmdfY2xhc3MpIHsNCisgY2FzZSA4MSAuLi4g
ODQ6DQorICpiYW5kID0gSUVFRTgwMjExX0JBTkRfMkdIWjsNCisgcmV0dXJuIHRydWU7DQpjYXNl
IDExMjoNCi0gY2FzZSAxMTUgLi4uIDEyNzoNCi0gY2FzZSAxMjggLi4uIDEzMDoNCisgY2FzZSAx
MTUgLi4uIDEzMDoNCipiYW5kID0gSUVFRTgwMjExX0JBTkRfNUdIWjsNCnJldHVybiB0cnVlOw0K
LSBjYXNlIDgxOg0KLSBjYXNlIDgyOg0KLSBjYXNlIDgzOg0KLSBjYXNlIDg0Og0KLSAqYmFuZCA9
IElFRUU4MDIxMV9CQU5EXzJHSFo7DQotIHJldHVybiB0cnVlOw0KY2FzZSAxODA6DQoqYmFuZCA9
IElFRUU4MDIxMV9CQU5EXzYwR0haOw0KcmV0dXJuIHRydWU7DQotLSANCjEuNy45LjUNCg0KDQpU
aGFua3MNCi1SYWh1bCBKYWluIA==


