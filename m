Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:42504 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbbFZJMe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jun 2015 05:12:34 -0400
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NQJ01SLAO8XES80@mailout3.samsung.com> for
 linux-wireless@vger.kernel.org; Fri, 26 Jun 2015 18:12:33 +0900 (KST)
Date: Fri, 26 Jun 2015 09:12:33 +0000 (GMT)
From: Amit Khatri <amit.khatri@samsung.com>
Subject: [PATCH 3/4] iw: Static analyser report that attr may be NULL so either
 we can remove condition check statement or add goto at end of this function.
To: "johannes@sipsolutions.net" <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Rahul Jain <rahul.jain@samsung.com>,
	HEMANSHU SRIVASTAVA <hemanshu.s@samsung.com>,
	Nitin Jhanwar <nitin.j@samsung.com>
Reply-to: amit.khatri@samsung.com
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <1851474397.309551435309952587.JavaMail.weblogic@ep2mlwas06c> (sfid-20150626_111240_658875_6B1806EF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

DQpIaSBKb2hhbm5lcywNCg0KU3ViamVjdDogW1BBVENIIDMvNF0gaXc6IFN0YXRpYyBhbmFseXNl
ciByZXBvcnQgdGhhdCBhdHRyIG1heSBiZSBOVUxMIHNvDQogZWl0aGVyIHdlIGNhbiByZW1vdmUg
Y29uZGl0aW9uIGNoZWNrIHN0YXRlbWVudCBvciBhZGQgZ290byBhdCBlbmQgb2YgdGhpcw0KIGZ1
bmN0aW9uLg0KDQpTaWduZWQtb2ZmLWJ5OiBBbWl0IEtoYXRyaSA8YW1pdC5raGF0cmlAc2Ftc3Vu
Zy5jb20+DQpTaWduZWQtb2ZmLWJ5OiBSYWh1bCBKYWluIDxyYWh1bC5qYWluQHNhbXN1bmcuY29t
Pg0KLS0tDQogZXZlbnQuYyB8IDYgKysrKystDQogMSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0aW9u
cygrKSwgMSBkZWxldGlvbigtKQ0KDQpkaWZmIC0tZ2l0IGEvZXZlbnQuYyBiL2V2ZW50LmMNCmlu
ZGV4IGY3M2UwNzguLjA2ZDIzNmIgMTAwNjQ0DQotLS0gYS9ldmVudC5jDQorKysgYi9ldmVudC5j
DQpAQCAtNDksOCArNDksMTAgQEAgc3RhdGljIHZvaWQgcHJpbnRfZnJhbWUoc3RydWN0IHByaW50
X2V2ZW50X2FyZ3MgKmFyZ3MsIHN0cnVjdCBubGF0dHIgKmF0dHIpDQogCWNoYXIgbWFjYnVmWzYq
M107DQogCXVpbnQxNl90IHRtcDsNCiANCi0JaWYgKCFhdHRyKQ0KKwlpZiAoIWF0dHIpIHsNCiAJ
CXByaW50ZigiIFtubyBmcmFtZV0iKTsNCisJCWdvdG8gb3V0Ow0KKwl9DQogDQogCWZyYW1lID0g
bmxhX2RhdGEoYXR0cik7DQogCWxlbiA9IG5sYV9sZW4oYXR0cik7DQpAQCAtOTcsNiArOTksOCBA
QCBzdGF0aWMgdm9pZCBwcmludF9mcmFtZShzdHJ1Y3QgcHJpbnRfZXZlbnRfYXJncyAqYXJncywg
c3RydWN0IG5sYXR0ciAqYXR0cikNCiAJZm9yIChpID0gMDsgaSA8IGxlbjsgaSsrKQ0KIAkJcHJp
bnRmKCIgJS4wMngiLCBmcmFtZVtpXSk7DQogCXByaW50ZigiXSIpOw0KKyBvdXQ6DQorCTsgIC8q
ZW1wdHkgc3RhdGVtZW50IHRvIGF2b2lkIGNvbXBpbGVyIGVycm9yICovDQogfQ0KIA0KIHN0YXRp
YyB2b2lkIHBhcnNlX2NxbV9ldmVudChzdHJ1Y3QgbmxhdHRyICoqYXR0cnMpDQotLSANCjEuOS4x


