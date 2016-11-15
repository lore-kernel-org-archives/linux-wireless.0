Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailca.topcon.com ([12.107.178.112]:52892 "EHLO
        smtpca.topcon.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752603AbcKONfP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Nov 2016 08:35:15 -0500
From: Nicola Smaldone <nsmaldone@tierratelematics.com>
To: Gianfranco Costamagna <locutusofborg@debian.org>,
        Kalle Valo <kvalo@codeaurora.org>
CC: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Marco.Arlone@roj.com" <Marco.Arlone@roj.com>
Subject: RE: [PATCH] broadcom/brcm80211/brcmfmac/cfg80211 driver, bad
 regulatory domain frequency value
Date: Tue, 15 Nov 2016 13:18:22 +0000
Message-ID: <8947AB956BCA3E4E9A143D07C3F63F22D6A0B215@LIV-EXCHMBX1.TOPCON.com> (sfid-20161115_143518_249670_3A3831DA)
References: <CACJOhtL-oFTJC5j0_+fdecWExZBKvDy13o+UBzw47tyrvD_SJQ@mail.gmail.com>
 <CACJOhtKej4EZ3ufGGUr=Rf1X=hufmKtPLQH3y4x0kK4nNg5U0w@mail.gmail.com>
 <690669269.1124561.1477671348137@mail.yahoo.com>
 <5474e850-1c52-c896-da9e-45720ed6d6ff@broadcom.com>
 <0812c8f2-f0ce-c62c-5f09-fa46dafd630f@broadcom.com>
 <233918815.6357602.1479123253455@mail.yahoo.com>
 <fba3cf06-917f-f1c9-6735-f166a18aa222@broadcom.com>
 <810879191.6335567.1479124065921@mail.yahoo.com>
 <87r36dov6u.fsf@purkki.adurom.net>
 <1967239621.630327.1479215628178@mail.yahoo.com>
In-Reply-To: <1967239621.630327.1479215628178@mail.yahoo.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tm8gcHJvYmxlbSBmb3IgbWUsIHRoYW5rcy4NCg0KTmljb2xhIFNNQUxET05F
DQp3d3cudGllcnJhdGVsZW1hdGljcy5jb20NCg0KLS0tLS1PcmlnaW5hbCBN
ZXNzYWdlLS0tLS0NCkZyb206IEdpYW5mcmFuY28gQ29zdGFtYWduYSBbbWFp
bHRvOmxvY3V0dXNvZmJvcmdAZGViaWFuLm9yZ10gDQpTZW50OiBtYXJ0ZWTD
rCAxNSBub3ZlbWJyZSAyMDE2IDE0OjE0DQpUbzogS2FsbGUgVmFsbyA8a3Zh
bG9AY29kZWF1cm9yYS5vcmc+DQpDYzogQXJlbmQgVmFuIFNwcmllbCA8YXJl
bmQudmFuc3ByaWVsQGJyb2FkY29tLmNvbT47IGJyY204MDIxMS1kZXYtbGlz
dEBicm9hZGNvbS5jb207IGxpbnV4LXdpcmVsZXNzQHZnZXIua2VybmVsLm9y
ZzsgTmljb2xhIFNtYWxkb25lIDxuc21hbGRvbmVAdGllcnJhdGVsZW1hdGlj
cy5jb20+OyBNYXJjby5BcmxvbmVAcm9qLmNvbQ0KU3ViamVjdDogUmU6IFtQ
QVRDSF0gYnJvYWRjb20vYnJjbTgwMjExL2JyY21mbWFjL2NmZzgwMjExIGRy
aXZlciwgYmFkIHJlZ3VsYXRvcnkgZG9tYWluIGZyZXF1ZW5jeSB2YWx1ZQ0K
DQpIaSwNCg0KDQo+IFNpZ25lZC1vZmYtYnk6IE5pY29sYSBTbWFsZG9uZSA8
bmljb2xhLnNtYWxkb25lQHRpZXJyYXNlcnZpY2UuY29tPg0KDQo+IFNpZ25l
ZC1vZmYtYnk6IEFybG9uZSBNYXJjbyA8bWFyY28uYXJsb25lQHJvai5jb20+
DQoNCj5QbGVhc2Ugbm90ZSB0aGF0IHlvdSBjYW5ub3QgYWRkIFNpZ25lZC1v
ZmYtYnkgZm9yIG90aGVyIHBlb3BsZSB3aXRob3V0IA0KPnRoZWlyIGV4cGxp
Y2l0IGFwcHJvdmFsIChzZWUgRG9jdW1lbnRhdGlvbi9TdWJtaXR0aW5nUGF0
Y2hlcykuIEkgZG9uJ3QgDQo+a25vdyBpZiB0aGV5IGRpZCBpdCBpbiB0aGlz
IGNhc2Ugb3Igbm90LCBidXQgd2FudGVkIHRvIHBvaW50IG91dCB0aGlzIA0K
PmFueXdheS4NCg0KDQpUaGUgZmlyc3Qgc2lnbm9mZiBpcyBteXNlbGYsIHdp
dGggdGhlIGNvbXBhbnkgZW1haWwsIHRoZSBvdGhlciB0d28gc2lnbm9mZnMg
YXJlIGZyb206IHRoZSBhdXRob3IsIGFuZCBOaWNvbGEsIHdobyBkaWQgd29y
ayB3aXRoIG1lIHRvIHRlc3QgaXQgKGV2ZW4gaWYgYSB0eXBvIGZpeCBpcyBu
b3QgInRlc3RhYmxlIikuDQoNCk5pY29sYSwgTWFyY28sIGlzIGl0IG9rIHRv
IGFkZCB5b3VyIHR3byBuYW1lcyBpbiB0aGUgc2lnbm9mZiBwYXJ0Pw0KKHRo
YXQgd2FzIGEgdmVyYmFsIHRhbGssIEkgZG9uJ3QgaGF2ZSBhbnl0aGluZyB3
cml0dGVuKQ0KDQpHaWFuZnJhbmNvDQoKQ29uZmlkZW50aWFsaXR5IE5vdGlj
ZTogVGhpcyBtZXNzYWdlIChpbmNsdWRpbmcgYXR0YWNobWVudHMpIGlzIGEg
cHJpdmF0ZSBjb21tdW5pY2F0aW9uIHNvbGVseQ0KZm9yIHVzZSBvZiB0aGUg
aW50ZW5kZWQgcmVjaXBpZW50KHMpLiBJZiB5b3UgYXJlIG5vdCB0aGUgaW50
ZW5kZWQgcmVjaXBpZW50KHMpIG9yIGJlbGlldmUgeW91DQpyZWNlaXZlZCB0
aGlzIG1lc3NhZ2UgaW4gZXJyb3IsIG5vdGlmeSB0aGUgc2VuZGVyIGltbWVk
aWF0ZWx5IGFuZCB0aGVuIGRlbGV0ZSB0aGlzIG1lc3NhZ2UuIEFueQ0Kb3Ro
ZXIgdXNlLCByZXRlbnRpb24sIGRpc3NlbWluYXRpb24gb3IgY29weWluZyBp
cyBwcm9oaWJpdGVkIGFuZCBtYXkgYmUgYSB2aW9sYXRpb24gb2YgbGF3LA0K
aW5jbHVkaW5nIHRoZSBFbGVjdHJvbmljIENvbW11bmljYXRpb24gUHJpdmFj
eSBBY3Qgb2YgMTk4Ni4=
