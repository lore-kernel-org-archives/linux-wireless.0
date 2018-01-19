Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:42310 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754833AbeASBkG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Jan 2018 20:40:06 -0500
From: Pkshih <pkshih@realtek.com>
To: "arend.vanspriel@broadcom.com" <arend.vanspriel@broadcom.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>
CC: =?utf-8?B?6I6K5b2l5a6j?= <yhchuang@realtek.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH v2 05/10] rtlwifi: enable mac80211 fast-tx support
Date: Fri, 19 Jan 2018 01:39:43 +0000
Message-ID: <1516325983.2726.5.camel@realtek.com> (sfid-20180119_024233_179652_89D84733)
References: <20180111070932.9929-1-pkshih@realtek.com>
         <20180111070932.9929-6-pkshih@realtek.com>
         <871sip24fc.fsf@purkki.adurom.net> <5A5E5C99.5020607@broadcom.com>
         (sfid-20180116_211216_753091_08EEF52B)
 <1516141444.410.52.camel@sipsolutions.net>
         <1516266330.3990.6.camel@realtek.com>
         <1516270185.410.56.camel@sipsolutions.net>
In-Reply-To: <1516270185.410.56.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gVGh1LCAyMDE4LTAxLTE4IGF0IDExOjA5ICswMTAwLCBKb2hhbm5lcyBCZXJnIHdyb3RlOg0K
PiBPbiBUaHUsIDIwMTgtMDEtMTggYXQgMDk6MDUgKzAwMDAsIFBrc2hpaCB3cm90ZToNCj4gPiAN
Cj4gPiANCj4gPiA+IA0KPiA+ID4gwqDCoMKgwqDCoMKgwqDCoC8qIGZhc3QteG1pdCBkb2Vzbid0
IGhhbmRsZSBmcmFnbWVudGF0aW9uIGF0IGFsbCAqLw0KPiA+ID4gwqDCoMKgwqDCoMKgwqDCoGlm
IChsb2NhbC0+aHcud2lwaHktPmZyYWdfdGhyZXNob2xkICE9ICh1MzIpLTEgJiYNCj4gPiA+IMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCFpZWVlODAyMTFfaHdfY2hlY2soJmxvY2FsLT5odywgU1VQ
UE9SVFNfVFhfRlJBRykpDQo+ID4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGdv
dG8gb3V0Ow0KPiA+ID4gDQo+ID4gVGhhbmsgeW91IGZvciB0aGlzIHBvaW50LiBUaGlzIGNvbW1p
dCBoYXMgbm90IHRvIHNldCBTVVBQT1JUU19UWF9GUkFHLMKgDQo+ID4gYnV0IG9ubHkgc2V0IFNV
UFBPUlRfRkFTVF9YTUlULiBJJ2xsIHRlc3QgYW5kIHByZXBhcmUgZm9yIG5leHTCoA0KPiA+IHN1
Ym1pc3Npb24uDQo+IEJ1dCB0aGUgcG9pbnQgaXMgdGhhdCB5b3UgKnNob3VsZG4ndCogc2V0IFNV
UFBPUlRTX1RYX0ZSQUcsIGFuZCB0aGVuDQo+IGZhc3QteG1pdCB3aWxsIG9ubHkgZ2V0IHVzZWQg
Zm9yIG5vbi1mcmFnbWVudGVkIHNldHVwcywgd2hpY2gNCj4gcmVhbGlzdGljYWxseSBpcyBhbGwg
YW55b25lIGNhcmVzIGFib3V0IGFueXdheS4NCj4gDQoNCk15IGZhdWx0LiBTaW5jZSB0aGUgZ29h
bCBvZiB0aGlzIGNvbW1pdCBpcyB0byBlbmFibGUgZmFzdC10eCwgSSBzaG91bGRuJ3QNCnNldMKg
U1VQUE9SVFNfVFhfRlJBRyBhbmQgdGhlIG9wIHNldF9mcmFnX3RocmVzaG9sZC4NCg0KUEsNCg==
