Return-Path: <SRS0=ht5v=ND=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51A33C67863
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 01:25:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E1BE20665
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 01:25:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4E1BE20665
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=realtek.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727872AbeJWJqF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Oct 2018 05:46:05 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:55124 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbeJWJqF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Oct 2018 05:46:05 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID w9N1OkNf026058, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id w9N1OkNf026058
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=NOT);
        Tue, 23 Oct 2018 09:24:46 +0800
Received: from RTITMBSVM01.realtek.com.tw ([fe80::f4ca:82cf:5a3:5d7a]) by
 RTITCASV01.realtek.com.tw ([::1]) with mapi id 14.03.0415.000; Tue, 23 Oct
 2018 09:24:45 +0800
From:   Pkshih <pkshih@realtek.com>
To:     "yuehaibing@huawei.com" <yuehaibing@huawei.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "colin.king@canonical.com" <colin.king@canonical.com>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        "natechancellor@gmail.com" <natechancellor@gmail.com>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH] rtlwifi: btcoex: remove set but not used variable 'ppsc'
Thread-Topic: [PATCH] rtlwifi: btcoex: remove set but not used variable
 'ppsc'
Thread-Index: AQHUadqMke4Dmp6jrki0QUw091mP3KUrhGMA
Date:   Tue, 23 Oct 2018 01:24:45 +0000
Message-ID: <1540257852.2768.4.camel@realtek.com>
References: <1540194675-65562-1-git-send-email-yuehaibing@huawei.com>
In-Reply-To: <1540194675-65562-1-git-send-email-yuehaibing@huawei.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.146]
Content-Type: text/plain; charset="utf-8"
Content-ID: <712225B4A4089D429066630624D2950F@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

T24gTW9uLCAyMDE4LTEwLTIyIGF0IDA3OjUxICswMDAwLCBZdWVIYWliaW5nIHdyb3RlOg0KPiBG
aXhlcyBnY2MgJy1XdW51c2VkLWJ1dC1zZXQtdmFyaWFibGUnIHdhcm5pbmc6DQo+IA0KPiBkcml2
ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvYnRjb2V4aXN0L2hhbGJ0Y291dHNyYy5j
OiBJbiBmdW5jdGlvbg0KPiAnaGFsYnRjX2xlYXZlX2xwcyc6DQo+IGRyaXZlcnMvbmV0L3dpcmVs
ZXNzL3JlYWx0ZWsvcnRsd2lmaS9idGNvZXhpc3QvaGFsYnRjb3V0c3JjLmM6Mjk1OjIxOiB3YXJu
aW5nOg0KPiDCoHZhcmlhYmxlICdwcHNjJyBzZXQgYnV0IG5vdCB1c2VkIFstV3VudXNlZC1idXQt
c2V0LXZhcmlhYmxlXQ0KPiANCj4gZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZp
L2J0Y29leGlzdC9oYWxidGNvdXRzcmMuYzogSW4gZnVuY3Rpb24NCj4gJ2hhbGJ0Y19lbnRlcl9s
cHMnOg0KPiBkcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvYnRjb2V4aXN0L2hh
bGJ0Y291dHNyYy5jOjMxODoyMTogd2FybmluZzoNCj4gwqB2YXJpYWJsZSAncHBzYycgc2V0IGJ1
dCBub3QgdXNlZCBbLVd1bnVzZWQtYnV0LXNldC12YXJpYWJsZV0NCj4gDQo+IEl0IG5ldmVyIHVz
ZWQgc2luY2UgaW50cm9kdWN0aW9uIGluDQo+IGNvbW1pdCBhYTQ1YTY3M2IyOTEgKCJydGx3aWZp
OiBidGNvZXhpc3Q6IEFkZCBuZXcgbWluaSBkcml2ZXIiKQ0KPiANCj4gU2lnbmVkLW9mZi1ieTog
WXVlSGFpYmluZyA8eXVlaGFpYmluZ0BodWF3ZWkuY29tPg0KDQoNCkFja2VkLWJ5OiBQaW5nLUtl
IFNoaWggPHBrc2hpaEByZWFsdGVrLmNvbT4NCg0KDQo=
