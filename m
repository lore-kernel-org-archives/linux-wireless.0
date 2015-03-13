Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:45682 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750903AbbCMEP6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2015 00:15:58 -0400
From: Avinash Patil <patila@marvell.com>
To: =?utf-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Cathy Luo <cluo@marvell.com>, Zhaoyang Liu <liuzy@marvell.com>,
	Chin-Ran Lo <crlo@marvell.com>, Plus Chen <pchen@marvell.com>,
	Shengzhen Li <szli@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>
Date: Thu, 12 Mar 2015 21:15:44 -0700
Subject: RE: [PATCH 3/9] mwifiex: enhance SD8897 MP aggregation limits
Message-ID: <CBACCFA0AEB13A41977475BCF3E896FC667477813D@SC-VEXCH2.marvell.com> (sfid-20150313_051601_149152_7349B4D9)
References: <1426180920-10567-1-git-send-email-patila@marvell.com>
	<1426180920-10567-4-git-send-email-patila@marvell.com>
 <87bnjy2wkm.fsf@nemi.mork.no>
In-Reply-To: <87bnjy2wkm.fsf@nemi.mork.no>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGksDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQmrDuHJuIE1vcmsg
W21haWx0bzpiam9ybkBtb3JrLm5vXQ0KPiBTZW50OiBUaHVyc2RheSwgTWFyY2ggMTIsIDIwMTUg
NjozOCBQTQ0KPiBUbzogQXZpbmFzaCBQYXRpbA0KPiBDYzogbGludXgtd2lyZWxlc3NAdmdlci5r
ZXJuZWwub3JnOyBBbWl0a3VtYXIgS2Fyd2FyOyBDYXRoeSBMdW87IFpoYW95YW5nIExpdTsNCj4g
Q2hpbi1SYW4gTG87IFBsdXMgQ2hlbjsgU2hlbmd6aGVuIExpOyBOaXNoYW50IFNhcm11a2FkYW0N
Cj4gU3ViamVjdDogUmU6IFtQQVRDSCAzLzldIG13aWZpZXg6IGVuaGFuY2UgU0Q4ODk3IE1QIGFn
Z3JlZ2F0aW9uIGxpbWl0cw0KPiANCj4gQXZpbmFzaCBQYXRpbCA8cGF0aWxhQG1hcnZlbGwuY29t
PiB3cml0ZXM6DQo+IA0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9td2lm
aWV4L3NkaW8uaA0KPiA+IGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvbXdpZmlleC9zZGlvLmgNCj4g
PiBpbmRleCBjNjM2OTQ0Li41YTIzYmQwIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L3dp
cmVsZXNzL213aWZpZXgvc2Rpby5oDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvbXdp
ZmlleC9zZGlvLmgNCj4gPiBAQCAtNjcsNiArNjcsNyBAQA0KPiA+DQo+ID4gICNkZWZpbmUgTVdJ
RklFWF9NUF9BR0dSX0JVRl9TSVpFXzE2SwkoMTYzODQpDQo+ID4gICNkZWZpbmUgTVdJRklFWF9N
UF9BR0dSX0JVRl9TSVpFXzMySwkoMzI3NjgpDQo+ID4gKyNkZWZpbmUgTVdJRklFWF9NUF9BR0dS
X0JVRl9TSVpFXzY0SyAgICAoNjUyODApDQo+IA0KPiBUaGUgZmlyc3QgdHdvIG1hY3JvcyBhcmUg
Y2xlYXJseSBtYXRjaGluZyB0aGVpciAxNksgYW5kIDMySyBuYW1lcywgYnV0IHRoZSA2NEsNCj4g
b25lIGlzIG5vdC4gIENhcmUgdG8gYWRkIGEgY29tbWVudCBleHBsYWluaW5nIHdoZXJlIHRoZSBt
aXNzaW5nDQo+IDI1NiBieXRlcyB3ZW50Pw0KDQpXZSByZXNlcnZlIGZpcnN0IGJsb2NrIG9mIDI1
NiBieXRlcyBmb3IgRE1BIGFsaWdubWVudC4NCkkgd2lsbCBhZGQgYSBjb21tZW50IHRvIGRlZmlu
aXRpb247IGFsc28gcmVuYW1lIGRlZmluZSBzaW5jZSBpdCBpcyBub3QgZXhhY3RseSA2NEsuDQog
DQo+IEJqw7hybiAoYWx3YXlzIGN1cmlvdXMgYWJvdXQgc3VycHJpc2luZyBudW1iZXJzIDotKQ0K
DQotQXZpbmFzaA0K
