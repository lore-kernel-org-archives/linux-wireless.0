Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:52392 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751032AbeA2Csh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 28 Jan 2018 21:48:37 -0500
From: Pkshih <pkshih@realtek.com>
To: "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 09/10] rtlwifi: btcoex: add routine to set default port id
Date: Mon, 29 Jan 2018 02:48:23 +0000
Message-ID: <1517194103.2618.2.camel@realtek.com> (sfid-20180129_034841_712147_869DC58B)
References: <20180126074645.27201-1-pkshih@realtek.com>
         <20180126074645.27201-10-pkshih@realtek.com>
         <496ad7f6-3630-7ffe-2a1f-7e72ac23ffe6@lwfinger.net>
In-Reply-To: <496ad7f6-3630-7ffe-2a1f-7e72ac23ffe6@lwfinger.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gU2F0LCAyMDE4LTAxLTI3IGF0IDEzOjIyIC0wNjAwLCBMYXJyeSBGaW5nZXIgd3JvdGU6DQo+
IE9uIDAxLzI2LzIwMTggMDE6NDYgQU0sIHBrc2hpaEByZWFsdGVrLmNvbSB3cm90ZToNCj4gPiBG
cm9tOiBQaW5nLUtlIFNoaWggPHBrc2hpaEByZWFsdGVrLmNvbT4NCj4gPsKgDQo+ID4gVGVsbCB3
aWZpIGFuZCBCVCBmaXJtd2FyZSB0aGUgZGVmYXVsdCBwb3J0IElEIHRvIHNldCBtdWx0aXBvcnRz
JyBzdGF0ZQ0KPiA+IHByb3Blcmx5LCBidXQgb25seSA4ODIyYmUgbmVlZHMgdGhpcyBmdW5jdGlv
biBjdXJyZW50bHkuDQo+ID7CoA0KPiA+IFNpZ25lZC1vZmYtYnk6IFBpbmctS2UgU2hpaCA8cGtz
aGloQHJlYWx0ZWsuY29tPg0KPiA+IC0tLQ0KPsKgDQo+IFRoaXMgcGF0Y2ggcmVzdWx0cyBpbiB0
aGUgZm9sbG93aW5nIGNvbXBpbGVyIHdhcm5pbmdzOg0KPsKgDQo+wqDCoMKgwqBDQyBbTV3CoMKg
ZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL3J0bDg3MjNiZS9kbS5vDQo+IGRy
aXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS9idGNvZXhpc3QvaGFsYnRjb3V0c3Jj
LmM6MTA1MjoxMzogd2FybmluZzrCoA0KPiDigJhoYWxidGNfc2V0X2RlZmF1bHRfcG9ydF9pZF9j
bWTigJkgZGVmaW5lZCBidXQgbm90IHVzZWQgWy1XdW51c2VkLWZ1bmN0aW9uXQ0KPsKgwqDCoHN0
YXRpYyB2b2lkIGhhbGJ0Y19zZXRfZGVmYXVsdF9wb3J0X2lkX2NtZCh2b2lkICpidF9jb250ZXh0
KQ0KPsKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoF5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+
fn5+fn5+fg0KPiBkcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvYnRjb2V4aXN0
L2hhbGJ0Y291dHNyYy5jOjEwNDI6MTM6IHdhcm5pbmc6wqANCj4g4oCYaGFsYnRjX3NlbmRfd2lm
aV9wb3J0X2lkX2NtZOKAmSBkZWZpbmVkIGJ1dCBub3QgdXNlZCBbLVd1bnVzZWQtZnVuY3Rpb25d
DQo+wqDCoMKgc3RhdGljIHZvaWQgaGFsYnRjX3NlbmRfd2lmaV9wb3J0X2lkX2NtZCh2b2lkICpi
dF9jb250ZXh0KQ0KPsKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoF5+fn5+fn5+fn5+fn5+
fn5+fn5+fn5+fn5+fn5+fg0KPsKgDQo+IFNvbWV0aGluZyBzZWVtcyB0byBiZSB3cm9uZy4gQXMg
dGhlc2Ugcm91dGluZXMgd2lsbCBsaWtlbHkgYmUgbmVlZGVkIGxhdGVyLCB5b3XCoA0KPiBuZWVk
IHRvIHJlbW92ZSB0aGUgc3RhdGljIG5vdGF0aW9uIGFuZCBwdXQgdGhlaXIgcHJvdG90eXBlcyBp
biBhIGhlYWRlciB0byBxdWlldMKgDQo+IFNwYXJzZS4NCg0KWWVzLCBsYXRlciBjb21taXQgbmVl
ZHMgdGhlbS4gSSdsbCBmaXggdGhlc2Ugd2FybmluZ3MgaW4gdjIuDQoNClBLDQoNCg==
