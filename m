Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:34686 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932098AbdBHGgn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 01:36:43 -0500
From: David Lin <dlin@marvell.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Steve deRosier <derosier@gmail.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Chor Teck Law <ctlaw@marvell.com>,
        James Lin <jamesl@marvell.com>, Pete Hsieh <peteh@marvell.com>
Subject: Re: [PATCH v9] Add new mac80211 driver mwlwifi.
Date: Wed, 8 Feb 2017 06:15:15 +0000
Message-ID: <3e57f30c29254db4a906e3e71ac36da5@SC-EXCH02.marvell.com> (sfid-20170208_073659_107144_516BC367)
References: <260962939eeb4dbbb6e462cc010aac21@SC-EXCH02.marvell.com>
 <CALLGbRLXa5m+eRhZpvWKyXkemB0qAkB=eoQKwns-vP29+izV+Q@mail.gmail.com>
 <CACna6rzKWAz_xxi=ehKijGtM4XEcioSjwmb=V0rq_vKioiS=Ew@mail.gmail.com>
In-Reply-To: <CACna6rzKWAz_xxi=ehKijGtM4XEcioSjwmb=V0rq_vKioiS=Ew@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PiBSYWZhxYIgTWnFgmVja2kgW21haWx0bzp6YWplYzVAZ21haWwuY29tXSB3cm90ZToNCj4gT24g
NyBGZWJydWFyeSAyMDE3IGF0IDIwOjEyLCBTdGV2ZSBkZVJvc2llciA8ZGVyb3NpZXJAZ21haWwu
Y29tPiB3cm90ZToNCj4gPj4gKyAvKiBsb29rIGZvciBhbGwgbWF0Y2hpbmcgcHJvcGVydHkgbmFt
ZXMgKi8NCj4gPj4gKyBmb3JfZWFjaF9wcm9wZXJ0eV9vZl9ub2RlKHByaXYtPmR0X25vZGUsIHBy
b3ApIHsgaWYNCj4gPj4gKyAoc3RyY21wKHByb3AtPm5hbWUsICJtYXJ2ZWxsLDJnaHoiKSA9PSAw
KQ0KPiA+PiArIHByaXYtPmRpc2FibGVfMmcgPSB0cnVlOw0KPiA+PiArIGlmIChzdHJjbXAocHJv
cC0+bmFtZSwgIm1hcnZlbGwsNWdoeiIpID09IDApDQo+ID4+ICsgcHJpdi0+ZGlzYWJsZV81ZyA9
IHRydWU7DQo+ID4+ICsgaWYgKHN0cmNtcChwcm9wLT5uYW1lLCAibWFydmVsbCxjaGFpbm1hc2si
KSA9PSAwKSB7IHByb3BfdmFsdWUgPQ0KPiA+PiArIGJlMzJfdG9fY3B1KCooKF9fYmUzMiAqKXBy
b3AtPnZhbHVlKSk7IGlmIChwcm9wX3ZhbHVlID09IDIpDQo+ID4+ICsgcHJpdi0+YW50ZW5uYV90
eCA9IEFOVEVOTkFfVFhfMjsNCj4gPj4gKw0KPiA+PiArIHByb3BfdmFsdWUgPSBiZTMyX3RvX2Nw
dSgqKChfX2JlMzIgKikgKHByb3AtPnZhbHVlICsgNCkpKTsgaWYNCj4gPj4gKyAocHJvcF92YWx1
ZSA9PSAyKQ0KPiA+PiArIHByaXYtPmFudGVubmFfcnggPSBBTlRFTk5BX1JYXzI7DQo+ID4+ICsg
fQ0KPiA+PiArIH0NCj4gPj4gKw0KPiA+PiArIHByaXYtPnB3cl9ub2RlID0gb2ZfZmluZF9ub2Rl
X2J5X25hbWUocHJpdi0+ZHRfbm9kZSwNCj4gPj4gKyAgICAgICJtYXJ2ZWxsLHBvd2VydGFibGUi
KTsNCj4gPj4gKyNlbmRpZg0KPiA+PiArfQ0KPiA+DQo+ID4gQUZBSUNULCB0aGVyZSdzIG5vIGRv
Y3VtZW50YXRpb24gZm9yIHRoZXNlIERUIGJpbmRpbmdzLiBUaGUgbXdsd2lmaQ0KPiA+IG5vZGUg
YW5kIHRoZSBtYXJ2ZWxsLHBvd2VydGFibGUgYm90aCBuZWVkIGZ1bGwgZG9jdW1lbnRhdGlvbiBp
bg0KPiA+IERvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy8uLi4gLg0KPiA+DQo+ID4g
RnJhbmtseSBJIGhhdmUgYSBmZWVsaW5nIEknbSBnb2luZyB0byBuZWVkIHRoZXNlIERUIG5vZGVz
IGFuZCBJJ2QgbGlrZQ0KPiA+IHRvIG5vdCBoYXZlIHRvIGd1ZXNzLWFuZC1jaGVjayBiYXNlZCBv
biB0aGUgY29kZS4NCj4gDQo+IFBsZWFzZSB1c2UgaWVlZTgwMjExLWZyZXEtbGltaXQ6DQo+IGh0
dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvY2dpdC9saW51eC9rZXJuZWwvZ2l0L2RhdmVtL25ldC1uZXh0
LmdpdC9jb21taXQvP2lkPWIzDQo+IDMwYjI1ZWFhYmRhMDBkNzRlNDc1NjZkOTIwMDkwN2RhMzgx
ODk2DQo+IA0KPiBNb3N0IGxpa2VseSB3aXRoIHdpcGh5X3JlYWRfb2ZfZnJlcV9saW1pdHMgaGVs
cGVyOg0KPiBodHRwczovL2dpdC5rZXJuZWwub3JnL2NnaXQvbGludXgva2VybmVsL2dpdC9kYXZl
bS9uZXQtbmV4dC5naXQvY29tbWl0Lz9pZD1lNg0KPiA5MWFjMmY3NWI2OWJlZTc0M2YwMzcwZDc5
NDU0YmE0NDI5YjE3NQ0KDQpJIGFscmVhZHkgcmVwbGllZCBtZWFuaW5nIG9mIHRoZXNlIHBhcmFt
ZXRlcnM6DQo8bWFydmVsbCwyZ2h6PiBpcyB1c2VkIHRvIGRpc2FibGUgMmcgYmFuZC4NCjxtYXJ2
ZWxsLDVnaHo+IGlzIHVzZWQgdG8gZGlzYWJsZSA1ZyBiYW5kLg0KPG1hcnZlbGwsIGNoYWlubWFz
az4gaXMgdXNlZCB0byBzcGVjaWZ5IGFudGVubmEgbnVtYmVyIChpZiBkZWZhdWx0IG51bWJlciBp
cyBzdWl0YWJsZSBmb3IgeW91LCB0aGVyZSBpcyBubyBuZWVkIHRvIHVzZSB0aGlzIHBhcmFtZXRl
cikuDQo8bWFydmVsbCxwb3dlcnRhYmxlPiBzaG91bGQgbm90IGJlIHVzZWQgZm9yIGNoaXAgd2l0
aCBkZXZpY2UgcG93ZXIgdGFibGUuIEluIGZhY3QsIHRoaXMgcGFyYW1ldGVyIHNob3VsZCBub3Qg
YmUgdXNlZCBhbnkgbW9yZS4NCg0KVGhhbmtzLA0KRGF2aWQNCg==
