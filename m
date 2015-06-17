Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:15178 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752563AbbFQIeY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 04:34:24 -0400
From: David Lin <dlin@marvell.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Pete Hsieh" <peteh@marvell.com>, Chor Teck Law <ctlaw@marvell.com>
Subject: RE: [PATCH v2] Add new mac80211 driver mwlwifi.
Date: Wed, 17 Jun 2015 08:34:19 +0000
Message-ID: <9c9237415bfe49568467f9795dc08111@SC-EXCH02.marvell.com> (sfid-20150617_103429_508262_BC4FC29A)
References: <2127ea28a2a74cd6a89d45b88caf06cb@SC-EXCH02.marvell.com>
	 <1434526059.1884.7.camel@sipsolutions.net>
	 <7e061b3712f4408284917b5a5b4d3813@SC-EXCH02.marvell.com>
 <1434529677.1884.9.camel@sipsolutions.net>
In-Reply-To: <1434529677.1884.9.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PiBKb2hhbm5lcyBCZXJnIHdyb3RlOg0KPiANCj4gT24gV2VkLCAyMDE1LTA2LTE3IGF0IDA4OjA3
ICswMDAwLCBEYXZpZCBMaW4gd3JvdGU6DQo+IA0KPiA+ID4gQWxzbywgeW91IHByb2JhYmx5IHJl
YWxseSBzaG91bGQgaGF2ZSB0d28gaGVhZGVyIGZpbGVzIC0gb25lIGZvciB0aGUNCj4gPiA+IGZp
cm13YXJlIHN0cnVjdHMgYW5kIG9uZSBmb3IgdGhlIGRyaXZlciBzdHJ1Y3RzIC0gZXNwZWNpYWxs
eSBzaW5jZQ0KPiA+ID4geW91IHNlZW0gdG8gYmUgY29uZnVzaW5nIHRoZSB0d28hDQo+ID4gPg0K
PiA+IEFzIG1lbnRpb25lZCBiZWZvcmUsIHRoaXMgaXMgY3VycmVudCBpbnRlcmZhY2Ugd2l0aCBG
L1csIGFuZCB0aGlzIEYvVw0KPiA+IGlzIHVzZWQgYnkgb3RoZXIgbWFydmVsbCdzIGRyaXZlcnMs
IEkgY2FuJ3QgY2hhbmdlIGl0Lg0KPiANCj4gWW91J3JlIG1pc3VuZGVyc3RhbmRpbmcuIEknbSBu
b3QgYXNraW5nIHlvdSB0byBjaGFuZ2UgdGhlIGludGVyZmFjZS4gSSdtIGp1c3QNCj4gYXNraW5n
IHlvdSB0byBtYWtlIHN1cmUgeW91IGtub3cgd2hpY2ggcGFydCBpcyBmaXJtd2FyZSBpbnRlcmZh
Y2UgYW5kIHdoaWNoDQo+IGlzbid0LiBDbGVhcmx5LCBwb2ludGVycyAqY2Fubm90KiBiZSBmaXJt
d2FyZSBpbnRlcmZhY2UgLSBpZiB0aGVyZSdzIHNvbWV0aGluZw0KPiAiY29va2llLWxpa2UiIHRo
YXQgeW91IHVzZSBhcyBwb2ludGVycyB5b3UgYXQgbGVhc3QgbmVlZCB0byBtYWtlIHN1cmUgeW91
IGtub3cNCj4gaG93IGxvbmcgdGhpcyBmaWVsZCBpcyAoMzIgb3IgNjQgYml0cykuLi4NCj4NClll
cywgd2Uga25vdyB0aGlzIGtpbmQgb2YgaXNzdWUuIFdlIHdpbGwgZW5oYW5jZSBpdCBpbiB0aGUg
ZnV0dXJlLg0KPiANCj4gPiBBbGwgc3RydWN0dXJlcyBkZWZpbmVkIGluIHRoaXMgZmlsZSBhcmUg
cmVsYXRlZCB0byBGL1cgY29tbWFuZHMsIGl0DQo+ID4gc2hvdWxkIGJlIGJldHRlciBsZXQgdGhl
bSBiZSBkZWZpbmVkIGluIHRoaXMgZmlsZS4NCj4gDQo+IEdpdmVuIHlvdXIgb3duIGNvbmZ1c2lv
biBvbiB3aGF0J3MgZmlybXdhcmUgQVBJIGFuZCB3aGF0IGlzbid0LCBJJ20gbm90IHNvDQo+IHN1
cmUgYWJvdXQgdGhhdCAuLi4NCj4NCkkgYW0gc3VyZSBhbGwgc3RydWN0dXJlcyBkZWZpbmVkIGlu
IHRoaXMgZmlsZSBpcyByZWxhdGVkIHRvIGZpcm13YXJlIGNvbW1hbmQuDQo+IA0KPiBqb2hhbm5l
cw0KDQo=
