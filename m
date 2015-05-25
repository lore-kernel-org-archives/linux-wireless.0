Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:19151 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbbEYGCk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 May 2015 02:02:40 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: "xerofoify@gmail.com" <xerofoify@gmail.com>
CC: "Coelho, Luciano" <luciano.coelho@intel.com>,
	"kvalo@codeaurora.org" <kvalo@codeaurora.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"Berg, Johannes" <johannes.berg@intel.com>
Subject: Re: [linuxwifi] [PATCH] iwlwifi: Remove use of the deprecacted
 marco, PTR_RET for the function, iwl_mvm_get_regdomain
Date: Mon, 25 May 2015 06:02:35 +0000
Message-ID: <1432533755.2957.0.camel@intel.com> (sfid-20150525_080245_837169_943C5716)
References: <1432428801-2458-1-git-send-email-xerofoify@gmail.com>
In-Reply-To: <1432428801-2458-1-git-send-email-xerofoify@gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gU2F0LCAyMDE1LTA1LTIzIGF0IDIwOjUzIC0wNDAwLCBOaWNob2xhcyBLcmF1c2Ugd3JvdGU6
DQo+IFRoaXMgcmVtb3ZlcyB0aGUgdXNlIG9mIHRoZSB0d28gZGVwcmVjYXRlZCBjYWxscyB0byB0
aGUNCj4gbWFyY28sIFBUUl9SRVQgaW4gdGhlIGZ1bmN0aW9uLCBpd2xfbXZtX2dldF9yZWdkb21h
aW4NCj4gYW5kIHJlcGxhY2VzIHRoZW0gYm90aCB3aXRoIGEgY2FsbCB0byB0aGUgZnVuY3Rpb24s
DQo+IFBUUl9FUlJfT1JfWkVSTy4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IE5pY2hvbGFzIEtyYXVz
ZSA8eGVyb2ZvaWZ5QGdtYWlsLmNvbT4NCg0KQXBwbGllZCBpbiBvdXIgaW50ZXJuYWwgdHJlZSBh
ZnRlciBhIGZldyBmaXhlcyB0byB0aGUgY29tbWl0IG1lc3NhZ2UuDQpXaWxsIGJlIHB1c2hlZCBv
dXQgd2l0aCB0aGUgcmVndWxhciBwcm9jZXNzLg0KVGhhbmtzLg0KDQo+IC0tLQ0KPiAgZHJpdmVy
cy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9tdm0vbWFjODAyMTEuYyB8IDQgKystLQ0KPiAgMSBmaWxl
IGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1n
aXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL212bS9tYWM4MDIxMS5jIGIvZHJpdmVy
cy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9tdm0vbWFjODAyMTEuYw0KPiBpbmRleCA0MDI2NWI5Li41
ZmIyZThlIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL212bS9t
YWM4MDIxMS5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvbXZtL21hYzgw
MjExLmMNCj4gQEAgLTMxOSw3ICszMTksNyBAQCBzdHJ1Y3QgaWVlZTgwMjExX3JlZ2RvbWFpbiAq
aXdsX212bV9nZXRfcmVnZG9tYWluKHN0cnVjdCB3aXBoeSAqd2lwaHksDQo+ICAJcmVzcCA9IGl3
bF9tdm1fdXBkYXRlX21jYyhtdm0sIGFscGhhMiwgc3JjX2lkKTsNCj4gIAlpZiAoSVNfRVJSX09S
X05VTEwocmVzcCkpIHsNCj4gIAkJSVdMX0RFQlVHX0xBUihtdm0sICJDb3VsZCBub3QgZ2V0IHVw
ZGF0ZSBmcm9tIEZXICVkXG4iLA0KPiAtCQkJICAgICAgUFRSX1JFVChyZXNwKSk7DQo+ICsJCQkg
ICAgICBQVFJfRVJSX09SX1pFUk8ocmVzcCkpOw0KPiAgCQlnb3RvIG91dDsNCj4gIAl9DQo+ICAN
Cj4gQEAgLTMzNSw3ICszMzUsNyBAQCBzdHJ1Y3QgaWVlZTgwMjExX3JlZ2RvbWFpbiAqaXdsX212
bV9nZXRfcmVnZG9tYWluKHN0cnVjdCB3aXBoeSAqd2lwaHksDQo+ICAJa2ZyZWUocmVzcCk7DQo+
ICAJaWYgKElTX0VSUl9PUl9OVUxMKHJlZ2QpKSB7DQo+ICAJCUlXTF9ERUJVR19MQVIobXZtLCAi
Q291bGQgbm90IGdldCBwYXJzZSB1cGRhdGUgZnJvbSBGVyAlZFxuIiwNCj4gLQkJCSAgICAgIFBU
Ul9SRVQocmVnZCkpOw0KPiArCQkJICAgICAgUFRSX0VSUl9PUl9aRVJPKHJlZ2QpKTsNCj4gIAkJ
Z290byBvdXQ7DQo+ICAJfQ0KPiAgDQoNCg==
