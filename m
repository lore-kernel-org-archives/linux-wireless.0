Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:36242 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751308AbaGOEHC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2014 00:07:02 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Paul Stewart <pstew@chromium.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Chin-Ran Lo <crlo@marvell.com>, Xinming Hu <huxm@marvell.com>
Date: Mon, 14 Jul 2014 21:06:53 -0700
Subject: RE: [PATCH 4/7] mwifiex: remove redundant TDLS setup action frame
 check
Message-ID: <477F20668A386D41ADCC57781B1F7043122FCE9301@SC-VEXCH1.marvell.com> (sfid-20140715_060706_525340_902121C3)
References: <1405137435-14045-1-git-send-email-bzhao@marvell.com>
 <CAMcMvshVx4zJkvPf2XgTPNUYNCqXKAm9wvi-iF1tJkODpyJ8bg@mail.gmail.com>
In-Reply-To: <CAMcMvshVx4zJkvPf2XgTPNUYNCqXKAm9wvi-iF1tJkODpyJ8bg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgUGF1bCwNCg0KVGhhbmtzIGZvciB5b3VyIGNvbW1lbnQuDQoNCj4gPiBAQCAtNzkxLDE5ICs3
OTEsMTUgQEAgdm9pZCBtd2lmaWV4X3Byb2Nlc3NfdGRsc19hY3Rpb25fZnJhbWUoc3RydWN0IG13
aWZpZXhfcHJpdmF0ZSAqcHJpdiwNCj4gPiAgICAgICAgICAgICAgICAgcmV0dXJuOw0KPiA+DQo+
ID4gICAgICAgICBwZWVyID0gYnVmICsgRVRIX0FMRU47DQo+ID4gLSAgICAgICBhY3Rpb24gPSAq
KGJ1ZiArIHNpemVvZihzdHJ1Y3QgZXRoaGRyKSArIDIpOw0KPiA+DQo+ID4gLSAgICAgICAvKiBq
dXN0IGhhbmRsZSBURExTIHNldHVwIHJlcXVlc3QvcmVzcG9uc2UvY29uZmlybSAqLw0KPiA+IC0g
ICAgICAgaWYgKGFjdGlvbiA+IFdMQU5fVERMU19TRVRVUF9DT05GSVJNKQ0KPiBJJ20gZ29pbmcg
dG8gYXNzdW1lIHRoYXQgdGhlIGludGVudCBvZiB0aGUgb3JpZ2luYWwgdGVzdCB3YXMgdG8gYXZv
aWQNCj4gYWxsb2NhdGlvbiBvZiBzdGFfcHRyIGJlbG93IGluIHRoZSBjYXNlIHdoZXJlIHRoZSBh
Y3Rpb24gd2FzIGludmFsaWQuDQo+IElzIGl0IG9rYXkgdG8gYWxsb2NhdGUgdGhpcyBwb2ludGVy
IGFuZCBub3QgZG8gYW55dGhpbmcgd2l0aCBpdCBiZWxvdz8NCg0KSSd2ZSBzZW50IHYyIHBhdGNo
LiBDb3VsZCB5b3UgcGxlYXNlIHJldmlldz8NCg0KVGhhbmtzLA0KQmluZw0KDQo+ID4gKyAgICAg
ICBzdGFfcHRyID0gbXdpZmlleF9hZGRfc3RhX2VudHJ5KHByaXYsIHBlZXIpOw0KPiA+ICsgICAg
ICAgaWYgKCFzdGFfcHRyKQ0KPiA+ICAgICAgICAgICAgICAgICByZXR1cm47DQo+ID4NCj4gPiAr
ICAgICAgIGFjdGlvbiA9ICooYnVmICsgc2l6ZW9mKHN0cnVjdCBldGhoZHIpICsgMik7DQo+ID4g
ICAgICAgICBkZXZfZGJnKHByaXYtPmFkYXB0ZXItPmRldiwNCj4gPiAgICAgICAgICAgICAgICAg
InJ4OnRkbHMgYWN0aW9uOiBwZWVyPSVwTSwgYWN0aW9uPSVkXG4iLCBwZWVyLCBhY3Rpb24pOw0K
PiA+DQo+ID4gLSAgICAgICBzdGFfcHRyID0gbXdpZmlleF9hZGRfc3RhX2VudHJ5KHByaXYsIHBl
ZXIpOw0KPiA+IC0gICAgICAgaWYgKCFzdGFfcHRyKQ0KPiA+IC0gICAgICAgICAgICAgICByZXR1
cm47DQo+ID4gLQ0KPiA+ICAgICAgICAgc3dpdGNoIChhY3Rpb24pIHsNCj4gPiAgICAgICAgIGNh
c2UgV0xBTl9URExTX1NFVFVQX1JFUVVFU1Q6DQo+ID4gICAgICAgICAgICAgICAgIGlmIChsZW4g
PCAoc2l6ZW9mKHN0cnVjdCBldGhoZHIpICsgVERMU19SRVFfRklYX0xFTikpDQo+ID4gLS0NCj4g
PiAxLjguMi4zDQo+ID4NCg==
