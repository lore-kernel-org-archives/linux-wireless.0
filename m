Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97692C169C4
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 11:37:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C643218AF
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 11:37:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732255AbfAaLhF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 06:37:05 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:51453 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726221AbfAaLhF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 06:37:05 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x0VBabs0011006, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv02.realtek.com.tw[172.21.6.19])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x0VBabs0011006
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Thu, 31 Jan 2019 19:36:37 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITCASV02.realtek.com.tw ([::1]) with mapi id 14.03.0415.000; Thu, 31 Jan
 2019 19:36:36 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     Brian Norris <briannorris@chromium.org>
CC:     "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "sgruszka@redhat.com" <sgruszka@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH v4 09/13] rtw88: chip files
Thread-Topic: [PATCH v4 09/13] rtw88: chip files
Thread-Index: AQHUuFC3BPdiKallRUKZ7P1Hq+CH5aXHsc6AgAGOL6A=
Date:   Thu, 31 Jan 2019 11:36:35 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D179ABC2@RTITMBSVM04.realtek.com.tw>
References: <1548820940-15237-1-git-send-email-yhchuang@realtek.com>
 <1548820940-15237-10-git-send-email-yhchuang@realtek.com>
 <20190130194453.GA156750@google.com>
In-Reply-To: <20190130194453.GA156750@google.com>
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

PiBGcm9tOiBCcmlhbiBOb3JyaXMgW21haWx0bzpicmlhbm5vcnJpc0BjaHJvbWl1bS5vcmddDQo+
IA0KPiA+ICtzdGF0aWMgaW5saW5lIHZvaWQNCj4gPiArcnR3X3dyaXRlMzJzX21hc2soc3RydWN0
IHJ0d19kZXYgKnJ0d2RldiwgdTMyIGFkZHIsIHUzMiBtYXNrLCB1MzIgZGF0YSkNCj4gPiArew0K
PiA+ICsJQlVJTERfQlVHX09OKGFkZHIgPCAweEMwMCB8fCBhZGRyID49IDB4RDAwKTsNCj4gDQo+
IFRoaXMgc2VlbXMgdG8gYmUgYSBub24tdHJhZGl0aW9uYWwgdXNlIG9mIEJVSUxEX0JVR19PTigp
LiBOb3JtYWxseSwgSQ0KPiBzZWUgdGhpcyB1c2VkIGZvciBzdHVmZiB0aGF0J3MgZ3VhcmFudGVl
ZCB0byBiZSBrbm93biBhdCBjb21waWxlIHRpbWUgLS0NCj4gc3RydWN0dXJlIG9mZnNldHMsIGNv
bnN0YW50cywgZXRjLiBUaGlzIGlzIHVzdWFsbHkgKGFsd2F5cz8pIGEgY29uc3RhbnQsDQo+IGJ1
dCBpdCBwYXNzZXMgdGhyb3VnaCBhIGZ1bmN0aW9uIHBhcmFtZXRlciwgc28gSSdtIG5vdCBzdXJl
IGlmIHRoYXQncw0KPiByZWFsbHkgZ3VhcmFudGVlZC4NCj4gDQo+IEFueXdheS4uLnRoaXMgaXMg
ZmFpbGluZyBjb25mdXNpbmdseSBmb3IgbWUgd2hlbiBJIHRyeSB0byBidWlsZDoNCj4gDQo+IGRy
aXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgvcnR3ODgyMmIuYzogSW4gZnVuY3Rpb24N
Cj4g4oCYcnR3X3dyaXRlMzJzX21hc2vigJk6DQo+IGRyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0
ZWsvcnR3ODgvcnR3ODgyMmIuYzoyMzA6MTc2OiBlcnJvcjogY2FsbCB0bw0KPiDigJhfX2NvbXBp
bGV0aW1lX2Fzc2VydF8yMzDigJkgZGVjbGFyZWQgd2l0aCBhdHRyaWJ1dGUgZXJyb3I6IEJVSUxE
X0JVR19PTg0KPiBmYWlsZWQ6IGFkZHIgPCAweEMwMCB8fCBhZGRyID49IDB4RDAwDQo+ICAgQlVJ
TERfQlVHX09OKGFkZHIgPCAweEMwMCB8fCBhZGRyID49IDB4RDAwKTsNCj4gDQo+IF4NCj4gDQo+
IEkgdHJpZWQgdG8gcGlucG9pbnQgd2hpY2ggY2FsbCB5aWVsZGVkIHRoaXMsIGFuZCBJIHRoaW5r
IG9uY2UgSSBkZWxldGVkDQo+IGVub3VnaCBjYWxscyB0byBydHdfd3JpdGUzMnNfbWFzaygpIGl0
IGNhbWUgZG93biB0byB0aGlzIG9uZToNCj4gDQo+ICAgICAgICAgcnR3X3dyaXRlMzJzX21hc2so
cnR3ZGV2LCBSRUdfUkZFSU5WLCBCSVQoMTEpIHwgQklUKDEwKSB8IDB4M2YsDQo+IDB4MCk7DQo+
IA0KPiB3aGljaCBkb2Vzbid0IHJlYWxseSBtYWtlIHNlbnNlLCBhcyB0aGF0J3MgYSB2YWx1ZSBv
ZiAweGNiYy4NCj4gDQo+IFdoYXQgSSByZWFsbHkgdGhpbmsgaXQgY29tZXMgZG93biB0byBpcyB0
aGF0IHlvdSBjYW4ndCBndWFyYW50ZWUNCj4gcnR3X3dyaXRlMzJzX21hc2soKSB3aWxsIGdldCBp
bmxpbmVkLCBhbmQgc28gQlVJTERfQlVHX09OKCkgbWF5IG5vdCBrbm93DQo+IHdoYXQgdG8gZG8g
d2l0aCBpdC4NCg0KWWVhaCwgeW91J3JlIHJpZ2h0LiBJIHRoaW5rIHdlIHNob3VsZCB0dXJuIGl0
IGludG8gbWFjcm8uDQpJIHdpbGwgc2VuZCB0aGUgZml4IHBhdGNoIGluIHRoZSBuZXh0IHBhdGNo
IHNldC4NClRoYW5rcyENCg0KPiANCj4gSSB0aGluayB5b3Ugc2hvdWxkIGVpdGhlciBkcm9wIHRo
ZSBCVUlMRF9CVUdfT04oKSwgb3IgZWxzZSB0dXJuDQo+IHJ0d193cml0ZTMyc19tYXNrKCkgaW50
byBhIG1hY3JvLg0KPiANCj4gQlRXLCBJJ20gdXNpbmcgYSB2YXJpYW50IG9mIGdjYyB2ZXJzaW9u
IDQuOS4yLiBJIG5vcm1hbGx5IHVzZSBjbGFuZyBmb3INCj4ga2VybmVsIGJ1aWxkcyAoYXMgdGhh
dCdzIHRoZSBjdXJyZW50IENocm9taXVtIE9TIHRvb2xjaGFpbiksIGJ1dCBjbGFuZw0KPiBzdGls
bCByZWd1bGFybHkgaGFzIGJyZWFrYWdlIHVwc3RyZWFtLCBzbyBJJ20gc3RpbGwgYnVpbGRpbmcg
d2l0aCBhbiBvbGQNCj4gR0NDIHRvb2xjaGFpbi4gSXQncyB0ZWNobmljYWxseSBzdGlsbCBzdXBw
b3J0ZWQgaW4NCj4gRG9jdW1lbnRhdGlvbi9wcm9jZXNzL2NoYW5nZXMucnN0IHRob3VnaCENCg0K
TGlrZSB5b3Ugc2FpZCwgc2hvdWxkIHN1cHBvcnQgaXQgYW55d2F5IDopDQoNCj4gDQo+IEJyaWFu
DQo+IA0KDQpZYW4tSHN1YW4NCg==
