Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:11271 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751203AbcKIUHS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Nov 2016 15:07:18 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>
CC: Tim Shepard <shep@alum.mit.edu>,
        "make-wifi-fast@lists.bufferbloat.net"
        <make-wifi-fast@lists.bufferbloat.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "nbd@nbd.name" <nbd@nbd.name>
Subject: Re: [v5] ath9k: Switch to using mac80211 intermediate software
 queues.
Date: Wed, 9 Nov 2016 20:07:12 +0000
Message-ID: <87a8d8v2mo.fsf@qca.qualcomm.com> (sfid-20161109_210723_422479_1FAC4F57)
References: <E1c4IsV-0003Rk-00@www.xplot.org> <87k2cd0waf.fsf@toke.dk>
In-Reply-To: <87k2cd0waf.fsf@toke.dk> ("Toke =?utf-8?Q?H=C3=B8iland-J?=
 =?utf-8?Q?=C3=B8rgensen=22's?= message of      "Wed, 09 Nov 2016 11:42:16 +0100")
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2VuIDx0b2tlQHRva2UuZGs+IHdyaXRlczoNCg0KPiBUaW0g
U2hlcGFyZCA8c2hlcEBhbHVtLm1pdC5lZHU+IHdyaXRlczoNCj4NCj4+PiBXaGlsZSBhdCBpdCwg
Y291bGQgeW91IGFsc28gYWRkIHRvIHRoZSBjb21taXQgbG9nIHNvbWUgaW5mbyBob3cgYXdlc29t
ZSB0aGlzDQo+Pj4gcGF0Y2ggaXMgZnJvbSB1c2VyJ3MgcG9pbnQgb2YgdmlldyBhbmQgaG93IGl0
IGhlbHBzLiBGb3IgZXhhbXBsZSwgYmVmb3JlIGFuZA0KPj4+IGFuZCBhZnRlciBudW1iZXJzIGFu
ZCBvdGhlciByZXN1bHRzLg0KPj4NCj4+IFRoYXQgdmFyaWVzIHdpbGRseSwgZGVwZW5kaW5nIG9u
IG1hbnkgZGV0YWlscyBvZiB0aGUgc2NlbmFyaW8NCj4+IChpbmNsdWRpbmcgdGhlIHdpcmVsZXNz
IGNhcGFiaWxpdGllcyBvZiB0aGUgY2xpZW50cyBjb25uZWN0ZWQgdG8gdGhlDQo+PiBBUCB1c2lu
ZyB0aGlzIHBhdGNoLCBhbmQgaG93IGZhciBhd2F5IHRob3NlIGNsaWVudHMgYXJlKS4gVGhlcmUn
cw0KPj4gcmVhbGx5IG5vdCBlbm91Z2ggcm9vbSBpbiBhIGNvbW1pdCBtZXNzYWdlIHRvIGV4cGxh
aW4gZW5vdWdoIHRvIG1ha2UNCj4+IGFueSBzdWNoIGNsYWltZWQgbnVtYmVycyByZXByb2R1Y2li
bGUuDQo+DQo+IEkgZGlzYWdyZWU7IGl0J3MgcXVpdGUgc3RyYWlnaHRmb3J3YXJkIHRvIGRlbW9u
c3RyYXRlIGEgZ2FpbiBmcm9tIHRoaXMNCj4gb24gYW4gYXRoOWsgYWNjZXNzIHBvaW50LiBBbmQg
d2hpbGUgb2YgY291cnNlIHRoZSBtYWM4MDIxMSBxdWV1ZXMgaXMgdGhlDQo+IHJlYXNvbiBmb3Ig
dGhpcywgdGhlIGNvbW1pdCB0aGF0IHVzZXMgaXQgKGkuZS4gdGhpcyBvbmUpIGNhbiBleHBsYWlu
DQo+IHRoYXQgYW5kIGluY2x1ZGUgc29tZSBudW1iZXJzLg0KDQpZZWFoLCBzbyB3aXRoIHRoYXQg
eW91IGFyZSBiYXNpY2FsbHkgYW5zd2VyaW5nICJXaHk/IiBwYXJ0IGluIHRoZSBjb21taXQNCmxv
ZyBzbyB0aGF0IG90aGVycyBjYW4gYWxzbyB1bmRlcnN0YW5kIHRoZSBtb3RpdmF0aW9uIGJlaGlu
ZCBhbGwgdGhpcy4NCg0KPiBJJ2xsIGFkZCB0aGF0IGFuZCByZXNlbmQgOikNCg0KVGhhbmtzLiBB
bmQgc29ycnkgZm9yIHRha2luZyBzbyBsb25nIHdpdGggdGhpcywgSSBoYXZlIGJlZW4gYmFzaWNh
bGx5DQp0cmF2ZWxsaW5nIG1vc3Qgb2YgdGhlIGxhc3QgbW9udGguIEkgc2hvdWxkIGdldCBiYWNr
IGhvbWUgb24gRnJpZGF5IGFuZA0KdGhpbmdzIHNob3VsZCBnZXQgbm9ybWFsIHNvb24uDQoNCi0t
IA0KS2FsbGUgVmFsbw==
