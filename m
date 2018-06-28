Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:35527 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751723AbeF1BxW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Jun 2018 21:53:22 -0400
From: Pkshih <pkshih@realtek.com>
To: "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] rtlwifi: rtl8821ae: fix firmware is not ready to run
Date: Thu, 28 Jun 2018 01:53:10 +0000
Message-ID: <1530150790.5655.0.camel@realtek.com> (sfid-20180628_035326_026076_D99B9E0A)
References: <20180627080130.12195-1-pkshih@realtek.com>
         <834573bf-fb52-2476-fb35-96127532924d@lwfinger.net>
In-Reply-To: <834573bf-fb52-2476-fb35-96127532924d@lwfinger.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gV2VkLCAyMDE4LTA2LTI3IGF0IDA4OjM2IC0wNTAwLCBMYXJyeSBGaW5nZXIgd3JvdGU6DQo+
IE9uIDA2LzI3LzIwMTggMDM6MDEgQU0sIHBrc2hpaEByZWFsdGVrLmNvbSB3cm90ZToNCj4gPiBG
cm9tOiBQaW5nLUtlIFNoaWggPHBrc2hpaEByZWFsdGVrLmNvbT4NCj4gPsKgDQo+ID4gcnRsODgy
MWFlIHVzZXMgdHdvIGtpbmRzIG9mIGZpcm13YXJlcyBmb3Igbm9ybWFsIGFuZCBXb1dsYW4gY2Fz
ZXMsIGFuZA0KPiA+IGVhY2ggZmlybXdhcmUgaGFzIGZpcm13YXJlIGRhdGEgYnVmZmVyIGFuZCBz
aXplIGluZGl2aWR1YWxseS4gT3JpZ2luYWwNCj4gPiBjb2RlIGFsd2F5cyBvdmVyd3JpdGUgc2l6
ZSBvZiBub3JtYWwgZmlybXdhcmUgcnRscHJpdi0+cnRsaGFsLmZ3c2l6ZSwgYW5kDQo+ID4gdGhp
cyBtaXNtYXRjaCBjYXVzZXMgZmlybXdhcmUgY2hlY2tzdW0gZXJyb3IsIHRoZW4gZmlybXdhcmUg
Y2FuJ3Qgc3RhcnQuDQo+ID7CoA0KPiA+IEluIHRoaXMgc2l0dWF0aW9uLCBkcml2ZXIgZ2l2ZXMg
bWVzc2FnZSAiRmlybXdhcmUgaXMgbm90IHJlYWR5IHRvIHJ1biEiLg0KPiA+wqANCj4gPiBGaXhl
czogZmU4OTcwN2YwYWZhICgicnRsd2lmaTogcnRsODgyMWFlOiBTaW1wbGlmeSBsb2FkaW5nIG9m
IFdPV0xBTiBmaXJtd2FyZSIpDQo+ID4gU2lnbmVkLW9mZi1ieTogUGluZy1LZSBTaGloIDxwa3No
aWhAcmVhbHRlay5jb20+DQo+ID4gLS0tDQo+ID4gdjI6IGZpeCBjb21taXQgbG9nIHR5cG8uDQo+
ID4gLS0tDQo+ID7CoMKgwqBkcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvY29y
ZS5jIHwgMSAtDQo+ID7CoMKgwqAxIGZpbGUgY2hhbmdlZCwgMSBkZWxldGlvbigtKQ0KPiANCj4g
VGhpcyBjaGFuZ2UgaXMgYSBnb29kIG9uZSwgYW5kIEkgYXBwcm92ZSBvZiBpdC4gVGhlIG9ubHkg
Y2hhbmdlIGlzIHRoYXQgaXTCoA0KPiBzaG91bGQgaGF2ZSBhIENjIHRvIHN0YWJsZSBhcyB0aGlz
IGNvZGUgd2FzIGFkZGVkIGluIGtlcm5lbCA0LjAhDQo+IA0KSSdsbCBDYyB0byBzdGFibGUgaW4g
djMuDQoNClRoYW5rcw0KUEsNCg0K
