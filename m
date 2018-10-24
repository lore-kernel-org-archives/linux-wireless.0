Return-Path: <SRS0=AjP+=NE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8D86C46475
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 03:05:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F3752082F
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 03:05:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5F3752082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=realtek.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727133AbeJXLbg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Oct 2018 07:31:36 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:34879 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725826AbeJXLbg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Oct 2018 07:31:36 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID w9O0qjYL001141, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcas12.realtek.com.tw[172.21.6.16])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id w9O0qjYL001141
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Wed, 24 Oct 2018 08:52:45 +0800
Received: from RTITEXH01.realtek.com.tw (172.21.6.62) by
 RTITCAS12.realtek.com.tw (172.21.6.16) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Wed, 24 Oct 2018 08:52:45 +0800
Received: from RTITMBSVM01.realtek.com.tw ([fe80::f4ca:82cf:5a3:5d7a]) by
 RTITEXH01.realtek.com.tw ([::1]) with mapi id 14.03.0415.000; Wed, 24 Oct
 2018 08:52:44 +0800
From:   Pkshih <pkshih@realtek.com>
To:     "joe@perches.com" <joe@perches.com>,
        "zhongjiang@huawei.com" <zhongjiang@huawei.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] rtlwifi: remove set but not used variable 'radiob_array_table' and 'radiob_arraylen'
Thread-Topic: [PATCH v2] rtlwifi: remove set but not used variable
 'radiob_array_table' and 'radiob_arraylen'
Thread-Index: AQHUaqwWhqcVPdyTf0GD+7a2PdeLy6UssxGAgABZEoA=
Date:   Wed, 24 Oct 2018 00:52:44 +0000
Message-ID: <1540342331.2495.1.camel@realtek.com>
References: <1540283282-9772-1-git-send-email-zhongjiang@huawei.com>
         <19b16ca89b5cde607338513638d4ef8e3a3d2802.camel@perches.com>
In-Reply-To: <19b16ca89b5cde607338513638d4ef8e3a3d2802.camel@perches.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.146]
Content-Type: text/plain; charset="utf-8"
Content-ID: <3CD09867DC58C748B98D5D626FECFF87@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

T24gVHVlLCAyMDE4LTEwLTIzIGF0IDEyOjMzIC0wNzAwLCBKb2UgUGVyY2hlcyB3cm90ZToNCj4g
T24gVHVlLCAyMDE4LTEwLTIzIGF0IDE2OjI4ICswODAwLCB6aG9uZyBqaWFuZyB3cm90ZToNCj4g
PiByYWRpb2JfYXJyYXlfdGFibGUnIGFuZCAncmFkaW9iX2FycmF5bGVuJyBhcmUgbm90IHVzZWQg
YWZ0ZXIgc2V0dGluZyBpdHMNCj4gdmFsdWUuDQo+ID4gSXQgaXMgc2FmZSB0byByZW1vdmUgdGhl
IHVudXNlZCB2YXJpYWJsZS4gTWVhbndoaWxlLCByYWRpbyBCIHJhZGlvIHNob3VsZCBiZQ0KPiA+
IHJlbW92ZWQgYXMgd2VsbC4gYmVjYXVzZSBpdCB3aWxsIG5vIGxvbmdlciBiZSByZWZlcmVuY2Vk
Lg0KPiANCj4gVGhlIHBhdGNoIHN1YmplY3QgaXMgYSBiaXQgb2ZmIGFuZCB0b28gZ2VuZXJpYyBo
ZXJlLg0KPiANCj4gVGhpcyBpcyBzcGVjaWZpYyB0byBydGw4NzIzYWUgYW5kIG5vdCBydGx3aWZp
IHNvIGl0IGlzDQo+IHByb2JhYmx5IGJldHRlciBmb3IgdGhlIHN1YmplY3QgdG8gYmUgc29tZXRo
aW5nIGxpa2U6DQo+IA0KPiBbUEFUQ0hdIHJ0bDg3MjNhZTogUmVtb3ZlIHNldCBidXQgbm90IHVz
ZWQgdmFyaWFibGVzIGFuZCAjZGVmaW5lcw0KDQpJJ2QgbGlrZSAncnRsd2lmaTrCoHJ0bDg3MjNh
ZTogJyBhcyBzdWJqZWN0IHByZWZpeC4NCg0KPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiB6aG9uZyBq
aWFuZyA8emhvbmdqaWFuZ0BodWF3ZWkuY29tPg0KPiA+IC0tLQ0KPiA+wqDCoGRyaXZlcnMvbmV0
L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS9ydGw4NzIzYWUvcGh5LmPCoMKgwqB8IDUgKy0tLS0N
Cj4gPsKgwqBkcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvcnRsODcyM2FlL3Rh
YmxlLmMgfCA0IC0tLS0NCj4gPsKgwqBkcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdp
ZmkvcnRsODcyM2FlL3RhYmxlLmggfCAyIC0tDQo+IA0KPiANCj4gLS0tLS0tUGxlYXNlIGNvbnNp
ZGVyIHRoZSBlbnZpcm9ubWVudCBiZWZvcmUgcHJpbnRpbmcgdGhpcyBlLW1haWwuDQo=
