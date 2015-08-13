Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:33143 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbbHMK1B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2015 06:27:01 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NT002IYLNOZ8W70@mailout2.samsung.com> for
 linux-wireless@vger.kernel.org; Thu, 13 Aug 2015 19:27:00 +0900 (KST)
Date: Thu, 13 Aug 2015 10:26:59 +0000 (GMT)
From: Amit Khatri <amit.khatri@samsung.com>
Subject: [PATCH 2/3] iw: Avoid NULL attr value to pass in nla_data.
To: "johannes@sipsolutions.net" <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Rahul Jain <rahul.jain@samsung.com>,
	HEMANSHU SRIVASTAVA <hemanshu.s@samsung.com>,
	Nitin Jhanwar <nitin.j@samsung.com>
Reply-to: amit.khatri@samsung.com
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <413802298.56331439461619306.JavaMail.weblogic@ep2mlwas02d> (sfid-20150813_122707_340586_0123823A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

dmFsdWUgb2YgYXR0ciBtYXkgYmUgTlVMTCBzbyBjaGVjayBiZWZvcmUgcGFzc2luZw0KdG8gZnVu
Y3Rpb24uDQoNClNpZ25lZC1vZmYtYnk6IEFtaXQgS2hhdHJpIDxhbWl0LmtoYXRyaUBzYW1zdW5n
LmNvbT4NClNpZ25lZC1vZmYtYnk6IFJhaHVsIEphaW4gPHJhaHVsLmphaW5Ac2Ftc3VuZy5jb20+
DQotLS0NCiBldmVudC5jIHwgNCArKystDQogMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygr
KSwgMSBkZWxldGlvbigtKQ0KDQpkaWZmIC0tZ2l0IGEvZXZlbnQuYyBiL2V2ZW50LmMNCmluZGV4
IDVmYjVhZmMuLjVkMGJmZGUgMTAwNjQ0DQotLS0gYS9ldmVudC5jDQorKysgYi9ldmVudC5jDQpA
QCAtNDksOCArNDksMTAgQEAgc3RhdGljIHZvaWQgcHJpbnRfZnJhbWUoc3RydWN0IHByaW50X2V2
ZW50X2FyZ3MgKmFyZ3MsIHN0cnVjdCBubGF0dHIgKmF0dHIpDQogICAgICAgIGNoYXIgbWFjYnVm
WzYqM107DQogICAgICAgIHVpbnQxNl90IHRtcDsNCg0KLSAgICAgICBpZiAoIWF0dHIpDQorICAg
ICAgIGlmICghYXR0cikgew0KICAgICAgICAgICAgICAgIHByaW50ZigiIFtubyBmcmFtZV0iKTsN
CisgICAgICAgICAgICAgICByZXR1cm47DQorICAgICAgIH0NCg0KICAgICAgICBmcmFtZSA9IG5s
YV9kYXRhKGF0dHIpOw0KICAgICAgICBsZW4gPSBubGFfbGVuKGF0dHIpOw0KLS0NCjEuOS4xDQo=


