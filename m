Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:39933 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S933279AbdDELR7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Apr 2017 07:17:59 -0400
From: Ganapathi Bhat <gbhat@marvell.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Cathy Luo" <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Subject: RE: [EXT] Re: mwifiex: Fix invalid port issue
Date: Wed, 5 Apr 2017 11:17:56 +0000
Message-ID: <14e37ebf8f4c4a23895884e48919edef@SC-EXCH02.marvell.com> (sfid-20170405_131919_869855_3E15AABF)
References: <1491281188-6471-1-git-send-email-gbhat@marvell.com>
 <20170405105212.BA68F60DC7@smtp.codeaurora.org>
In-Reply-To: <20170405105212.BA68F60DC7@smtp.codeaurora.org>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PiBGcm9tOiBLYWxsZSBWYWxvIFttYWlsdG86a3ZhbG9AY29kZWF1cm9yYS5vcmddDQo+IFNlbnQ6
IFdlZG5lc2RheSwgQXByaWwgMDUsIDIwMTcgNDoyMiBQTQ0KPiBUbzogR2FuYXBhdGhpIEJoYXQN
Cj4gQ2M6IGxpbnV4LXdpcmVsZXNzQHZnZXIua2VybmVsLm9yZzsgQ2F0aHkgTHVvOyBOaXNoYW50
IFNhcm11a2FkYW07DQo+IEdhbmFwYXRoaSBCaGF0DQo+IFN1YmplY3Q6IFtFWFRdIFJlOiBtd2lm
aWV4OiBGaXggaW52YWxpZCBwb3J0IGlzc3VlDQo+IA0KPiBHYW5hcGF0aGkgQmhhdCA8Z2JoYXRA
bWFydmVsbC5jb20+IHdyb3RlOg0KPiA+IFdlIGhhdmUgdG8gdXNlIHN0YXJ0IHBvcnQsIGZvciBU
WC9SWCBvZiBzaW5nbGUgcGFja2V0LCBpbnN0ZWFkIG9mDQo+ID4gY3VycmVudCBhZ2dyZWdhdGlu
ZyBwb3J0LiBUaGlzIHdpbGwgZml4IFNESU8NCj4gPiBDTUQ1MyhUWC9SWCkgcmV0dXJuaW5nIC1F
VElNRURPVVQgYW5kIGhhbHRpbmcgdGhlIGRhdGEgcGF0aC4NCj4gPg0KPiA+IGZpeGVzOiAwY2I1
MmFhYzQgKCdtd2lmaWV4OiBkbyBub3Qgc2V0IG11bHRpcG9ydCBmbGFnIGZvciB0eC9yeA0KPiBz
aW5nbGUNCj4gPiBwYWNrZXQnKQ0KPiA+IFNpZ25lZC1vZmYtYnk6IEdhbmFwYXRoaSBCaGF0IDxn
YmhhdEBtYXJ2ZWxsLmNvbT4NCj4gDQo+IFRoZSBjb3JyZWN0IGZvcm1hdCBpczoNCj4gDQo+IEZp
eGVzOiAwY2I1MmFhYzRkMTkgKCJtd2lmaWV4OiBkbyBub3Qgc2V0IG11bHRpcG9ydCBmbGFnIGZv
ciB0eC9yeA0KPiBzaW5nbGUgcGFja2V0IikNCj4gDQo+IEkgY2FuIGZpeCB0aGF0LiAobm8gcHVu
IGludGVuZGVkKQ0KDQpUaGFua3MgS2FsbGUuIEkgd2lsbCBmb2xsb3cgdGhlIHNhbWUgaW4gZnV0
dXJlLg0KDQo+IA0KPiAtLQ0KPiBodHRwczovL3BhdGNod29yay5rZXJuZWwub3JnL3BhdGNoLzk2
NjA4NDUvDQo+IA0KPiBodHRwczovL3dpcmVsZXNzLndpa2kua2VybmVsLm9yZy9lbi9kZXZlbG9w
ZXJzL2RvY3VtZW50YXRpb24vc3VibWl0dGluZw0KPiBwYXRjaGVzDQoNCg0KUmVnYXJkcywNCkdh
bmFwYXRoaQ0K
