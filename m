Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:3904 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719Ab2BVCRs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Feb 2012 21:17:48 -0500
From: "Allan, Bruce W" <bruce.w.allan@intel.com>
To: Joe Perches <joe@perches.com>
CC: David Miller <davem@davemloft.net>,
	Andy Whitcroft <apw@shadowen.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"andrei.emeltchenko.news@gmail.com"
	<andrei.emeltchenko.news@gmail.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] checkpatch: Add some --strict coding style checks
Date: Wed, 22 Feb 2012 02:17:46 +0000
Message-ID: <804857E1F29AAC47BF68C404FC60A18429B98A@ORSMSX102.amr.corp.intel.com> (sfid-20120222_031814_580051_AC30843E)
References: <20120221151435.GA19354@tuxdriver.com>
	 <20120221.144417.1445117001833888214.davem@davemloft.net>
	 <CAMXE1-qB8_5oGey2=Ypa5BitZnye3YqdM=yB8oKCGLvoZu_8HQ@mail.gmail.com>
	 <20120221.154053.2103818562080068513.davem@davemloft.net>
	 <1329857959.5143.11.camel@joe2Laptop>
	 <804857E1F29AAC47BF68C404FC60A18429B3EE@ORSMSX102.amr.corp.intel.com>
	 <1329874581.5143.22.camel@joe2Laptop>
	 <804857E1F29AAC47BF68C404FC60A18429B8F2@ORSMSX102.amr.corp.intel.com>
 <1329875935.5143.24.camel@joe2Laptop>
In-Reply-To: <1329875935.5143.24.camel@joe2Laptop>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKb2UgUGVyY2hlcyBbbWFpbHRv
OmpvZUBwZXJjaGVzLmNvbV0NCj4gU2VudDogVHVlc2RheSwgRmVicnVhcnkgMjEsIDIwMTIgNTo1
OSBQTQ0KPiBUbzogQWxsYW4sIEJydWNlIFcNCj4gQ2M6IERhdmlkIE1pbGxlcjsgQW5keSBXaGl0
Y3JvZnQ7IEFuZHJldyBNb3J0b247DQo+IGFuZHJlaS5lbWVsdGNoZW5rby5uZXdzQGdtYWlsLmNv
bTsgbGludmlsbGVAdHV4ZHJpdmVyLmNvbTsgbGludXgtDQo+IHdpcmVsZXNzQHZnZXIua2VybmVs
Lm9yZzsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbGludXgtDQo+IGtlcm5lbEB2Z2VyLmtlcm5l
bC5vcmcNCj4gU3ViamVjdDogUkU6IFtQQVRDSF0gY2hlY2twYXRjaDogQWRkIHNvbWUgLS1zdHJp
Y3QgY29kaW5nIHN0eWxlIGNoZWNrcw0KPiANCj4gT24gV2VkLCAyMDEyLTAyLTIyIGF0IDAxOjU2
ICswMDAwLCBBbGxhbiwgQnJ1Y2UgVyB3cm90ZToNCj4gPiA+IE9uIFR1ZSwgMjAxMi0wMi0yMSBh
dCAyMjowOSArMDAwMCwgQWxsYW4sIEJydWNlIFcgd3JvdGU6DQo+ID4gPiA+IFRoaXMgYXBwZWFy
cyB0byBmYWxzZWx5IGNvbXBsYWluIGFib3V0IHBhcmVudGhlc2lzIGFsaWdubWVudCBpbg0KPiA+
ID4gPiBjb25kaXRpb25hbCBzdGF0ZW1lbnRzIHdpdGggbXVsdGlwbGUgb3BlbmluZyBwYXJlbnRo
ZXNlcy4NCj4gPiA+IENhbiB5b3UgdHJ5IHRoaXMgb25lIHBsZWFzZT8NCj4gW10NCj4gPiBJdCdz
IGJldHRlciwgYnV0IHRoZXJlIGFyZSBzdGlsbCBpbnN0YW5jZXMgb2YgZmFsc2UgaGl0cyBBRkFJ
Q1QuDQo+IA0KPiBEbyB5b3UgaGF2ZSBhbnkgZXhhbXBsZXM/DQo+IFRoZSBvbmx5IG9uZSBJIG5v
dGljZWQgd2FzIHNwYWNlcyBmb3IgYWxpZ25tZW50IGluc3RlYWQgb2YgdGFicy4NCj4gSSB0aGlu
ayB0aGF0J3Mgbm90IGEgZmFsc2UgaGl0IG15c2VsZi4NCj4gDQoNCkV4YW1wbGUgMToNCglpZiAo
KChhID09IGIpIHx8DQoJICAgICAoYyA9PSBkKSB8fA0KCSAgICAgKGUgPT0gZikpICYmDQoJICAg
IChib29sX3ZhcikpDQoJCWJheigpOw0KDQpFeGFtcGxlIDI6DQoJaWYgKCghKHZhciAmIEZPT19N
QVNLKSAmJg0KCSAgICAgKGEgPT0gYikpIHx8DQoJICAgIChjID09IGQpKQ0KCQliYXooKTsNCg0K
RXhhbXBsZSAzOg0KCWlmICghKChmb28gJiBGT09fTUFTSykgJiYNCgkgICAgICAoYmFyICYgQkFS
X01BU0spKSkNCgkJYmF6KCk7DQoNCkhUSCwNCkJydWNlLg0K
