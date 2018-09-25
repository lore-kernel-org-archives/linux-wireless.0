Return-Path: <SRS0=9L0z=MH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0757C43382
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 02:44:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E7F320C0A
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 02:44:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3E7F320C0A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=realtek.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728488AbeIYItQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Sep 2018 04:49:16 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:34268 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727420AbeIYItQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Sep 2018 04:49:16 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID w8P2hpO7001865, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcas12.realtek.com.tw[172.21.6.16])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id w8P2hpO7001865
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Tue, 25 Sep 2018 10:43:51 +0800
Received: from RTITMBSVM01.realtek.com.tw ([fe80::f4ca:82cf:5a3:5d7a]) by
 RTITCAS12.realtek.com.tw ([::1]) with mapi id 14.03.0415.000; Tue, 25 Sep
 2018 10:43:51 +0800
From:   Pkshih <pkshih@realtek.com>
To:     "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "natechancellor@gmail.com" <natechancellor@gmail.com>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] rtlwifi: btcoex: Use proper enumerated types for Wi-Fi only interface
Thread-Topic: [PATCH v2] rtlwifi: btcoex: Use proper enumerated types for
 Wi-Fi only interface
Thread-Index: AQHUUwclU7zduEk3WE+qI5ZbEEJOrKT/xvqA
Date:   Tue, 25 Sep 2018 02:43:50 +0000
Message-ID: <1537843423.3221.0.camel@realtek.com>
References: <20180923063114.11446-1-natechancellor@gmail.com>
In-Reply-To: <20180923063114.11446-1-natechancellor@gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.146]
Content-Type: text/plain; charset="utf-8"
Content-ID: <04EAAA06C57EC6409991CCB011837167@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

T24gU2F0LCAyMDE4LTA5LTIyIGF0IDIzOjMxIC0wNzAwLCBOYXRoYW4gQ2hhbmNlbGxvciB3cm90
ZToNCj4gQ2xhbmcgd2FybnMgd2hlbiBvbmUgZW51bWVyYXRlZCB0eXBlIGlzIGltcGxpY2l0bHkg
Y29udmVydGVkIHRvIGFub3RoZXIuDQo+IA0KPiBkcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVr
L3J0bHdpZmkvYnRjb2V4aXN0L2hhbGJ0Y291dHNyYy5jOjEzMjc6MzQ6DQo+IHdhcm5pbmc6IGlt
cGxpY2l0IGNvbnZlcnNpb24gZnJvbSBlbnVtZXJhdGlvbiB0eXBlICdlbnVtDQo+IGJ0Y19jaGlw
X2ludGVyZmFjZScgdG8gZGlmZmVyZW50IGVudW1lcmF0aW9uIHR5cGUgJ2VudW0NCj4gd2lmaW9u
bHlfY2hpcF9pbnRlcmZhY2UnIFstV2VudW0tY29udmVyc2lvbl0NCj4gwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqB3aWZpb25seV9jZmctPmNoaXBfaW50ZXJmYWNlID0gQlRDX0lOVEZf
UENJOw0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB+IF5+fn5+fn5+fn5+fg0K
PiBkcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvYnRjb2V4aXN0L2hhbGJ0Y291
dHNyYy5jOjEzMzA6MzQ6DQo+IHdhcm5pbmc6IGltcGxpY2l0IGNvbnZlcnNpb24gZnJvbSBlbnVt
ZXJhdGlvbiB0eXBlICdlbnVtDQo+IGJ0Y19jaGlwX2ludGVyZmFjZScgdG8gZGlmZmVyZW50IGVu
dW1lcmF0aW9uIHR5cGUgJ2VudW0NCj4gd2lmaW9ubHlfY2hpcF9pbnRlcmZhY2UnIFstV2VudW0t
Y29udmVyc2lvbl0NCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB3aWZpb25seV9j
ZmctPmNoaXBfaW50ZXJmYWNlID0gQlRDX0lOVEZfVVNCOw0KPiDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqB+IF5+fn5+fn5+fn5+fg0KPiBkcml2ZXJzL25ldC93aXJlbGVzcy9yZWFs
dGVrL3J0bHdpZmkvYnRjb2V4aXN0L2hhbGJ0Y291dHNyYy5jOjEzMzM6MzQ6DQo+IHdhcm5pbmc6
IGltcGxpY2l0IGNvbnZlcnNpb24gZnJvbSBlbnVtZXJhdGlvbiB0eXBlICdlbnVtDQo+IGJ0Y19j
aGlwX2ludGVyZmFjZScgdG8gZGlmZmVyZW50IGVudW1lcmF0aW9uIHR5cGUgJ2VudW0NCj4gd2lm
aW9ubHlfY2hpcF9pbnRlcmZhY2UnIFstV2VudW0tY29udmVyc2lvbl0NCj4gwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqB3aWZpb25seV9jZmctPmNoaXBfaW50ZXJmYWNlID0gQlRDX0lO
VEZfVU5LTk9XTjsNCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgfiBefn5+fn5+
fn5+fn5+fn5+DQo+IDMgd2FybmluZ3MgZ2VuZXJhdGVkLg0KPiANCj4gVXNlIHRoZSB2YWx1ZXMg
ZnJvbSB0aGUgY29ycmVjdCBlbnVtZXJhdGVkIHR5cGUsIHdpZmlvbmx5X2NoaXBfaW50ZXJmYWNl
Lg0KPiANCj4gQlRDX0lOVEZfVU5LTk9XTiA9IFdJRklPTkxZX0lOVEZfVU5LTk9XTiA9IDANCj4g
QlRDX0lOVEZfUENJID0gV0lGSU9OTFlfSU5URl9QQ0kgPSAxDQo+IEJUQ19JTlRGX1VTQiA9IFdJ
RklPTkxZX0lOVEZfVVNCID0gMg0KPiANCj4gTGluazogaHR0cHM6Ly9naXRodWIuY29tL0NsYW5n
QnVpbHRMaW51eC9saW51eC9pc3N1ZXMvMTM1DQo+IFNpZ25lZC1vZmYtYnk6IE5hdGhhbiBDaGFu
Y2VsbG9yIDxuYXRlY2hhbmNlbGxvckBnbWFpbC5jb20+DQoNCkFja2VkLWJ5OiBQaW5nLUtlIFNo
aWggPHBrc2hpaEByZWFsdGVrLmNvbT4NCg0K
