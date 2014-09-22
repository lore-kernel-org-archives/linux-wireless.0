Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:53024 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754223AbaIVR2g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2014 13:28:36 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: "bjorn@mork.no" <bjorn@mork.no>,
	Emmanuel Grumbach <egrumbach@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Kaufman, Liad" <liad.kaufman@intel.com>
Subject: RE: [PATCH 13/17] iwlwifi: 8000: fix fw name to account for revision
Date: Mon, 22 Sep 2014 17:28:31 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB31B5261F1@hasmsx107.ger.corp.intel.com> (sfid-20140922_192839_977481_51ED3B4E)
References: <541F23D2.90600@gmail.com>
	<1411327338-23099-13-git-send-email-egrumbach@gmail.com>
 <87ppeoc4s0.fsf@nemi.mork.no>
In-Reply-To: <87ppeoc4s0.fsf@nemi.mork.no>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

IA0KPiBFbW1hbnVlbCBHcnVtYmFjaCA8ZWdydW1iYWNoQGdtYWlsLmNvbT4gd3JpdGVzOg0KPiAN
Cj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2wtODAwMC5j
DQo+ID4gYi9kcml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL2l3bC04MDAwLmMNCj4gPiBpbmRl
eCA0YWU4YmE2Li5lNDM1MTQ4IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNz
L2l3bHdpZmkvaXdsLTgwMDAuYw0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdp
ZmkvaXdsLTgwMDAuYw0KPiA+IEBAIC04MSw3ICs4MSw3IEBADQo+ID4gICNkZWZpbmUgSVdMODAw
MF9OVk1fVkVSU0lPTgkJMHgwYTFkDQo+ID4gICNkZWZpbmUgSVdMODAwMF9UWF9QT1dFUl9WRVJT
SU9OCTB4ZmZmZiAvKiBtZWFuaW5nbGVzcyAqLw0KPiA+DQo+ID4gLSNkZWZpbmUgSVdMODAwMF9G
V19QUkUgIml3bHdpZmktODAwMC0iDQo+ID4gKyNkZWZpbmUgSVdMODAwMF9GV19QUkUgIml3bHdp
ZmktODAwMCINCj4gPiAgI2RlZmluZSBJV0w4MDAwX01PRFVMRV9GSVJNV0FSRShhcGkpIElXTDgw
MDBfRldfUFJFDQo+IF9fc3RyaW5naWZ5KGFwaSkgIi51Y29kZSINCj4gDQo+IElzbid0IHRoaXMg
Z29pbmcgdG8gY3JlYXRlIGEgbWlzbGVhZGluZyBNT0RVTEVfRklSTVdBUkUgZW50cnksIG1hdGNo
aW5nDQo+IG5laXRoZXIgb2YgdGhlIGZpcm13YXJlIHZhcmlhbnRzPw0KPiANCj4NClllcyBwcm9i
YWJseSAtIE9UT0gsIHRoaXMgZGV2aWNlIGlzIGZhciBmcm9tIGJlaW5nIG9uIHRoZSBzaGVsdmVz
LiBCeSB0aGUgdGltZSBpdCB3aWxsIGhpdCB0aGUgc2hlbHZlcywgd2Ugd2lsbCBoYXZlIHJlbW92
ZWQgYWxsIHRoZSBoYWNrcyBmb3IgdGhlIGVhcmx5IHN0ZXBzIG9mIHRoZSBoYXJkd2FyZS4NCklk
ZWFzIHRvIG1ha2UgaXQgYmV0dGVyPw0KDQpHb29kIHRvIGtub3cgdGhhdCBzb21lb25lIGlzIGFj
dHVhbGx5IGxvb2tpbmcgYXQgdGhlIHBhdGNoZXMgSSB0YWtlIGNhcmUgdG8gc2VuZCA6KQ0K
