Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:46728 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755383AbdKJBuD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Nov 2017 20:50:03 -0500
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: Dave Taht <dave.taht@gmail.com>,
        =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
        Kalle Valo <kvalo@codeaurora.org>
CC: "make-wifi-fast@lists.bufferbloat.net"
        <make-wifi-fast@lists.bufferbloat.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: RE: [Make-wifi-fast] [PATCH] ath10k: Re-enable TXQs for all devices
Date: Fri, 10 Nov 2017 01:49:55 +0000
Message-ID: <a7b75767d01b46ef818f86dbd0c657a8@NALASEXR01H.na.qualcomm.com> (sfid-20171110_025007_305551_13FC41A7)
References: <20171109071945.11033-1-toke@toke.dk>
 <6112ae948ba2409da27709d01da567eb@NALASEXR01H.na.qualcomm.com>
 <87k1yzq9i8.fsf@toke.dk>
 <CAA93jw6yw5=ALMdRaRrGU9uySmov9HwM-mr2npRbzsSxHgSAGw@mail.gmail.com>
In-Reply-To: <CAA93jw6yw5=ALMdRaRrGU9uySmov9HwM-mr2npRbzsSxHgSAGw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PiA+DQo+ID4gVGhlIGlzc3VlIHRoYXQgc2VlbXMgdG8gcG9pbnQgdG8gaGFzIGJlZW4gZml4ZWQg
YSB3aGlsZSBhZ287IEknbGwgc2VuZA0KPiA+IGFuZCB1cGRhdGVkIHBhdGNoIHdpdGggYSBiZXR0
ZXIgY29tbWl0IG1lc3NhZ2UgKGFsc28gZm9yZ290IHRvIGNjIHRoZQ0KPiA+IGF0aDEwayBsaXN0
LCBJIHNlZSkuDQo+ID4NCj4gPiAtVG9rZQ0KPiANCj4gSG1tLiBJIHJlbWVtYmVyIHRoYXQgdGhy
ZWFkLiBJIHRob3VnaHQgd2UnZCBiYXNpY2FsbHkgcmVzb2x2ZWQgdGhhdCBpc3N1ZSAoNDUlDQo+
IG9mIHRoZSB0aW1lIHNwZW50IGluIGZxX2NvZGVsX2Ryb3AgdW5kZXIgdWRwIGZsb29kKSwgYmFj
ayB0aGVuLCB3aXRoIGVyaWMgYWRkaW5nDQo+IHRoZSBiYXRjaCBkcm9wIGZpeCB0byBmcV9jb2Rl
bCBpdHNlbGY6DQo+IA0KPiBTZWUgY29tbWl0OiBodHRwczovL29zZG4ubmV0L3Byb2plY3RzL2Fu
ZHJvaWQtDQo+IHg4Ni9zY20vZ2l0L2tlcm5lbC9jb21taXRzLzlkMTg1NjJhMjI3ODc0Mjg5ZmRh
OGNhNWQxMTdkOGY1MDNmMWRjY2ENCj4gDQo+IHdoaWNoIGZpeGVkIHVwIHRoZSBwcm9ibGVtIGJl
YXV0aWZ1bGx5Og0KPiANCj4gaHR0cHM6Ly9saXN0cy5idWZmZXJibG9hdC5uZXQvcGlwZXJtYWls
L21ha2Utd2lmaS1mYXN0LzIwMTYtTWF5LzAwMDU5MC5odG1sDQo+IA0KPiBTbyBpZiB3ZSd2ZSBi
ZWVuIGNhcnJ5aW5nIHRoaXMgZGFybiBwYXRjaCBmb3IgdGhlIGF0aDEwayB2cyBzb21ldGhpbmcg
dGhhdCB3ZSdkDQo+IGFjdHVhbGx5IGZpeGVkIGVsc2V3aGVyZSBpbiB0aGUgc3RhY2ssIGZvciBv
dmVyIGEgeWVhciwgc2lnaC4NCj4NCkRhdmUsDQoNCkFncmVlLi4gRXZlbiBJIGFtIG5vdCBmYW4g
b2YgdGhhdCBwYXRjaCBpbiBhdGgxMGsuIElJUkMgTWljaGFsIHB1c2hlZCB0aGlzDQpjaGFuZ2Ug
YXMgdGVtcCBvbmUgYW5kIHBsYW5uZWQgdG8gcmV2ZXJ0IGl0IG9uY2UgaXQgaXMgZml4ZWQgaW4g
c3RhY2sgb3IgaW4gZHJpdmVyLg0KDQpJIHRob3VnaHQgRXJpYyBjaGFuZ2UgaW4gZnFfY29kZWwg
aXMgbWVhbnQgb25seSBmb3IgZmF0dHkgdWRwIGZsb3dzLiBGb3JnaXZlIG15IGlnbm9yYW5jZS4N
Cg0KLVJhamt1bWFyDQoNCg==
