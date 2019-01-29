Return-Path: <SRS0=Fojl=QF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DF09C282CD
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 02:27:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B1BB21738
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 02:27:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbfA2C1p (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 21:27:45 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:41826 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727009AbfA2C1p (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 21:27:45 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x0T2RIDo027446, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x0T2RIDo027446
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=NOT);
        Tue, 29 Jan 2019 10:27:18 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITCASV01.realtek.com.tw ([::1]) with mapi id 14.03.0415.000; Tue, 29 Jan
 2019 10:27:17 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     Brian Norris <briannorris@chromium.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>
CC:     Kalle Valo <kvalo@codeaurora.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH v3 00/13] rtw88: mac80211 driver for Realtek 802.11ac wireless network chips
Thread-Topic: [PATCH v3 00/13] rtw88: mac80211 driver for Realtek 802.11ac
 wireless network chips
Thread-Index: AQHUtsz0oGWsIdSZ5km8koIDZ4UJzKXEW5SlgAAMGcD//4h9AIAA0IYAgADC+dA=
Date:   Tue, 29 Jan 2019 02:27:16 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D1794B00@RTITMBSVM04.realtek.com.tw>
References: <1548654407-28469-1-git-send-email-yhchuang@realtek.com>
 <87tvht18mn.fsf@codeaurora.org>
 <F7CD281DE3E379468C6D07993EA72F84D1793BB2@RTITMBSVM04.realtek.com.tw>
 <20190128101214.GC4132@redhat.com>
 <CA+ASDXNW9v_abS+nX2+H2XymwOL9aVNwdPn-QhfZo71aeQahWQ@mail.gmail.com>
In-Reply-To: <CA+ASDXNW9v_abS+nX2+H2XymwOL9aVNwdPn-QhfZo71aeQahWQ@mail.gmail.com>
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

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQnJpYW4gTm9ycmlzIFtt
YWlsdG86YnJpYW5ub3JyaXNAY2hyb21pdW0ub3JnXQ0KPiBTZW50OiBUdWVzZGF5LCBKYW51YXJ5
IDI5LCAyMDE5IDY6MzkgQU0NCj4gVG86IFN0YW5pc2xhdyBHcnVzemthDQo+IENjOiBUb255IENo
dWFuZzsgS2FsbGUgVmFsbzsgam9oYW5uZXNAc2lwc29sdXRpb25zLm5ldDsNCj4gTGFycnkuRmlu
Z2VyQGx3ZmluZ2VyLm5ldDsgUGtzaGloOyBBbmR5IEh1YW5nOyBsaW51eC13aXJlbGVzc0B2Z2Vy
Lmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2MyAwMC8xM10gcnR3ODg6IG1hYzgw
MjExIGRyaXZlciBmb3IgUmVhbHRlayA4MDIuMTFhYw0KPiB3aXJlbGVzcyBuZXR3b3JrIGNoaXBz
DQo+IA0KPiBPbiBNb24sIEphbiAyOCwgMjAxOSBhdCAyOjE2IEFNIFN0YW5pc2xhdyBHcnVzemth
IDxzZ3J1c3prYUByZWRoYXQuY29tPg0KPiB3cm90ZToNCj4gPiBPbiBNb24sIEphbiAyOCwgMjAx
OSBhdCAwOToyNTozMkFNICswMDAwLCBUb255IENodWFuZyB3cm90ZToNCj4gPiA+IFNvcnJ5IGZv
ciB0aGUgdHlwbyBoZXJlLiBZZXMsIEkgbWVhbiAiIHdpcmVsZXNzLWRyaXZlcnMtbmV4dCAiLg0K
PiA+ID4gSW4gTUFJTlRBSU5FUlMgZmlsZSwgSSBkbyBjaGFuZ2UgdG8gIndpcmVsZXNzLWRyaXZl
cnMtbmV4dCIgaW5zdGVhZCBvZg0KPiAid2lyZWxlc3MtbmV4dCIuDQo+ID4NCj4gPiBUaGUgZ2l0
IGVudHJ5IGluIE1BSU5UQUlORVIgZmlsZSBpcyBub3QgbmVjZXNzYXJ5IGFuZCBzaG91bGQgcG9p
bnQNCj4gPiB0aGUgZHJpdmVyIHNwZWNpZmljIHRyZWUsIHdoaWNoIHJ0dzg4IGRvIG5vdCBoYXZl
LiBKdXN0IHJlbW92ZSB0aGlzDQo+ID4gZW50cnkuDQo+IA0KPiBZZXMsIGl0IHNlZW1zIFRvbnkg
bWlzLWludGVycHJldGVkIG15IHN1Z2dlc3Rpb24gd2hlbiBJIHNhaWQgaGUgd2FzDQo+IHVzaW5n
IHRoZSB3cm9uZyB0cmVlLiBJIGFncmVlIHRoaXMgZHJpdmVyIGRvZXMgbm90IG5lZWQgYSBnaXQg
ZW50cnkgYXQNCj4gYWxsLg0KDQpTb3JyeSBmb3IgdGhhdCwgbm93IHJ0dzg4IGluZGVlZCBkb2Vz
IG5vdCBoYXZlIGFuIG93biB0cmVlIG90aGVyIHRoYW4gd2lyZWxlc3MtZHJpdmVycy4NCkFuZCBL
YWxsZSBjYW4ganVzdCByZW1vdmUgaXQuDQoNCj4gDQo+IFJlZ2FyZHMsDQo+IEJyaWFuDQo+IA0K
PiBQLlMuIEkgZG8gcGxhbiB0byBnaXZlIHRoaXMgZHJpdmVyIGEgc3BpbiB0aGlzIHdlZWsgYW5k
IGhvcGVmdWxseSBnaXZlDQo+IGl0IGEgbGl0dGxlIGNsb3NlciByZXZpZXcuIE5vIGd1YXJhbnRl
ZXMgSSBhY3R1YWxseSBnZXQgdGhlIHRpbWUgZm9yDQo+IHRoYXQsIGJ1dCBJIGhvcGUgdG8uLi4N
Cg0KDQpUaGFua3MgZm9yIHlvdXIgcmV2aWV3Lg0KSnVzdCBwb2ludCBpdCBvdXQgaWYgSSBoYXZl
IGRvbmUgYW55dGhpbmcgd3Jvbmcgb3IgaW5hcHByb3ByaWF0ZS4NCg0KDQpZYW4tSHN1YW4NCg==
