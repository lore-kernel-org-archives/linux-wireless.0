Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:49619 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbbG0IcS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2015 04:32:18 -0400
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NS500BYF11CHP70@mailout4.samsung.com> for
 linux-wireless@vger.kernel.org; Mon, 27 Jul 2015 17:32:00 +0900 (KST)
Date: Mon, 27 Jul 2015 08:31:09 +0000 (GMT)
From: Rahul Jain <rahul.jain@samsung.com>
Subject: [PATCH] mwifiex: corrected README as per the file debugfs.c
To: akarwar@marvell.com, nishants@marvell.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	HEMANSHU SRIVASTAVA <hemanshu.s@samsung.com>
Reply-to: rahul.jain@samsung.com
MIME-version: 1.0
Content-type: text/plain; charset=windows-1252
MIME-version: 1.0
Message-id: <127092198.55801437985868073.JavaMail.weblogic@epmlwas04c> (sfid-20150727_103226_780982_C37C2693)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

U3ViamVjdDogW1BBVENIXSBtd2lmaWV4OiBjb3JyZWN0ZWQgUkVBRE1FIGFzIHBlciB0aGUgZmls
ZSBkZWJ1Z2ZzLmMKClNpZ25lZC1vZmYtYnk6IFJhaHVsIEphaW4gPHJhaHVsLmphaW5Ac2Ftc3Vu
Zy5jb20+ClNpZ25lZC1vZmYtYnk6IEFtaXQgS2hhdHJpIDxhbWl0LmtoYXRyaUBzYW1zdW5nLmNv
bT4KLS0tCiBkcml2ZXJzL25ldC93aXJlbGVzcy9td2lmaWV4L1JFQURNRSB8IDMgKystCiAxIGZp
bGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9uZXQvd2lyZWxlc3MvbXdpZmlleC9SRUFETUUgYi9kcml2ZXJzL25ldC93aXJlbGVz
cy9td2lmaWV4L1JFQURNRQppbmRleCAyZjBmOWI1Li5lMDEwOGRmIDEwMDY0NAotLS0gYS9kcml2
ZXJzL25ldC93aXJlbGVzcy9td2lmaWV4L1JFQURNRQorKysgYi9kcml2ZXJzL25ldC93aXJlbGVz
cy9td2lmaWV4L1JFQURNRQpAQCAtOTMsNiArOTMsNyBAQCBpbmZvCiAKIAlkcml2ZXJfbmFtZSA9
ICJtd2lmaWV4IgogCWRyaXZlcl92ZXJzaW9uID0gPGRyaXZlcl9uYW1lLCBkcml2ZXJfdmVyc2lv
biwgKGZpcm13YXJlX3ZlcnNpb24pPgorCXZlcmV4dCA9IDxkcml2ZXIgZXh0ZW5kZWQgdmVyc2lv
bj4KIAlpbnRlcmZhY2VfbmFtZSA9ICJtbGFuWCIKIAlic3NfbW9kZSA9ICJBZC1ob2MiIHwgIk1h
bmFnZWQiIHwgIkF1dG8iIHwgIlVua25vd24iCiAJbWVkaWFfc3RhdGUgPSAiRGlzY29ubmVjdGVk
IiB8ICJDb25uZWN0ZWQiCkBAIC0xMDEsNyArMTAyLDcgQEAgaW5mbwogCWVzc2lkID0gPGN1cnJl
bnQgU1NJRD4KIAlic3NpZCA9IDxjdXJyZW50IEJTU0lEPgogCWNoYW5uZWwgPSA8Y3VycmVudCBj
aGFubmVsPgotCXJlZ2lvbl9jb2RlID0gPGN1cnJlbnQgcmVnaW9uIGNvZGU+CisJY291bnRyeV9j
b2RlID0gPGN1cnJlbnQgY291bnRyeSBjb2RlPgogCW11bHRpY2Fzcl9hZGRyZXNzW25dID0gPG11
bHRpY2FzdCBhZGRyZXNzPgogCW51bV90eF9ieXRlcyA9IDxudW1iZXIgb2YgYnl0ZXMgc2VudCB0
byBkZXZpY2U+CiAJbnVtX3J4X2J5dGVzID0gPG51bWJlciBvZiBieXRlcyByZWNlaXZlZCBmcm9t
IGRldmljZSBhbmQgc2VudCB0byBrZXJuZWw+Ci0tIAoxLjkuMQoK


