Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-co1nam03on0116.outbound.protection.outlook.com ([104.47.40.116]:19709
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751242AbdIAABl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Aug 2017 20:01:41 -0400
From: Eric Bentley <Eric.Bentley@lairdtech.com>
To: Steve deRosier <derosier@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "arend.vanspriel@broadcom.com" <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH] Correctly fail to suspend when SDIO does not support
 power on suspend
Date: Fri, 1 Sep 2017 00:01:38 +0000
Message-ID: <BD42024C-8F8D-4883-A370-67B8FB0B1CEC@lairdtech.com> (sfid-20170901_020145_115804_83B92A2B)
References: <BY1PR0201MB0904426CF17EF719FA343B1C839D0@BY1PR0201MB0904.namprd02.prod.outlook.com>
 <CALLGbRKbKWdo7BeDWUi24iP4OJDh-3WGdxEVBJCuYQ44==pE7g@mail.gmail.com>
In-Reply-To: <CALLGbRKbKWdo7BeDWUi24iP4OJDh-3WGdxEVBJCuYQ44==pE7g@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

WWVwIOKAkyB0cmllZCB0byBjbGVhbiBzb21lIHdoaXRlIHNwYWNlIHVwIGF0IHRoZSBsYXN0IG1p
bnV0ZeKApnVnaA0KDQpPbiA4LzMxLzE3LCA3OjQ5IFBNLCAic3RldmUuZGVyb3NpZXJAZ21haWwu
Y29tIG9uIGJlaGFsZiBvZiBTdGV2ZSBkZVJvc2llciIgPHN0ZXZlLmRlcm9zaWVyQGdtYWlsLmNv
bSBvbiBiZWhhbGYgb2YgZGVyb3NpZXJAZ21haWwuY29tPiB3cm90ZToNCg0KICAgIE9uIFRodSwg
QXVnIDMxLCAyMDE3IGF0IDQ6NDQgUE0sIEVyaWMgQmVudGxleQ0KICAgIDxFcmljLkJlbnRsZXlA
bGFpcmR0ZWNoLmNvbT4gd3JvdGU6DQogICAgPiAtICAgICAgIGlmIChzZGlvX3NldF9ob3N0X3Bt
X2ZsYWdzKHNkaW9kZXYtPmZ1bmNbMV0sIHNkaW9fZmxhZ3MpKQ0KICAgID4gKyAgICAgICBpZiAo
c2Rpb19zZXRfaG9zdF9wbV9mbGFncyhzZGlvZGV2LT5mdW5jWzFdLCBzZGlvX2ZsYWdzKSkgKA0K
ICAgIA0KICAgIEhpIEVyaWMsDQogICAgDQogICAgU2hvdWxkbid0IHRoYXQgYmUgYSAneycgaW5z
dGVhZCBvZiAnKCc/ICBNYXliZSBJJ20gbWlzc2luZyBzb21lDQogICAgY29udGV4dCwgYnV0IHRo
YXQgZG9lc24ndCBsb29rIGNvbXBpbGFibGUuDQogICAgDQogICAgOikNCiAgICANCiAgICAtIFN0
ZXZlDQogICAgDQoNCg==
