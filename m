Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:42092 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750937AbeFVFME (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Jun 2018 01:12:04 -0400
From: Pkshih <pkshih@realtek.com>
To: "arend.vanspriel@broadcom.com" <arend.vanspriel@broadcom.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] rtlwifi: Fix kernel Oops "Fw download fail!!"
Date: Fri, 22 Jun 2018 05:11:37 +0000
Message-ID: <1529644291.5134.2.camel@realtek.com> (sfid-20180622_071208_373221_0DE07883)
References: <20180621070635.8217-1-pkshih@realtek.com>
         <b8a27a7a-1eef-b20f-2684-a1aa4c25aeae@lwfinger.net>
         <1529634409.3075.11.camel@realtek.com>
         <CAF7Mx6p4tDxfUsBOd-w5EF+N2AN74_FgL-8qDt+GJbB2Ntd-dA@mail.gmail.com>
In-Reply-To: <CAF7Mx6p4tDxfUsBOd-w5EF+N2AN74_FgL-8qDt+GJbB2Ntd-dA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gRnJpLCAyMDE4LTA2LTIyIGF0IDA3OjAwICswMjAwLCBBcmVuZCBWYW4gU3ByaWVsIHdyb3Rl
Og0KPiBPcCB2ciAyMiBqdW4uIDIwMTggMDQ6Mjcgc2NocmVlZiBQa3NoaWggPHBrc2hpaEByZWFs
dGVrLmNvbT46DQo+ID4NCj4gPiBPbiBUaHUsIDIwMTgtMDYtMjEgYXQgMTA6MTQgLTA1MDAsIExh
cnJ5IEZpbmdlciB3cm90ZToNCj4gPiA+IE9uIDA2LzIxLzIwMTggMDI6MDYgQU0sIHBrc2hpaEBy
ZWFsdGVrLmNvbSB3cm90ZToNCj4gPiA+ID4gRnJvbTogUGluZy1LZSBTaGloIDxwa3NoaWhAcmVh
bHRlay5jb20+DQo+IFtzbmlwXQ0KPiA+ID4gPiBIaSBLYWxsZSwNCj4gPiA+ID7CoA0KPiA+ID4g
PiBJJ2QgbGlrZSB0byBxdWV1ZSB0aGlzIGZpeCB0byA0LjE4LCBiZWNhdXNlIGtlcm5lbCBvb3Bz
IGluIHVzZXJzJyBsYXB0b3AuDQo+ID4gPsKgDQo+ID4gPiBSZXZpZXdlZCBieSBMYXJyeSBGaW5n
ZXIgPExhcnJ5LkZpbmdlckBsd2Zpbmdlci5uZXQ+DQo+ID4gPsKgDQo+ID4gPiBJcyBpcyBzdWZm
aWNpZW50IGZvciB0aGlzIHBhdGNoIHRvIGdvIHRvIDQuMTgsIG9yIHNob3VsZCBpdCBiZSBzZW50
IHRvIHN0YWJsZSzCoA0KPiA+ID4gYXMgd2VsbC4NCj4gPiA+wqANCj4gPg0KPiA+IFlvdSdyZSBy
aWdodCwgaXQgc2hvdWxkIGJlIHNlbnQgdG8gc3RhYmxlLg0KPiA+IEl0IGhhZCBiZWVuIGEgcG90
ZW50aWFsIHJhY2UgY29uZGl0aW9uIGlzc3VlIGZvciBhIGxvbmcgdGltZSwgYnV0IGl0IGV4cG9z
ZWQNCj4gPiB3aGVuIGRlbGF5ZWQgd29yayB0YWtlIGEgbG9uZyB0aW1lIHRvIHByb2Nlc3Mgb3Ig
d2FpdCBmb3IgZXZlbnQuDQo+ID4gSSB0aGluayB0aGlzIGlzc3VlIHdvdWxkIGJlIHBvc3NpYmx5
IGhhcHBlbmVkIHNpbmNlIHY0LjExIHdoZW4gSSBtb3ZlIEMySCBoYW5kbGVyDQo+ID4gdG8gZGVs
YXllZCB3b3JrLg0KPiBDYW4geW91IHByb3ZpZGUgdGhlIGNvbW1pdCBpZCBmb3IgdGhlIEZpeGVz
OiB0YWc/DQoNClN1cmUuDQoNCkZpeGVzOiBjY2ViMGE1OTczMjAgKCJydGx3aWZpOiBBZGQgd29y
ayBxdWV1ZSBmb3IgYzJoIGNtZC4iKQ0KDQpUaGFua3MgZm9yIHlvdXIgcmVtaW5kZXIuDQpQSw0K
DQo=
