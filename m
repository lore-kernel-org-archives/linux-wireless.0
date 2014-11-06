Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shout01.mail.de ([213.128.151.216]:60526 "EHLO shout01.mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081AbaKFN7E (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2014 08:59:04 -0500
Received: from postfix01.mail.de (postfix01.bt.mail.de [10.0.121.125])
	by shout01.mail.de (Postfix) with ESMTP id 9F3274761D
	for <linux-wireless@vger.kernel.org>; Thu,  6 Nov 2014 14:52:18 +0100 (CET)
Received: from smtp04.mail.de (smtp04.bt.mail.de [10.0.121.214])
	by postfix01.mail.de (Postfix) with ESMTP id 6FDC442AA5
	for <linux-wireless@vger.kernel.org>; Thu,  6 Nov 2014 14:52:18 +0100 (CET)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp04.mail.de (Postfix) with ESMTPSA id 11DF985248
	for <linux-wireless@vger.kernel.org>; Thu,  6 Nov 2014 14:52:16 +0100 (CET)
Date: Thu, 06 Nov 2014 14:52:12 +0100
Subject: Problem with Intel Wireless-N 7260 and Ubuntu 14.10
From: =?ISO-8859-1?Q?Henry_W=FCnsche?= <henry.wuensche@mail.de>
To: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <20141106135217.11DF985248@smtp04.mail.de> (sfid-20141106_145908_962686_A47A8B72)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGVsbG8hCkkgZ290IGEgcHJvYmxlbSB3aXRoIGFuIExlbm92byBVMzMwcCBib3RlYm9vayBhbmQg
aXQncyBidWlsZCBpbiBJbnRlbApXaXJlbGVzcy1OIDcyNjAgaW4gY29tYmluYXRpb24gd2l0aCBV
YnVudHUgMTQuMTAgLgpJZiB0aGUgV2lGaSBjYXJkIGlzIHJ1bm5pbmcgaW4gTi1tb2RlIGFmdGVy
IGEgZmV3IG1pbnV0ZXMgSSBhbSBubyBtb3JlIGFibGUKdG8gcGluZyBteSByb3V0ZXIgb3Igdmlz
aXQgYW55IHdlYnNpdGUuIElmIHRoZSBOLW1vZGUgaXMgZGlzYWJsZWQgdmlhIHRoZQpjb21tYW5k
ICJvcHRpb25zIGl3bHdpZmkgMTFuX2Rpc2FibGU9MSIgaW4gIi9ldGMvbW9kcHJvYmUuZC9pd2x3
aWZpLmNvbmYiCml0IHdvcmtzIGZvciBtZS4KCkkgYWxzbyBub3RpY2VkIHRoYXQgdGhlIHdpZmkg
cmFuZ2Ugd2l0aCB0aGF0IHdpcmVsZXNzIGNhcmQgb24gVWJ1bnR1IGlzCnRlcnJpYmxlLiBJIGR1
YWwgYm9vdCB3aXRoIFdpbmRvd3MgOC4xIGFuZCB0aGVyZcKgIHdpZmkgcmFuZ2UgaXMgbXVjaCBi
ZXR0ZXIKYW5kIGV2ZW4gTi1tb2RlIHdvcmtzLgoKYWZ0ZXIgYm9vdGluZyBVYnVudHUgKG1haW5s
aW5lIGtlcm5lbCAzLjE3LjEpIGRtZXNnIHNob3dzIHRoaXM6CgpbwqAgwqAgNC4xMzMxMzldIGl3
bHdpZmkgMDAwMDowMjowMC4wOiBpcnEgNDkgZm9yIE1TSS9NU0ktWApbwqAgwqAgNC4xMzM0ODRd
IGl3bHdpZmkgMDAwMDowMjowMC4wOiBEaXJlY3QgZmlybXdhcmUgbG9hZCBmb3IKaXdsd2lmaS03
MjYwLTEwLnVjb2RlIGZhaWxlZCB3aXRoIGVycm9yIC0yClvCoCDCoCA0LjEzMzQ4N10gaXdsd2lm
aSAwMDAwOjAyOjAwLjA6IEZhbGxpbmcgYmFjayB0byB1c2VyIGhlbHBlcgpbwqAgwqAgNC4yNTM3
MzVdIGl3bHdpZmkgMDAwMDowMjowMC4wOiBsb2FkZWQgZmlybXdhcmUgdmVyc2lvbiAyNS4yMjIu
OS4wCm9wX21vZGUgaXdsbXZtClvCoCDCoCA1LjgxNjUxNF0gaXdsd2lmaSAwMDAwOjAyOjAwLjA6
IERldGVjdGVkIEludGVsKFIpIFdpcmVsZXNzIE4gNzI2MCwKUkVWPTB4MTQ0ClvCoCDCoCA1Ljgx
NjU2Ml0gaXdsd2lmaSAwMDAwOjAyOjAwLjA6IEwxIERpc2FibGVkOyBFbmFibGluZyBMMFMKW8Kg
IMKgIDUuODE2Nzc3XSBpd2x3aWZpIDAwMDA6MDI6MDAuMDogTDEgRGlzYWJsZWQ7IEVuYWJsaW5n
IEwwUwpbwqAgwqAgNi4wODY1OTNdIGl3bHdpZmkgMDAwMDowMjowMC4wOiBMMSBEaXNhYmxlZDsg
RW5hYmxpbmcgTDBTClvCoCDCoCA2LjA4NjgwMl0gaXdsd2lmaSAwMDAwOjAyOjAwLjA6IEwxIERp
c2FibGVkOyBFbmFibGluZyBMMFMKW8KgIMKgIDcuMTY3ODMzXSBpd2x3aWZpIDAwMDA6MDI6MDAu
MDogVGltZSBFdmVudCBlbmQgbm90aWZpY2F0aW9uIGZhaWx1cmUKCnRoZSBtZW50aW9uZWQgZmly
bXdhcmXCoCBpd2x3aWZpLTcyNjAtMTAudWNvZGUgaXNuJ3QgaW5zdGFsbGVkLCBidXQKwqBpd2x3
aWZpLTcyNjAtNy51Y29kZQrCoGl3bHdpZmktNzI2MC04LnVjb2RlCsKgaXdsd2lmaS03MjYwLTku
dWNvZGUKCmFyZS4KCklzIHRoZXJlIGFueSBzb2x1dGlvbiBmb3IgdGhpcyBwcm9ibGVtIG9yIGFu
eSBmaXg/CkkgcmVhZCB0aGF0wqAgaXdsd2lmaS03MjYwLTEwLnVjb2RlIGlzbid0IGF0YWJsZSB5
ZXQsIHNvIEkgaGF2ZW4ndCBpbnN0YWxsZWQKaXQgYXQgdGhlIG1vbWVudC4KClRoYW5rcyBpbiBh
ZHZhbmNlIGFuZCBiZXN0IHJlZ2FyZHMsCgpIZW5yeSBXw7xuc2NoZQ==

