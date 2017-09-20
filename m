Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:39760 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751468AbdITKE2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Sep 2017 06:04:28 -0400
From: Xinming Hu <huxm@marvell.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Linux Wireless <linux-wireless@vger.kernel.org>
CC: Kalle Valo <kvalo@codeaurora.org>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>,
        "rajatja@google.com" <rajatja@google.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: Re: Re: [PATCH] mwifiex: add device specific ioctl handler
Date: Wed, 20 Sep 2017 10:04:22 +0000
Message-ID: <429692343ed64d759eef2aa014a87fbb@SC-EXCH02.marvell.com> (sfid-20170920_120431_761263_C971FFA1)
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGksDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQXJlbmQgdmFuIFNw
cmllbCBbbWFpbHRvOmFyZW5kLnZhbnNwcmllbEBicm9hZGNvbS5jb21dDQo+IFNlbnQ6IDIwMTfE
6jnUwjIwyNUgMTY6NDANCj4gVG86IFhpbm1pbmcgSHUgPGh1eGlubWluZzgyMEBnbWFpbC5jb20+
OyBMaW51eCBXaXJlbGVzcw0KPiA8bGludXgtd2lyZWxlc3NAdmdlci5rZXJuZWwub3JnPg0KPiBD
YzogS2FsbGUgVmFsbyA8a3ZhbG9AY29kZWF1cm9yYS5vcmc+OyBCcmlhbiBOb3JyaXMNCj4gPGJy
aWFubm9ycmlzQGdvb2dsZS5jb20+OyBEbWl0cnkgVG9yb2tob3YgPGR0b3JAZ29vZ2xlLmNvbT47
DQo+IHJhamF0amFAZ29vZ2xlLmNvbTsgWmhpeXVhbiBZYW5nIDx5YW5nenlAbWFydmVsbC5jb20+
OyBUaW0gU29uZw0KPiA8c29uZ3Rhb0BtYXJ2ZWxsLmNvbT47IENhdGh5IEx1byA8Y2x1b0BtYXJ2
ZWxsLmNvbT47IEdhbmFwYXRoaSBCaGF0DQo+IDxnYmhhdEBtYXJ2ZWxsLmNvbT47IFhpbm1pbmcg
SHUgPGh1eG1AbWFydmVsbC5jb20+DQo+IFN1YmplY3Q6IFtFWFRdIFJlOiBbUEFUQ0hdIG13aWZp
ZXg6IGFkZCBkZXZpY2Ugc3BlY2lmaWMgaW9jdGwgaGFuZGxlcg0KPiANCj4gRXh0ZXJuYWwgRW1h
aWwNCj4gDQo+IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gT24gOS8yMC8yMDE3IDg6NDQgQU0sIFhpbm1pbmcg
SHUgd3JvdGU6DQo+ID4gRnJvbTogWGlubWluZyBIdSA8aHV4bUBtYXJ2ZWxsLmNvbT4NCj4gPg0K
PiA+IEFkZCBuZXRfZGV2IG5kb19kb19pb2N0bCBoYW5kbGVyLCB3aGljaCBjb3VsZCBiZSB1c2Vk
IGZvciBkb3dubG9hZGluZw0KPiA+IGhvc3QgY29tbWFuZCBieSB1dGlsaXR5IGluIG1hbnVmYWN0
b3J5IHRlc3QNCj4gDQo+IE5vdCBzdXJlIGlmIHdlIHdhbnQgaW9jdGxzIGluIHVwc3RyZWFtIHdp
cmVsZXNzIGRyaXZlcnMuDQoNClllcywgd2V4dCBpb2N0bCBjb3VsZCBiZSBkaXNjYXJkIGFuZCBy
ZXBsYWNlZCBieSB3ZWxsIGRlZmluZWQgbmw4MDIxMS9jZmc4MDIxMS4NCkJ1dCBwZXIgbXkgdW5k
ZXJzdGFuZCwgdGhlIG5ldCBkZXZpY2UgaW9jdGwgd2lsbCBzdGlsbCB3b3JrcyBub3JtYWxseS4g
UmlnaHQgPw0KDQo+IFlvdSBjb3VsZCBsb29rIGF0DQo+IG5sODAyMTEgdmVuZG9yIGNvbW1hbmRz
LCBidXQgdGhhdCBpcyBhbHNvIHVuZGVyIHNjcnV0aW55IGlmIGNvbW1vbiB3aWZpDQo+IGZ1bmN0
aW9uYWxpdHkgaXMgcHJvdmlkZWQgYnkgaXQuIEkgYW0gcHJldHR5IHN1cmUgS2FsbGUgaGFzIGhp
cyBpZGVhcyBhYm91dCB0aGlzIDotKQ0KPiANCg0KWWVzLCB0aGUgbmV3IHV0aWxpdHkgc2hvdWxk
IHVzZSBubDgwMjExIGludGVyZmFjZS4NCkJ1dCB3ZSBoYXZlIGxvdHMgb2YgbGVnYWN5IHV0aWxp
dHkgYmFzZWQgb24gaW9jdGwsIGl0IHdpbGwgYmUgaGVscGZ1bCB0byByZWR1Y2UgbWFzc2l2ZSB3
b3JrIG9uIHJlZmFjdG9yaW5nLg0KDQo+IFJlZ2FyZHMsDQo+IEFyZW5kDQo=
