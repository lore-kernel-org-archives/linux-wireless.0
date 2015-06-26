Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:50329 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbbFZJOZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jun 2015 05:14:25 -0400
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NQJ01LNXOBZ1V20@mailout4.samsung.com> for
 linux-wireless@vger.kernel.org; Fri, 26 Jun 2015 18:14:23 +0900 (KST)
Date: Fri, 26 Jun 2015 09:14:23 +0000 (GMT)
From: Amit Khatri <amit.khatri@samsung.com>
Subject: [PATCH 4/4] iw:In case of memory allocation failure by nlmsg_alloc()
 cqm will pass to NLA_PUT_U32. it should not happen.
To: "johannes@sipsolutions.net" <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Rahul Jain <rahul.jain@samsung.com>,
	HEMANSHU SRIVASTAVA <hemanshu.s@samsung.com>,
	Nitin Jhanwar <nitin.j@samsung.com>
Reply-to: amit.khatri@samsung.com
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <490671727.309651435310062683.JavaMail.weblogic@ep2mlwas06c> (sfid-20150626_111437_260250_D15B3184)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

DQpIaSBKb2hhbm5lcywNCg0KU3ViamVjdDogW1BBVENIIDQvNF0gaXc6SW4gY2FzZSBvZiBtZW1v
cnkgYWxsb2NhdGlvbiBmYWlsdXJlIGJ5IG5sbXNnX2FsbG9jKCkNCiBjcW0gd2lsbCBwYXNzIHRv
IE5MQV9QVVRfVTMyLiBpdCBzaG91bGQgbm90IGhhcHBlbi4NCg0KU2lnbmVkLW9mZi1ieTogQW1p
dCBLaGF0cmkgPGFtaXQua2hhdHJpQHNhbXN1bmcuY29tPg0KU2lnbmVkLW9mZi1ieTogUmFodWwg
SmFpbiA8cmFodWwuamFpbkBzYW1zdW5nLmNvbT4NCi0tLQ0KIGNxbS5jIHwgMiArKw0KIDEgZmls
ZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKykNCg0KZGlmZiAtLWdpdCBhL2NxbS5jIGIvY3FtLmMN
CmluZGV4IDY1ODc2YWYuLmJmNjA0MDEgMTAwNjQ0DQotLS0gYS9jcW0uYw0KKysrIGIvY3FtLmMN
CkBAIC0zNCw2ICszNCw4IEBAIHN0YXRpYyBpbnQgaXdfY3FtX3Jzc2koc3RydWN0IG5sODAyMTFf
c3RhdGUgKnN0YXRlLCBzdHJ1Y3QgbmxfY2IgKmNiLA0KIA0KIAkvKiBjb25uZWN0aW9uIHF1YWxp
dHkgbW9uaXRvciBhdHRyaWJ1dGVzICovDQogCWNxbSA9IG5sbXNnX2FsbG9jKCk7DQorCWlmKCFj
cW0pDQorCQlyZXR1cm4gLUVOT01FTTsNCiANCiAJTkxBX1BVVF9VMzIoY3FtLCBOTDgwMjExX0FU
VFJfQ1FNX1JTU0lfVEhPTEQsIHRob2xkKTsNCiAJTkxBX1BVVF9VMzIoY3FtLCBOTDgwMjExX0FU
VFJfQ1FNX1JTU0lfSFlTVCwgaHlzdCk7DQotLSANCjEuOS4xDQo=


