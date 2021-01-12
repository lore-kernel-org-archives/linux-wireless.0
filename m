Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC592C433E0
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Jan 2021 02:21:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FB6722D58
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Jan 2021 02:21:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729857AbhALCVF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Jan 2021 21:21:05 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:48390 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727886AbhALCVF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Jan 2021 21:21:05 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 10C2K97Q0017170, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmbs04.realtek.com.tw[172.21.6.97])
        by rtits2.realtek.com.tw (8.15.2/2.70/5.88) with ESMTPS id 10C2K97Q0017170
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 12 Jan 2021 10:20:09 +0800
Received: from RTEXMB06.realtek.com.tw (172.21.6.99) by
 RTEXMBS04.realtek.com.tw (172.21.6.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 12 Jan 2021 10:20:08 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMB06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2044.4; Tue, 12 Jan 2021 10:20:08 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::ecca:80ca:53:e833]) by
 RTEXMBS04.realtek.com.tw ([fe80::ecca:80ca:53:e833%12]) with mapi id
 15.01.2106.006; Tue, 12 Jan 2021 10:20:08 +0800
From:   Pkshih <pkshih@realtek.com>
To:     "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "abaci-bugfix@linux.alibaba.com" <abaci-bugfix@linux.alibaba.com>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] rtw88: debug: style: Simplify bool comparison
Thread-Topic: [PATCH] rtw88: debug: style: Simplify bool comparison
Thread-Index: AQHW5/ucgdIAEnze3069k02IgzXoGqoivKgA
Date:   Tue, 12 Jan 2021 02:20:08 +0000
Message-ID: <1610417974.3495.6.camel@realtek.com>
References: <1610356932-56073-1-git-send-email-abaci-bugfix@linux.alibaba.com>
In-Reply-To: <1610356932-56073-1-git-send-email-abaci-bugfix@linux.alibaba.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.213]
Content-Type: text/plain; charset="utf-8"
Content-ID: <890FF8EFC305BA41B518A4523CA4C9E2@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

T24gTW9uLCAyMDIxLTAxLTExIGF0IDA5OjIyICswMDAwLCBZQU5HIExJIHdyb3RlOg0KPiBGaXgg
dGhlIGZvbGxvd2luZyBjb2NjaWNoZWNrIHdhcm5pbmc6DQo+IMKgLi9kcml2ZXJzL25ldC93aXJl
bGVzcy9yZWFsdGVrL3J0dzg4L2RlYnVnLmM6ODAwOjE3LTIzOiBXQVJOSU5HOg0KPiBDb21wYXJp
c29uIG9mIDAvMSB0byBib29sIHZhcmlhYmxlDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBZQU5HIExJ
IDxhYmFjaS1idWdmaXhAbGludXguYWxpYmFiYS5jb20+DQo+IFJlcG9ydGVkLWJ5OiBBYmFjaSBS
b2JvdDxhYmFjaUBsaW51eC5hbGliYWJhLmNvbT4tLS0NCj4gwqBkcml2ZXJzL25ldC93aXJlbGVz
cy9yZWFsdGVrL3J0dzg4L2RlYnVnLmMgfCAyICstDQo+IMKgMSBmaWxlIGNoYW5nZWQsIDEgaW5z
ZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiANCg0KSSB0aGluayB0aGF0ICJydHc4ODoi
IG9yICJydHc4ODogZGVidWc6IiBhcyBzdWJqZWN0IHByZWZpeCBpcyBlbm91Z2guDQpPdGhlcnMg
YXJlIGdvb2QgdG8gbWUuDQoNCi0tLQ0KUGluZy1LZQ0KDQo=
