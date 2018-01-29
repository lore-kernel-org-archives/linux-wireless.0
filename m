Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:56223 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750730AbeA2DNq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 28 Jan 2018 22:13:46 -0500
From: Pkshih <pkshih@realtek.com>
To: "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 04/10] rtlwifi: Extend tx_power_by_rate_offset size for newer IC
Date: Mon, 29 Jan 2018 03:13:33 +0000
Message-ID: <1517195612.2618.10.camel@realtek.com> (sfid-20180129_041350_438257_A2B15B74)
References: <20180126074645.27201-1-pkshih@realtek.com>
         <20180126074645.27201-5-pkshih@realtek.com>
         <57387d71-27cf-2448-dfe3-b4748930c36b@lwfinger.net>
In-Reply-To: <57387d71-27cf-2448-dfe3-b4748930c36b@lwfinger.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gU2F0LCAyMDE4LTAxLTI3IGF0IDEzOjQ0IC0wNjAwLCBMYXJyeSBGaW5nZXIgd3JvdGU6DQo+
IE9uIDAxLzI2LzIwMTggMDE6NDYgQU0sIHBrc2hpaEByZWFsdGVrLmNvbSB3cm90ZToNCj4gPiBG
cm9tOiBQaW5nLUtlIFNoaWggPHBrc2hpaEByZWFsdGVrLmNvbT4NCj4gPsKgDQo+ID4gSW4gb2xk
ZXIgZGVzaWduLCB0aGUgVFggcG93ZXIgaXMgZ3JvdXBlZCBpbnRvIHJhdGUgc2VjdGlvbiAoc21h
bGxlciBhcnJheQ0KPiA+IHNpemUpLCBidXQgbmV3IGRlc2lnbiBncm91cHMgdGhlbSBpbnRvIHJh
dGUgKGxhcmdlciBhcnJheSBzaXplKS4gVGh1cywNCj4gPiB3ZSBleHRlbmQgdGhlIHNpemUgZm9y
IGJvdGggY2FzZXMsIGFuZCBhZGQgY29tcGlsZSB0aW1lIGFzc2VydGlvbi4NCj4gPsKgDQo+ID4g
U2lnbmVkLW9mZi1ieTogUGluZy1LZSBTaGloIDxwa3NoaWhAcmVhbHRlay5jb20+DQo+ID4gLS0t
DQo+wqANCj4gSSBoYXRlIHRvIHNlZSBhbnkgYXJyYXlzIGdldHRpbmcgbGFyZ2VyLCBidXQgSSBj
YW4gc2VlIHRoYXQgY2hhbmdlcyBpbiByYXRlc8KgDQo+IG1ha2UgdGhpcyBpbmV2aXRhYmxlLiBU
aGUgQlVJTERfQlVHX09OKCkgaXMgYSBnb29kIGFkZGl0aW9uLg0KPsKgDQo+IEFja2VkLWJ5OiBM
YXJyeSBGaW5nZXIgPExhcnJ5LkZpbmdlckBsd2Zpbmdlci5uZXQ+DQo+DQoNCk15IHN0ZXBzIHRv
IHJldmlzZSB0eF9wb3dlciBwcm9jZWR1cmUgYXJlDQoxLiBleHRlbmRzIHRoZSBhcnJheSBzaXpl
ICh0aGlzIGNvbW1pdCkNCjIuIGFkZCA4ODIyYmUgKHRoZSBuZXcgdHhfcG93ZXIgcHJvY2VkdXJl
IGlzIGluY2x1ZGVkKQ0KMy4gbWFrZSBhbGwgY2hpcHMgdXNlIHRoZSBuZXcgdHhfcG93ZXIgcHJv
Y2VkdXJlDQoNClBLDQo=
