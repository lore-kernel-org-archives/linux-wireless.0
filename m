Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:3630 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321AbaL3U2t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2014 15:28:49 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: "jkosina@suse.cz" <jkosina@suse.cz>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"egrumbach@gmail.com" <egrumbach@gmail.com>,
	"peter@hurleysoftware.com" <peter@hurleysoftware.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"Berg, Johannes" <johannes.berg@intel.com>
Subject: Re: iwlwifi-driver card doesn't work with 3.19-rc2+
Date: Tue, 30 Dec 2014 20:28:23 +0000
Message-ID: <1419971304.30412.0.camel@egrumbacBox> (sfid-20141230_212915_966000_A05336BD)
References: <alpine.LNX.2.00.1412301427430.31609@pobox.suse.cz>
	 <CANUX_P0=wJiKrR4cUgEN=LO+eQ2byprz0K9m9QxzJc+kf4+_bA@mail.gmail.com>
	 <54A2B807.1020202@hurleysoftware.com>
	 <0BA3FCBA62E2DC44AF3030971E174FB31B5DC915@hasmsx107.ger.corp.intel.com>
	 <alpine.LNX.2.00.1412301610320.31609@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1412301610320.31609@pobox.suse.cz>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gVHVlLCAyMDE0LTEyLTMwIGF0IDE2OjIxICswMTAwLCBKaXJpIEtvc2luYSB3cm90ZToNCj4g
T24gVHVlLCAzMCBEZWMgMjAxNCwgR3J1bWJhY2gsIEVtbWFudWVsIHdyb3RlOg0KPiANCj4gPiA+
ID4gU28gd2h5IGRvIHlvdSB1c2VkIHRoZW0/DQo+ID4gPiA+IFRoZXkgaGF2ZSBiZWVuIGRlcHJl
Y2F0ZWQgZm9yIGEgY291cGxlIG9mIHllYXJzIG5vdy4gWW91IHNob3VsZCBiZQ0KPiA+ID4gPiB1
c2luZyBubDgwMjExIGJhc2VkIHRvb2xzIHN1Y2ggYXMgaXcuDQo+ID4gPiANCj4gPiA+IEEgY291
cGxlIG9mIHllYXJzIGlzIG5vdCB2ZXJ5IGxvbmcgd2hlcmUgdXNlcnNwYWNlIGlzIGNvbmNlcm5l
ZC4NCj4gPiA+IA0KPiA+IFdlbGwgLSB0aGUgZGVjZW50bHkgbmV3IHdpcmVsZXNzIHRvb2xzIGRv
IHRhbGsgbmw4MDIxMS4NCj4gDQo+IFdpdGggMy4xOC1yYzUsIEkgZ2V0IHRoaXM6DQo+IA0KPiAj
IGl3Y29uZmlnIC0tdmVyc2lvbg0KPiBpd2NvbmZpZyAgV2lyZWxlc3MtVG9vbHMgdmVyc2lvbiAz
MA0KPiAgICAgICAgICAgQ29tcGF0aWJsZSB3aXRoIFdpcmVsZXNzIEV4dGVuc2lvbiB2MTEgdG8g
djIyLg0KPiANCj4gS2VybmVsICAgIEN1cnJlbnRseSBjb21waWxlZCB3aXRoIFdpcmVsZXNzIEV4
dGVuc2lvbiB2MjIuDQo+IA0KPiB3bGFuMCAgICAgUmVjb21tZW5kIFdpcmVsZXNzIEV4dGVuc2lv
biB2MjEgb3IgbGF0ZXIsDQo+ICAgICAgICAgICBDdXJyZW50bHkgY29tcGlsZWQgd2l0aCBXaXJl
bGVzcyBFeHRlbnNpb24gdjIyLg0KPiANCj4gDQo+IFdpdGggMy4xOS1yYywgSSBnZXQgKHdpdGgg
dGhlIHNhbWUgdXNlcnNwYWNlKSB0aGlzOg0KPiANCj4gIyBpd2NvbmZpZyAtLXZlcnNpb24NCj4g
aXdjb25maWcgIFdpcmVsZXNzLVRvb2xzIHZlcnNpb24gMzANCj4gICAgICAgICAgIENvbXBhdGli
bGUgd2l0aCBXaXJlbGVzcyBFeHRlbnNpb24gdjExIHRvIHYyMi4NCj4gDQo+ICAgICAgICAgICBD
YW5ub3QgcmVhZCAvcHJvYy9uZXQvd2lyZWxlc3MNCj4gDQo+IEFuZCBub3RoaW5nIGVsc2UgKGl3
bGlzdCwgZXRjKSB3b3JrcyBlaXRoZXIuIFRoaXMgaXMgd2l0aA0KPiANCj4gIyBycG0gLXFpIHdp
cmVsZXNzLXRvb2xzIHwgZ3JlcCBWZXINCj4gVmVyc2lvbiAgICAgOiAzMC5wcmU5DQo+IA0KPiBm
cm9tIG9wZW5TVVNFIDEzLjIuIFRoYXQncyBub3QgZGVjZW50bHkgbmV3IGVub3VnaD8NCj4gDQoN
CllvdSBzaG91bGQgYWxzbyBoYXZlIHRoZSBpdyB0b29sIHdoaWNoIHdpbGwgcHJvdmlkZSBhbGwg
eW91IG5lZWQNCnVzaW5nIHRoZSBubDgwMjExIGludGVyZmFjZSB3aGljaCBpcyBub3cgdGhlIHBy
ZWZlcnJlZCBpbnRlcmZhY2UuDQoNCj4gPiBZb3UgY2FuIHN0aWxsIGVuYWJsZSBpdCAoQ0ZHODAy
MTFfV0VYVCkuDQo+ID4gSXQgaGFzIGJlZW4gZGlzYWJsZWQgYnk6DQo+ID4gDQo+ID4gY29tbWl0
IDI0YTBhYTIxMmVlMmRiZTQ0MzYwMjg4Njg0NDc4ZDc2YThlMjBhMGENCj4gPiBBdXRob3I6IEpv
aGFubmVzIEJlcmcgPGpvaGFubmVzLmJlcmdAaW50ZWwuY29tPg0KPiA+IERhdGU6ICAgRnJpIE5v
diAyOCAxMjoxNDowNiAyMDE0ICswMTAwDQo+ID4NCj4gPiAgICBjZmc4MDIxMTogbWFrZSBXRVhU
IGNvbXBhdGliaWxpdHkgdW5zZWxlY3RhYmxlDQo+IA0KPiBJIHRoaW5rIHRoaXMgbmVlZHMgdG8g
YmUgcmV2ZXJ0ZWQuDQo+IA0KDQo=
