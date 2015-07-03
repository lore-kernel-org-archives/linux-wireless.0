Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:40322 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbbGCEwf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jul 2015 00:52:35 -0400
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NQW028OWAVKN8C0@mailout2.samsung.com> for
 linux-wireless@vger.kernel.org; Fri, 03 Jul 2015 13:52:32 +0900 (KST)
Date: Fri, 03 Jul 2015 04:52:32 +0000 (GMT)
From: Rahul Jain <rahul.jain@samsung.com>
Subject: [PATCH] Logically DeadCode
To: davem@davemloft.net, johannes.berg@intel.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Cc: Nitin Jhanwar <nitin.j@samsung.com>,
	"hemanshu.s@samsung.com" <hemanshu.s@samsung.com>,
	Amit Khatri <amit.khatri@samsung.com>
Reply-to: rahul.jain@samsung.com
MIME-version: 1.0
Content-type: text/plain; charset=windows-1252
MIME-version: 1.0
Message-id: <893988929.229281435899150021.JavaMail.weblogic@ep2mlwas07a> (sfid-20150703_065301_805585_5C0945A5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

aGVsbG8sCgpGcm9tIDBjMzQwMzAxNjZhMTUwZDZkOWYxYWI1MmU3YmI0MGE1NDQwYTY4YzIgTW9u
IFNlcCAxNyAwMDowMDowMCAyMDAxCkZyb206IFJhaHVsIEphaW4gPHJhaHVsLmphaW5Ac2Ftc3Vu
Zy5jb20+CkRhdGU6IEZyaSwgMyBKdWwgMjAxNSAxMDoxOToxMiArMDUzMApTdWJqZWN0OiBbUEFU
Q0hdIExvZ2ljYWxseSBEZWFkQ29kZQoKU2lnbmVkLW9mZi1ieTogUmFodWwgSmFpbiA8cmFodWwu
amFpbkBzYW1zdW5nLmNvbT4KU2lnbmVkLW9mZi1ieTogQW1pdCBLaGF0cmkgPGFtaXQua2hhdHJp
QHNhbXN1bmcuY29tPgotLS0KIG5ldC93aXJlbGVzcy91dGlsLmMgICAgICAgIHwgMyAtLS0KIG5l
dC93aXJlbGVzcy93ZXh0LWNvbXBhdC5jIHwgMyAtLS0KIDIgZmlsZXMgY2hhbmdlZCwgNiBkZWxl
dGlvbnMoLSkKCmRpZmYgLS1naXQgYS9uZXQvd2lyZWxlc3MvdXRpbC5jIGIvbmV0L3dpcmVsZXNz
L3V0aWwuYwppbmRleCBiYWY3MjE4Li41MDdlODk0IDEwMDY0NAotLS0gYS9uZXQvd2lyZWxlc3Mv
dXRpbC5jCisrKyBiL25ldC93aXJlbGVzcy91dGlsLmMKQEAgLTEwMDksOSArMTAwOSw2IEBAIGlu
dCBjZmc4MDIxMV9jaGFuZ2VfaWZhY2Uoc3RydWN0IGNmZzgwMjExX3JlZ2lzdGVyZWRfZGV2aWNl
ICpyZGV2LAogCQljYXNlIE5VTV9OTDgwMjExX0lGVFlQRVM6CiAJCQkvKiBub3QgaGFwcGVuaW5n
ICovCiAJCQlicmVhazsKLQkJY2FzZSBOTDgwMjExX0lGVFlQRV9QMlBfREVWSUNFOgotCQkJV0FS
Tl9PTigxKTsKLQkJCWJyZWFrOwogCQl9CiAJfQogCmRpZmYgLS1naXQgYS9uZXQvd2lyZWxlc3Mv
d2V4dC1jb21wYXQuYyBiL25ldC93aXJlbGVzcy93ZXh0LWNvbXBhdC5jCmluZGV4IGZkNjgyODMu
LjhkZTFiNjQgMTAwNjQ0Ci0tLSBhL25ldC93aXJlbGVzcy93ZXh0LWNvbXBhdC5jCisrKyBiL25l
dC93aXJlbGVzcy93ZXh0LWNvbXBhdC5jCkBAIC0zODcsOSArMzg3LDYgQEAgc3RhdGljIGludCBj
Zmc4MDIxMV93ZXh0X3Npd3JldHJ5KHN0cnVjdCBuZXRfZGV2aWNlICpkZXYsCiAJCWNoYW5nZWQg
fD0gV0lQSFlfUEFSQU1fUkVUUllfU0hPUlQ7CiAJfQogCi0JaWYgKCFjaGFuZ2VkKQotCQlyZXR1
cm4gMDsKLQogCWVyciA9IHJkZXZfc2V0X3dpcGh5X3BhcmFtcyhyZGV2LCBjaGFuZ2VkKTsKIAlp
ZiAoZXJyKSB7CiAJCXdkZXYtPndpcGh5LT5yZXRyeV9zaG9ydCA9IG9zaG9ydDsKLS0gCjEuOS4x
Cgo=


