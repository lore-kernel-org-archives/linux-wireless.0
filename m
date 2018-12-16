Return-Path: <SRS0=od2B=OZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,T_MIXED_ES autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B40CC43387
	for <linux-wireless@archiver.kernel.org>; Sun, 16 Dec 2018 09:01:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F04F6217F9
	for <linux-wireless@archiver.kernel.org>; Sun, 16 Dec 2018 09:01:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729811AbeLPJBR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 16 Dec 2018 04:01:17 -0500
Received: from mga11.intel.com ([192.55.52.93]:45167 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729758AbeLPJBR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Dec 2018 04:01:17 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Dec 2018 01:01:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,360,1539673200"; 
   d="scan'208";a="107784546"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by fmsmga007.fm.intel.com with ESMTP; 16 Dec 2018 01:01:17 -0800
Received: from fmsmsx154.amr.corp.intel.com (10.18.116.70) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Sun, 16 Dec 2018 01:01:16 -0800
Received: from HASMSX109.ger.corp.intel.com (10.184.198.21) by
 FMSMSX154.amr.corp.intel.com (10.18.116.70) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Sun, 16 Dec 2018 01:01:16 -0800
Received: from hasmsx112.ger.corp.intel.com ([169.254.11.88]) by
 hasmsx109.ger.corp.intel.com ([169.254.3.179]) with mapi id 14.03.0415.000;
 Sun, 16 Dec 2018 11:01:13 +0200
From:   "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To:     "linux-firmware@kernel.org" <linux-firmware@kernel.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        linuxwifi <linuxwifi@intel.com>,
        "kyle@infradead.org" <kyle@infradead.org>,
        "jwboyer@kernel.org" <jwboyer@kernel.org>,
        "ben@decadent.org.uk" <ben@decadent.org.uk>
Subject: pull-request: iwlwifi firmware updates 2018-12-16
Thread-Topic: pull-request: iwlwifi firmware updates 2018-12-16
Thread-Index: AQHUlR3lvsk4zBcgi0WInUgBaQRQ1Q==
Date:   Sun, 16 Dec 2018 09:01:13 +0000
Message-ID: <1544950869.7454.5.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.116.233]
Content-Type: text/plain; charset="utf-8"
Content-ID: <BAC9831F8576514CB13311A9B39D30A1@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

SGksDQoNClF1aXRlIGEgZmV3IHVwZGF0ZXMgaGVyZS4NClBsZWFzZSBwdWxsLg0KDQpUaGFuayB5
b3UuDQoNClRoZSBmb2xsb3dpbmcgY2hhbmdlcyBzaW5jZSBjb21taXQgMjExZGUxNjc5YTY4Yjhh
YjBmODQxYTgwNThkZjM1ZTEzZTM5NjNmMDoNCg0KICBicmNtOiBwcm92aWRlIG5ldyBmaXJtd2Fy
ZXMgZm9yIEJDTTQzNjYgY2hpcHNldCAoMjAxOC0xMi0xNSAyMDo1MTozOCAtMDUwMCkNCg0KYXJl
IGF2YWlsYWJsZSBpbiB0aGUgR2l0IHJlcG9zaXRvcnkgYXQ6DQoNCiAgZ2l0Oi8vZ2l0Lmtlcm5l
bC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2l3bHdpZmkvbGludXgtZmlybXdhcmUuZ2l0
IA0KDQpmb3IgeW91IHRvIGZldGNoIGNoYW5nZXMgdXAgdG8gODcwN2VmMzMxM2VlMGY2NzM3Njgz
YzkzYWEyY2IxZGZmNjQ4MzY0MzoNCg0KICBpd2x3aWZpOiB1cGRhdGUgZmlybXdhcmVzIGZvciA4
MDAwIHNlcmllcyAoMjAxOC0xMi0xNiAxMDo0Njo0MCArMDIwMCkNCg0KLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KRW1tYW51
ZWwgR3J1bWJhY2ggKDMpOg0KICAgICAgaXdsd2lmaTogdXBkYXRlIC00MS51Y29kZSBmb3IgOTAw
MCBzZXJpZXMNCiAgICAgIGl3bHdpZmk6IGFkZCAtNDMudWNvZGUgZm9yIDkwMDAgc2VyaWVzDQog
ICAgICBpd2x3aWZpOiB1cGRhdGUgZmlybXdhcmVzIGZvciA4MDAwIHNlcmllcw0KDQogV0hFTkNF
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgIDE0ICsrKysrKysrKystLS0tDQogaXdsd2lm
aS04MDAwQy0zNi51Y29kZSAgICAgICAgICAgIHwgQmluIDI0ODY1NzIgLT4gMjQ4NjU3MiBieXRl
cw0KIGl3bHdpZmktODI2NS0zNi51Y29kZSAgICAgICAgICAgICB8IEJpbiAyNDk4MDQ0IC0+IDI0
OTgwNDQgYnl0ZXMNCiBpd2x3aWZpLTkwMDAtcHUtYjAtamYtYjAtNDEudWNvZGUgfCBCaW4gMjk2
MTg2NCAtPiAyNjIwNDY0IGJ5dGVzDQogaXdsd2lmaS05MDAwLXB1LWIwLWpmLWIwLTQzLnVjb2Rl
IHwgQmluIDAgLT4gMjU0MzUzMiBieXRlcw0KIGl3bHdpZmktOTI2MC10aC1iMC1qZi1iMC00MS51
Y29kZSB8IEJpbiAyNjIwMzY4IC0+IDI2MjA2NTYgYnl0ZXMNCiBpd2x3aWZpLTkyNjAtdGgtYjAt
amYtYjAtNDMudWNvZGUgfCBCaW4gMCAtPiAyNTU4MTcyIGJ5dGVzDQogNyBmaWxlcyBjaGFuZ2Vk
LCAxMCBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQ0KIGNyZWF0ZSBtb2RlIDEwMDY0NCBp
d2x3aWZpLTkwMDAtcHUtYjAtamYtYjAtNDMudWNvZGUNCiBjcmVhdGUgbW9kZSAxMDA2NDQgaXds
d2lmaS05MjYwLXRoLWIwLWpmLWIwLTQzLnVjb2RlDQoNCmRpZmYgLS1naXQgYS9XSEVOQ0UgYi9X
SEVOQ0UNCmluZGV4IDJkZTM4NDFhYTkyNy4uMzY4OTQ0MzYyMGEyIDEwMDY0NA0KLS0tIGEvV0hF
TkNFDQorKysgYi9XSEVOQ0UNCkBAIC05ODAsNyArOTgwLDcgQEAgRmlsZTogaXdsd2lmaS04MDAw
Qy0zNC51Y29kZQ0KIFZlcnNpb246IDM0LjYxMDI4OC4wDQogDQogRmlsZTogaXdsd2lmaS04MDAw
Qy0zNi51Y29kZQ0KLVZlcnNpb246IDM2Ljc1OTZhZmQ0LjANCitWZXJzaW9uOiAzNi45ZjBhMmQ2
OC4wDQogDQogRmlsZTogaXdsd2lmaS04MjY1LTIxLnVjb2RlDQogVmVyc2lvbjogMjEuMzAyODAw
LjANCkBAIC05OTgsNyArOTk4LDcgQEAgRmlsZTogaXdsd2lmaS04MjY1LTM0LnVjb2RlDQogVmVy
c2lvbjogMzQuNjEwMjg4LjANCiANCiBGaWxlOiBpd2x3aWZpLTgyNjUtMzYudWNvZGUNCi1WZXJz
aW9uOiAzNi43NTk2YWZkNC4wDQorVmVyc2lvbjogMzYuOWYwYTJkNjguMA0KIA0KIEZpbGU6IGl3
bHdpZmktOTAwMC1wdS1iMC1qZi1iMC0zMy51Y29kZQ0KIFZlcnNpb246IDMzLjYxMDI5NC4wDQpA
QCAtMTAxMCw3ICsxMDEwLDEwIEBAIEZpbGU6IGl3bHdpZmktOTAwMC1wdS1iMC1qZi1iMC0zOC51
Y29kZQ0KIFZlcnNpb246IDM4Ljc1NWNmZGQ4LjANCiANCiBGaWxlOiBpd2x3aWZpLTkwMDAtcHUt
YjAtamYtYjAtNDEudWNvZGUNCi1WZXJzaW9uOiAzOC4xZjFlOGQ0YS4wDQorVmVyc2lvbjogNDEu
ZmMxYTdhZWEuMA0KKw0KK0ZpbGU6IGl3bHdpZmktOTAwMC1wdS1iMC1qZi1iMC00My51Y29kZQ0K
K1ZlcnNpb246IDQzLmM3MzExNGIzLjANCiANCiBGaWxlOiBpd2x3aWZpLTkyNjAtdGgtYjAtamYt
YjAtMzMudWNvZGUNCiBWZXJzaW9uOiAzMy42MTAyOTQuMA0KQEAgLTEwMjIsNyArMTAyNSwxMCBA
QCBGaWxlOiBpd2x3aWZpLTkyNjAtdGgtYjAtamYtYjAtMzgudWNvZGUNCiBWZXJzaW9uOiAzOC43
NTVjZmRkOC4wDQogDQogRmlsZTogaXdsd2lmaS05MjYwLXRoLWIwLWpmLWIwLTQxLnVjb2RlDQot
VmVyc2lvbjogNDEuMWYxZThkNGEuMA0KK1ZlcnNpb246IDQxLmZjMWE3YWVhLjANCisNCitGaWxl
OiBpd2x3aWZpLTkyNjAtdGgtYjAtamYtYjAtNDMudWNvZGUNCitWZXJzaW9uOiA0My5jNzMxMTRi
My4wDQogDQogTGljZW5jZTogUmVkaXN0cmlidXRhYmxlLiBTZWUgTElDRU5DRS5pd2x3aWZpX2Zp
cm13YXJlIGZvciBkZXRhaWxzDQogDQpkaWZmIC0tZ2l0IGEvaXdsd2lmaS04MDAwQy0zNi51Y29k
ZSBiL2l3bHdpZmktODAwMEMtMzYudWNvZGUNCmluZGV4IGI5MzU3NDViZTdhZi4uZTgzYTAyNGEz
OTExIDEwMDY0NA0KQmluYXJ5IGZpbGVzIGEvaXdsd2lmaS04MDAwQy0zNi51Y29kZSBhbmQgYi9p
d2x3aWZpLTgwMDBDLTM2LnVjb2RlIGRpZmZlcg0KZGlmZiAtLWdpdCBhL2l3bHdpZmktODI2NS0z
Ni51Y29kZSBiL2l3bHdpZmktODI2NS0zNi51Y29kZQ0KaW5kZXggMmJkOWY5NGQ5NDM3Li40MDZl
MDMzMjVkMzQgMTAwNjQ0DQpCaW5hcnkgZmlsZXMgYS9pd2x3aWZpLTgyNjUtMzYudWNvZGUgYW5k
IGIvaXdsd2lmaS04MjY1LTM2LnVjb2RlIGRpZmZlcg0KZGlmZiAtLWdpdCBhL2l3bHdpZmktOTAw
MC1wdS1iMC1qZi1iMC00MS51Y29kZSBiL2l3bHdpZmktOTAwMC1wdS1iMC1qZi1iMC00MS51Y29k
ZQ0KaW5kZXggNGNjM2EwMTI0ZWM0Li42NWMxYmJiZGJkZjIgMTAwNjQ0DQpCaW5hcnkgZmlsZXMg
YS9pd2x3aWZpLTkwMDAtcHUtYjAtamYtYjAtNDEudWNvZGUgYW5kIGIvaXdsd2lmaS05MDAwLXB1
LWIwLWpmLWIwLTQxLnVjb2RlIGRpZmZlcg0KZGlmZiAtLWdpdCBhL2l3bHdpZmktOTAwMC1wdS1i
MC1qZi1iMC00My51Y29kZSBiL2l3bHdpZmktOTAwMC1wdS1iMC1qZi1iMC00My51Y29kZQ0KbmV3
IGZpbGUgbW9kZSAxMDA2NDQNCmluZGV4IDAwMDAwMDAwMDAwMC4uZjVjZjVmMzFiOTIwDQpCaW5h
cnkgZmlsZXMgL2Rldi9udWxsIGFuZCBiL2l3bHdpZmktOTAwMC1wdS1iMC1qZi1iMC00My51Y29k
ZSBkaWZmZXINCmRpZmYgLS1naXQgYS9pd2x3aWZpLTkyNjAtdGgtYjAtamYtYjAtNDEudWNvZGUg
Yi9pd2x3aWZpLTkyNjAtdGgtYjAtamYtYjAtNDEudWNvZGUNCmluZGV4IGViYjU2ZjhlMzI2Ny4u
ZGU0ZTc0ZTc3ODQ0IDEwMDY0NA0KQmluYXJ5IGZpbGVzIGEvaXdsd2lmaS05MjYwLXRoLWIwLWpm
LWIwLTQxLnVjb2RlIGFuZCBiL2l3bHdpZmktOTI2MC10aC1iMC1qZi1iMC00MS51Y29kZSBkaWZm
ZXINCmRpZmYgLS1naXQgYS9pd2x3aWZpLTkyNjAtdGgtYjAtamYtYjAtNDMudWNvZGUgYi9pd2x3
aWZpLTkyNjAtdGgtYjAtamYtYjAtNDMudWNvZGUNCm5ldyBmaWxlIG1vZGUgMTAwNjQ0DQppbmRl
eCAwMDAwMDAwMDAwMDAuLjI5MDkzZDVkNTkyZg0KQmluYXJ5IGZpbGVzIC9kZXYvbnVsbCBhbmQg
Yi9pd2x3aWZpLTkyNjAtdGgtYjAtamYtYjAtNDMudWNvZGUgZGlmZmVy
