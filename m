Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:46274 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752748AbaCFKXE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Mar 2014 05:23:04 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Karl Beldan <karl.beldan@gmail.com>,
	Emmanuel Grumbach <egrumbach@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Bondar, Alexander" <alexander.bondar@intel.com>
Subject: RE: [PATCH 08/36] iwlwifi: mvm: Change power management dependency
 on multi MAC
Date: Thu, 6 Mar 2014 10:22:49 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB303D79687@HASMSX103.ger.corp.intel.com> (sfid-20140306_112315_196570_DBAA0D0A)
References: <52B0B72A.5070704@gmail.com>
 <1387313079-28123-8-git-send-email-egrumbach@gmail.com>
 <20140113111357.GA4611@magnum.frso.rivierawaves.com>
 <0BA3FCBA62E2DC44AF3030971E174FB303D3C4A5@HASMSX103.ger.corp.intel.com>
 <20140113124049.GA5796@magnum.frso.rivierawaves.com>
 <52D83C56.5010706@gmail.com> <20140116214357.GA10376@gobelin>
 <CANUX_P25Oi=_5RBHKyuWQEZe6DXVyMOFS2xfGfa45HyyJSz=ug@mail.gmail.com>
 <20140306102102.GA15185@magnum.frso.rivierawaves.com>
In-Reply-To: <20140306102102.GA15185@magnum.frso.rivierawaves.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PiANCj4gSGksDQo+IA0KPiBUaGFua3MgZm9yIHRoZSB1cGRhdGUsIGluZGVlZCBtb25pdG9yIGlz
IGluIGJldHRlciBzaGFwZSwgaG93ZXZlciBJIGFtDQo+IHN0aWxsIHNlZWluZyBzb21lIGlzc3Vl
cy4NCj4gRS5nLiBzaG9ydC1ndWFyZCBvciA+IDIwTUh6IGJ3IGZyYW1lcyBhcmUgbm90IHZpc2li
bGUgd2hlbiBub3QNCj4gYWdncmVnYXRlZCwgSSBzdGlsbCBzZWUgIk1pY3JvY29kZSBTVyBlcnJv
ciBkZXRlY3RlZC4iIGJ1dCBpbiBhDQo+IGRpZmZlcmVudCBzY2VuYXJpbyAobW9uaXRvcmluZyB3
aXRoIG1haW4gbWFuYWdlZCBpZmFjZSBkb3duLCB0aGVuIHVwcGluZw0KPiB0aGUgbWFpbiBtYW5h
Z2VkIGlmYWNlIHVwKSwgaXQgYWxzbyBzZWVtcyB0aGF0IHdlIGZpbHRlciBvdXQgbWFueSBmcmFt
ZXMNCj4gd2hlbiB0aGUgbWFpbiBtYW5hZ2VkIGlmYWNlIGlzIHVwIGFuZC9vcj8gYXNzb2NpYXRl
ZC4NCj4gQWxzbywgSSBzdGFydGVkIHdvcmtpbmcgb24gQU1TRFVzIHRoaXMgd2VlayBhbmQgeWVz
dGVyZGF5IG15IGxhcHRvcA0KPiBjcmFzaGVkIGltbWVkaWF0ZWx5IHdoZW4gbW9uaXRvcmluZy4g
VGhpcyBtb3JuaW5nIEkgc2VlIHRoYXQgdGhpcw0KPiBoYXBwZW5zIHdoZW4gbXkgYWdncmVnYXRl
cyBzdGFydCBnZXR0aW5nIGFib3ZlIHRoZSB+NGsgbGltaXQgYW5kDQo+IG1vZHByb2Jpbmcgd2l0
aCBhbXNkdV9zaXplXzhLPTEgc2VlbXMgdG8gJ2ZpeCcgdGhlIGlzc3VlLCBJIGd1ZXNzIHNvbWUN
Cj4gcGxhY2VzIG5lZWQgc29tZSBvZmxvd3MgY2hlY2tzLg0KPiBBbGwgdGhpcyB3aXRoIHdpcmVs
ZXNzLW5leHRANzA0NDQ1ZDkgKGkuZS4gY2lyY2EgdGhlIHRpbWUgSSBnb3QgeW91cg0KPiBlbWFp
bCkgYW5kIGZ3IDIyLjE1LjguMC4NCj4gDQoNClBsZWFzZSBwYXN0ZSB0aGUgZGF0YSBmb3IgdGhl
IGZpcm13YXJlIGFzc2VydC4gQWxzbywgdGFrZSBodHRwczovL2dpdC5rZXJuZWwub3JnL2NnaXQv
bGludXgva2VybmVsL2dpdC9qYmVyZy9tYWM4MDIxMS5naXQvY29tbWl0Lz9pZD0xYzM3YTcyYzFi
ZDBiODNiZThiOTVjZmY3ZjFiYzliMWYzMmJkNDMzIGludG8gYWNjb3VudC4NCg==
