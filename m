Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:12285 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005AbbDAJTo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Apr 2015 05:19:44 -0400
From: "Peer, Ilan" <ilan.peer@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"mcgrof@suse.com" <mcgrof@suse.com>
Subject: RE: [PATCH v2] cfg80211: Stop calling crda if it is not responsive
Date: Wed, 1 Apr 2015 09:19:39 +0000
Message-ID: <CB3B3D4774441E42AA3EA0E1BA8230A04D092DC4@HASMSX106.ger.corp.intel.com> (sfid-20150401_111949_453958_B5A392ED)
References: <1427717749-27225-1-git-send-email-ilan.peer@intel.com>
	 (sfid-20150330_141354_463006_F82C75ED)
 <1427878274.3428.2.camel@sipsolutions.net>
In-Reply-To: <1427878274.3428.2.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKb2hhbm5lcyBCZXJnIFttYWls
dG86am9oYW5uZXNAc2lwc29sdXRpb25zLm5ldF0NCj4gU2VudDogV2VkbmVzZGF5LCBBcHJpbCAw
MSwgMjAxNSAxMTo1MQ0KPiBUbzogUGVlciwgSWxhbg0KPiBDYzogbGludXgtd2lyZWxlc3NAdmdl
ci5rZXJuZWwub3JnOyBtY2dyb2ZAc3VzZS5jb20NCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2Ml0g
Y2ZnODAyMTE6IFN0b3AgY2FsbGluZyBjcmRhIGlmIGl0IGlzIG5vdCByZXNwb25zaXZlDQo+IA0K
PiBPbiBNb24sIDIwMTUtMDMtMzAgYXQgMTU6MTUgKzAzMDAsIElsYW4gUGVlciB3cm90ZToNCj4g
PiBQYXRjaCBlZWNhOWZjZTFkNzFhNDk1NTg1NWNlYjBjM2IxM2MxZWI5ZGIyN2MxIChjZmc4MDIx
MToNCj4gU2NoZWR1bGUNCj4gPiB0aW1lb3V0IGZvciBhbGwgQ1JEQSBjYWxsKSBpbnRyb2R1Y2Vk
IGEgcmVncmVzc2lvbiwgd2hlcmUgaW4gY2FzZSB0aGF0DQo+ID4gY3JkYSBpcyBub3QgaW5zdGFs
bGVkIChvciBub3QgY29uZmlndXJlZCBwcm9wZXJseSBldGMuKSwgdGhlDQo+ID4gcmVndWxhdG9y
eSBjb3JlIHdpbGwgbmVlZGxlc3NseSBjb250aW51ZSB0byBjYWxsIGl0LCBwb2xsdXRpbmcgdGhl
IGxvZw0KPiA+IHdpdGggdGhlIGZvbGxvd2luZyBsb2c6DQo+ID4NCj4gPiAiY2ZnODAyMTE6IENh
bGxpbmcgQ1JEQSB0byB1cGRhdGUgd29ybGQgcmVndWxhdG9yeSBkb21haW4iDQo+ID4NCj4gPiBG
aXggdGhpcyBieSBsaW1pdGluZyB0aGUgbnVtYmVyIG9mIGNvbnRpbnVvdXMgQ1JEQSByZXF1ZXN0
IGZhaWx1cmVzLg0KPiANCj4gQXBwbGllZCwgYnV0IEkgcHV0IHRoZSBjb25kaXRpb24gaW4gYSBw
bGFjZSBiZWZvcmUgcHJpbnRpbmcgbW9yZSBtZXNzYWdlcywgYW5kDQo+IGNoYW5nZWQgdGhlIG1l
c3NhZ2VzIGJhY2sgdG8gdGhlIG9yaWdpbmFsIG9uZXMuDQo+IA0KDQpCdXQgdGhpcyB3b3VsZCBt
aXNzIHRoZSB1cGRhdGUgaW4gY2FzZSB0aGF0IHRoZSBpbnRlcm5hbCBEQiBpcyBhbHNvIHVzZWQu
DQoNCklsYW4uDQo=
