Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:11350 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800AbaL1S5l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Dec 2014 13:57:41 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"Berg, Johannes" <johannes.berg@intel.com>,
	"kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [patch -next] iwlwifi: use a format string for an snprintf()
Date: Sun, 28 Dec 2014 18:57:37 +0000
Message-ID: <1419793057.15213.2.camel@egrumbacBox> (sfid-20141228_195746_546238_21477D21)
References: <20141204110220.GE22643@mwanda>
In-Reply-To: <20141204110220.GE22643@mwanda>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gVGh1LCAyMDE0LTEyLTA0IGF0IDE0OjAyICswMzAwLCBEYW4gQ2FycGVudGVyIHdyb3RlOg0K
PiBUaGlzIHdpbGwgbWFrZSBLZWVzIENvb2sgaGFwcHkgaWYgd2Ugc3BlY2lmeSBhIGZvcm1hdCBz
dHJpbmcgYW5kLCB3aG8NCj4ga25vd3MsIG1heWJlIHNvbWVkYXkgdGhlcmUgd2lsbCBiZSBhIGZp
cm13YXJlIHZlcnNpb24gd2l0aCBhIHBlcmNlbnQNCj4gY2hhcmFjdGVyIGFuZCB3ZSdsbCBiZSBn
bGFkIGZvciB0aGlzLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogRGFuIENhcnBlbnRlciA8ZGFuLmNh
cnBlbnRlckBvcmFjbGUuY29tPg0KPiANCg0KVGhlIHBhdGNoIHRoYXQgaW50cm9kdWNlcyB0aGlz
IGNvZGUgaGFzIGJlZW4gcmV2ZXJ0ZWQgaW4gLW5leHQsIHNvIHRoaXMNCmRvZXNuJ3QgYXBwbHkg
dGhlcmUuDQoNClRoYW5rIHlvdS4NCg0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxl
c3MvaXdsd2lmaS9pd2wtZHJ2LmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL2l3bC1k
cnYuYw0KPiBpbmRleCAzOGRlMTUxLi42OGVmZTk3IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25l
dC93aXJlbGVzcy9pd2x3aWZpL2l3bC1kcnYuYw0KPiArKysgYi9kcml2ZXJzL25ldC93aXJlbGVz
cy9pd2x3aWZpL2l3bC1kcnYuYw0KPiBAQCAtMTI5Niw3ICsxMjk2LDcgQEAgc3RhdGljIHZvaWQg
aXdsX3JlcV9md19jYWxsYmFjayhjb25zdCBzdHJ1Y3QgZmlybXdhcmUgKnVjb2RlX3Jhdywgdm9p
ZCAqY29udGV4dCkNCj4gIAkJaXdsX2RlYWxsb2NfdWNvZGUoZHJ2KTsNCj4gIA0KPiAgCQkvKiBC
dWlsZCBuYW1lIG9mIGNvcnJlY3Qtc3RlcCBGVyAqLw0KPiAtCQlzbnByaW50ZihmaXJtd2FyZV9u
YW1lLCBzaXplb2YoZmlybXdhcmVfbmFtZSksDQo+ICsJCXNucHJpbnRmKGZpcm13YXJlX25hbWUs
IHNpemVvZihmaXJtd2FyZV9uYW1lKSwgIiVzIiwNCj4gIAkJCSBzdHJyY2hyKGRydi0+ZmlybXdh
cmVfbmFtZSwgJy0nKSk7DQo+ICAJCXNucHJpbnRmKGRydi0+ZmlybXdhcmVfbmFtZSwgc2l6ZW9m
KGRydi0+ZmlybXdhcmVfbmFtZSksDQo+ICAJCQkgIiVzJXMiLCBkcnYtPmNmZy0+ZndfbmFtZV9w
cmUsIGZpcm13YXJlX25hbWUpOw0KDQo=
