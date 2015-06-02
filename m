Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:28497 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752058AbbFBHtx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2015 03:49:53 -0400
From: "Coelho, Luciano" <luciano.coelho@intel.com>
To: "luto@kernel.org" <luto@kernel.org>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"Berg, Johannes" <johannes.berg@intel.com>
Subject: Re: iwlwifi/iwlmvm dies on resume when rfkill is set
Date: Tue, 2 Jun 2015 07:49:50 +0000
Message-ID: <1433231389.17081.3.camel@intel.com> (sfid-20150602_094956_271985_43C8F28F)
References: <CALCETrU+Jk+rNwV7ibCy_LJoHkcgSPr7EFRzCxgSkJ5Jwh5q4w@mail.gmail.com>
	 <1433201414.13801.2.camel@intel.com>
In-Reply-To: <1433201414.13801.2.camel@intel.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gTW9uLCAyMDE1LTA2LTAxIGF0IDIzOjMwICswMDAwLCBHcnVtYmFjaCwgRW1tYW51ZWwgd3Jv
dGU6DQo+IE9uIE1vbiwgMjAxNS0wNi0wMSBhdCAxNTo1MSAtMDcwMCwgQW5keSBMdXRvbWlyc2tp
IHdyb3RlOg0KPiA+IElmIEkgc3dpdGNoIG15IGxhcHRvcCBpbnRvIGFpcnBsYW5lIG1vZGUgKGhh
cmR3YXJlIHN3aXRjaCkgYW5kIHRoZW4NCj4gPiBzdXNwZW5kIGFuZCByZXN1bWUsIG15IHdpcmVs
ZXNzIGlzIGRlYWQgb24gcmVzdW1lIGFuZCBpdCBzcGV3cyBhbGwNCj4gPiBvdmVyIHRoZSBrZXJu
ZWwgbG9nIChzZWUgYmVsb3cpLiAgSSBjYW4gcmVzY3VlIGl0IGJ5IHN3aXRjaGluZw0KPiA+IGFp
cnBsYW5lIG1vZGUgb2ZmIGFuZCB0aGVuIHN1c3BlbmRpbmcgYW5kIHJlc3VtaW5nIGFnYWluLg0K
PiA+IA0KPiANCj4gVGhpcyBvbmUgaXMgdHJhY2tlZCBoZXJlOg0KPiBodHRwczovL2J1Z3ppbGxh
Lmtlcm5lbC5vcmcvc2hvd19idWcuY2dpP2lkPTk4NTkxDQo+IA0KPiANCj4gPiBUaGlzIHByb2Js
ZW0gaGFzIGV4aXN0ZWQgb24gYWxsIGtlcm5lbCB2ZXJzaW9ucyBJJ3ZlIHRyaWVkLCBhbHRob3Vn
aCBJDQo+ID4gaGF2ZW4ndCB0cmllZCBhIDQuMCBrZXJuZWwgeWV0Lg0KPiA+IA0KPiANCj4gVGhp
cyBpcyBhIHRyaWNreSBIVyB0aW1pbmcgaXNzdWVzIHdoaWNoIChhcyB5b3UgY2FuIGltYWdpbmUp
IHdlIGNhbid0DQo+IHJlcHJvZHVjZSBpbnRlcm5hbGx5Lg0KPiBZb3Ugc2VlbSB0byBoYXZlIGEg
TEVOT1ZPIHdoZXJlYXMgdGhlIHN1Ym1pdHRlZCBvZiB0aGUgYnVnemlsbGEgYWJvdmUNCj4gaGFz
IHNvbWUgb3RoZXIgT0VNLg0KPiBXZSBhcmUgY3VycmVudGx5IGNoZWNraW5nIHdpdGggb3VyIFN5
c3RlbSBwZW9wbGUgKHdobyBrbm93IHRoZSBIVykgaG93DQo+IHdlIHNob3VsZCBhZGRyZXNzIHRo
YXQuDQoNClJpZ2h0LCBJJ20gaW52ZXN0aWdhdGluZyB0aGlzLiAgVGhlIHByb2JsZW0gc2VlbXMg
dG8gYmUgYSBxdWljayB0b2dnbGUNCm9mIHRoZSByZmtpbGwgaW50ZXJydXB0IHRoYXQgbWF5IGJl
IGNhdXNlZCBieSB0aGUgd2F5IHdlIHJlc2V0IHRoZQ0KZGV2aWNlIHdoZW4gcmVzdW1pbmcuICBJ
IGhhdmUgaW52b2x2ZWQgb3VyIFN5c3RlbSBhbmQgSFcgcGVvcGxlIGFuZCBJJ2xsDQpsZXQgeW91
IGtub3cgaG93IGl0IGlzIGdvaW5nIGFzIHNvb24gYXMgSSBoYXZlIG1vcmUgaW5mby4NCg0KVGhh
bmtzIGZvciByZXBvcnRpbmchDQoNCi0tDQpMdWNhLg0K
