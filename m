Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:56304 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757974AbcAUG5z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2016 01:57:55 -0500
From: "Peer, Ilan" <ilan.peer@intel.com>
To: Arend van Spriel <arend@broadcom.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: RE: [RFC V2 2/3] nl80211: add bss selection attribute to CONNECT
 command
Date: Thu, 21 Jan 2016 06:57:50 +0000
Message-ID: <CB3B3D4774441E42AA3EA0E1BA8230A0612BF0B2@HASMSX110.ger.corp.intel.com> (sfid-20160121_075759_150780_C841CA9E)
References: <1452678583-20086-1-git-send-email-arend@broadcom.com>
 <1452678583-20086-3-git-send-email-arend@broadcom.com>
 <1452769832.2444.14.camel@sipsolutions.net> <569CB190.1000901@broadcom.com>
 <1453209647.3896.22.camel@sipsolutions.net> <569EB9A6.4030808@broadcom.com>
 <1453298541.13263.10.camel@sipsolutions.net> <56A001DA.9010400@broadcom.com>
In-Reply-To: <56A001DA.9010400@broadcom.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBcmVuZCB2YW4gU3ByaWVsIFtt
YWlsdG86YXJlbmRAYnJvYWRjb20uY29tXQ0KPiBTZW50OiBXZWRuZXNkYXksIEphbnVhcnkgMjAs
IDIwMTYgMjM6NTQNCj4gVG86IEpvaGFubmVzIEJlcmcNCj4gQ2M6IGxpbnV4LXdpcmVsZXNzOyBQ
ZWVyLCBJbGFuDQo+IFN1YmplY3Q6IFJlOiBbUkZDIFYyIDIvM10gbmw4MDIxMTogYWRkIGJzcyBz
ZWxlY3Rpb24gYXR0cmlidXRlIHRvIENPTk5FQ1QNCj4gY29tbWFuZA0KPiANCj4gDQo+IA0KPiBP
biAyMC0xLTIwMTYgMTU6MDIsIEpvaGFubmVzIEJlcmcgd3JvdGU6DQo+ID4gSWxhbiBwb2ludGVk
IG1lIHRvIHRoaXM6DQo+ID4NCj4gPiBodHRwOi8vYW5kcm9pZHhyZWYuY29tLzYuMC4xX3IxMC94
cmVmL2hhcmR3YXJlL2xpYmhhcmR3YXJlX2xlZ2FjeS9pbmNsDQo+ID4gdWRlL2hhcmR3YXJlX2xl
Z2FjeS9nc2Nhbi5oIzM1MQ0KPiA+DQo+ID4NCj4gPiBJJ2Qgc2F5IHRoYXQgd291bGQganVzdCBi
ZSBhIHNlcGFyYXRlIHByaW1pdGl2ZSwgYW5kIHRoZW4gQW5kcm9pZA0KPiA+IHdvdWxkIHBpY2sg
dGhhdCBpbiBzb21lIHdheT8NCj4gDQo+IEl0IHdhcyBub3QgcGFydCBvZiBteSBwbGFuLCBidXQg
aXQgc2VlbXMgdG8gZml0LCB5ZXMuIEFuZHJvaWQgbm93IHVzZXMgdmVuZG9yDQo+IGNvbW1hbmQg
d2l0aCBnb29nbGUgb3VpIGZvciBnc2NhbiBpZiBJIGFtIG5vdCBtaXN0YWtlbi4NCj4gDQoNClRo
ZXNlIGRvIG5vdCBuZWVkIHRvIG5lY2Vzc2FyaWx5IGJlIHZlbmRvciBjb21tYW5kcyA6KSBXZSBj
YW4gZXh0ZW5kIHlvdXIgd29yayB0byBhbHNvIHN1cHBvcnQgdGhlIGFuZHJvaWQgYmVoYXZpb3Ig
KGp1c3QgcG9pbnRlZCB0aGlzIG91dCBzbyB3ZSB3b3VsZCBub3QgYmUgYmxvY2tlZCB3aGVuIHdh
bnRpbmcgdG8gZXh0ZW5kIGl0KS4NCg0KUmVnYXJkcywNCg0KSWxhbi4NCg==
