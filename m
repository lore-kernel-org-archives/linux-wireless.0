Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-dm3nam03on0110.outbound.protection.outlook.com ([104.47.41.110]:33997
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751242AbdIAAE4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Aug 2017 20:04:56 -0400
From: Eric Bentley <Eric.Bentley@lairdtech.com>
To: Steve deRosier <derosier@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "arend.vanspriel@broadcom.com" <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH v2] Correctly fail to suspend when SDIO does not support
 power on suspend
Date: Fri, 1 Sep 2017 00:04:51 +0000
Message-ID: <F895C8CD-1D0E-46CB-9C12-5B4775E76217@lairdtech.com> (sfid-20170901_020459_305145_E5380AC8)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

UmV0dXJuIGVycm9yIHdoZW4gZmFpbGluZyB0byBzZXQgcG93ZXIgbWFuYWdlbWVudCBjYXBhYmls
aXRpZXMgZmxhZy4gIFRoaXMgd2lsbCBjYXVzZSB0aGUgc3VzcGVuZCB0byBmYWlsIGJ1dCB0aGUg
cmFkaW8NCndpbGwgY29udGludWUgdG8gb3BlcmF0ZS4gIEFsbG93aW5nIHRoaXMgdG8gZmFpbCB3
aXRob3V0IHJlcG9ydGluZyBlcnJvciB3aWxsIGNhdXNlIHRoZSByYWRpbyB0byBiZSBub24tZnVu
Y3Rpb25hbCBvbiANCnJlc3VtZSBhcyBpdCB3aWxsIGhhdmUgbG9zdCBwb3dlci4NCg0KU2lnbmVk
LW9mZi1ieTogRXJpYyBCZW50bGV5IGVyaWMuYmVudGxleUBsYWlyZHRlY2guY29tDQotLS0NCnYy
OiBjb3JyZWN0ZWQgZXJyYW50ICggd2l0aCB7DQotLS0NCiBkcml2ZXJzL25ldC93aXJlbGVzcy9i
cm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvYmNtc2RoLmMgfCA0ICsrKy0NCiAxIGZpbGUgY2hh
bmdlZCwgMyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2
ZXJzL25ldC93aXJlbGVzcy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvYmNtc2RoLmMgYi9k
cml2ZXJzL25ldC93aXJlbGVzcy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvYmNtc2RoLmMN
CmluZGV4IDcyMTM5YjUuLjJmN2QwM2YgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVz
cy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvYmNtc2RoLmMNCisrKyBiL2RyaXZlcnMvbmV0
L3dpcmVsZXNzL2Jyb2FkY29tL2JyY204MDIxMS9icmNtZm1hYy9iY21zZGguYw0KQEAgLTEyNjQs
OCArMTI2NCwxMCBAQCBzdGF0aWMgaW50IGJyY21mX29wc19zZGlvX3N1c3BlbmQoc3RydWN0IGRl
dmljZSAqZGV2KQ0KICAgICAgICAgICAgICAgICBlbHNlDQogICAgICAgICAgICAgICAgICAgICAg
ICAgc2Rpb19mbGFncyB8PSBNTUNfUE1fV0FLRV9TRElPX0lSUTsNCiAgICAgICAgIH0NCi0gICAg
ICAgaWYgKHNkaW9fc2V0X2hvc3RfcG1fZmxhZ3Moc2Rpb2Rldi0+ZnVuY1sxXSwgc2Rpb19mbGFn
cykpDQorICAgICAgIGlmIChzZGlvX3NldF9ob3N0X3BtX2ZsYWdzKHNkaW9kZXYtPmZ1bmNbMV0s
IHNkaW9fZmxhZ3MpKSB7DQogICAgICAgICAgICAgICAgIGJyY21mX2VycigiRmFpbGVkIHRvIHNl
dCBwbV9mbGFncyAleFxuIiwgc2Rpb19mbGFncyk7DQorICAgICAgICAgICAgICAgcmV0dXJuIC1F
SU5WQUw7DQorICAgICAgIH0NCiAgICAgICAgIHJldHVybiAwOw0KIH0NCiANCi0tIA0KMi42LjAu
R0lUDQoNCg0K
