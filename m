Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:44557 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1947055AbdEZG5B (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 May 2017 02:57:01 -0400
From: Xinming Hu <huxm@marvell.com>
To: Kalle Valo <kvalo@codeaurora.org>,
        Xinming Hu <huxinming820@gmail.com>
CC: Linux Wireless <linux-wireless@vger.kernel.org>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>,
        "rajatja@google.com" <rajatja@google.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        Cathy Luo <cluo@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: Re: [PATCH v4 1/5] mwifiex: use variable interface header length
Date: Fri, 26 May 2017 06:56:53 +0000
Message-ID: <855803f571094956a1aecb0a44f619df@SC-EXCH02.marvell.com> (sfid-20170526_085832_418372_3A7B345E)
References: <1495523554-30753-1-git-send-email-huxinming820@gmail.com>
 <8737buslbp.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <8737buslbp.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEthbGxlIFZhbG8gW21haWx0
bzprdmFsb0Bjb2RlYXVyb3JhLm9yZ10NCj4gU2VudDogMjAxN8TqNdTCMjTI1SAxNjozNg0KPiBU
bzogWGlubWluZyBIdQ0KPiBDYzogTGludXggV2lyZWxlc3M7IEJyaWFuIE5vcnJpczsgRG1pdHJ5
IFRvcm9raG92OyByYWphdGphQGdvb2dsZS5jb207DQo+IFpoaXl1YW4gWWFuZzsgQ2F0aHkgTHVv
OyBYaW5taW5nIEh1OyBHYW5hcGF0aGkgQmhhdA0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHY0IDEv
NV0gbXdpZmlleDogdXNlIHZhcmlhYmxlIGludGVyZmFjZSBoZWFkZXIgbGVuZ3RoDQo+IA0KPiBY
aW5taW5nIEh1IDxodXhpbm1pbmc4MjBAZ21haWwuY29tPiB3cml0ZXM6DQo+IA0KPiA+IEZyb206
IFhpbm1pbmcgSHUgPGh1eG1AbWFydmVsbC5jb20+DQo+ID4NCj4gPiBVc2IgdHggYWdncmVnYXRp
b24gZmVhdHVyZSB3aWxsIHV0aWxpemUgNC1ieXRlcyBidXMgaW50ZXJmYWNlIGhlYWRlciwNCj4g
PiBvdGhlcndpc2UgaXQgd2lsbCBiZSBzZXQgdG8gemVybyBpbiBkZWZhdWx0IGNhc2UuDQo+ID4N
Cj4gPiBTaWduZWQtb2ZmLWJ5OiBYaW5taW5nIEh1IDxodXhtQG1hcnZlbGwuY29tPg0KPiA+IFNp
Z25lZC1vZmYtYnk6IENhdGh5IEx1byA8Y2x1b0BtYXJ2ZWxsLmNvbT4NCj4gPiBTaWduZWQtb2Zm
LWJ5OiBHYW5hcGF0aGkgQmhhdCA8Z2JoYXRAbWFydmVsbC5jb20+DQo+ID4gLS0tDQo+ID4gRHJv
cCA1LzYgcGF0Y2ggaW4gdjMNCj4gPiB2NDogc2FtZSBhcyB2MSx2Mix2Mw0KPiANCj4gQlRXLCBJ
IHdvdWxkIHByZWZlciB0aGF0IHlvdSBkb24ndCB1c2UgbXkgcXVhbGNvbW0uY29tIGFkZHJlc3Mg
d2hlbg0KPiBzdWJtaXR0aW5nIHBhdGNoZXMuIFVzaW5nIGNvZGVhdXJvcmEub3JnIG9yIG5vdCBD
Q2luZyBtZSBhdCBhbGwgKGFzIEkgdGFrZSBhbGwNCj4gcGF0Y2hlcyBmcm9tIHBhdGNod29yayBh
bnl3YXkpIGlzIG11Y2ggYmV0dGVyIGZvciBtZS4NCj4gDQpPaywgS2FsbGUuDQoNClJlZ2FyZHMs
DQpTaW1vbg0KPiAtLQ0KPiBLYWxsZSBWYWxvDQo=
