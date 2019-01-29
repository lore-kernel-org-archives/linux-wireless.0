Return-Path: <SRS0=Fojl=QF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7AB3C282D0
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 02:19:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4AF62148E
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 02:19:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727133AbfA2CQO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 21:16:14 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:40509 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727111AbfA2CQO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 21:16:14 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x0T2Fqbm016798, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcas11.realtek.com.tw[172.21.6.12])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x0T2Fqbm016798
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Tue, 29 Jan 2019 10:15:52 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITCAS11.realtek.com.tw ([fe80::7c6d:ced5:c4ff:8297%15]) with mapi id
 14.03.0399.000; Tue, 29 Jan 2019 10:15:52 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     Larry Finger <Larry.Finger@lwfinger.net>
CC:     Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "briannorris@chromium.org" <briannorris@chromium.org>,
        "sgruszka@redhat.com" <sgruszka@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH v3 00/13] rtw88: mac80211 driver for Realtek 802.11ac wireless network chips
Thread-Topic: [PATCH v3 00/13] rtw88: mac80211 driver for Realtek 802.11ac
 wireless network chips
Thread-Index: AQHUtsz0oGWsIdSZ5km8koIDZ4UJzKXEpEWAgADdk7A=
Date:   Tue, 29 Jan 2019 02:15:51 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D1794AAB@RTITMBSVM04.realtek.com.tw>
References: <1548654407-28469-1-git-send-email-yhchuang@realtek.com>
 <043aedf4-0ed4-e128-3cd2-242aaef128f6@lwfinger.net>
In-Reply-To: <043aedf4-0ed4-e128-3cd2-242aaef128f6@lwfinger.net>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.68.123]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

PiBUb255LA0KPiANCj4gSSBoYWQgbm90IHRlc3RlZCBydHc4OCBmb3Igc29tZSB0aW1lLCBzbyBJ
IGJ1aWx0IGEga2VybmVsIHdpdGggdGhlIFYzIHBhdGNoZXMgYW5kDQo+IGZvdW5kIHRoYXQgcnR3
ODggY3Jhc2hlZCB3aXRoIGEgTlVMTCBwb2ludGVyIGRlcmVmZXJlbmNlLiBJIGRpZCBzb21lDQo+
IGRlYnVnZ2luZyBhbmQgZm91bmQgdGhhdCB0aGUgcHJvYmxlbSB3YXMgaW4gcm91dGluZSBydHdf
Y2hpcF9lZnVzZV9lbmFibGUoKQ0KPiB3aGVyZSBmdy0+ZmlybXdhcmUgd2FzIE5VTEwuDQo+IA0K
DQpIaSBMYXJyeSwNCg0KVGhpcyBOVUxMIHBvaW50ZXIgd2FzIGZvdW5kIG1vbnRocyBhZ28gYW5k
IGhhcyBiZWVuIGZpeGVkIGFscmVhZHkuDQpUaGFua3MgZm9yIHlvdXIgdGVzdCA6KS4NCkkgYW0g
aG9sZGluZyB0aGUgcGF0Y2ggdG8gZml4IGl0IGZvciB0aGUgbmV4dCBwYXRjaHNldHMuDQoNCkJU
Vywgc2luY2UgcnR3ODggaGFzIG5vdCBiZWVuIGFjY2VwdGVkLCBjb3VsZCBJIHNlbmQgbmV4dCBw
YXRjaCBzZXQgYmFzZWQgb24NCnRoaXMgcGF0Y2ggc2V0IGFzIGxvbmcgYXMgSSBleHBsaWNpdGx5
IG1hcmsgdGhhdCB0aGUgbmV4dCBwYXRjaCBpcyBiYXNlZCBvbiB0aGUgcHJldmlvdXMgb25lPw0K
VGhhbmtzIQ0KDQpZYW4tSHN1YW4NCg==
