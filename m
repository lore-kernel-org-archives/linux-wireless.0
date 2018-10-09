Return-Path: <SRS0=ggvw=MV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65CB7C64EB0
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 05:11:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A3E4213A2
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 05:11:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1A3E4213A2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=realtek.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbeJIMZz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Oct 2018 08:25:55 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:34120 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725803AbeJIMZz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Oct 2018 08:25:55 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID w995AQuC019922, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcas11.realtek.com.tw[172.21.6.12])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id w995AQuC019922
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Tue, 9 Oct 2018 13:10:26 +0800
Received: from RTITMBSVM01.realtek.com.tw ([fe80::f4ca:82cf:5a3:5d7a]) by
 RTITCAS11.realtek.com.tw ([fe80::7c6d:ced5:c4ff:8297%15]) with mapi id
 14.03.0399.000; Tue, 9 Oct 2018 13:10:25 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>
CC:     "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "sgruszka@redhat.com" <sgruszka@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [RFC v3 12/12] rtw88: Kconfig & Makefile
Thread-Topic: [RFC v3 12/12] rtw88: Kconfig & Makefile
Thread-Index: AQHUXxXPL4YuHfsoc0OpBXWs7mZrrqUWNs2g
Date:   Tue, 9 Oct 2018 05:10:24 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D172C8B3@RTITMBSVM01.realtek.com.tw>
References: <1538565659-29530-1-git-send-email-yhchuang@realtek.com>
         <1538565659-29530-13-git-send-email-yhchuang@realtek.com>
         (sfid-20181003_132143_363210_BDF3D2A2)
 <201810081447.w98ElIFH018051@rtits1.realtek.com.tw>
In-Reply-To: <201810081447.w98ElIFH018051@rtits1.realtek.com.tw>
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

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSm9oYW5uZXMgQmVyZyBb
bWFpbHRvOmpvaGFubmVzQHNpcHNvbHV0aW9ucy5uZXRdDQo+IFNlbnQ6IE1vbmRheSwgT2N0b2Jl
ciAwOCwgMjAxOCAxMDowMCBQTQ0KPiBUbzogVG9ueSBDaHVhbmc7IGt2YWxvQGNvZGVhdXJvcmEu
b3JnDQo+IENjOiBMYXJyeS5GaW5nZXJAbHdmaW5nZXIubmV0OyBQa3NoaWg7IEFuZHkgSHVhbmc7
IHNncnVzemthQHJlZGhhdC5jb207DQo+IGxpbnV4LXdpcmVsZXNzQHZnZXIua2VybmVsLm9yZw0K
PiBTdWJqZWN0OiBSZTogW1JGQyB2MyAxMi8xMl0gcnR3ODg6IEtjb25maWcgJiBNYWtlZmlsZQ0K
PiANCj4gT24gV2VkLCAyMDE4LTEwLTAzIGF0IDE5OjIwICswODAwLCB5aGNodWFuZ0ByZWFsdGVr
LmNvbSB3cm90ZToNCj4gPg0KPiA+ICtjb25maWcgUlRXODhfQ09SRQ0KPiA+ICsJdHJpc3RhdGUN
Cj4gPiArCWRlcGVuZHMgb24gUlRXODgNCj4gPiArDQo+ID4gK2NvbmZpZyBSVFc4OF9QQ0kNCj4g
PiArCXRyaXN0YXRlDQo+ID4gKwlkZXBlbmRzIG9uIFJUVzg4X0NPUkUgJiYgUENJDQo+IA0KPiBU
aG9zZSAiZGVwZW5kcyBvbiIgbGluZXMgYXJlIG1pc2xlYWRpbmcsIEkgZG9uJ3QgdGhpbmsgc2Vs
ZWN0IGhvbm91cnMNCj4gdGhhdD8NCg0KU2VsZWN0IGRvZXNuJ3QgaG9ub3VyIHRoZW0sIHNvIHRo
ZSBkZXBlbmRzIG9uIGxpbmVzIHNlZW1zIHRvIGJlIHVubmVjZXNzYXJ5Lg0KU2hvdWxkIGp1c3Qg
c2VsZWN0IHRoZW0gYWZ0ZXIgdGhlIGRlcGVuZHMgb24gbGluZS4NCkFuZCBSVFc4OCBpcyBkZWZp
bml0ZWx5IHNlbGVjdGVkIHRvIGVudGVyIHRoZSBtZW51LCBzbyBJIHRoaW5rIHdlIGNhbiBqdXN0
DQpyZW1vdmUgdGhlIGRlcGVuZHMgb24gbGluZXMgYnV0IGxlZnQgdGhlIG9uZXMgdW5kZXIgUlRX
ODhfODgyMkJFIGFuZA0KUlRXODhfODgyMkNFDQoNCj4gDQo+ID4gKysrIGIvZHJpdmVycy9uZXQv
d2lyZWxlc3MvcmVhbHRlay9ydHc4OC9NYWtlZmlsZQ0KPiA+IEBAIC0wLDAgKzEsMTkgQEANCj4g
PiArb2JqLSQoQ09ORklHX1JUVzg4X0NPUkUpCSs9IHJ0dzg4Lm8NCj4gPiArcnR3ODgteSArPSBt
YWluLm8gXA0KPiA+ICsJICAgbWFjODAyMTEubyBcDQo+ID4gKwkgICBkZWJ1Zy5vIFwNCj4gPiAr
CSAgIHR4Lm8gXA0KPiA+ICsJICAgcngubyBcDQo+ID4gKwkgICBtYWMubyBcDQo+ID4gKwkgICBw
aHkubyBcDQo+ID4gKwkgICBlZnVzZS5vIFwNCj4gPiArCSAgIGZ3Lm8gXA0KPiA+ICsJICAgcHMu
byBcDQo+ID4gKwkgICBzZWMubyBcDQo+ID4gKwkgICByZWdkLm8NCj4gPiArDQo+ID4gK3J0dzg4
LSQoQ09ORklHX1JUVzg4Xzg4MjJCRSkJKz0gcnR3ODgyMmIubyBydHc4ODIyYl90YWJsZS5vDQo+
ID4gK3J0dzg4LSQoQ09ORklHX1JUVzg4Xzg4MjJDRSkJKz0gcnR3ODgyMmMubyBydHc4ODIyY190
YWJsZS5vDQo+ID4gKw0KPiA+ICtvYmotJChDT05GSUdfUlRXODhfUENJKQkJKz0gcnR3cGNpLm8N
Cj4gPiArcnR3cGNpLW9ianMJCQk6PSBwY2kubw0KPiANCj4gVGhpcyBpcyBhIHdlaXJkIHNwbGl0
PyBXaHkgZXZlbiBib3RoZXIgd2l0aCB0d28gbW9kdWxlcyBpZiBldmVyeXRoaW5nDQo+IGdvZXMg
aW50byB0aGUgbWFpbiAicnR3ODgiIG1vZHVsZSBleGNlcHQgZm9yIGEgc2luZ2xlIGZpbGU/DQo+
IA0KDQoNCkl0J3MgYmVjYXVzZSB0aGVyZSB3aWxsIGhhdmUgMiBtb3JlIGJ1cyB1c2IgJiBzZGlv
Lg0KQW5kIHdlIGRvIG9ubHkgcGNpIGZvciA4ODIyYmUsIHVzYiBmb3IgODgyMmJ1LCBzZGlvIGZv
ciA4ODIyYnMNClNvIHRoZSBtb2R1bGUgaXMgc2VwYXJhdGVkIHRvIGluc2VydCBvcHRpb25hbGx5
DQoNCllhbi1Ic3VhbiBDaHVhbmcNCg==
