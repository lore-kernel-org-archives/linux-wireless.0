Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:22342 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254AbbENFCa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2015 01:02:30 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NOB00G85Q03T720@mailout1.samsung.com> for
 linux-wireless@vger.kernel.org; Thu, 14 May 2015 14:02:27 +0900 (KST)
Date: Thu, 14 May 2015 05:02:23 +0000 (GMT)
From: Rahul Jain <rahul.jain@samsung.com>
Subject: [PATCH] Added 2 new Control Frames ( Beamforming Report Poll & VHT
 NDP Announcement) defined in 802.11ac
To: linux-wireless@vger.kernel.org, johannes.berg@intel.com
Reply-to: rahul.jain@samsung.com
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <2076339160.163631431579743152.JavaMail.weblogic@ep2mlwas05d> (sfid-20150514_070252_547798_4C831930)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

aGVsbG8gQWxsLAoKQmVsb3cgaXMgdGhlIHBhdGNoIGZvciAyIG5ldyBjb250cm9sIGZyYW1lcyBk
ZWZpbmVkIGluIDgwMi4xMWFjLgpQbGVhc2UgcmV2aWV3IGFuZCBtZXJnZS4KCkZyb20gYjljYTMz
NTA0MDU0N2U1NjU2ODRmNWJmNjBkMzdkYjg5NjMyMjY2MyBNb24gU2VwIDE3IDAwOjAwOjAwIDIw
MDEgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIApG
cm9tOiByYWh1bCA8cmFodWwuamFpbkBzYW1zdW5nLmNvbT4KRGF0ZTogVGh1LCAxNCBNYXkgMjAx
NSAxMDoyMTo0OCArMDUzMApTdWJqZWN0OiBbUEFUQ0hdIEFkZGVkIDIgbmV3IENvbnRyb2wgRnJh
bWVzICggQmVhbWZvcm1pbmcgUmVwb3J0IFBvbGwgJiBWSFQgCiBORFAgQW5ub3VuY2VtZW50KSBk
ZWZpbmVkIGluIDgwMi4xMWFjCgoKU2lnbmVkLW9mZi1ieTogcmFodWwgPHJhaHVsLmphaW5Ac2Ft
c3VuZy5jb20+Ci0tLQogaW5jbHVkZS9saW51eC9pZWVlODAyMTEuaCB8ICAgIDIgKysKIDEgZmls
ZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L2ll
ZWU4MDIxMS5oIGIvaW5jbHVkZS9saW51eC9pZWVlODAyMTEuaAppbmRleCBiOWM3ODk3Li5jYTM4
NjE2IDEwMDY0NAotLS0gYS9pbmNsdWRlL2xpbnV4L2llZWU4MDIxMS5oCisrKyBiL2luY2x1ZGUv
bGludXgvaWVlZTgwMjExLmgKQEAgLTc1LDYgKzc1LDggQEAKICNkZWZpbmUgSUVFRTgwMjExX1NU
WVBFX0FDVElPTiAgICAgICAgIDB4MDBEMAogCiAvKiBjb250cm9sICovCisjZGVmaW5lIElFRUU4
MDIxMV9TVFlQRV9CRUFNRk9STV9QT0xMICAweDAwNDAKKyNkZWZpbmUgSUVFRTgwMjExX1NUWVBF
X1ZIVF9ORFBfQU5OT1VDRSAgICAgICAgMHgwMDUwCiAjZGVmaW5lIElFRUU4MDIxMV9TVFlQRV9D
VExfRVhUICAgICAgICAgICAgICAgIDB4MDA2MAogI2RlZmluZSBJRUVFODAyMTFfU1RZUEVfQkFD
S19SRVEgICAgICAgMHgwMDgwCiAjZGVmaW5lIElFRUU4MDIxMV9TVFlQRV9CQUNLICAgICAgICAg
ICAweDAwOTAKLS0gCjEuNy45LjU=


