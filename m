Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:23822 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932087AbdEDGGX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 May 2017 02:06:23 -0400
From: "Coelho, Luciano" <luciano.coelho@intel.com>
To: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>
Subject: Re: new warning at net/wireless/util.c:1236
Date: Thu, 4 May 2017 06:06:18 +0000
Message-ID: <1493877978.14233.85.camel@intel.com> (sfid-20170504_080629_073268_67BD16E6)
References: <CA+55aFxyp5gpUZEYHXLwyhbK6DMWf4RoVykGxq9FPtO=j4yJsw@mail.gmail.com>
         <87o9v99r3g.fsf@purkki.adurom.net>
In-Reply-To: <87o9v99r3g.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gVGh1LCAyMDE3LTA1LTA0IGF0IDA3OjM1ICswMzAwLCBLYWxsZSBWYWxvIHdyb3RlOg0KPiBM
aW51cyBUb3J2YWxkcyA8dG9ydmFsZHNAbGludXgtZm91bmRhdGlvbi5vcmc+IHdyaXRlczoNCj4g
DQo+ID4gU28gbXkgRGVsbCBYUFMgMTMgc2VlbXMgdG8gaGF2ZSBncm93biBhIG5ldyB3YXJuaW5n
IGFzIG9mIHRoZQ0KPiA+IG5ldHdvcmtpbmcgbWVyZ2UgeWVzdGVyZGF5Lg0KPiA+IA0KPiA+IFRo
aW5ncyBzdGlsbCB3b3JrLCBidXQgd2hlbiBpdCBzdGFydHMgd2FybmluZywgaXQgZ2VuZXJhdGVz
IGEgKmxvdCogb2YNCj4gPiBub2lzZSAoSSBnb3QgMzYgb2YgdGhlc2Ugd2l0aGluIGFib3V0IHRl
biBtaW51dGVzKS4NCj4gPiANCj4gPiBJIGhhdmUgbm8gaWRlYSB3aGF0IHRyaWdnZXJlZCBpdCwg
YmVjYXVzZSB3aGVuIEkgcmVib290ZWQgKG5vdCBiZWNhdXNlDQo+ID4gb2YgdGhpcyBpc3N1ZSwg
YnV0IGp1c3QgdG8gcmVib290IGludG8gYSBuZXdlciBrZXJuZWwpIEkgZG9uJ3Qgc2VlIGl0DQo+
ID4gYWdhaW4uDQo+ID4gDQo+ID4gVGhpcyBpcyBhbGwgcHJldHR5IHJlZ3VsYXIgd2lyZWxlc3Mg
LSBpdCdzIGludGVsIDgyNjAgd2lyZWxlc3MgaW4gYQ0KPiA+IGZhaXJseSBub3JtYWwgbGFwdG9w
Lg0KPiA+IA0KPiA+IFRoaW5ncyBzdGlsbCBzZWVtIHRvICp3b3JrKiBvaywgc28gdGhlIG9ubHkg
cHJvYmxlbSBoZXJlIGlzIHRoZSBvdmVybHkNCj4gPiB2ZXJib3NlIGFuZCB1c2VsZXNzIFdBUk5f
T04uIEl0IGRvZXNuJ3QgZXZlbiBwcmludCBvdXQgKndoaWNoKiByYXRlIGl0DQo+ID4gaXMgd2Fy
bmluZyBhYm91dCwgaXQganVzdCBkb2VzIHRoYXQgc3R1cGlkIHVuY29uZGl0aW9uYWwgV0FSTl9P
TigpDQo+ID4gd2l0aG91dCBldmVyIHNodXR0aW5nIHVwIGFib3V0IGl0Li4NCj4gPiANCj4gPiBU
aGUgV0FSTl9PTigpIHNlZW1zIHRvIGJlIG9sZCwgYnV0IG15IGxvZ3MgZG9uJ3Qgc2VlbSB0byBo
YXZlIGFueQ0KPiA+IG1lbnRpb24gb2YgdGhpcyB1bnRpbCB0b2RheSwgc28gdGhlcmUncyBzb21l
dGhpbmcgdGhhdCBoYXMgY2hhbmdlZA0KPiA+IHRoYXQgbm93IHRyaWdnZXJzIGl0Lg0KPiA+IA0K
PiA+IElkZWFzPw0KPiA+IA0KPiA+ICAgICAgICAgICAgICAgICAgIExpbnVzDQo+ID4gDQo+ID4g
LS0tDQo+ID4gDQo+ID4gV0FSTklORzogQ1BVOiAzIFBJRDogMTEzOCBhdCBuZXQvd2lyZWxlc3Mv
dXRpbC5jOjEyMzYNCj4gPiBjZmc4MDIxMV9jYWxjdWxhdGVfYml0cmF0ZSsweDEzOS8weDE3MCBb
Y2ZnODAyMTFdDQo+IA0KPiBBcyB0aGlzIGlzIHdpdGggaXdsd2lmaSBhZGRpbmcgYWxzbyBMdWNh
LiBUaGVyZSB3ZXJlIHNvbWUgcmF0ZSBoYW5kbGluZw0KPiBjaGFuZ2VzIGluIGl3bHdpZmksIGxp
a2UgY29tbWl0IDc3ZTQwOTQ1NWY0MSwgYnV0IGRvbid0IGtub3cgaWYgdGhhdA0KPiBjb3VsZCBj
YXVzZSB0aGlzLg0KDQpUaGFua3MgS2FsbGUuICBJIGRvbid0IHNlZSBhbnl0aGluZyBpbiB0aGUg
aXdsd2lmaSBkcml2ZXIgdGhhdCBjb3VsZCBiZQ0KY2F1c2luZyB0aGlzLiAgSm9oYW5uZXMgc3Vz
cGVjdHMgc29tZSBSWCByYXRlIGNoYW5nZXMgaGUgbWFkZSBpbg0KbWFjODAyMTEuLi4NCg0KLS0N
Ckx1Y2Eu
