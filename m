Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:49874 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752492AbbFJQuv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2015 12:50:51 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: "xerofoify@gmail.com" <xerofoify@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Spinadel, David" <david.spinadel@intel.com>,
	"Coelho, Luciano" <luciano.coelho@intel.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"eliad@wizery.com" <eliad@wizery.com>,
	"Berg, Johannes" <johannes.berg@intel.com>,
	"kvalo@codeaurora.org" <kvalo@codeaurora.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] iwlwifi:dvm:Return false if resume command data is not
 same size as received packet for the function iwl_resume_status_fn
Date: Wed, 10 Jun 2015 16:50:45 +0000
Message-ID: <1433955045.20602.2.camel@intel.com> (sfid-20150610_185101_059346_C8346CD5)
References: <1433954031-7176-1-git-send-email-xerofoify@gmail.com>
In-Reply-To: <1433954031-7176-1-git-send-email-xerofoify@gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gV2VkLCAyMDE1LTA2LTEwIGF0IDEyOjMzIC0wNDAwLCBOaWNob2xhcyBLcmF1c2Ugd3JvdGU6
DQo+IFRoaXMgbWFrZXMgdGhlIGZ1bmN0aW9uIGl3bF9yZXN1bWVfc3RhdHVzX2ZuIHJldHVybiBm
YWxzZSBub3cgaWYNCj4gdGhlIHJlY2VpdmVkIHBhY2tldCBvZiB0eXBlIGl3bF9yeF9wYWNrZXQg
aXMgbm90IHRoZSBzYW1lIHNpemUNCj4gYXMgdGhlIHN0cnVjdHVyZSBwb2ludGVyLCBpd2xfcmVz
dW1lX2RhdGEncyBjbWQgZWxlbWVudCBpbiBvcmRlcg0KPiB0byBzaWduYWwgY2FsbGVycyBhYm91
dCB0aGlzIGVycm9yIGFuZCBhbGxvdyB0aGVtIHRvIGhhbmRsZSBpdA0KPiBvY2N1cnJlbnRseS4N
Cj4gDQoNCkhtLi4uIERpZCB5b3UgYWN0dWFsbHkgaGl0IHRoaXMgaWY/DQpJIGFtIG5vdCBzdXJl
IEkgcmVhbGx5IHdhbnQgdG8gd2FpdCBoZXJlICh3aGljaCBpcyB3aGF0IHdpbGwgaGFwcGVuIGlm
DQp5b3UgcmV0dXJuIGZhbHNlKSB3aGVuIHdlIGdldCBhbiB1bmV4cGVjdGVkIGxlbmd0aD8gSSBk
byBub3QgZXhwZWN0DQphbnl0aGluZyBiZXNpZGVzIHRoZSByZXNwb25zZSBJIGFtIHdhaXRpbmcg
Zm9yIHNpbmNlIHRoZSBmaXJtd2FyZSBpcw0KaGFuZGxpbmcgdGhlIEdFVF9TVEFUVVMgKm9ubHkq
IC0gaXQganVzdCBjYW1lIGJhY2sgZnJvbSBXb1dMQU4uIEJvdHRvbQ0KbGluZSwgdGhpcyBpcyBy
ZWFsbHkgYW4gZXJyb3IgcGF0aCBhbmQgSSBwcmVmZXIgdG8gZXhpdCBhbmQgbm90IHdhaXQgZm9y
DQp0aGUgdGltZW91dCBpbiB0aGF0IGNhc2UuDQpCdXQgSSBtaWdodCBiZSBtaXNzaW5nIHNvbWV0
aGluZz8NCg0KPiBTaWduZWQtb2ZmLWJ5OiBOaWNob2xhcyBLcmF1c2UgPHhlcm9mb2lmeUBnbWFp
bC5jb20+DQo+IC0tLQ0KPiAgZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9kdm0vbWFjODAy
MTEuYyB8IDIgKy0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlv
bigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvZHZt
L21hYzgwMjExLmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL2R2bS9tYWM4MDIxMS5j
DQo+IGluZGV4IDVhYmQ2MmUuLjIxZTgwOGMgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L3dp
cmVsZXNzL2l3bHdpZmkvZHZtL21hYzgwMjExLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvd2lyZWxl
c3MvaXdsd2lmaS9kdm0vbWFjODAyMTEuYw0KPiBAQCAtNDA5LDcgKzQwOSw3IEBAIHN0YXRpYyBi
b29sIGl3bF9yZXN1bWVfc3RhdHVzX2ZuKHN0cnVjdCBpd2xfbm90aWZfd2FpdF9kYXRhICpub3Rp
Zl93YWl0LA0KPiAgDQo+ICAJaWYgKGl3bF9yeF9wYWNrZXRfcGF5bG9hZF9sZW4ocGt0KSAhPSBz
aXplb2YoKnJlc3VtZV9kYXRhLT5jbWQpKSB7DQo+ICAJCUlXTF9FUlIocHJpdiwgInJ4IHdyb25n
IHNpemUgZGF0YVxuIik7DQo+IC0JCXJldHVybiB0cnVlOw0KPiArCQlyZXR1cm4gZmFsc2U7DQo+
ICAJfQ0KPiAgCW1lbWNweShyZXN1bWVfZGF0YS0+Y21kLCBwa3QtPmRhdGEsIHNpemVvZigqcmVz
dW1lX2RhdGEtPmNtZCkpOw0KPiAgCXJlc3VtZV9kYXRhLT52YWxpZCA9IHRydWU7DQoNCg==
