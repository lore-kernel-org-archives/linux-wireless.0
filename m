Return-Path: <SRS0=OIIa=QG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 513A0C169C4
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 01:32:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2912921473
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 01:32:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728176AbfA3BcG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Jan 2019 20:32:06 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:54917 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727525AbfA3BcG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Jan 2019 20:32:06 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x0U1Vt8P013750, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv02.realtek.com.tw[172.21.6.19])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x0U1Vt8P013750
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Wed, 30 Jan 2019 09:31:55 +0800
Received: from RTITEXH01.realtek.com.tw (172.21.6.62) by
 RTITCASV02.realtek.com.tw (172.21.6.19) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Wed, 30 Jan 2019 09:31:54 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITEXH01.realtek.com.tw ([::1]) with mapi id 14.03.0435.000; Wed, 30 Jan
 2019 09:31:54 +0800
From:   Pkshih <pkshih@realtek.com>
To:     "yuehaibing@huawei.com" <yuehaibing@huawei.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] rtlwifi: remove set but not used variable 'cmd_seq'
Thread-Topic: [PATCH] rtlwifi: remove set but not used variable 'cmd_seq'
Thread-Index: AQHUt5eXWQIp2qb2YUKxhJh09PMIRaXFO2QAgAFGbYA=
Date:   Wed, 30 Jan 2019 01:31:54 +0000
Message-ID: <1548811903.17195.1.camel@realtek.com>
References: <1536667978-10556-1-git-send-email-yuehaibing@huawei.com>
         <581817ea-a414-e6ed-3615-5e44837a5221@huawei.com>
         <e37bae9c-c920-56cf-7813-0004c017f02a@huawei.com>
In-Reply-To: <e37bae9c-c920-56cf-7813-0004c017f02a@huawei.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.154]
Content-Type: text/plain; charset="utf-8"
Content-ID: <6046A2165B48E047B8A7CE9273370F3D@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

T24gVHVlLCAyMDE5LTAxLTI5IGF0IDE0OjAzICswODAwLCBZdWVIYWliaW5nIHdyb3RlOg0KPiAr
Y2MgbmV0ZGV2QHZnZXIua2VybmVsLm9yZw0KPiANCj4gT24gMjAxOS8xLzI5IDEzOjU3LCBZdWVI
YWliaW5nIHdyb3RlOg0KPiA+IHBpbmcuLi4NCj4gPsKgDQo+ID4gT24gMjAxOC85LzExIDIwOjEy
LCBZdWVIYWliaW5nIHdyb3RlOg0KPiA+PiBGaXhlcyBnY2MgJy1XdW51c2VkLWJ1dC1zZXQtdmFy
aWFibGUnIHdhcm5pbmc6DQo+ID4+DQo+ID4+IGRyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsv
cnRsd2lmaS9iYXNlLmM6IEluIGZ1bmN0aW9uDQo+ICdydGxfYzJoX2NvbnRlbnRfcGFyc2luZyc6
DQo+ID4+IGRyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS9iYXNlLmM6MjMxMzox
Mzogd2FybmluZzoNCj4gPj7CoMKgdmFyaWFibGUgJ2NtZF9zZXEnIHNldCBidXQgbm90IHVzZWQg
Wy1XdW51c2VkLWJ1dC1zZXQtdmFyaWFibGVdDQo+ID4+DQo+ID4+IFNpZ25lZC1vZmYtYnk6IFl1
ZUhhaWJpbmcgPHl1ZWhhaWJpbmdAaHVhd2VpLmNvbT4NCg0KVGhhbmtzIGZvciB5b3VyIGZpeC4N
Cg0KQWNrZWQtYnk6IFBpbmctS2UgU2hpaCA8cGtzaGloQHJlYWx0ZWsuY29tPg0KDQoNCj4gPj4g
LS0tDQo+ID4+wqDCoGRyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS9iYXNlLmMg
fCAzICstLQ0KPiA+PsKgwqAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDIgZGVsZXRp
b25zKC0pDQo+ID4+DQo+ID4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFs
dGVrL3J0bHdpZmkvYmFzZS5jDQo+IGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3
aWZpL2Jhc2UuYw0KPiA+PiBpbmRleCBmNDEyMmM4Li45MmI2OTE4IDEwMDY0NA0KPiA+PiAtLS0g
YS9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvYmFzZS5jDQo+ID4+ICsrKyBi
L2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS9iYXNlLmMNCj4gPj4gQEAgLTIz
MTAsMTEgKzIzMTAsMTAgQEAgc3RhdGljIHZvaWQgcnRsX2MyaF9jb250ZW50X3BhcnNpbmcoc3Ry
dWN0DQo+IGllZWU4MDIxMV9odyAqaHcsDQo+ID4+wqDCoAlzdHJ1Y3QgcnRsX3ByaXYgKnJ0bHBy
aXYgPSBydGxfcHJpdihodyk7DQo+ID4+wqDCoAlzdHJ1Y3QgcnRsX2hhbF9vcHMgKmhhbF9vcHMg
PSBydGxwcml2LT5jZmctPm9wczsNCj4gPj7CoMKgCWNvbnN0IHN0cnVjdCBydGxfYnRjX29wcyAq
YnRjX29wcyA9IHJ0bHByaXYtPmJ0Y29leGlzdC5idGNfb3BzOw0KPiA+PiAtCXU4IGNtZF9pZCwg
Y21kX3NlcSwgY21kX2xlbjsNCj4gPj4gKwl1OCBjbWRfaWQsIGNtZF9sZW47DQo+ID4+wqDCoAl1
OCAqY21kX2J1ZiA9IE5VTEw7DQo+ID4+wqDCoA0KPiA+PsKgwqAJY21kX2lkID0gR0VUX0MySF9D
TURfSUQoc2tiLT5kYXRhKTsNCj4gPj4gLQljbWRfc2VxID0gR0VUX0MySF9TRVEoc2tiLT5kYXRh
KTsNCj4gPj7CoMKgCWNtZF9sZW4gPSBza2ItPmxlbiAtIEMySF9EQVRBX09GRlNFVDsNCj4gPj7C
oMKgCWNtZF9idWYgPSBHRVRfQzJIX0RBVEFfUFRSKHNrYi0+ZGF0YSk7DQo+ID4+DQo+ID4+DQo+
ID4+IC4NCj4gDQoNCg0KDQo=
