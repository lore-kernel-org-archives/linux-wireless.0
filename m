Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:44994 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752054AbeCaNwh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 31 Mar 2018 09:52:37 -0400
From: Pkshih <pkshih@realtek.com>
To: "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 11/17] rtlwifi: halmac: add files to implement halmac ops
Date: Sat, 31 Mar 2018 13:52:14 +0000
Message-ID: <1522504333.1910.11.camel@realtek.com> (sfid-20180331_155245_474201_DFE432AA)
References: <20180330071916.23360-1-pkshih@realtek.com>
         <20180330071916.23360-12-pkshih@realtek.com>
         (sfid-20180330_092005_131151_0A8F8A2A)
 <1522437431.2902.0.camel@sipsolutions.net>
In-Reply-To: <1522437431.2902.0.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gRnJpLCAyMDE4LTAzLTMwIGF0IDIxOjE3ICswMjAwLCBKb2hhbm5lcyBCZXJnIHdyb3RlOg0K
PiBPbiBGcmksIDIwMTgtMDMtMzAgYXQgMTU6MTkgKzA4MDAsIHBrc2hpaEByZWFsdGVrLmNvbSB3
cm90ZToNCj4gPsKgDQo+ID4gK3N0YXRpYyBzdHJ1Y3QgcnRsX2hhbG1hY19vcHMgcnRsX2hhbG1h
Y19vcGVyYXRpb24gPSB7DQo+IA0KPiBZb3Ugc2hvdWxkIG1ha2UgdGhpcyBjb25zdCwgaWYgYXQg
YWxsIHBvc3NpYmxlIChpdCBsb29rcyBsaWtlIGl0IHNob3VsZA0KPiBiZSkuDQo+IA0KSSdsbCBk
byBpdC4NCg0KPiA+ICsJLmhhbG1hY19pbml0X2FkYXB0ZXIgPSBydGxfaGFsbWFjX2luaXRfYWRh
cHRlciwNCj4gPiArCS5oYWxtYWNfZGVpbml0X2FkYXB0ZXIgPSBydGxfaGFsbWFjX2RlaW5pdF9h
ZGFwdGVyLA0KPiA+ICsJLmhhbG1hY19pbml0X2hhbCA9IHJ0bF9oYWxtYWNfaW5pdF9oYWwsDQo+
ID4gKwkuaGFsbWFjX2RlaW5pdF9oYWwgPSBydGxfaGFsbWFjX2RlaW5pdF9oYWwsDQo+ID4gKwku
aGFsbWFjX3Bvd2Vyb24gPSBydGxfaGFsbWFjX3Bvd2Vyb24sDQo+ID4gKwkuaGFsbWFjX3Bvd2Vy
b2ZmID0gcnRsX2hhbG1hY19wb3dlcm9mZiwNCj4gPiArDQo+ID4gKwkuaGFsbWFjX3BoeV9wb3dl
cl9zd2l0Y2ggPSBydGxfaGFsbWFjX3BoeV9wb3dlcl9zd2l0Y2gsDQo+ID4gKwkuaGFsbWFjX3Nl
dF9tYWNfYWRkcmVzcyA9IHJ0bF9oYWxtYWNfc2V0X21hY19hZGRyZXNzLA0KPiA+ICsJLmhhbG1h
Y19zZXRfYnNzaWQgPSBydGxfaGFsbWFjX3NldF9ic3NpZCwNCj4gPiArDQo+ID4gKwkuaGFsbWFj
X2dldF9waHlzaWNhbF9lZnVzZV9zaXplID0gcnRsX2hhbG1hY19nZXRfcGh5c2ljYWxfZWZ1c2Vf
c2l6ZSwNCj4gPiArCS5oYWxtYWNfcmVhZF9waHlzaWNhbF9lZnVzZV9tYXAgPSBydGxfaGFsbWFj
X3JlYWRfcGh5c2ljYWxfZWZ1c2VfbWFwLA0KPiA+ICsJLmhhbG1hY19nZXRfbG9naWNhbF9lZnVz
ZV9zaXplID0gcnRsX2hhbG1hY19nZXRfbG9naWNhbF9lZnVzZV9zaXplLA0KPiA+ICsJLmhhbG1h
Y19yZWFkX2xvZ2ljYWxfZWZ1c2VfbWFwID0gcnRsX2hhbG1hY19yZWFkX2xvZ2ljYWxfZWZ1c2Vf
bWFwLA0KPiA+ICsNCj4gPiArCS5oYWxtYWNfc2V0X2JhbmR3aWR0aCA9IHJ0bF9oYWxtYWNfc2V0
X2JhbmR3aWR0aCwNCj4gPiArDQo+ID4gKwkuaGFsbWFjX2MyaF9oYW5kbGUgPSBydGxfaGFsbWFj
X2MyaF9oYW5kbGUsDQo+ID4gKw0KPiA+ICsJLmhhbG1hY19jaGtfdHhkZXNjID0gcnRsX2hhbG1h
Y19jaGtfdHhkZXNjLA0KPiA+ICsJLmhhbG1hY19pcWsgPSBydGxfaGFsbWFjX2lxaywNCj4gPiAr
fTsNCj4gPiArDQo+ID4gK3N0cnVjdCBydGxfaGFsbWFjX29wcyAqcnRsX2hhbG1hY19nZXRfb3Bz
X3BvaW50ZXIodm9pZCkNCj4gPiArew0KPiA+ICsJcmV0dXJuICZydGxfaGFsbWFjX29wZXJhdGlv
bjsNCj4gPiArfQ0KPiA+ICtFWFBPUlRfU1lNQk9MKHJ0bF9oYWxtYWNfZ2V0X29wc19wb2ludGVy
KTsNCj4gDQo+IFRoaXMgc2VlbXMgbGlrZSBhIHJhdGhlciBwb2ludGxlc3MgaW5kaXJlY3Rpb24s
IHlvdSBjYW4gZXhwb3J0IHRoZQ0KPiB2YXJpYWJsZS4NCj4gDQoNCkkgdXNlIHRoZSBpbmRpcmVj
dGlvbiBiZWNhdXNlIGFub3RoZXIgZXhpc3RpbmcgbW9kdWxlIGJ0Y29leCB1c2VzDQp0aGlzIHN0
eWxlLiBJIG1heSBhbHNvIGNoYW5nZSB0aGUgZXhpc3RpbmcgY29kZS4NCg0KVGhhbmtzIGZvciB5
b3VyIHJldmlldy4NClBLDQoNCg==
