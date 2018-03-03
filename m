Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:58983 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750823AbeCCFMa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Mar 2018 00:12:30 -0500
From: Pkshih <pkshih@realtek.com>
To: "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 03/15] rtlwifi: btcoex: Add enum DM_INFO for btcoex to query dm's counters
Date: Sat, 3 Mar 2018 05:12:12 +0000
Message-ID: <1520053932.1841.2.camel@realtek.com> (sfid-20180303_061323_481176_75CDE070)
References: <20180228030718.19510-1-pkshih@realtek.com>
         <20180228030718.19510-4-pkshih@realtek.com>
         <1ee67725-5198-9dae-3f46-331774f8003b@lwfinger.net>
In-Reply-To: <1ee67725-5198-9dae-3f46-331774f8003b@lwfinger.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gRnJpLCAyMDE4LTAzLTAyIGF0IDE2OjE5IC0wNjAwLCBMYXJyeSBGaW5nZXIgd3JvdGU6DQo+
IE9uIDAyLzI3LzIwMTggMDk6MDcgUE0sIHBrc2hpaEByZWFsdGVrLmNvbSB3cm90ZToNCj4gPiBG
cm9tOiBQaW5nLUtlIFNoaWggPHBrc2hpaEByZWFsdGVrLmNvbT4NCj4gPsKgDQo+ID4gYnRjb2V4
IHVzZXMgZG0ncyBjb3VudGVycyB0byBjaGVjayB0aGUgZW52b3JpbWVudCBpcyBub3NpeSBvciBu
b3QuIElmIGl0DQo+ID4gaXMgY2xlYW4sIGJ0Y29leCBzZXQgbW9yZSB0aW1lIHNvbHRzIHRvIFdp
Rmkgc28gdGhhdCBpdCBjYW4gdHJhbnNpbXQgYXMNCj4gPiBzb29uIGFzIHBvc3NpYmxlLiBUaGF0
IHdpbGwgc2F2ZSB0aW1lLCBhbmQgQlQgd2lsbCBoYXZlIG1vcmUgdGltZSBzb2x0cw0KPiA+IGFm
dGVyIFdpRmkgdHJhZmZpYyBpcyBjb21wbGV0ZS4NCj4gPsKgDQo+ID4gU2lnbmVkLW9mZi1ieTog
UGluZy1LZSBTaGloIDxwa3NoaWhAcmVhbHRlay5jb20+DQo+IA0KPiBUaGUgY29tbWl0IG1lc3Nh
Z2UgbmVlZHMgdG8gaGF2ZSB0aGUgZm9sbG93aW5nIHR5cG9zIGZpeGVkOg0KPiBlbnZvcmltZW50
IHNob3VsZCBiZSBlbnZpcm9ubWVudA0KPiBub3NpeSBzaG91bGQgYmUgbm9pc3kNCj4gc29sdHMg
c2hvdWxkIGJlIHNsb3RzICgyIHBsYWNlcykNCj4gdHJhbnNpbXQgc2hvdWxkIGJlIHRyYW5zbWl0
DQo+IA0KSSBtdXN0IGJlIHRpcmVkIGF0IHRoYXQgdGltZSA6LSgNCkknbGwgZml4IHRoZW0gaW4g
djIuDQoNCj4gWWVzLCBJIGtub3cgaXQgaXMgZGlmZmljdWx0IHRvIHdyaXRlIGluIGEgc2Vjb25k
IGxhbmd1YWdlLg0KPiANCkluZGVlZC4gSSdsbCBrZWVwIHRvIHByYWN0aWNlLg0KDQpQSw0KDQo=
