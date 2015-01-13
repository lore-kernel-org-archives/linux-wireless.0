Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:56781 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753601AbbAMGAP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2015 01:00:15 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: "linville@tuxdriver.com" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"kvalo@qca.qualcomm.com" <kvalo@qca.qualcomm.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
Subject: Re: [PATCH] iwlwifi: document switch case fall-through in
 iwl_mvm_send_sta_key
Date: Tue, 13 Jan 2015 06:00:10 +0000
Message-ID: <1421128811.15386.0.camel@egrumbacBox> (sfid-20150113_070024_247541_060115BE)
References: <1421097491-29574-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1421097491-29574-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gTW9uLCAyMDE1LTAxLTEyIGF0IDE2OjE4IC0wNTAwLCBKb2huIFcuIExpbnZpbGxlIHdyb3Rl
Og0KPiBBZGQgYSBjb21tZW50IGluZGljYXRpbmcgdGhhdCB0aGUgV0xBTl9DSVBIRVJfU1VJVEVf
V0VQMTA0IGNhc2UgZmFsbHMNCj4gdGhyb3VnaCB0byB0aGUgV0xBTl9DSVBIRVJfU1VJVEVfV0VQ
NDAgY2FzZSBpbiBpd2xfbXZtX3NlbmRfc3RhX2tleS4NCj4gVGhpcyB3aWxsIGRvY3VtZW50IHRo
YXQgdGhlIGxhY2sgb2YgYSBicmVhayBpcyBpbnRlbnRpb25hbC4NCj4gDQo+IENvdmVyaXR5OiBD
SUQgMTI2MDAyMw0KPiANCj4gU2lnbmVkLW9mZi1ieTogSm9obiBXLiBMaW52aWxsZSA8bGludmls
bGVAdHV4ZHJpdmVyLmNvbT4NCj4gLS0tDQo+IFRoaXMgc2VlbXMgdG8gd29yaywgc28gSSdtIGd1
ZXNzaW5nIHRoYXQgdGhlIGZhbGwtdGhyb3VnaCBpcw0KPiBpbnRlbnRpb25hbC4uLg0KPiANCj4g
IGRyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvbXZtL3N0YS5jIHwgMSArDQo+ICAxIGZpbGUg
Y2hhbmdlZCwgMSBpbnNlcnRpb24oKykNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93
aXJlbGVzcy9pd2x3aWZpL212bS9zdGEuYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkv
bXZtL3N0YS5jDQo+IGluZGV4IGQ4NmZlNDMyZTUxZi4uYzBmYzRmYzAxNjFiIDEwMDY0NA0KPiAt
LS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL212bS9zdGEuYw0KPiArKysgYi9kcml2
ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL212bS9zdGEuYw0KPiBAQCAtMTE5Niw2ICsxMTk2LDcg
QEAgc3RhdGljIGludCBpd2xfbXZtX3NlbmRfc3RhX2tleShzdHJ1Y3QgaXdsX212bSAqbXZtLA0K
PiAgCQlicmVhazsNCj4gIAljYXNlIFdMQU5fQ0lQSEVSX1NVSVRFX1dFUDEwNDoNCj4gIAkJa2V5
X2ZsYWdzIHw9IGNwdV90b19sZTE2KFNUQV9LRVlfRkxHX1dFUF8xM0JZVEVTKTsNCj4gKwkJLyog
ZmFsbCB0aHJvdWdoICovDQo+ICAJY2FzZSBXTEFOX0NJUEhFUl9TVUlURV9XRVA0MDoNCj4gIAkJ
a2V5X2ZsYWdzIHw9IGNwdV90b19sZTE2KFNUQV9LRVlfRkxHX1dFUCk7DQo+ICAJCW1lbWNweShj
bWQua2V5ICsgMywga2V5Y29uZi0+a2V5LCBrZXljb25mLT5rZXlsZW4pOw0KDQpBcHBsaWVkIC0g
dGhhbmtzLg0K
