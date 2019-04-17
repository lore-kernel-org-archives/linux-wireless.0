Return-Path: <SRS0=eC3p=ST=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ACCCC10F14
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 01:35:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F6CA20821
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 01:35:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729383AbfDQBfK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Apr 2019 21:35:10 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:53095 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728486AbfDQBfJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Apr 2019 21:35:09 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x3H1YuRn000414, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x3H1YuRn000414
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=NOT);
        Wed, 17 Apr 2019 09:34:56 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITCASV01.realtek.com.tw ([::1]) with mapi id 14.03.0415.000; Wed, 17 Apr
 2019 09:34:56 +0800
From:   Pkshih <pkshih@realtek.com>
To:     "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH] rtlwifi: rtl8188ee: Remove extraneous file
Thread-Topic: [PATCH] rtlwifi: rtl8188ee: Remove extraneous file
Thread-Index: AQHU9LWG8OP7qwVl1k+H5cKcYLbBjKY/C+IA
Date:   Wed, 17 Apr 2019 01:34:55 +0000
Message-ID: <1555464872.3420.2.camel@realtek.com>
References: <20190417003547.26271-1-Larry.Finger@lwfinger.net>
In-Reply-To: <20190417003547.26271-1-Larry.Finger@lwfinger.net>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.114]
Content-Type: text/plain; charset="utf-8"
Content-ID: <1D8A0CAD877D2C4FA7825196134DF064@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

T24gVHVlLCAyMDE5LTA0LTE2IGF0IDE5OjM1IC0wNTAwLCBMYXJyeSBGaW5nZXIgd3JvdGU6DQo+
IFNvbWVob3cgZmlsZSBkcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvcnRsODE4
OGVlL3RyeC5jLnJlaiB3YXMNCj4gaW5jb3Jwb3JhdGVkIGludG8gdGhlIHNvdXJjZXMuIE9idmlv
dXNseSwgaXQgY2FuIGJlIHJlbW92ZWQuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBMYXJyeSBGaW5n
ZXIgPExhcnJ5LkZpbmdlckBsd2Zpbmdlci5uZXQ+DQo+IFJlcG9ydGVkLWJ5OiBBbmRyZXcgTW9y
dG9uIDxha3BtQGxpbnV4LWZvdW5kYXRpb24ub3JnPg0KPiBDYzogQW5kcmV3IE1vcnRvbiA8YWtw
bUBsaW51eC1mb3VuZGF0aW9uLm9yZz4NCj4gLS0tDQo+IEFuZHJldywNCj4gDQo+IFRoYW5rcy4N
Cj4gDQo+IExhcnJ5DQo+IC0tLQ0KPiDCoGRyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRs
d2lmaS9ydGw4MTg4ZWUvdHJ4LmMucmVqIHwgMTAgLS0tLS0tLS0tLQ0KPiDCoDEgZmlsZSBjaGFu
Z2VkLCAxMCBkZWxldGlvbnMoLSkNCj4gwqBkZWxldGUgbW9kZSAxMDA2NDQgZHJpdmVycy9uZXQv
d2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL3J0bDgxODhlZS90cnguYy5yZWoNCj4gDQo+IGRpZmYg
LS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvcnRsODE4OGVlL3Ry
eC5jLnJlag0KPiBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS9ydGw4MTg4
ZWUvdHJ4LmMucmVqDQo+IGRlbGV0ZWQgZmlsZSBtb2RlIDEwMDY0NA0KPiBpbmRleCBhYTAzZDQ2
MDVkOGMuLjAwMDAwMDAwMDAwMA0KPiAtLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVr
L3J0bHdpZmkvcnRsODE4OGVlL3RyeC5jLnJlag0KPiArKysgL2Rldi9udWxsDQo+IEBAIC0xLDEw
ICswLDAgQEANCj4gLS0tLSBkcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvcnRs
ODE4OGVlL3RyeC5jDQo+IC0rKysgZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZp
L3J0bDgxODhlZS90cnguYw0KPiAtQEAgLTM3Myw2ICszNzMsNyBAQCBib29sIHJ0bDg4ZWVfcnhf
cXVlcnlfZGVzYyhzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywNCj4gLcKgCXN0cnVjdCByeF9md2lu
Zm9fODhlICpwX2RydmluZm87DQo+IC3CoAlzdHJ1Y3QgaWVlZTgwMjExX2hkciAqaGRyOw0KPiAt
wqAJdTMyIHBoeXN0YXR1cyA9IEdFVF9SWF9ERVNDX1BIWVNUKHBkZXNjKTsNCj4gLSsJdTggd2Fr
ZV9tYXRjaDsNCj4gLcKgDQo+IC3CoAlzdGF0dXMtPnBhY2tldF9yZXBvcnRfdHlwZSA9ICh1OClH
RVRfUlhfU1RBVFVTX0RFU0NfUlBUX1NFTChwZGVzYyk7DQo+IC3CoAlpZiAoc3RhdHVzLT5wYWNr
ZXRfcmVwb3J0X3R5cGUgPT0gVFhfUkVQT1JUMikNCg0KVGhlIGNoYW5nZSBvZiB0cnguYyBzZWVt
cyBub3QgYmVsb25nIHRvIHRoaXMgcGF0Y2gsIHJpZ2h0P8KgDQoNCg0K
