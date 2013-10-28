Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:55194 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756788Ab3J1SOf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Oct 2013 14:14:35 -0400
From: "Chauhan, Rajesh" <rajeshc@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Rodriguez, Luis" <rodrigue@qca.qualcomm.com>,
	"Malinen, Jouni" <jouni@qca.qualcomm.com>,
	"Bahini, Henri" <hbahini@qca.qualcomm.com>,
	"Chang, Leo" <schang@qca.qualcomm.com>,
	"Luo, Xun" <xunl@qca.qualcomm.com>,
	"Chauhan, Rajesh" <rajeshc@qca.qualcomm.com>
Subject: RE: [PATCH] cfg80211/nl80211: Add support to report unsafe
 frequency ranges(s)
Date: Mon, 28 Oct 2013 18:14:34 +0000
Message-ID: <D19FD2B13A40CD4B8DA64DB9B8F112E9218E464B@nasanexd01a.na.qualcomm.com> (sfid-20131028_191439_046191_54AFB6B8)
References: <1381985833-31312-1-git-send-email-rajeshc@qca.qualcomm.com>
	 <1382020835.14410.16.camel@jlt4.sipsolutions.net>
	 <D19FD2B13A40CD4B8DA64DB9B8F112E9218DAC92@nasanexd01a.na.qualcomm.com>
 <1382971479.17956.29.camel@jlt4.sipsolutions.net>
In-Reply-To: <1382971479.17956.29.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgSm9oYW5uZXMsDQoNCkluIGFub3RoZXIgZW1haWwsIEkgYW0gcHJvcG9zaW5nIHRvIGFkZCBh
biBhdHRyaWJ1dGUgZm9yIHRoZSBzb3VyY2Ugb2YgaW50ZXJmZXJlbmNlIChmb3IgZXhhbXBsZSwg
ImNlbGx1bGFyIikgZm9yIGVhY2ggZnJlcXVlbmN5IHJhbmdlLiBTbyB0aGF0IHdheSBkcml2ZXIg
d2lsbCBoYXZlIHRvIHNwZWNpZnkgZXhhY3Qgc291cmNlIG9mIGludGVyZmVyZW5jZSBhbmQgdGhh
dCB3b3VsZCBhbHNvIGF2b2lkIHJhbmRvbSBjaGFubmVsIHN0ZWVyaW5nLiBJIHdvdWxkIHNlbmQg
b3V0IHVwZGF0ZWQgcGF0Y2ggc2V0IHdpdGggdGhhdCBjaGFuZ2UuDQoNClJlZ2FyZHMsDQpSYWpl
c2ggQ2hhdWhhbg0KDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTogSm9oYW5uZXMg
QmVyZyBbbWFpbHRvOmpvaGFubmVzQHNpcHNvbHV0aW9ucy5uZXRdIA0KU2VudDogTW9uZGF5LCBP
Y3RvYmVyIDI4LCAyMDEzIDc6NDUgQU0NClRvOiBDaGF1aGFuLCBSYWplc2gNCkNjOiBsaW51eC13
aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmc7IFJvZHJpZ3VleiwgTHVpczsgTWFsaW5lbiwgSm91bmk7
IEJhaGluaSwgSGVucmk7IENoYW5nLCBMZW87IEx1bywgWHVuDQpTdWJqZWN0OiBSZTogW1BBVENI
XSBjZmc4MDIxMS9ubDgwMjExOiBBZGQgc3VwcG9ydCB0byByZXBvcnQgdW5zYWZlIGZyZXF1ZW5j
eSByYW5nZXMocykNCg0KT24gVGh1LCAyMDEzLTEwLTE3IGF0IDE3OjE5ICswMDAwLCBDaGF1aGFu
LCBSYWplc2ggd3JvdGU6DQo+IEhpIEpvaGFubmVzLA0KPiANCj4gVGhhbmtzIGZvciB5b3VyIGNv
bW1lbnQuIFB1cnBvc2Ugb2YgdGhpcyBwYXRjaCBpcyB0byBhZGQgYW4gQVBJIGZvciANCj4gV0xB
TiBkcml2ZXIgdG8gcmVwb3J0IGZyZXF1ZW5jeSByYW5nZXMgd2hpY2ggc2hvdWxkIGJlIGF2b2lk
ZWQgZm9yIA0KPiBTQVAvUDJQLUdPIGJlY2F1c2Ugb2YgaW50ZXJmZXJlbmNlLg0KPiANCj4gSG93
IGFib3V0IGlmIEkgcmV3b3JkIGNvbW1pdCB0ZXN0IGFzIGJlbG93Pw0KPiANCj4gY2ZnODAyMTEv
bmw4MDIxMTogQWRkIEFQSSB0byByZXBvcnQgZnJlcXVlbmN5IHJhbmdlKHMpIHRvIGJlIGF2b2lk
ZWQNCj4gDQo+IEFkZCBzdXBwb3J0IGZvciBXTEFOIGRyaXZlciB0byByZXBvcnQgZnJlcXVlbmN5
IHJhbmdlKHMpIHRvIGJlIGF2b2lkZWQgDQo+IGJlY2F1c2Ugb2YgaW50ZXJmZXJlbmNlLg0KDQpX
b3VsZG4ndCBpdCBtYWtlIG1vcmUgc2Vuc2UgdG8gcmFpc2UgYSAiZGV0ZWN0ZWQgaW50ZXJmZXJl
bmNlIiBldmVudD8NClRoZXJlJ3Mgbm8gd2F5IHRvIGtub3cgd2hhdCBjaGFubmVsIHJhbmdlIGlz
IGFmZmVjdGVkIGFueXdheS4gSSBmZWFyIHRoYXQgdGhpcyBpcyB2YWd1ZSBlbm91Z2ggZm9yIHlv
dSB0byAoYWIpdXNlIGl0IGZvciBhbGwga2luZHMgb2YgcmFuZG9tICJjaGFubmVsIHN0ZWVyaW5n
IiBmcm9tIHRoZSBkcml2ZXIuDQoNCmpvaGFubmVzDQoNCg==
