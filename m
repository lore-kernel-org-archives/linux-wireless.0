Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:33057 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755943AbbJVMID (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2015 08:08:03 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"Sharon, Sara" <sara.sharon@intel.com>,
	"ido@wizery.com" <ido@wizery.com>
Subject: RE: [RFC v3 2/2] iwlwifi: mvm: send large SKBs to the transport
Date: Thu, 22 Oct 2015 12:07:59 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB32E8AC94B@hasmsx107.ger.corp.intel.com> (sfid-20151022_140815_102784_5F644A37)
References: <1445452464-19525-1-git-send-email-emmanuel.grumbach@intel.com>
	 <1445452464-19525-3-git-send-email-emmanuel.grumbach@intel.com>
 <1445515406.22974.107.camel@edumazet-glaptop2.roam.corp.google.com>
In-Reply-To: <1445515406.22974.107.camel@edumazet-glaptop2.roam.corp.google.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PiANCj4gT24gV2VkLCAyMDE1LTEwLTIxIGF0IDIxOjM0ICswMzAwLCBFbW1hbnVlbCBHcnVtYmFj
aCB3cm90ZToNCj4gPiArDQo+ID4gKwkJaWYgKHNrYi0+cHJvdG9jb2wgPT0gaHRvbnMoRVRIX1Bf
SVApKSB7DQo+ID4gKwkJCWlwX2hkcih0bXApLT5pZCA9IGlwX2hkcihza2IpLT5pZDsNCj4gDQo+
IFRvbyBsYXRlLCB5b3UgYWxyZWFkeSBjYWxsZWQgY29uc3VtZV9za2Ioc2tiKS4NCj4gU28gdGhp
cyBpcyBhIHBvdGVudGlhbCB1c2UgYWZ0ZXIgZnJlZS4NCg0KT3VjaCAtIHRoYW5rcyBmb3IgY2F0
Y2hpbmcgdGhpcyENCg0KPiANCj4gPiArCQkJYmUxNl9hZGRfY3B1KCZpcF9oZHIodG1wKS0+aWQs
IGkgKg0KPiBudW1fc3ViZnJhbWVzKTsNCj4gPiArCQl9DQo+ID4gKw0KPiANCj4gDQo+IEkgd291
bGQgdXNlDQo+IGJhc2VfaWQgPSBpcF9oZHIoc2tiKS0+aWQ7IC8vIGJlZm9yZSB0aGUgY29uc3Vt
ZV9za2Ioc2tiKQ0KPiBpcF9oZHIodG1wKS0+aWQgPSBodG9ucyhiYXNlX2lkICsgaSAqIG51bV9z
dWJmcmFtZXMpOw0KPiANClN1cmUgLSBJIHdpbGwuDQoNCkkgd2lsbCBzZW5kIGEgdjQgd2l0aCB0
aGUgZml4ZXMuDQo=
