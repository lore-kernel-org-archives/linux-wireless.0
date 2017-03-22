Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:38621 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935428AbdCVRfD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Mar 2017 13:35:03 -0400
From: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
To: "aloisio.almeida@openbossa.org" <aloisio.almeida@openbossa.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "lauro.venancio@openbossa.org" <lauro.venancio@openbossa.org>,
        "mika.westerberg@linux.intel.com" <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH v1 1/2] NFC: pn544: Request GPIOs with proper connection
 IDs
Date: Wed, 22 Mar 2017 17:34:58 +0000
Message-ID: <1490204097.19767.176.camel@intel.com> (sfid-20170322_183538_613487_E8A75603)
References: <20170307101230.23062-1-andriy.shevchenko@linux.intel.com>
         <1488881748.20145.102.camel@linux.intel.com>
In-Reply-To: <1488881748.20145.102.camel@linux.intel.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gVHVlLCAyMDE3LTAzLTA3IGF0IDEyOjE1ICswMjAwLCBBbmR5IFNoZXZjaGVua28gd3JvdGU6
DQo+IE9uIFR1ZSwgMjAxNy0wMy0wNyBhdCAxMjoxMiArMDIwMCwgQW5keSBTaGV2Y2hlbmtvIHdy
b3RlOg0KPiA+IFNpbmNlIEFDUEkgZG9lcyBzdXBwb3J0IF9EU0Qgd2UgbWlnaHQgaGF2ZSBhIGZp
cm13YXJlIHRoYXQgcHJvdmlkZXMNCj4gPiBhDQo+ID4gR1BJTyBtYXBwaW5nIGluIERTRFQuIFdo
ZW4gR1BJTyBpcyByZXF1ZXN0ZWQgdGhlIGNvcmUgd2lsbCBjaGVjayBmb3INCj4gPiBwcm9wZXJ0
eSB3aXRoIGdpdmVuIG5hbWUuIFRoYXQncyB3aHkgd2UgaGF2ZSB0byBmb2xsb3cgdGhlIHN0YW5k
YXJkDQo+ID4gbmFtZXMgd2hpY2ggYXJlIGFscmVhZHkgaW4gdXNlIGluIERUIGNhc2UuDQo+ID4g
DQo+ID4gUmVxdWVzdCBHUElPcyB3aXRoIHByb3BlciBjb25uZWN0aW9uIElEcywgaS5lLiB1c2Ug
c2FtZSBuYW1lcyBhcw0KPiA+IHVzZWQNCj4gPiBmb3IgRFQgY2FzZS4NCj4gPiANCj4gPiBJbiB0
aGUgZnV0dXJlIEFDUEkgYW5kIERUIGNhc2VzIG1pZ2h0IGJlIHVuaWZpZWQuDQo+IA0KPiBEaXNj
YXJkIHRoaXMgc2VyaWVzLCBpdCBzaG91bGQgYmUgdjIsIGp1c3QgcmVzZW50Lg0KDQpXaGlsZSBJ
J20gcHJlcGFyaW5nIHYyLCB0aGVyZSBpcyBhIG1vc3QgaW1wb3J0YW50IHF1ZXN0aW9uIGhhcyBh
cmlzZW4uDQoNCkRvIHdlIGhhdmUgYW55IGV2aWRlbmNlIG9mIE5YUDU0NDAgKEFDUEkgSUQpIGlu
ICpyZWFsKiB3b3JsZD8NCg0KVG8gbWUgaXQgKHRoZSBJRCBpdHNlbGYpIHNvdW5kcyBhcnRpZmlj
aWFsIGFuZCB3aWxmdWxseSBpbnZlbnRlZC4gSW4NCmNhc2UgSSdtIHJpZ2h0IGl0IG11c3QgYmUg
cmVtb3ZlZCBmcm9tIHRoZSBkcml2ZXIuIE90aGVyd2lzZSwgSSB3b3VsZA0KbGlrZSB0byBzZWUg
ZG9jdW1lbnRhdGlvbiBvciBhbGlrZSB3aXRoIERTRFQgZXhjZXJwdCBhbmQgbW9kZWwgb2YgdGhl
DQpyZWFsIGRldmljZSB3aGljaCBoYXMgaXQuDQoNCi0tIA0KQW5keSBTaGV2Y2hlbmtvIDxhbmRy
aXkuc2hldmNoZW5rb0BpbnRlbC5jb20+DQpJbnRlbCBGaW5sYW5kIE95IC0gQklDIDAzNTc2MDYt
NCAtIFdlc3RlbmRpbmthdHUgNywgMDIxNjAgRXNwb28=
