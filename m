Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:50861 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753254AbeDMLWr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Apr 2018 07:22:47 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Alfonso Sanchez-Beato <alfonso.sanchez-beato@canonical.com>
CC: "ath6kl@lists.infradead.org" <ath6kl@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: use WMI to set RSN capabilities
Date: Fri, 13 Apr 2018 11:22:39 +0000
Message-ID: <87bmens64i.fsf@kamboji.qca.qualcomm.com> (sfid-20180413_132250_453825_72E4D2B0)
References: <20180412154159.13934-1-alfonso.sanchez-beato@canonical.com>
        <87zi27s7pj.fsf@kamboji.qca.qualcomm.com>
        <CACM4vuDrEu0fz_hqh17kzuaQ8F8TCCr-uqt1rZttk1m8_fPTaA@mail.gmail.com>
In-Reply-To: <CACM4vuDrEu0fz_hqh17kzuaQ8F8TCCr-uqt1rZttk1m8_fPTaA@mail.gmail.com>       (Alfonso
 Sanchez-Beato's message of "Fri, 13 Apr 2018 13:19:11 +0200")
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

QWxmb25zbyBTYW5jaGV6LUJlYXRvIDxhbGZvbnNvLnNhbmNoZXotYmVhdG9AY2Fub25pY2FsLmNv
bT4gd3JpdGVzOg0KDQo+IE9uIEZyaSwgQXByIDEzLCAyMDE4IGF0IDEyOjQ4IFBNLCBLYWxsZSBW
YWxvIDxrdmFsb0BxY2EucXVhbGNvbW0uY29tPiB3cm90ZToNCj4+DQo+PiBBbGZvbnNvIFPDoW5j
aGV6LUJlYXRvIDxhbGZvbnNvLnNhbmNoZXotYmVhdG9AY2Fub25pY2FsLmNvbT4gd3JpdGVzOg0K
Pj4NCj4+ID4gVGhpcyBmaXhlcyBBUCBtb2RlIHdoZW4gdGhlIEFUSDZLTF9GV19DQVBBQklMSVRZ
X1JTTl9DQVBfT1ZFUlJJREUgZmxhZw0KPj4gPiBpcyBub3QgcHJlc2VudCBpbiB0aGUgRlcuIFRo
ZSBpZCBvZiBzb21lIFdNSSBjb21tYW5kcyBpcyBhbHNvIGZpeGVkDQo+PiA+ICh0aGVyZSB3YXMg
YW4gZXJyb3IgaW4gdGhlIGVudW0gb3JkZXIpLCBhbmQgYSBmdW5jdGlvbiB0byBzZXQgUlNOIGNh
cHMNCj4+ID4gaXMgYWRkZWQuDQo+PiA+DQo+PiA+IFNpZ25lZC1vZmYtYnk6IEFsZm9uc28gU8Oh
bmNoZXotQmVhdG8gPGFsZm9uc28uc2FuY2hlei1iZWF0b0BjYW5vbmljYWwuY29tPg0KPj4NCj4+
IFdoYXQgaGFyZHdhcmUgYW5kIGZpcm13YXJlIHZlcnNpb24/IERvIG5vdGUgdGhhdCBpZHMgY2Fu
IGNoYW5nZSBiZXR3ZWVuDQo+PiBhdGg2a2wgZmlybXdhcmUgYnJhbmNoZXMgc28gZXZlbiBpZiBp
dCB3b3JrcyBmb3IgeW91IGl0IG1pZ2h0IGJyZWFrIHNvbWUNCj4+IG90aGVyIGJyYW5jaC4gVGhh
dCdzIHdoeSBpdCdzIGdvb2QgdG8gZG9jdW1lbnQgdGhlIHNldHVwIGluIHRoZSBjb21taXQNCj4+
IGxvZy4NCj4NCj4gSSBoYXZlIHRlc3RlZCB0aGlzIGluIGFuIEF0aGVyb3MgUUNBNjIzNC4ga21z
ZyBzaG93cyB0aGlzIGFib3V0IHRoZSBmdzoNCj4NCj4gYXRoNmtsOiBhcjYwMDQgaHcgMy4wIHNk
aW8gZncgMy41LjAuNjA0IGFwaSAxDQoNCk9rLCBJJ2xsIGFkZCB0aGlzIHRvIHRoZSBjb21taXQg
bG9nLg0KDQotLSANCkthbGxlIFZhbG8=
