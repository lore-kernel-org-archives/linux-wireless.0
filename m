Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:47557 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbbFZJDe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jun 2015 05:03:34 -0400
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NQJ01JUINTWTY10@mailout4.samsung.com> for
 linux-wireless@vger.kernel.org; Fri, 26 Jun 2015 18:03:32 +0900 (KST)
Date: Fri, 26 Jun 2015 09:02:36 +0000 (GMT)
From: Amit Khatri <amit.khatri@samsung.com>
Subject: [PATCH 1/4]  iw:Avoid resource memory leak. free ssids and freqs
 memory before return
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"rahul.jain@samsung.com" <rahul.jain@samsung.com>,
	hemanshu.s@samsung.com, Nitin Jhanwar <nitin.j@samsung.com>
Reply-to: amit.khatri@samsung.com
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <507180215.308811435309355412.JavaMail.weblogic@ep2mlwas06c> (sfid-20150626_110437_842647_75274F8A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgSm9oYW5uZXMsCgpTdWJqZWN0OiBbUEFUQ0ggMS80XSBbaXddIEF2b2lkIHJlc291cmNlIG1l
bW9yeSBsZWFrLiBmcmVlIHNzaWRzIGFuZCBmcmVxcwogbWVtb3J5IGJlZm9yZSByZXR1cm4KClNp
Z25lZC1vZmYtYnk6IEFtaXQgS2hhdHJpIDxhbWl0LmtoYXRyaUBzYW1zdW5nLmNvbT4KU2lnbmVk
LW9mZi1ieTogUmFodWwgSmFpbiA8cmFodWwuamFpbkBzYW1zdW5nLmNvbT4KLS0tCiBzY2FuLmMg
fCAyICsrCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEvc2Nh
bi5jIGIvc2Nhbi5jCmluZGV4IGJmMzlmMzQuLjU0ODNjMWQgMTAwNjQ0Ci0tLSBhL3NjYW4uYwor
KysgYi9zY2FuLmMKQEAgLTQwOSw2ICs0MDksOCBAQCBzdGF0aWMgaW50IGhhbmRsZV9zY2FuKHN0
cnVjdCBubDgwMjExX3N0YXRlICpzdGF0ZSwKIAkJCQlicmVhazsKIAkJCX0KIAkJY2FzZSBET05F
OgorCQkJbmxtc2dfZnJlZShzc2lkcyk7CisJCQlubG1zZ19mcmVlKGZyZXFzKTsKIAkJCXJldHVy
biAxOwogCQljYXNlIEZSRVE6CiAJCQlmcmVxID0gc3RydG91bChhcmd2W2ldLCAmZXB0ciwgMTAp
OwotLSAKMS45LjEKCg==


