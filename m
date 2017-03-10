Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:55276 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935727AbdCJMGE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Mar 2017 07:06:04 -0500
From: "Coelho, Luciano" <luciano.coelho@intel.com>
To: "axboe@kernel.dk" <axboe@kernel.dk>
CC: "Kaufman, Liad" <liad.kaufman@intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Sharon, Sara" <sara.sharon@intel.com>
Subject: Re: WARNING: CPU: 1 PID: 23668 at
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c:1539 iwl_mvm_rm_sta+0x3ce/0x450
Date: Fri, 10 Mar 2017 12:02:41 +0000
Message-ID: <1489147360.22435.15.camel@intel.com> (sfid-20170310_130616_779986_7EDF10C4)
References: <f2bedfee-e74f-47d6-9088-94171f0e5538@email.android.com>
         <05fff778-8703-f429-f555-aa533c2df25f@kernel.dk>
         <fdfbfffa-31c9-7646-82b5-b6a759b73d21@kernel.dk>
         <1489147283.22435.14.camel@coelho.fi>
In-Reply-To: <1489147283.22435.14.camel@coelho.fi>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gRnJpLCAyMDE3LTAzLTEwIGF0IDE0OjAxICswMjAwLCBMdWNhIENvZWxobyB3cm90ZToNCj4g
SGkgSmVucywNCj4gDQo+IE9uIFRodSwgMjAxNy0wMy0wOSBhdCAyMTo0MSAtMDcwMCwgSmVucyBB
eGJvZSB3cm90ZToNCj4gPiBPbiAwMy8wMS8yMDE3IDA5OjEwIFBNLCBKZW5zIEF4Ym9lIHdyb3Rl
Og0KPiA+ID4gT24gMDMvMDEvMjAxNyAwODozMyBQTSwgTHVjYSBDb2VsaG8gd3JvdGU6DQo+ID4g
PiA+IEhpIEplbnMsDQo+ID4gPiA+IA0KPiA+ID4gPiBPbiBNYXIgMSwgMjAxNyAyMDoyNSwgSmVu
cyBBeGJvZSA8YXhib2VAa2VybmVsLmRrPiB3cm90ZToNCj4gPiA+ID4gDQo+ID4gPiA+ICAgICBO
b3QgdGhhdCBmb2xrcyBoYXZlIGJlZW4ganVtcGluZyBhbGwgb3ZlciB0aGlzLCBidXQgaW4gY2Fz
ZSBzb21lb25lIGlzDQo+ID4gPiA+ICAgICBjdXJpb3VzLCBpdCB0cmlnZ2VyZWQgdHdpY2UgaGVy
ZSB0b2RheS4gRm9yIHRob3NlIHR3byB0aW1lcywgdGhlIHZhbHVlDQo+ID4gPiA+ICAgICBvZiBt
dm0tPnBlbmRpbmdfZnJhbWVzW3N0YV9pZF0gd2FzIDgwIGFuZCAzOSwgcmVzcGVjdGl2ZWx5Lg0K
PiA+ID4gPiANCj4gPiA+ID4gU29ycnkgZm9yIHRoZSBkZWxheSwgSSdtIG9uIHZhY2F0aW9uIG5v
dyB3aXRoIGxpbWl0ZWQgaW50ZXJuZXQgYWNjZXNzLg0KPiA+ID4gPiBCdXQgd2UnbGwgdGFrZSBh
IGxvb2sgaW50byB0aGlzIGVhcmx5IG5leHQgd2VlayBhdCB0aGUgbGF0ZXN0Lg0KPiA+ID4gPiAN
Cj4gPiA+ID4gVGhhbmtzIGEgbG90IGZvciB0aGUgZGV0YWlsZWQgcmVwb3J0IQ0KPiA+ID4gDQo+
ID4gPiBObyB3b3JyaWVzLCB0aGFua3MgZm9yIHJlc3BvbmRpbmcuIEkganVzdCB3YW50ZWQgdG8g
ZW5zdXJlIHRoaXMgd2Fzbid0DQo+ID4gPiBkcm9wcGVkIG9uIHRoZSBmbG9vci4NCj4gPiA+IA0K
PiA+ID4gQlRXLCBhIGZldyBtb3JlIHZhbHVlcyBvZiAtPnBlbmRpbmdfZnJhbWVzW3N0YV9pZF06
DQo+ID4gPiANCj4gPiA+ICQgZG1lc2cgfCBncmVwICJyZXQ9Ig0KPiA+ID4gWyAyMzM0LjMwODI1
NF0gcmV0PTM5DQo+ID4gPiBbIDc5MTUuMzExODI4XSByZXQ9ODANCj4gPiA+IFszMTYwMi4zMTcy
MDRdIHJldD00MQ0KPiA+ID4gWzMyMTM5LjUxMDk5M10gcmV0PTU0DQo+ID4gPiBbMzMyOTIuOTE3
NzU5XSByZXQ9OTYNCj4gPiA+IA0KPiA+ID4gaXQgc2VlbXMgdG8gb2Z0ZW4gaGFwcGVuIGFyb3Vu
ZCByZXN1bWUuDQo+ID4gDQo+ID4gVGhpcyBpcyBzdGlsbCBoYXBwZW5pbmcgYWxsIHRoZSB0aW1l
IGluIGN1cnJlbnQgLWdpdC4NCj4gDQo+IENvdWxkIHlvdSBjb2xsZWN0IHRyYWNlcyB3aXRoIHRy
YWNlLWNtZCwgYXMgZXhwbGFpbmVkIGluIG91ciB3aWtpWzFdPw0KPiBUaGlzIHdpbGwgcHJvYmFi
bHkgaGVscCBwb2ludCBvdXQgdGhlIHByb2JsZW0uICBJIGtub3cgaXQncyBhIGJpdA0KPiBkaWZm
aWN1bHQgYmVjYXVzZSBpdCBhcHBlYXJzIHRvIGhhcHBlbiByYW5kb21seSBmb3IgeW91LCBidXQg
aXQncyB3b3J0aA0KPiB0cnlpbmcuDQoNCkFuZCBvZiBjb3Vyc2UsIHRoZSBsaW5rIEkgd2FudGVk
IHRvIGdpdmUgeW91IGlzIHRoaXM6DQoNClsxXSBodHRwczovL3dpcmVsZXNzLndpa2kua2VybmVs
Lm9yZy9lbi91c2Vycy9kcml2ZXJzL2l3bHdpZmkvZGVidWdnaW5nI3RyYWNpbmcNCg0KDQotLQ0K
THVjYS4=
