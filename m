Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sbg-il.ceva-dsp.com ([195.82.128.8]:63551 "EHLO
        sbg-il.ceva-dsp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966988AbdAKN43 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Jan 2017 08:56:29 -0500
From: Cedric Izoard <Cedric.Izoard@ceva-dsp.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        Masashi Honma <masashi.honma@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [REGRESSION, bisect] mesh: SAE connection causes kernel crash
Date: Wed, 11 Jan 2017 13:41:24 +0000
Message-ID: <15013a41b64d4e5db560768be77efb18@ceva-dsp.com> (sfid-20170111_145638_320024_D0C35812)
References: <b72bc51c-1873-6178-9990-7d9e99ee4b88@gmail.com>
         <1484121737.23671.0.camel@sipsolutions.net>
         <aa60ffb2-b756-b807-4976-20f2eca6665d@gmail.com>
         <1484125220.23671.1.camel@sipsolutions.net>
         <12d8a797-6c51-4a79-2820-1f9e2e72b2f5@gmail.com>
         <1484128809.23671.11.camel@sipsolutions.net>
         <670a7439-50b9-4f07-1d7d-cb915547562e@gmail.com>
         <1484132519.23671.12.camel@sipsolutions.net>
         <1dd6e9f3-5ad2-1138-8017-c0ab208d9f88@gmail.com>
         <927a79f16e8c429da7a0d06f1bfb2567@ceva-dsp.com>
         <1484136355.29931.1.camel@sipsolutions.net>
         <2b0df84e78434d11af1089e82485704b@ceva-dsp.com>
 <1484141660.29931.11.camel@sipsolutions.net>
In-Reply-To: <1484141660.29931.11.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PiA+IFdoZW4gY2FsbGluZyBkcnZfdHgoKSB0aGUgaGVhZHJvb20gaXMgbm90IGJpZyBlbm91Z2gg
Zm9yIHRoZSBkcml2ZXIuDQo+IA0KPiBPay4NCj4gDQo+ID4gPg0KPiA+ID4gTWF5YmUgd2UncmUg
YWRkaW5nIHNvbWV0aGluZyBlbHNlIHRvIHRoaXMgc2tiPw0KPiA+ID4NCj4gPiA+IEkgY2FuJ3Qg
ZmluZCBhbnl0aGluZyBpbiB0aGUgYXRoOWtfaHRjIGRyaXZlciB0aGF0J3MgYWRkaW5nIG1vcmUN
Cj4gPiA+IHRoYW4NCj4gPiA+IDIzIGJ5dGVzIChpdCdzIGFkdmVydGlzaW5nIDI0KSBidXQgY2xl
YXJseSB0aGUgbGFzdCA4IGJ5dGVzIGhlcmUgYXJlDQo+ID4gPiBmYWlsaW5nOg0KPiA+ID4NCj4g
PiA+ID4gW8KgwqDCoDgzLjIwMDM0Nl0gc2tidWZmOiBza2JfdW5kZXJfcGFuaWM6IHRleHQ6ZmZm
ZmZmZmZhMDM0YzAyOA0KPiA+ID4gPiBsZW46MTU0DQo+ID4gPiA+IHB1dDo4IGhlYWQ6ZmZmZjg4
MDIxMzQyMmUwMCBkYXRhOmZmZmY4ODAyMTM0MjJkZmEgdGFpbDoweDk0DQo+ID4gPiA+IGVuZDow
eGMwDQo+ID4gPiA+IGRldjo8TlVMTD4NCj4gPiA+DQo+ID4gPiBNYXliZSBtYWM4MDIxMSBpcyBw
dXR0aW5nIHNvbWV0aGluZyBlbHNlPyBJdCdkIGhhdmUgdG8gYmUNCj4gPg0KPiA+IHllcyBtYWM4
MDIxMSBpcyBhZGRpbmcgdGhlIHNlY3VyaXR5IGhlYWRlci4NCj4gPiBoZWFkcm9vbSBhc2tlZCB0
byBza2JfY29weV9leHBhbmQgc2hvdWxkIGFsc28gdGFrZSBzZGF0YS0NCj4gPiA+ZW5jcnlwdF9o
ZWFkcm9vbSBpbnRvIGFjY291bnQuDQo+IA0KPiBJIHN1c3BlY3RlZCB0aGF0LCBzaW5jZSBpdCB3
YXMgYWJvdXQgdGhlIG9ubHkgcGxhY2UgdGhhdCB3YXMgYWRkaW5nIGFueXRoaW5nLA0KPiBidXQg
SSBjb3VsZG4ndCB0ZXN0IGl0IDopDQo+IA0KPiBDYW4geW91IHNlbmQgYSBwYXRjaD8NCg0KU3Vy
ZSwgSSB3aWxsIHNlbmQgYSBwYXRjaC4NCg0KY2VkcmljDQo=
