Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:24403 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750927AbaB1I07 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Feb 2014 03:26:59 -0500
From: Bing Zhao <bzhao@marvell.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Tim Shepard <shep@alum.mit.edu>,
	Avery Pennarun <apenwarr@gmail.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>
Date: Fri, 28 Feb 2014 00:26:50 -0800
Subject: RE: [PATCH 5/9] mwifiex: stop AP at shutdown time
Message-ID: <477F20668A386D41ADCC57781B1F70430F53C089D0@SC-VEXCH1.marvell.com> (sfid-20140228_092702_701271_F204ABE9)
References: <1393558517-887-1-git-send-email-bzhao@marvell.com>
	 <1393558517-887-3-git-send-email-bzhao@marvell.com>
	 (sfid-20140228_043533_674886_AC58C7E4)
 <1393574198.4133.0.camel@jlt4.sipsolutions.net>
In-Reply-To: <1393574198.4133.0.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgSm9oYW5uZXMsDQoNClRoYW5rcyBmb3IgcmV2aWV3aW5nIG91ciBwYXRjaC4NCg0KPiBPbiBU
aHUsIDIwMTQtMDItMjcgYXQgMTk6MzUgLTA4MDAsIEJpbmcgWmhhbyB3cm90ZToNCj4gPiBGcm9t
OiBBbWl0a3VtYXIgS2Fyd2FyIDxha2Fyd2FyQG1hcnZlbGwuY29tPg0KPiA+DQo+ID4gRGVhdXRo
IGlzIHNlbnQgdG8gQVAgd2hlbiB0aGUgZGV2aWNlIGlzIGFjdGluZyBhcyBzdGF0aW9uIGF0IHNo
dXRkb3duDQo+ID4gdGltZS4gU2ltaWxhcmx5IHdlIHNob3VsZCBzdG9wIEFQIG9wZXJhdGlvbiBh
bHNvLg0KPiA+IG13aWZpZXhfZGVhdXRoZW50aWNhdGUoKSB0YWtlcyBjYXJlIGNsb3NpbmcgdGhl
IGNvbm5lY3Rpb24gYmFzZWQgb24NCj4gPiBwcm92aWRlZCBpbnRlcmZhY2UgdHlwZS4NCj4gDQo+
IFdvdWxkbid0IGFsbCB0aGlzIGJlIGhhbmRsZWQgYnkgY2ZnODAyMTEgYW55d2F5Pw0KDQpJdCB3
b3VsZCwgYnV0IGl0J3MgdG9vIGxhdGUuDQpXaGVuIG13aWZpZXggZHJpdmVyIGdldHMgdW5sb2Fk
ZWQsIGl0IG5lZWRzIHRvIHNlbmQgQlNTX1NUT1AgY29tbWFuZCB0byBmaXJtd2FyZSBhbmQgdGhl
biBzaHV0IGRvd24gdGhlIGZpcm13YXJlLiBQcmlvciB0byB0aGlzIHBhdGNoIHdlIHJlbHkgb24g
LnN0b3BfYXAgaGFuZGxlciB0byBzZW5kIHRoZSBCU1NfU1RPUCBjb21tYW5kIHRvIGZpcm13YXJl
Lg0KVW5mb3J0dW5hdGVseSwgYnkgdGhlIHRpbWUgd2hlbiAuc3RvcF9hcCBoYW5kbGVyIGlzIGNh
bGxlZCwgZHJpdmVyIGhhcyBhbHJlYWR5IHNodXQgZG93biB0aGUgZmlybXdhcmUsIGhlbmNlIHRo
ZSBCU1NfU1RPUCBjb21tYW5kIGlzIGlnbm9yZWQsIGxlYXZpbmcgdGhlIGZpcm13YXJlIGluIGEg
dW5rbm93biBzdGF0ZS4NClRoaXMgcGF0Y2ggbWFrZXMgc3VyZSB0aGF0IHRoZSBCU1NfU1RPUCBj
b21tYW5kIGlzIHNlbnQgdG8gZmlybXdhcmUgZXhwbGljaXRseSBiZWZvcmUgdGhlIHNodXRkb3du
Lg0KDQpUaGFua3MsDQpCaW5nDQoNCj4gDQo+IGpvaGFubmVzDQoNCg==
