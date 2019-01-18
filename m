Return-Path: <SRS0=80NG=P2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62954C43444
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jan 2019 03:59:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 316BC2086D
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jan 2019 03:59:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbfARD7C (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 17 Jan 2019 22:59:02 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:41434 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726910AbfARD7C (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Jan 2019 22:59:02 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x0I3wbgR005623, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcas12.realtek.com.tw[172.21.6.16])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x0I3wbgR005623
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Fri, 18 Jan 2019 11:58:37 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITCAS12.realtek.com.tw ([::1]) with mapi id 14.03.0415.000; Fri, 18 Jan
 2019 11:58:36 +0800
From:   Pkshih <pkshih@realtek.com>
To:     "yuehaibing@huawei.com" <yuehaibing@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "arend.vanspriel@broadcom.com" <arend.vanspriel@broadcom.com>,
        "chi-hsien.lin@cypress.com" <chi-hsien.lin@cypress.com>,
        "franky.lin@broadcom.com" <franky.lin@broadcom.com>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "brcm80211-dev-list@cypress.com" <brcm80211-dev-list@cypress.com>
Subject: Re: [PATCH] wireless: remove unneeded semicolon
Thread-Topic: [PATCH] wireless: remove unneeded semicolon
Thread-Index: AQHUrt6EDwbXphF6dUilq9B8gANrLqW0Zm6A
Date:   Fri, 18 Jan 2019 03:58:35 +0000
Message-ID: <1547812715.3687.1.camel@realtek.com>
References: <20190118033215.5904-1-yuehaibing@huawei.com>
In-Reply-To: <20190118033215.5904-1-yuehaibing@huawei.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.154]
Content-Type: text/plain; charset="utf-8"
Content-ID: <0FABF84C87D6324D991AAF1F8349EACA@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

T24gRnJpLCAyMDE5LTAxLTE4IGF0IDExOjMyICswODAwLCBZdWVIYWliaW5nIHdyb3RlOg0KPiBy
ZW1vdmUgdW5uZWVkZWQgc2VtaWNvbG9uDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBZdWVIYWliaW5n
IDx5dWVoYWliaW5nQGh1YXdlaS5jb20+DQo+IC0tLQ0KPiDCoGRyaXZlcnMvbmV0L3dpcmVsZXNz
L2F0aC9hdGgxMGsvd21pLmjCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqB8IDIgKy0NCj4gwqBkcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoNmtsL2luaXQuY8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB8IDIgKy0NCj4gwqBkcml2ZXJzL25l
dC93aXJlbGVzcy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvYmNtc2RoLmMgfCAyICstDQo+
IMKgZHJpdmVycy9uZXQvd2lyZWxlc3MvcmF5X2NzLmPCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgfCAyICstDQo+IMKgZHJpdmVycy9uZXQv
d2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL3J0bDg3MjNiZS9waHkuY8KgwqDCoMKgwqDCoHwgNiAr
KystLS0NCg0KRm9yIHJ0bHdpZmkgZHJpdmVyLA0KQWNrZWQtYnk6IFBpbmctS2UgU2hpaCA8cGtz
aGloQHJlYWx0ZWsuY29tPg0KDQo=
