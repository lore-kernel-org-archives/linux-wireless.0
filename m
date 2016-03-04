Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:25619 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758796AbcCDTwO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2016 14:52:14 -0500
From: "Coelho, Luciano" <luciano.coelho@intel.com>
To: "bjorn@mork.no" <bjorn@mork.no>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Ivgi, Chaya Rachel" <chaya.rachel.ivgi@intel.com>
Subject: Re: [PATCH 02/43] iwlwifi: mvm: add registration to thermal zone
Date: Fri, 4 Mar 2016 19:52:11 +0000
Message-ID: <1457121130.28365.171.camel@intel.com> (sfid-20160304_205217_679720_53DDA787)
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
	 <1456905404-14435-2-git-send-email-emmanuel.grumbach@intel.com>
	 <877fhi9jes.fsf@nemi.mork.no>
In-Reply-To: <877fhi9jes.fsf@nemi.mork.no>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gRnJpLCAyMDE2LTAzLTA0IGF0IDE5OjM5ICswMTAwLCBCasO4cm4gTW9yayB3cm90ZToNCj4g
RW1tYW51ZWwgR3J1bWJhY2ggPGVtbWFudWVsLmdydW1iYWNoQGludGVsLmNvbT4gd3JpdGVzOg0K
PiANCj4gPiBGcm9tOiBDaGF5YSBSYWNoZWwgSXZnaSA8Y2hheWEucmFjaGVsLml2Z2lAaW50ZWwu
Y29tPg0KPiA+IA0KPiA+IFJlZ2lzdGVyIHRvIHRoZXJtYWxfem9uZSBpbnRlcmZhY2UgYW5kIGlt
cGxlbWVudCB0aGUNCj4gPiB0aGVybWFsIG9wcy4NCj4gDQo+IEFuZCB0aGVyZSBpdCB3YXMgOikN
Cg0KWWVzLCBJIGd1ZXNzIHlvdSBrbmV3IGl0IHdhcyBjb21pbmcuIDopDQoNCg0KPiA+ICtzdGF0
aWMgdm9pZCBpd2xfbXZtX3RoZXJtYWxfem9uZV9yZWdpc3RlcihzdHJ1Y3QgaXdsX212bSAqbXZt
KQ0KPiA+ICt7DQo+ID4gKwlpbnQgaTsNCj4gPiArCWNoYXIgbmFtZVtdID0gIml3bHdpZmkiOw0K
PiA+ICsNCj4gPiArCWlmICghaXdsX212bV9pc190dF9pbl9mdyhtdm0pKSB7DQo+ID4gKwkJbXZt
LT50el9kZXZpY2UudHpvbmUgPSBOVUxMOw0KPiA+ICsNCj4gPiArCQlyZXR1cm47DQo+ID4gKwl9
DQo+ID4gKw0KPiA+ICsJQlVJTERfQlVHX09OKEFSUkFZX1NJWkUobmFtZSkgPj0gVEhFUk1BTF9O
QU1FX0xFTkdUSCk7DQo+ID4gKw0KPiA+ICsJbXZtLT50el9kZXZpY2UudHpvbmUgPSB0aGVybWFs
X3pvbmVfZGV2aWNlX3JlZ2lzdGVyKG5hbWUsDQo+IA0KPiANCj4gV2h5IG5vdCBzaW1wbHnCoA0K
PiDCoMKgwqDCoMKgwqDCoMKgbXZtLT50el9kZXZpY2UudHpvbmUgPSB0aGVybWFsX3pvbmVfZGV2
aWNlX3JlZ2lzdGVyKERSVl9OQU1FLA0KPiA/DQoNCkdvb2QgcG9pbnQsIEkgZ3Vlc3Mgd2UgY291
bGQgaGF2ZSB1c2VkIERSVl9OQU1FIGluc3RlYWQgb2YgZGVmaW5pbmcgdGhlDQpzYW1lIHN0cmlu
ZyBhZ2Fpbi4gwqBUaGUgQlVJTERfQlVHX09OKCkgaXMganVzdCB0byBiZSBleHRyYSBjYXJlZnVs
IGFuZA0KaXMgcHJvYmFibHkgYSBiaXQgb3ZlcmtpbGwgbm93LiDCoFdlIGhhdmUgZGViYXRlZCBh
IGxvdCBhYm91dCB0aGlzIG5hbWUsDQppZiBpdCB3b3VsZCBoYXZlIHRvIGJlIGR5bmFtaWMgKGku
ZS4gZGlmZmVyZW50IG5hbWVzIGZvciBlYWNoIGRldmljZSksDQpidXQgdGhlbiB3ZSBzZXR0bGVk
IG9uIHNpbXBseSB1c2luZyB0aGUgZHJpdmVyIG5hbWUuIMKgQWRkaXRpb25hbGx5LCBpdA0Kc2Vl
bXMgdGhhdCBtb3N0IChpZiBub3QgYWxsKSBvdGhlciBjYWxsZXJzIG9mIHRoaXMgZnVuY3Rpb24g
cGFzcyB0aGVpcg0Kb3duIHN0cmluZyBpbnN0ZWFkIG9mIHVzaW5nIERSVl9OQU1FIG9yIHdoYXRl
dmVyLi4uDQoNCi0tDQpDaGVlcnMsDQpMdWNhLg==
