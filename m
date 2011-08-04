Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:47472 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755066Ab1HDDgK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Aug 2011 23:36:10 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Dan Williams <dcbw@redhat.com>
CC: Daniel Drake <dsd@laptop.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"libertas-dev@lists.infradead.org" <libertas-dev@lists.infradead.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Frank Huang <frankh@marvell.com>
Date: Wed, 3 Aug 2011 20:31:50 -0700
Subject: RE: [PATCH 1/4] libertas: remove auto_deep_sleep functionality
Message-ID: <477F20668A386D41ADCC57781B1F704307FFD55062@SC-VEXCH1.marvell.com> (sfid-20110804_053624_222464_6E45C150)
References: <20110717170310.CAD139D401C@zog.reactivated.net>
	 <477F20668A386D41ADCC57781B1F704307FFB0947D@SC-VEXCH1.marvell.com>
	 <CAGq3pz6DbsHG9JY8oZqaeRp4=EC1-sKunSuF2Q1+tfBoYbcyLg@mail.gmail.com>
	 <477F20668A386D41ADCC57781B1F704307FFBB244E@SC-VEXCH1.marvell.com>
	 <CAGq3pz4cTSZj+_MwJrxG=Ri1zELKbx2i9Hz==3_=t+aho_Y+Xg@mail.gmail.com>
	 <477F20668A386D41ADCC57781B1F704307FFBB25D6@SC-VEXCH1.marvell.com>
 <1311177831.21004.0.camel@dcbw.foobar.com>
In-Reply-To: <1311177831.21004.0.camel@dcbw.foobar.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PiA+IEFueXdheSwgZm9yIHVzZXJzIHdobyBuZWVkIHRoaXMgZmVhdHVyZSB3ZSBjYW4gYWRkIGEg
bW9kdWxlIHBhcmFtZXRlciB0byBlbmFibGUgaXQgd2l0aCB0aGUgcGF0Y2gNCj4gYmVsb3cuIFBs
ZWFzZSBsZXQgbWUga25vdyB3aGF0IHlvdSB0aGluay4NCj4gDQo+IEknZCByYXRoZXIgd2UgZmln
dXJlIG91dCBzb21lIG5sODAyMTEvY2ZnODAyMTEga25vYiBmb3IgdGhpcyByYXRoZXIgdGhhbg0K
PiBhIG1vZHVsZSBwYXJhbWV0ZXI7IHdlIGNhbiBjZXJ0YWlubHkgYWRkIGNhbGxzIGFuZCBhdHRy
aWJ1dGVzIHRvIG5sODAyMTENCj4gaWYgd2UgbmVlZCB0by4NCj4gDQo+IERhbg0KDQpIaSBEYW4s
DQoNCkluICJzdHJ1Y3QgY2ZnODAyMTFfb3BzIiAoY2ZnODAyMTEuaCkgYSAic2V0X3Bvd2VyX21n
bXQiIGhhbmRsZXIgaXMgZGVmaW5lZCBmb3IgSUVFRSBQb3dlciBTYXZlLg0KDQotLS0NCiAqIEBz
ZXRfcG93ZXJfbWdtdDogQ29uZmlndXJlIFdMQU4gcG93ZXIgbWFuYWdlbWVudC4gQSB0aW1lb3V0
IHZhbHVlIG9mIC0xDQogKiAgICAgIGFsbG93cyB0aGUgZHJpdmVyIHRvIGFkanVzdCB0aGUgZHlu
YW1pYyBwcyB0aW1lb3V0IHZhbHVlLg0KDQogICAgICAgIGludCAgICAgKCpzZXRfcG93ZXJfbWdt
dCkoc3RydWN0IHdpcGh5ICp3aXBoeSwgc3RydWN0IG5ldF9kZXZpY2UgKmRldiwNCiAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICBib29sIGVuYWJsZWQsIGludCB0aW1lb3V0KTsNCi0t
LQ0KDQpBbmQgdGhlIGNvcnJlc3BvbmRpbmcgaXcgY29tbWFuZCBpcyAic2V0IHBvd2VyX3NhdmUg
b258b2ZmIi4NCg0KQ3VycmVudGx5ICdhdGg2a2wnLCAnaXdtYzMyMDB3aWZpJywgJ3JuZGlzX3ds
YW4nLCBhbmQgJ213aWZpZXgnIGRyaXZlcnMgaGF2ZSBpbXBsZW1lbnRlZCB0aGUgc2V0X3Bvd2Vy
X21nbXQgY2FsbGJhY2sgZnVuY3Rpb24gZm9yIHBvd2VyIHNhdmluZyBoYW5kbGluZy4NCg0KRG8g
eW91IHRoaW5rIGlmIHdlIHNob3VsZCBhZGQgbmV3IG9wcyBmb3IgYXV0byBkZWVwIHNsZWVwPw0K
DQpUaGFua3MsDQpCaW5nDQoNCg==
