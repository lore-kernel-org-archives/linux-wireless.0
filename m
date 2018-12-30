Return-Path: <SRS0=Iw3I=PH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C819C43387
	for <linux-wireless@archiver.kernel.org>; Sun, 30 Dec 2018 08:07:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2FE5421019
	for <linux-wireless@archiver.kernel.org>; Sun, 30 Dec 2018 08:07:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726042AbeL3IHi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 30 Dec 2018 03:07:38 -0500
Received: from mga07.intel.com ([134.134.136.100]:57044 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726035AbeL3IHi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 30 Dec 2018 03:07:38 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Dec 2018 00:07:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,417,1539673200"; 
   d="scan'208";a="307595148"
Received: from fmsmsx104.amr.corp.intel.com ([10.18.124.202])
  by fmsmga005.fm.intel.com with ESMTP; 30 Dec 2018 00:07:36 -0800
Received: from fmsmsx117.amr.corp.intel.com (10.18.116.17) by
 fmsmsx104.amr.corp.intel.com (10.18.124.202) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Sun, 30 Dec 2018 00:07:36 -0800
Received: from lcsmsx153.ger.corp.intel.com (10.186.165.228) by
 fmsmsx117.amr.corp.intel.com (10.18.116.17) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Sun, 30 Dec 2018 00:07:36 -0800
Received: from hasmsx112.ger.corp.intel.com ([169.254.11.88]) by
 LCSMSX153.ger.corp.intel.com ([169.254.8.40]) with mapi id 14.03.0415.000;
 Sun, 30 Dec 2018 10:07:33 +0200
From:   "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To:     "linux-firmware@kernel.org" <linux-firmware@kernel.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        linuxwifi <linuxwifi@intel.com>,
        "kyle@infradead.org" <kyle@infradead.org>,
        "jwboyer@kernel.org" <jwboyer@kernel.org>,
        "ben@decadent.org.uk" <ben@decadent.org.uk>
Subject: pull request: iwlwifi firmware updates 2018-12-30
Thread-Topic: pull request: iwlwifi firmware updates 2018-12-30
Thread-Index: AQHUoBa3x++UKjxcNkWdkej42N9fkQ==
Date:   Sun, 30 Dec 2018 08:07:32 +0000
Message-ID: <1546157106.3213.3.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.117.29]
Content-Type: text/plain; charset="utf-8"
Content-ID: <400918A8970E104B9E268550BE0506F7@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

SGksDQoNClRoaXMgY29udGFpbnMgYSBmaXggZm9yOg0KaHR0cHM6Ly9idWd6aWxsYS5rZXJuZWwu
b3JnL3Nob3dfYnVnLmNnaT9pZD0yMDIwODUNCg0KUGxlYXNlIHB1bGwuDQoNCg0KVGhhbmtzIQ0K
DQpUaGUgZm9sbG93aW5nIGNoYW5nZXMgc2luY2UgY29tbWl0IDBmMjJjODUyNzQzOWVhYWY1YzNm
Y2Y4N2IzMWM4OTQ0NWI2ZmE4NGQ6DQoNCiAgUmV2ZXJ0ICJhbWRncHU6IHVwZGF0ZSB2ZWdhMTAg
ZncgZm9yIDE4LjUwIHJlbGVhc2UiICgyMDE4LTEyLTE4IDE1OjM4OjUzIC0wNTAwKQ0KDQphcmUg
YXZhaWxhYmxlIGluIHRoZSBHaXQgcmVwb3NpdG9yeSBhdDoNCg0KICBnaXQ6Ly9naXQua2VybmVs
Lm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvaXdsd2lmaS9saW51eC1maXJtd2FyZS5naXQg
dGFncy9pd2x3aWZpLWZ3LTIwMTgtMTItMzANCg0KZm9yIHlvdSB0byBmZXRjaCBjaGFuZ2VzIHVw
IHRvIGI3Mjc3MzkxODdmMDVlMTZlMGI4NGRhMjk2MTVmMTY1ZTEwMmEyZjY6DQoNCiAgaXdsd2lm
aTogdXBkYXRlIGZpcm13YXJlcyBmb3IgOTAwMCBzZXJpZXMgKDIwMTgtMTItMzAgMDg6Mzg6MDEg
KzAyMDApDQoNCi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0NCnVwZGF0ZXMgZm9yIC00My51Y29kZSBmb3IgOTI2MCBhbmQgOTAw
MA0KDQotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tDQpFbW1hbnVlbCBHcnVtYmFjaCAoMSk6DQogICAgICBpd2x3aWZpOiB1cGRh
dGUgZmlybXdhcmVzIGZvciA5MDAwIHNlcmllcw0KDQogV0hFTkNFICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIHwgICA0ICsrLS0NCiBpd2x3aWZpLTkwMDAtcHUtYjAtamYtYjAtNDMudWNvZGUg
fCBCaW4gMjU0MzUzMiAtPiAyNTQzNTM2IGJ5dGVzDQogaXdsd2lmaS05MjYwLXRoLWIwLWpmLWIw
LTQzLnVjb2RlIHwgQmluIDI1NTgxNzIgLT4gMjU1ODE3NiBieXRlcw0KIDMgZmlsZXMgY2hhbmdl
ZCwgMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvV0hFTkNF
IGIvV0hFTkNFDQppbmRleCBhY2Q5M2NiYzY4MDguLjk1ZGZkMDBjYzk1NSAxMDA2NDQNCi0tLSBh
L1dIRU5DRQ0KKysrIGIvV0hFTkNFDQpAQCAtMTAxMyw3ICsxMDEzLDcgQEAgRmlsZTogaXdsd2lm
aS05MDAwLXB1LWIwLWpmLWIwLTQxLnVjb2RlDQogVmVyc2lvbjogNDEuZmMxYTdhZWEuMA0KIA0K
IEZpbGU6IGl3bHdpZmktOTAwMC1wdS1iMC1qZi1iMC00My51Y29kZQ0KLVZlcnNpb246IDQzLmM3
MzExNGIzLjANCitWZXJzaW9uOiA0My45NWViNGU5Ny4wDQogDQogRmlsZTogaXdsd2lmaS05MjYw
LXRoLWIwLWpmLWIwLTMzLnVjb2RlDQogVmVyc2lvbjogMzMuNjEwMjk0LjANCkBAIC0xMDI4LDcg
KzEwMjgsNyBAQCBGaWxlOiBpd2x3aWZpLTkyNjAtdGgtYjAtamYtYjAtNDEudWNvZGUNCiBWZXJz
aW9uOiA0MS5mYzFhN2FlYS4wDQogDQogRmlsZTogaXdsd2lmaS05MjYwLXRoLWIwLWpmLWIwLTQz
LnVjb2RlDQotVmVyc2lvbjogNDMuYzczMTE0YjMuMA0KK1ZlcnNpb246IDQzLjk1ZWI0ZTk3LjAN
CiANCiBMaWNlbmNlOiBSZWRpc3RyaWJ1dGFibGUuIFNlZSBMSUNFTkNFLml3bHdpZmlfZmlybXdh
cmUgZm9yIGRldGFpbHMNCiANCmRpZmYgLS1naXQgYS9pd2x3aWZpLTkwMDAtcHUtYjAtamYtYjAt
NDMudWNvZGUgYi9pd2x3aWZpLTkwMDAtcHUtYjAtamYtYjAtNDMudWNvZGUNCmluZGV4IGY1Y2Y1
ZjMxYjkyMC4uYWU2MTAyNjNlYTU2IDEwMDY0NA0KQmluYXJ5IGZpbGVzIGEvaXdsd2lmaS05MDAw
LXB1LWIwLWpmLWIwLTQzLnVjb2RlIGFuZCBiL2l3bHdpZmktOTAwMC1wdS1iMC1qZi1iMC00My51
Y29kZSBkaWZmZXINCmRpZmYgLS1naXQgYS9pd2x3aWZpLTkyNjAtdGgtYjAtamYtYjAtNDMudWNv
ZGUgYi9pd2x3aWZpLTkyNjAtdGgtYjAtamYtYjAtNDMudWNvZGUNCmluZGV4IDI5MDkzZDVkNTky
Zi4uM2Q1Y2NkNjMyMzQxIDEwMDY0NA0KQmluYXJ5IGZpbGVzIGEvaXdsd2lmaS05MjYwLXRoLWIw
LWpmLWIwLTQzLnVjb2RlIGFuZCBiL2l3bHdpZmktOTI2MC10aC1iMC1qZi1iMC00My51Y29kZSBk
aWZmZXI=
