Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:32620 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751618Ab3JFL3K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Oct 2013 07:29:10 -0400
From: "Peer, Ilan" <ilan.peer@intel.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Jeff Johnson <jjohnson@qca.qualcomm.com>
CC: "Spinadel, David" <david.spinadel@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>, Jouni Malinen <j@w1.fi>,
	"Ginsburg, Noam" <noam.ginsburg@intel.com>,
	"Perelmooter, Liraz" <liraz.perelmooter@intel.com>,
	"Shalev, Oz" <oz.shalev@intel.com>,
	"Michael Green" <green@qca.qualcomm.com>
Subject: RE: [PATCH 3/3] [RFC] cfg80211: Enable GO operation on additional
 channels
Date: Sun, 6 Oct 2013 11:28:36 +0000
Message-ID: <CB3B3D4774441E42AA3EA0E1BA8230A0332F99C6@HASMSX106.ger.corp.intel.com> (sfid-20131006_132926_644465_B1CACD77)
References: <1372768095-26053-1-git-send-email-ilan.peer@intel.com>
 <1372768095-26053-4-git-send-email-ilan.peer@intel.com>
 <CAB=NE6VQXQPRK9_Q-Nh+ripRa+PdCd=4_EZvPxeghBjc32ejyQ@mail.gmail.com>
 <CB3B3D4774441E42AA3EA0E1BA8230A01AD2DFC5@HASMSX106.ger.corp.intel.com>
 <CAB=NE6WY43BYDehH5-MyF0GQORC1dTrNToUsRVC-Q5bDwcna3A@mail.gmail.com>
 <CB3B3D4774441E42AA3EA0E1BA8230A01AD31E3C@HASMSX106.ger.corp.intel.com>
 <CAB=NE6Vcqrs-US-HJzxcnFhjF0-dsnvPdcWoUpuo-UDV_5cReQ@mail.gmail.com>
 <CAB=NE6WmEQg68BViF9v+2D__p8Gc_5bCFUkBMfTz0A96C1jyDw@mail.gmail.com>
In-Reply-To: <CAB=NE6WmEQg68BViF9v+2D__p8Gc_5bCFUkBMfTz0A96C1jyDw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBtY2dyb2ZAZ21haWwuY29tIFtt
YWlsdG86bWNncm9mQGdtYWlsLmNvbV0gT24gQmVoYWxmIE9mIEx1aXMgUi4NCj4gUm9kcmlndWV6
DQo+IFNlbnQ6IEZyaWRheSwgT2N0b2JlciAwNCwgMjAxMyAyMDozOA0KPiBUbzogUGVlciwgSWxh
bjsgSmVmZiBKb2huc29uDQo+IENjOiBTcGluYWRlbCwgRGF2aWQ7IGxpbnV4LXdpcmVsZXNzOyB3
aXJlbGVzcy1yZWdkYkBsaXN0cy5pbmZyYWRlYWQub3JnOyBKb3VuaQ0KPiBNYWxpbmVuOyBHaW5z
YnVyZywgTm9hbTsgUGVyZWxtb290ZXIsIExpcmF6OyBTaGFsZXYsIE96OyBNaWNoYWVsIEdyZWVu
DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggMy8zXSBbUkZDXSBjZmc4MDIxMTogRW5hYmxlIEdPIG9w
ZXJhdGlvbiBvbiBhZGRpdGlvbmFsDQo+IGNoYW5uZWxzDQo+IA0KPiBPbiBUaHUsIEp1bCAxOCwg
MjAxMyBhdCA0OjM0IFBNLCBMdWlzIFIuIFJvZHJpZ3VleiA8bWNncm9mQGRvLW5vdC0NCj4gcGFu
aWMuY29tPiB3cm90ZToNCj4gPiBPbiBXZWQsIEp1bCAxNywgMjAxMyBhdCAxMjoxNSBQTSwgUGVl
ciwgSWxhbiA8aWxhbi5wZWVyQGludGVsLmNvbT4gd3JvdGU6DQo+ID4+PiBJdCB3YXMgdW5jbGVh
ciBmb3Igd2hhdCBleGFjdCBjaGFubmVscyB5b3UgbmVlZGVkIHRvIGRlYWwgd2l0aCBoZXJlLg0K
PiA+Pj4gR2l2ZW4gcmV2aWV3IHNvIGZhciB3b3VsZG4ndCBpdCBqdXN0IGJlIERGUyBmbGFnZ2Vk
IGNoYW5uZWxzIG9uIHNvbWUNCj4gPj4+IFVOSUkgYmFuZHMgPyBUaGVuIGFnYWluIGlmIHRoZSBp
bmRvb3IgZmxhZyBuZWVkcyB0byBiZSBwZWdnZWQgdG8gdG8NCj4gPj4+IGEgc3BlY2lmaWMgVU5J
SSBiYW5kIGFuZCB3ZSBjYW4gZG8gdGhhdCBvbiB3aXJlbGVzcy1yZWdkYiBkbyB3ZSBldmVuDQo+
ID4+PiBuZWVkIHRoZSBVTklJIGJhbmQgY2hlY2sgcm91dGluZSBoZWxwZXI/DQo+ID4+Pg0KPiA+
Pg0KPiA+PiBHZW5lcmFsbHkgaXQgaXMgcG9zc2libGUgdGhhdCB0aGUgaW5kb29yIHByb3BlcnR5
IGlzIG5vdCBwZWdnZWQgdG8NCj4gPj4gdGhlICdvdGhlcl9jaGFubmVsJywgb3IgaXQgaXMgcG9z
c2libGUgdGhhdCBpdCBpcyBwZWdnZWQgYnV0IHRoZXkgYXJlDQo+ID4+IG5vdCBpbiB0aGUgc2Ft
ZSBVTklJIGJhbmQsIHNvIHRoZSB2ZXJpZmljYXRpb24gaXMgc3RpbGwgbmVlZGVkLiBJDQo+ID4+
IGd1ZXNzIHRoYXQgb25jZSBJIGdldCB0aGUgbGlzdCB5b3UgcmVxdWVzdGVkIHRoaW5ncyB3aWxs
IGJlIGNsZWFyZXINCj4gPj4gOikNCj4gPg0KPiA+IE9LIHNvIHRoZXJlIGFyZSBleGNlcHRpb25z
IHRvIHRoZSBpbmRvb3IgZmxhZyBhZmZlY3RpbmcgR08gdW5kZXIgdGhlc2UNCj4gPiBydWxlcyBv
ciBub3QuIExvb2tpbmcgZm9yd2FyZCB0byB0aGUgcmVzcGluLg0KPiANCj4gQW54aW91c2x5IGxv
b2tpbmcgZm9yd2FyZCB0byB0aGUgcmVzcGluIDpEDQo+IA0KDQpNZSB0b28gOykgLi4uIHVuZm9y
dHVuYXRlbHkgSSBkaWQgbm90IGdldCBhIGNoYW5jZSB0byB3b3JrIG9uIHRoaXMgaW4gdGhlIGxh
c3QgY291cGxlIG9mIG1vbnRocy4gSG9wZSBJJ2xsIGdldCB0byBpdCB0aGlzIHdlZWsgb3IgdGhl
IG5leHQuIFNvcnJ5IGZvciBub3QgdXBkYXRpbmcgZWFybGllciAuLi4NCg0KUmVnYXJkcywNCg0K
SWxhbi4NCg0K
