Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:36290 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714AbbHMKUu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2015 06:20:50 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NT002APPNEPZK60@mailout4.samsung.com> for
 linux-wireless@vger.kernel.org; Thu, 13 Aug 2015 19:20:49 +0900 (KST)
Date: Thu, 13 Aug 2015 10:20:48 +0000 (GMT)
From: Amit Khatri <amit.khatri@samsung.com>
Subject: [PATCH 1/3] iw: check nlmsg_allocation
To: "johannes@sipsolutions.net" <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Rahul Jain <rahul.jain@samsung.com>,
	HEMANSHU SRIVASTAVA <hemanshu.s@samsung.com>,
	Nitin Jhanwar <nitin.j@samsung.com>
Reply-to: amit.khatri@samsung.com
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <383051846.59031439461247528.JavaMail.weblogic@ep2mlwas04a> (sfid-20150813_122054_354918_3F11113A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SW4gY2FzZSBvZiBtZW1vcnkgYWxsb2NhdGlvbiBmYWlsdXJlIGJ5ICBubG1zZ19hbGxvYygpIGNx
bSB3aWxsIHBhc3MgdG8gTkxBX1BVVF9VMzIuDQppdCBzaG91bGQgbm90IGhhcHBlbg0KDQpTaWdu
ZWQtb2ZmLWJ5OiBBbWl0IEtoYXRyaSA8YW1pdC5raGF0cmlAc2Ftc3VuZy5jb20+DQpTaWduZWQt
b2ZmLWJ5OiBSYWh1bCBKYWluIDxyYWh1bC5qYWluQHNhbXN1bmcuY29tPg0KLS0tDQogY3FtLmMg
fCAyICsrDQogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKQ0KDQpkaWZmIC0tZ2l0IGEv
Y3FtLmMgYi9jcW0uYw0KaW5kZXggZGRkZDM2ZS4uNDEyZDc3YiAxMDA2NDQNCi0tLSBhL2NxbS5j
DQorKysgYi9jcW0uYw0KQEAgLTM0LDYgKzM0LDggQEAgc3RhdGljIGludCBpd19jcW1fcnNzaShz
dHJ1Y3Qgbmw4MDIxMV9zdGF0ZSAqc3RhdGUsDQoNCiAgICAgICAgLyogY29ubmVjdGlvbiBxdWFs
aXR5IG1vbml0b3IgYXR0cmlidXRlcyAqLw0KICAgICAgICBjcW0gPSBubG1zZ19hbGxvYygpOw0K
KyAgICAgICBpZighY3FtKQ0KKyAgICAgICAgICAgICAgIHJldHVybiAtRU5PTUVNOw0KDQogICAg
ICAgIE5MQV9QVVRfVTMyKGNxbSwgTkw4MDIxMV9BVFRSX0NRTV9SU1NJX1RIT0xELCB0aG9sZCk7
DQogICAgICAgIE5MQV9QVVRfVTMyKGNxbSwgTkw4MDIxMV9BVFRSX0NRTV9SU1NJX0hZU1QsIGh5
c3QpOw0KLS0NCjEuOS4xDQo=


