Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:37713 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933204AbeGIArp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 8 Jul 2018 20:47:45 -0400
From: Pkshih <pkshih@realtek.com>
To: "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jian-hong@endlessm.com" <jian-hong@endlessm.com>
Subject: Re: [PATCH] staging: r8822be: Fix RTL8822be can't find any wireless AP
Date: Mon, 9 Jul 2018 00:47:33 +0000
Message-ID: <1531097242.2699.1.camel@realtek.com> (sfid-20180709_024806_368672_64CCEE7B)
References: <20180706054435.3732-1-pkshih@realtek.com>
         <63971c24-d99d-459e-fb9a-df583c5a89d6@lwfinger.net>
In-Reply-To: <63971c24-d99d-459e-fb9a-df583c5a89d6@lwfinger.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gU3VuLCAyMDE4LTA3LTA4IGF0IDExOjMwIC0wNTAwLCBMYXJyeSBGaW5nZXIgd3JvdGU6DQo+
IE9uIDA3LzA2LzIwMTggMTI6NDQgQU0sIHBrc2hpaEByZWFsdGVrLmNvbSB3cm90ZToNCj4gPiBG
cm9tOiBQaW5nLUtlIFNoaWggPHBrc2hpaEByZWFsdGVrLmNvbT4NCj4gPsKgDQo+ID4gUlRMODgy
MmJlIGNhbid0IGJyaW5nIHVwIHByb3Blcmx5IG9uIEFTVVMgWDUzMFVOLCBhbmQgZG1lc2cgc2F5
czoNCj4gPiBbIDguNTkxMzMzXSByODgyMmJlOiBtb2R1bGUgaXMgZnJvbSB0aGUgc3RhZ2luZyBk
aXJlY3RvcnksIHRoZSBxdWFsaXR5DQo+ID4gaXMgdW5rbm93biwgeW91IGhhdmUgYmVlbiB3YXJu
ZWQuDQo+ID4gWyA4LjU5MzEyMl0gcjg4MjJiZSAwMDAwOjAyOjAwLjA6IGVuYWJsaW5nIGRldmlj
ZSAoMDAwMCAtPiAwMDAzKQ0KPiA+IFsgOC42NjkxNjNdIHI4ODIyYmU6IFVzaW5nIGZpcm13YXJl
IHJ0bHdpZmkvcnRsODgyMmJlZncuYmluDQo+ID4gWyA5LjI4OTkzOV0gcjg4MjJiZTogcnRsd2lm
aTogd2lyZWxlc3Mgc3dpdGNoIGlzIG9uDQo+ID4gWyAxMC4wNTY0MjZdIHI4ODIyYmUgMDAwMDow
MjowMC4wIHdscDJzMDogcmVuYW1lZCBmcm9tIHdsYW4wDQo+ID4gLi4uDQo+ID4gWyAxMS45NTI1
MzRdIHI4ODIyYmU6IGhhbG1hY19pbml0X2hhbCBmYWlsZWQNCj4gPiBbIDExLjk1NTkzM10gcjg4
MjJiZTogaGFsbWFjX2luaXRfaGFsIGZhaWxlZA0KPiA+IFsgMTEuOTU2MjI3XSByODgyMmJlOiBo
YWxtYWNfaW5pdF9oYWwgZmFpbGVkDQo+ID4gWyAyMi4wMDc5NDJdIHI4ODIyYmU6IGhhbG1hY19p
bml0X2hhbCBmYWlsZWQNCj4gPsKgDQo+ID4gSmlhbi1Ib25nIHJlcG9ydGVkIGl0IHdvcmtzIGlm
IHR1cm4gb2ZmIEFTUE0gd2l0aCBtb2R1bGUgcGFyYW1ldGVyIGFzcG09MC4NCj4gPiBJbiBvcmRl
ciB0byBmaXggdGhpcyBwcm9ibGVtIGtpbmRseSwgdGhpcyBjb21taXQgZG9uJ3QgdHVybiBvZmYg
YXNwbSBidXQNCj4gPiBlbmxhcmdlIEFTUE0gTDEgbGF0ZW5jeSB0byA3Lg0KPiA+wqANCj4gPiBS
ZXBvcnRlZC1ieTogSmlhbi1Ib25nIFBhbiA8amlhbi1ob25nQGVuZGxlc3NtLmNvbT4NCj4gPiBU
ZXN0ZWQtYnk6IEppYW4tSG9uZyBQYW4gPGppYW4taG9uZ0BlbmRsZXNzbS5jb20+DQo+ID4gU2ln
bmVkLW9mZi1ieTogUGluZy1LZSBTaGloIDxwa3NoaWhAcmVhbHRlay5jb20+DQo+IA0KPiBUaGlz
IHBhdGNoIGRlZmluaXRlbHkgbmVlZHMgYSBDYyBmb3Igc3RhYmxlLiBPdGhlcndpc2UgSSBBQ0sg
aXQuDQo+IA0KDQpIaSBMYXJyeSwNCg0KVGhpcyBwYXRjaCBoYWQgYmVlbiBhcHBsaWVkIGJ5IEdy
ZWcsIGFuZCBDQydlZCB0byBzdGFibGUuDQpUaGFua3MgZm9yIHlvdXIgcmVtaW5kZXIuwqANCg0K
UEsNCg==
