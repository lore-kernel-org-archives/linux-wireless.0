Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31D90C7EE21
	for <linux-wireless@archiver.kernel.org>; Wed,  3 May 2023 01:30:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbjECBaS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 May 2023 21:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjECBaR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 May 2023 21:30:17 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CD011BCA
        for <linux-wireless@vger.kernel.org>; Tue,  2 May 2023 18:30:16 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 3431U8zF4016172, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 3431U8zF4016172
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
        Wed, 3 May 2023 09:30:08 +0800
Received: from RTEXMBS01.realtek.com.tw (172.21.6.94) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Wed, 3 May 2023 09:30:12 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS01.realtek.com.tw (172.21.6.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Wed, 3 May 2023 09:30:12 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::e138:e7f1:4709:ff4d]) by
 RTEXMBS04.realtek.com.tw ([fe80::e138:e7f1:4709:ff4d%5]) with mapi id
 15.01.2375.007; Wed, 3 May 2023 09:30:12 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Bitterblue Smith <rtl8821cerfe2@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Jes Sorensen <Jes.Sorensen@gmail.com>
Subject: RE: [PATCH v2 2/2] wifi: rtl8xxxu: Rename some registers
Thread-Topic: [PATCH v2 2/2] wifi: rtl8xxxu: Rename some registers
Thread-Index: AQHZfSWZA/5a8sqVFkGDjZSZZz857K9Hwxew
Date:   Wed, 3 May 2023 01:30:12 +0000
Message-ID: <9db2d0be61ea4af4b815f91b96a20079@realtek.com>
References: <c43d971c-21bf-6714-d852-c76e515438b0@gmail.com>
 <1779693f-c40b-fb86-e697-fd7958ea90bd@gmail.com>
In-Reply-To: <1779693f-c40b-fb86-e697-fd7958ea90bd@gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS01.realtek.com.tw, 9
x-kse-antispam-interceptor-info: fallback
x-kse-antivirus-interceptor-info: fallback
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-AntiSpam-Interceptor-Info: fallback
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQml0dGVyYmx1ZSBTbWl0
aCA8cnRsODgyMWNlcmZlMkBnbWFpbC5jb20+DQo+IFNlbnQ6IFdlZG5lc2RheSwgTWF5IDMsIDIw
MjMgMjo0MSBBTQ0KPiBUbzogbGludXgtd2lyZWxlc3NAdmdlci5rZXJuZWwub3JnDQo+IENjOiBK
ZXMgU29yZW5zZW4gPEplcy5Tb3JlbnNlbkBnbWFpbC5jb20+OyBQaW5nLUtlIFNoaWggPHBrc2hp
aEByZWFsdGVrLmNvbT4NCj4gU3ViamVjdDogW1BBVENIIHYyIDIvMl0gd2lmaTogcnRsOHh4eHU6
IFJlbmFtZSBzb21lIHJlZ2lzdGVycw0KPiANCj4gR2l2ZSBwcm9wZXIgbmFtZXM6DQo+IA0KPiBS
RjYwNTJfUkVHX1VOS05PV05fNTYgLT4gUkY2MDUyX1JFR19QQURfVFhHDQo+IFJGNjA1Ml9SRUdf
VU5LTk9XTl9ERiAtPiBSRjYwNTJfUkVHX0dBSU5fQ0NBDQo+IA0KPiBBbmQgZml4IHR5cG9zOg0K
PiANCj4gUkVHX09GRE0wX0FHQ1JfU1NJX1RBQkxFIC0+IFJFR19PRkRNMF9BR0NfUlNTSV9UQUJM
RQ0KPiBSRUdfQkJfQUNDRUVTU19DVFJMIC0+IFJFR19CQl9BQ0NFU1NfQ1RSTA0KPiANCj4gU2ln
bmVkLW9mZi1ieTogQml0dGVyYmx1ZSBTbWl0aCA8cnRsODgyMWNlcmZlMkBnbWFpbC5jb20+DQoN
ClJldmlld2VkLWJ5OiBQaW5nLUtlIFNoaWggPHBrc2hpaEByZWFsdGVrLmNvbT4NCg0KDQo=
