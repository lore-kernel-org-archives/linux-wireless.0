Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sbg-il.ceva-dsp.com ([195.82.128.8]:63323 "EHLO
        sbg-il.ceva-dsp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751162AbdAKNhw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Jan 2017 08:37:52 -0500
From: Cedric Izoard <Cedric.Izoard@ceva-dsp.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        Masashi Honma <masashi.honma@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [REGRESSION, bisect] mesh: SAE connection causes kernel crash
Date: Wed, 11 Jan 2017 13:22:40 +0000
Message-ID: <2b0df84e78434d11af1089e82485704b@ceva-dsp.com> (sfid-20170111_143757_028213_7FE4DB52)
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
In-Reply-To: <1484136355.29931.1.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PiA+IEhlcmUgaXMgdGhlIHN0YWNrIHRyYWNlIEkgZ2V0Og0KPiA+IEkgYWRkZWQgYSB0cmFjZSBi
ZWZvcmUgY2FsbGluZyBza2JfY29weV9leHBhbmQgdG8gZ2V0IHRoZSBoZWFkcm9vbSBvZg0KPiA+
IHRoZSBidWZmZXIgYmVmb3JlIHRoZSBjb3B5IGFuZCB0aGUgaGVhZHJvb20gYXNrZWQgYnkgdGhl
IGRyaXZlci4NCj4gPg0KPiA+IFvCoMKgwqA4My4yMDAyNjFdIE1FU0ggZndkOiBza2JfaGVhZHJv
b209MTU0LCBuZWVkZWQgaGVhZHJvb209MjQNCj4gDQo+IENvdWxkIHlvdSBhbHNvIGFkZCBhIHNp
bWlsYXIgdHJhY2UganVzdCBiZWZvcmUgY2FsbGluZyBkcnZfdHgoKT8NCg0KV2hlbiBjYWxsaW5n
IGRydl90eCgpIHRoZSBoZWFkcm9vbSBpcyBub3QgYmlnIGVub3VnaCBmb3IgdGhlIGRyaXZlci4N
Cg0KPiANCj4gTWF5YmUgd2UncmUgYWRkaW5nIHNvbWV0aGluZyBlbHNlIHRvIHRoaXMgc2tiPw0K
PiANCj4gSSBjYW4ndCBmaW5kIGFueXRoaW5nIGluIHRoZSBhdGg5a19odGMgZHJpdmVyIHRoYXQn
cyBhZGRpbmcgbW9yZSB0aGFuDQo+IDIzIGJ5dGVzIChpdCdzIGFkdmVydGlzaW5nIDI0KSBidXQg
Y2xlYXJseSB0aGUgbGFzdCA4IGJ5dGVzIGhlcmUgYXJlDQo+IGZhaWxpbmc6DQo+IA0KPiA+IFvC
oMKgwqA4My4yMDAzNDZdIHNrYnVmZjogc2tiX3VuZGVyX3BhbmljOiB0ZXh0OmZmZmZmZmZmYTAz
NGMwMjggbGVuOjE1NA0KPiA+IHB1dDo4IGhlYWQ6ZmZmZjg4MDIxMzQyMmUwMCBkYXRhOmZmZmY4
ODAyMTM0MjJkZmEgdGFpbDoweDk0IGVuZDoweGMwDQo+ID4gZGV2OjxOVUxMPg0KPiANCj4gTWF5
YmUgbWFjODAyMTEgaXMgcHV0dGluZyBzb21ldGhpbmcgZWxzZT8gSXQnZCBoYXZlIHRvIGJlDQoN
CnllcyBtYWM4MDIxMSBpcyBhZGRpbmcgdGhlIHNlY3VyaXR5IGhlYWRlci4NCmhlYWRyb29tIGFz
a2VkIHRvIHNrYl9jb3B5X2V4cGFuZCBzaG91bGQgYWxzbyB0YWtlIHNkYXRhLT5lbmNyeXB0X2hl
YWRyb29tIGludG8gYWNjb3VudC4NCg0KY2VkcmljDQo=
