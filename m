Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:36758 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751173AbdLMKe6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Dec 2017 05:34:58 -0500
From: Ganapathi Bhat <gbhat@marvell.com>
To: Ellie Reeves <ellierevves@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "amitkarwar@gmail.com" <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Xinming Hu <huxm@marvell.com>
Subject: RE: [EXT] Marvell Mwifiex wireless driver: mwifiex_pcie broken on
 Marvell ESPRESSOBin
Date: Wed, 13 Dec 2017 10:34:55 +0000
Message-ID: <8341b7bb8ccb4137b8143f4a312ab83f@SC-EXCH02.marvell.com> (sfid-20171213_113506_657820_2233DEAD)
References: <6dc0221c-c7ec-d107-02e8-0ab443807e51@gmail.com>
 <a4233e0d08f1400fa30ef112e0fda464@SC-EXCH02.marvell.com>
 <7d8c7705-70ac-9a36-b5d2-23fcffcf6a29@gmail.com>
 <4dbd89bbcb0a4706bf3fe7b79025d95c@SC-EXCH02.marvell.com>
 <6e26f5b1-10a7-b7fc-1518-f0d0f66a50e9@gmail.com>
 <44a8b2b8-d798-0e5d-0da1-c2bea52463bc@gmail.com>
 <0c5acf38-d634-12b6-9f0d-0ae8c6535558@gmail.com>
In-Reply-To: <0c5acf38-d634-12b6-9f0d-0ae8c6535558@gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgRWxsaWUNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBFbGxpZSBS
ZWV2ZXMgW21haWx0bzplbGxpZXJldnZlc0BnbWFpbC5jb21dDQo+IFNlbnQ6IEZyaWRheSwgRGVj
ZW1iZXIgMDEsIDIwMTcgOTowNyBQTQ0KPiBUbzogR2FuYXBhdGhpIEJoYXQNCj4gQ2M6IGxpbnV4
LXdpcmVsZXNzQHZnZXIua2VybmVsLm9yZzsgYW1pdGthcndhckBnbWFpbC5jb207IE5pc2hhbnQN
Cj4gU2FybXVrYWRhbTsgWGlubWluZyBIdQ0KPiBTdWJqZWN0OiBSZTogW0VYVF0gTWFydmVsbCBN
d2lmaWV4IHdpcmVsZXNzIGRyaXZlcjogbXdpZmlleF9wY2llIGJyb2tlbiBvbg0KPiBNYXJ2ZWxs
IEVTUFJFU1NPQmluDQo+DQo+IEhpLA0KPiBqdXN0IGEgc2hvcnQgbWVzc2FnZSB0byBtZW50aW9u
IEkgYm9vdGVkIHRoZSA0LjE0IGtlcm5lbCBhbmQgZ3JhYmJlZCB3aGF0DQo+IHdhcyBpbiAvc3lz
L2NsYXNzL2RldmNvcmVkdW1wL2RldmNkMS9kYXRhIGludG8gYSBmaWxlLiBJJ20gbm90IHN1cmUg
aWYgaXQNCj4gY291bGQgYmUgdXNlZnVsLCBidXQgZGlkIGl0IGFueXdheXMuLi4gTGV0IG1lIGtu
b3cgaWYgaXQncyB1c2VmdWwgYW5kIEknbGwgcG9zdA0KPiB0aGUgYmluYXJ5IHNvbWV3aGVyZS4N
Cj4gVGhhbmtzDQpZb3UgY2FuIHNoYXJlIHRoYXQuICBBZGRpdGlvbmFsbHksIGNhbiB5b3Ugc2hh
cmUgdGhlIGRtZXNnIGxvZ3Mgd2l0aCBleHRlbnNpdmUgbG9nIGxldmVsLg0KWW91IGNhbiB1c2Ug
YmVsb3cgY29tbWFuZCB0byBzZXQgdGhlIHNhbWU6DQplY2hvICAgIDB4ZmZmZmZmZmYgICAgICA+
ICAgICAgIC9zeXMva2VybmVsL2RlYnVnL213aWZpZXgvbWxhbjAvZGVidWdfbWFzaw0KPg0KPiAt
LS0tLS0tLSBNZXNzYWdlIG9yaWdpbmFsIC0tLS0tLS0tDQo+ID4gSGkgYWdhaW4sDQo+ID4gSSB0
cmllZCB0aGUgZmV3IHBhdGNoIHRoYXQgbWFkZSBpdCB0byB0aGlzIGxpc3Qgd2l0aG91dCBhbnkg
cmVhbA0KPiA+IHN1Y2Nlc3MuLi4gSSBzdXBwb3NlIHRoZSBpc3N1ZSBpc24ndCB0aGF0IGVhc3kg
dG8gcmVwcm9kdWNlIG9uIHlvdXINCj4gPiBzaWRlIHNvLi4uIFNoYWxsIEkgdHJ5IGEgZ2l0IGJp
c2VjdCwgYnVpbGRpbmcgb25seSB0aGF0IG1vZHVsZSBhbmQgc2VlDQo+ID4gaWYgSSBjYW4gbmFy
cm93IGl0IGRvd24gYSBiaXQgPyBJJ20gbm8gZXhwZXJ0IHdpdGggZ2l0IG9yIGdpdCBiaXNlY3QN
Cj4gPiBmb3IgdGhhdCBtYXR0ZXIsIGJ1dCBJJ20gZ3Vlc3NpbmcgYnVpbGRpbmcgdGhlIG1vZHVs
ZSB3aWxsIGJlIGxlc3MNCj4gPiB0aW1lIGNvbnN1bWluZyB0aGFuIGJ1aWxkaW5nIHRoZSBlbnRp
cmUga2VybmVsLi4uIFVubGVzcyB5b3Ugd2FudCBtZQ0KPiA+IHRvIGRvIHNvbWV0aGluZyBlbHNl
IHRvIGhlbHAgaW4gZGVidWdnaW5nLiBJIHdhbnQgdG8gaGVscCBhcyBtdWNoIGFzIEkNCj4gPiBj
YW4gdG8gc29sdmUgdGhpcywgaGVoLCBldmVuIGRlc3BpdGUgbWUgYW5ub3lpbmcgbXkgZmF0aGVy
IGJlY2F1c2UgaGlzDQo+ID4gd2lmaSBhY2Nlc3MgcG9pbnQgZ29lcyBwb29mLiA6KSBUaGFua3Ms
DQo+ID4NCj4NCj4gLS0NCj4gRWxsaWUgUmVldmVzDQoNCg==
