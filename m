Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oln040092069044.outbound.protection.outlook.com ([40.92.69.44]:38483
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753952AbeGHJ50 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 8 Jul 2018 05:57:26 -0400
From: Bernd Edlinger <bernd.edlinger@hotmail.de>
To: Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] Add a missing break in parse_station_flags
Date: Sun, 8 Jul 2018 09:57:22 +0000
Message-ID: <AM5PR0701MB265751E3A716081292C5224FE4450@AM5PR0701MB2657.eurprd07.prod.outlook.com> (sfid-20180708_115802_424118_3E8FEE4A)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SSB3YXMgbG9va2luZyBhdCB1c3VhbGx5IHN1cHByZXNzZWQgZ2NjIHdhcm5pbmdzLA0KWy1XaW1w
bGljaXQtZmFsbHRocm91Z2g9XSBpbiB0aGlzIGNhc2U6DQoNClRoZSBjb2RlIGRlZmluaXRlbHkg
bG9va3MgbGlrZSBhIGJyZWFrIGlzIG1pc3NpbmcgaGVyZS4NCkhvd2V2ZXIgSSBhbSBub3QgYWJs
ZSB0byB0ZXN0IHRoZSBOTDgwMjExX0lGVFlQRV9NRVNIX1BPSU5ULA0Kbm9yIGRvIEkgYWN0dWFs
bHkga25vdyB3aGF0IG1pZ2h0IGJlIDopDQpTbyBwbGVhc2UgdXNlIHRoaXMgcGF0Y2ggd2l0aCBj
YXV0aW9uIGFuZCBvbmx5IGlmIHlvdSBhcmUNCmFibGUgdG8gZG8gc29tZSB0ZXN0aW5nLg0KDQpT
aWduZWQtb2ZmLWJ5OiBCZXJuZCBFZGxpbmdlciA8YmVybmQuZWRsaW5nZXJAaG90bWFpbC5kZT4N
Ci0tLQ0KICBuZXQvd2lyZWxlc3Mvbmw4MDIxMS5jIHwgMSArDQogIDEgZmlsZSBjaGFuZ2VkLCAx
IGluc2VydGlvbigrKQ0KDQpkaWZmIC0tZ2l0IGEvbmV0L3dpcmVsZXNzL25sODAyMTEuYyBiL25l
dC93aXJlbGVzcy9ubDgwMjExLmMNCmluZGV4IDRlZWNlMDYuLjY1MzdiNWQgMTAwNjQ0DQotLS0g
YS9uZXQvd2lyZWxlc3Mvbmw4MDIxMS5jDQorKysgYi9uZXQvd2lyZWxlc3Mvbmw4MDIxMS5jDQpA
QCAtNDQwOSw2ICs0NDA5LDcgQEAgc3RhdGljIGludCBwYXJzZV9zdGF0aW9uX2ZsYWdzKHN0cnVj
dCBnZW5sX2luZm8gKmluZm8sDQogIAkJcGFyYW1zLT5zdGFfZmxhZ3NfbWFzayA9IEJJVChOTDgw
MjExX1NUQV9GTEFHX0FVVEhFTlRJQ0FURUQpIHwNCiAgCQkJCQkgQklUKE5MODAyMTFfU1RBX0ZM
QUdfTUZQKSB8DQogIAkJCQkJIEJJVChOTDgwMjExX1NUQV9GTEFHX0FVVEhPUklaRUQpOw0KKwkJ
YnJlYWs7DQogIAlkZWZhdWx0Og0KICAJCXJldHVybiAtRUlOVkFMOw0KICAJfQ0KLS0gDQoxLjku
MQ0K
