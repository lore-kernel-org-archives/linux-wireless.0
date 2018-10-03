Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92FFDC64EBC
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 03:01:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0831220878
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 03:01:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0831220878
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=realtek.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbeJCJoA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 05:44:00 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:59088 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbeJCJn7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 05:43:59 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID w932vIh8028913, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv02.realtek.com.tw[172.21.6.19])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id w932vIh8028913
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Wed, 3 Oct 2018 10:57:18 +0800
Received: from RTITMBSVM01.realtek.com.tw ([fe80::f4ca:82cf:5a3:5d7a]) by
 RTITCASV02.realtek.com.tw ([::1]) with mapi id 14.03.0415.000; Wed, 3 Oct
 2018 10:57:17 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     Larry Finger <Larry.Finger@lwfinger.net>,
        Stanislaw Gruszka <sgruszka@redhat.com>
CC:     "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>
Subject: RE: [PATCH 01/12] rtwlan: main files
Thread-Topic: [PATCH 01/12] rtwlan: main files
Thread-Index: AQHUVmkc7fXueOv/LUWUMOOpXqM0maUFAMQw///nxICAAImvEIAF0JYAgABSFACAAUSXkA==
Date:   Wed, 3 Oct 2018 02:57:16 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D1728978@RTITMBSVM01.realtek.com.tw>
References: <1537509847-21087-1-git-send-email-yhchuang@realtek.com>
 <1537509847-21087-2-git-send-email-yhchuang@realtek.com>
 <20180927135040.GA4712@redhat.com>
 <F7CD281DE3E379468C6D07993EA72F84D08D9F56@RTITMBSVM01.realtek.com.tw>
 <20180928092918.GC8323@redhat.com>
 <F7CD281DE3E379468C6D07993EA72F84D08DB7E3@RTITMBSVM01.realtek.com.tw>
 <20181002102957.GB25116@redhat.com>
 <a54dec4e-1164-f9c5-c791-3396a239eeba@lwfinger.net>
In-Reply-To: <a54dec4e-1164-f9c5-c791-3396a239eeba@lwfinger.net>
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

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTGFycnkgRmluZ2VyIFtt
YWlsdG86bGFycnkuZmluZ2VyQGdtYWlsLmNvbV0gT24gQmVoYWxmIE9mIExhcnJ5IEZpbmdlcg0K
PiBTZW50OiBUdWVzZGF5LCBPY3RvYmVyIDAyLCAyMDE4IDExOjI0IFBNDQo+IFRvOiBTdGFuaXNs
YXcgR3J1c3prYTsgVG9ueSBDaHVhbmcNCj4gQ2M6IGt2YWxvQGNvZGVhdXJvcmEub3JnOyBsaW51
eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmc7IFBrc2hpaDsgQW5keQ0KPiBIdWFuZw0KPiBTdWJq
ZWN0OiBSZTogW1BBVENIIDAxLzEyXSBydHdsYW46IG1haW4gZmlsZXMNCj4gDQo+IE9uIDEwLzIv
MTggNToyOSBBTSwgU3RhbmlzbGF3IEdydXN6a2Egd3JvdGU6DQo+ID4gT24gRnJpLCBTZXAgMjgs
IDIwMTggYXQgMTE6MzI6NDFBTSArMDAwMCwgVG9ueSBDaHVhbmcgd3JvdGU6DQo+ID4+PiAJaWYg
KHJ0d19oY2lfdHgocnR3ZGV2LCAmcGt0X2luZm8sIHNrYikpDQo+ID4+PiAJCWRldl9rZnJlZV9z
a2JfYW55KHNrYikNCj4gPj4+DQo+ID4+PiBqdXN0IHRvIHJlbW92ZSAncmV0dXJuOycgYW5kIG91
dCBsYWJlbC4NCj4gPj4NCj4gPj4NCj4gPj4gT0ssIGJ1dCB3aHkgbm90IHVzZSBpZWVlODAyMTFf
ZnJlZV90eHNrYiwgc2hvdWxkIGl0IGJlIGJldHRlciBmb3INCj4gbWFjODAyMTE/DQo+ID4NCj4g
PiBZZXMsIGl0IGlzIGJldHRlciBhcyBpdCBhbHNvIGRvIHNvbWUgZXh0cmEgdGhpbmcgZm9yIGRy
b3BwZWQgZnJhbWUuDQo+ID4NCj4gPj4+PiBPSywgYnV0IEkgdGhpbmsgdGhpcyBpcyBuZWVkZWQs
IG91ciB0YWJsZXMgaGF2ZSBkaWZmZXJlbnQgZm9ybXMgLi4uLg0KPiA+Pj4NCj4gPj4+IE5vdCBz
dXJlIGlmIHRoYXQgaXMgYmV0dGVyIHNvbHV0aW9uLCBidXQgY291bGQgdGhlIHRhYmxlcyBiZSBw
cmUtcHJhcnNlZA0KPiA+Pj4gYnkgdXNlci1zcGFjZSBwcm9ncmFtIGFuZCB0aGVuIGVtYmVkIGlu
IHRoZSBkcml2ZXIgaW4gcmVhZHkgdG8gc2VuZA0KPiA+Pj4gdG8gdGhlIGhhcmR3YXJlIGZyb20g
Pw0KPiA+Pj4NCj4gPj4+IEFsc28gdGhlcmUgYXJlIGxvdCBvZiByZWR1bmRhbmN5IGluIHRob3Nl
IHRhYmxlcywgZm9yIGV4YW1wbGU6DQo+ID4+Pg0KPiA+Pj4gKwkweDgxQywgMHhGRjAwMDAwMywN
Cj4gPj4+ICsJMHg4MUMsIDB4RjUwMDAwMDMsDQo+ID4+PiArCTB4ODFDLCAweEY0MDIwMDAzLA0K
PiA+Pj4gKwkweDgxQywgMHhGMzA0MDAwMywNCj4gPj4+ICsJMHg4MUMsIDB4RjIwNjAwMDMsDQo+
ID4+PiArCTB4ODFDLCAweEYxMDgwMDAzLA0KPiA+Pj4gKwkweDgxQywgMHhGMDBBMDAwMywNCj4g
Pj4+ICsJMHg4MUMsIDB4RUYwQzAwMDMsDQo+ID4+PiArCTB4ODFDLCAweEVFMEUwMDAzLA0KPiA+
Pj4gKwkweDgxQywgMHhFRDEwMDAwMywNCj4gPj4+ICsJMHg4MUMsIDB4RUMxMjAwMDMsDQo+ID4+
PiArCTB4ODFDLCAweEVCMTQwMDAzLA0KPiA+Pj4gKwkweDgxQywgMHhFQTE2MDAwMywNCj4gPj4+
ICsJMHg4MUMsIDB4RTkxODAwMDMsDQo+ID4+PiArCTB4ODFDLCAweEU4MUEwMDAzLA0KPiA+Pj4g
KwkweDgxQywgMHhFNzFDMDAwMywNCj4gPj4+ICsJMHg4MUMsIDB4RTYxRTAwMDMsDQo+ID4+PiAr
CTB4ODFDLCAweEU1MjAwMDAzLA0KPiA+Pj4NCj4gPj4+IDB4ODFDIGFuZCAwMDAzIHJlcGVhdHMg
aW4gbWFueSBsaW5lcy4NCj4gPj4+DQo+ID4+PiBUaGlzIHNlZW1zIHRvIGJlIHBhcnNlIGRhdGEs
IG5vdCB0aGF0IHdlIGhhdmUgdG8gd3JpdGUgMHg4MUMNCj4gPj4+IHJlZ2lzdGVyIG1hbnkgdGlt
ZXMuIFdvdWxkIGJlIHBvc3NpYmxlIHRvIHJlbW92ZSB0aGUgcmVkdW5kYW5jeT8NCj4gPj4NCj4g
Pj4NCj4gPj4gTm8sIHRoZXkgY2Fubm90IGJlIHJlbW92ZWQsIHRoZSBzZXF1ZW5jZSBtYXR0ZXJz
Lg0KPiA+PiBBbmQgaXQgaXMgcmVhbGx5IHdyaXRpbmcgdG8gMHg4MUMgLi4uDQo+ID4+IEl0IGlz
IHJlYWxseSBtYWdpYywgSSBjYW5ub3QgYmVsaWV2ZSB0byB0aGlzLCB0b28uDQo+ID4NCj4gPiBU
aGlzIGlzIGNvbnRyYWRpY3Rpb24gZm9yIHdoYXQgSSBhc2tlZCB5b3UgYmVmb3JlLCBpLmUuIGRv
aW5nIHBhcnNpbmcNCj4gPiBpbiB1c2VyIHNwYWNlLCBidXQgc2luY2Ugd2UgaGF2ZSB0aGlzIHBh
cnNpbmcgbWVjaGFuaXNtIGluIHRoZSBkcml2ZXINCj4gPiBwZXJoYXBzIHRoZSB0YWJsZXMgY2Fu
IGJlIGNvZGVkIGluIHNvbWUgbW9yZSBjb21wYWN0IHdheSwgZm9yIGV4YW1wbGU6DQo+ID4NCj4g
PiB7IHByZWZpeCwgc3VmZml4LCBsZW4sIHtkYXRhfSB9DQo+ID4NCj4gPiB7IDB4ODFDLCAweDAw
MDMsIE4gLA0KPiA+ICAgIHsgMHhGRjAyICwgMHhGNTAwICwgLi4uLiAsIDB4RTUyMCB9IH0NCj4g
Pg0KPiA+IFRoZSBydHc4ODIyYl90YWJsZS5jIGZpbGUgaXMgcXVpdGUgYmlnLg0KPiANCj4gWW91
IG1pZ2h0IGFsc28gY29uc2lkZXIgaGF2aW5nIHRoZXNlIHRhYmxlcyBhcyBhIGNvbmZpZ3VyYXRp
b24gZmlsZSByZWFkIGZyb20NCj4gdGhlIGZpcm13YXJlIGRpcmVjdG9yeS4NCj4gDQoNCkhpIExh
cnJ5LA0KDQpDYW4gd2UgcHV0IHRoZSBjb25maWd1cmF0aW9uIGZpbGUgaW4gdGhlIGZpcm13YXJl
IGRpcmVjdG9yeT8NClNob3VsZCB3ZSBwYWNrYWdlIHRoZW0gaW50byBiaW5hcnkgZmlsZXM/IE9y
IGp1c3QgcHV0IHRoZSByYXcgZGF0YS4NCg0KV2UgY2FuIHRlc3QgdGhlIHBlcmZvcm1hbmNlIGZv
ciBpdC4gQWZ0ZXIgd2UgZ290IHRoZSByZXN1bHQsIHdlIHdpbGwgbWFrZSBhIGRlY2lzaW9uDQph
Ym91dCBpdC4gQW5kIGlmIHdlIGRlY2lkZSB0byBwdXQgdGhlbSBpbiB0aGUgZmlybXdhcmUgZGly
ZWN0b3J5LCB3aWxsIHNlbmQgYSBwYXRjaC4NCkZvciBub3csIEkgdGhpbmsgd2UgY2FuIGp1c3Qg
bGVhdmUgdGhlbSBpbiB0aGUgLmMuDQoNCllhbi1Ic3VhbiBDaHVhbmcNCg0K
