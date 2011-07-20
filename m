Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:58054 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751178Ab1GTTlO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jul 2011 15:41:14 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Dan Williams <dcbw@redhat.com>
CC: Daniel Drake <dsd@laptop.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"libertas-dev@lists.infradead.org" <libertas-dev@lists.infradead.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Frank Huang <frankh@marvell.com>
Date: Wed, 20 Jul 2011 12:32:09 -0700
Subject: RE: [PATCH 1/4] libertas: remove auto_deep_sleep functionality
Message-ID: <477F20668A386D41ADCC57781B1F704307FFBB27DD@SC-VEXCH1.marvell.com> (sfid-20110720_214117_552805_415A281F)
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

SGkgRGFuLA0KDQo+ID4gPiA+IFRvIGVuYWJsZSBkZWVwIHNsZWVwIG1vZGU6DQo+ID4gPiA+IGl3
Y29uZmlnIHdsYW4wIHBvd2VyIHBlcmlvZCAwDQo+ID4gPiA+DQo+ID4gPiA+IFRvIGVuYWJsZSBh
dXRvIGRlZXAgc2xlZXAgbW9kZSB3aXRoIGlkbGUgdGltZSBwZXJpb2Qgc2V0IHRvIDUgc2Vjb25k
czoNCj4gPiA+ID4gaXdjb25maWcgd2xhbjAgcG93ZXIgcGVyaW9kIDUNCj4gPiA+ID4NCj4gPiA+
ID4gVG8gZGlzYWJsZSBkZWVwIHNsZWVwL2F1dG8gZGVlcCBzbGVlcCBtb2RlOg0KPiA+ID4gPiBp
d2NvbmZpZyB3bGFuMCBwb3dlciBwZXJpb2QgLTENCj4gPiA+DQo+ID4gPiBQYXVsIHBvaW50ZWQg
b3V0IHRoYXQgaW5kZWVkLCBpbiBvbGQga2VybmVscywgdGhpcyBmdW5jdGlvbmFsaXR5IHdhcw0K
PiA+ID4gaG9va2VkIHVwIHRvIHRoZSBwb3dlciB3aXJlbGVzcyBleHRlbnNpb24uDQo+ID4gPg0K
PiA+ID4gSW4gcmVjZW50IGtlcm5lbHMsIHRoaXMgaXMgbm90IHRoZSBjYXNlIC0gaXRzIG5vdCBo
b29rZWQgdXAgdG8NCj4gPiA+IGFueXRoaW5nLiBUaGUgY29tbWFuZHMgeW91IHdyaXRlIGFib3Zl
IHdpbGwgZmFpbC4NCj4gPg0KPiA+IFllYWguIEkgZGlkbid0IGtub3cgdGhhdCB0aGUgZW50aXJl
IHdleHQgaGFzIGJlZW4gcmVtb3ZlZCBmcm9tIGxpYmVydGFzLg0KPiA+DQo+ID4gQW55d2F5LCBm
b3IgdXNlcnMgd2hvIG5lZWQgdGhpcyBmZWF0dXJlIHdlIGNhbiBhZGQgYSBtb2R1bGUgcGFyYW1l
dGVyIHRvIGVuYWJsZSBpdCB3aXRoIHRoZSBwYXRjaA0KPiBiZWxvdy4gUGxlYXNlIGxldCBtZSBr
bm93IHdoYXQgeW91IHRoaW5rLg0KPiANCj4gSSdkIHJhdGhlciB3ZSBmaWd1cmUgb3V0IHNvbWUg
bmw4MDIxMS9jZmc4MDIxMSBrbm9iIGZvciB0aGlzIHJhdGhlciB0aGFuDQo+IGEgbW9kdWxlIHBh
cmFtZXRlcjsgd2UgY2FuIGNlcnRhaW5seSBhZGQgY2FsbHMgYW5kIGF0dHJpYnV0ZXMgdG8gbmw4
MDIxMQ0KPiBpZiB3ZSBuZWVkIHRvLg0KDQpBZ3JlZS4gQ29uZmlndXJhdGlvbiB2aWEgbmw4MDIx
MS9jZmc4MDIxMSBBUEkgaXMgdGhlIGJlc3Qgc29sdXRpb24uIEknbGwgY2hlY2sgb24gdGhhdC4N
Cg0KVGhhbmtzLA0KQmluZw0K
