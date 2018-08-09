Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:4439 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731112AbeHIR7v (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Aug 2018 13:59:51 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: =?utf-8?B?TWljaGFlbCBCw7xzY2g=?= <m@bues.ch>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        b43-dev <b43-dev@lists.infradead.org>
Subject: Re: b43/leds: Ensure NUL-termination of LED name string
Date: Thu, 9 Aug 2018 15:28:08 +0000
Message-ID: <87lg9f1rw8.fsf@kamboji.qca.qualcomm.com> (sfid-20180809_173427_687924_917055E8)
References: <20180731211404.2eac1bb0@wiggum>
In-Reply-To: <20180731211404.2eac1bb0@wiggum> ("Michael
 \=\?utf-8\?Q\?B\=C3\=BCs\?\= \=\?utf-8\?Q\?ch\=22's\?\= message of     "Tue, 31
 Jul 2018 21:14:04 +0200")
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

TWljaGFlbCBCw7xzY2ggPG1AYnVlcy5jaD4gd3JpdGVzOg0KDQo+IHN0cm5jcHkgbWlnaHQgbm90
IE5VTC10ZXJtaW5hdGUgdGhlIHN0cmluZywgaWYgdGhlIG5hbWUgZXF1YWxzIHRoZSBidWZmZXIg
c2l6ZS4NCj4gVXNlIHN0cmxjcHkgaW5zdGVhZC4NCj4NCj4gU2lnbmVkLW9mZi1ieTogTWljaGFl
bCBCdWVzY2ggPG1AYnVlcy5jaD4NCj4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCg0KVGhp
cyBpcyB3ZWlyZCwgd2l0aCBhbGwgdGhlIHBhdGNoZXMgeW91IHN1Ym1pdHRlZCBsYXN0IHdlZWsg
SSBnZXQgdGhpcw0KaWYgSSBkb3dubG9hZCB0aGUgcGF0Y2ggZnJvbSBwYXRjaHdvcms6DQoNCiQg
Z2l0IGFtIC1zIDEubWJveA0KUGF0Y2ggaXMgZW1wdHkuIFdhcyBpdCBzcGxpdCB3cm9uZz8NCg0K
QnV0IGlmIEkgZG93bmxvYWQgdGhlIHBhdGNoIGRpcmVjdGx5IGZyb20gbXkgSU1BUCBmb2xkZXIg
SSBoYXZlIG5vDQpwcm9ibGVtczoNCg0KJCBnaXQgYW0gLXMgMS5tYm94DQpBcHBseWluZzogYjQz
L2xlZHM6IEVuc3VyZSBOVUwtdGVybWluYXRpb24gb2YgTEVEIG5hbWUgc3RyaW5nDQoNClRoaXMg
aGFwcGVucyBldmVuIHdpdGhvdXQgbXkgY3VzdG9tIHBhdGNod29yayBzY3JpcHQgc28gdGhpcyBo
YXMNCnNvbWV0aGluZyB0byBkbyB3aXRoIHRoZSBwYXRjaHdvcmsgc2VydmVyLCBidXQgaXQncyBu
b3Qgb2J2aW91cyB0byBtZQ0Kd2hhdCB0cmlnZ2VycyBpdC4gSUlSQyBJIGhhdmUgbm90IHNlZW4g
YW55dGhpbmcgbGlrZSB0aGlzIGJlZm9yZS4gSXQNCnNlZW1zIHRoYXQgeW91IGRpZG4ndCB1c2Ug
Z2l0LXNlbmQtZW1haWwsIEkgc3Ryb25nbHkgc3VnZ2VzdCB0byB1c2UgdGhhdA0KanVzdCB0byBh
dm9pZCBwcm9ibGVtcyBsaWtlIHRoaXMuDQoNCkFueXdheSwgYXBwbGllZCBtYW51YWxseToNCg0K
MmFhNjUwZDE5NTBmIGI0My9sZWRzOiBFbnN1cmUgTlVMLXRlcm1pbmF0aW9uIG9mIExFRCBuYW1l
IHN0cmluZw0KDQotLSANCkthbGxlIFZhbG8=
