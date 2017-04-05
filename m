Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:39984 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S933568AbdDELTB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Apr 2017 07:19:01 -0400
From: Ganapathi Bhat <gbhat@marvell.com>
To: Kalle Valo <kvalo@codeaurora.org>,
        Amitkumar Karwar <akarwar@marvell.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Karthik Doddayennegere Ananthapadmanabha" <karthida@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Subject: RE: [EXT] Re: mwifiex: apply radar flag
Date: Wed, 5 Apr 2017 11:18:58 +0000
Message-ID: <357ed75f312c46519718ac45980aa363@SC-EXCH02.marvell.com> (sfid-20170405_131952_778304_E4CE9478)
References: <1490870450-6601-1-git-send-email-akarwar@marvell.com>
 <20170405104850.B4B5660DAD@smtp.codeaurora.org>
In-Reply-To: <20170405104850.B4B5660DAD@smtp.codeaurora.org>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PiBGcm9tOiBLYWxsZSBWYWxvIFttYWlsdG86a3ZhbG9AY29kZWF1cm9yYS5vcmddDQo+IFNlbnQ6
IFdlZG5lc2RheSwgQXByaWwgMDUsIDIwMTcgNDoxOSBQTQ0KPiBUbzogQW1pdGt1bWFyIEthcndh
cg0KPiBDYzogbGludXgtd2lyZWxlc3NAdmdlci5rZXJuZWwub3JnOyBHYW5hcGF0aGkgQmhhdDsg
S2FydGhpaw0KPiBEb2RkYXllbm5lZ2VyZSBBbmFudGhhcGFkbWFuYWJoYTsgQW1pdGt1bWFyIEth
cndhcg0KPiBTdWJqZWN0OiBbRVhUXSBSZTogbXdpZmlleDogYXBwbHkgcmFkYXIgZmxhZw0KPiAN
Cj4gQW1pdGt1bWFyIEthcndhciA8YWthcndhckBtYXJ2ZWxsLmNvbT4gd3JvdGU6DQo+ID4gRnJv
bTogS2FydGhpayBEIEEgPGthcnRoaWRhQG1hcnZlbGwuY29tPg0KPiA+DQo+ID4gV2hlbiBJRUVF
ODAyMTFfQ0hBTl9SQURBUiBpcyBzZXQgYnkgY2ZnODAyMTEsIHBhc3NpdmUgc2NhbiBtdXN0IGJl
DQo+ID4gcGVyZm9ybWVkLiBJbiBtd2lmaWV4LGFjdGl2ZSBzY2FuIGlzIHBlcmZvcm1lZCBldmVu
IHRob3VnaCBmbGFnIGlzDQo+IHNldA0KPiA+IGZyb20gY2ZnODAyMTEuIG13aWZpZXhfcmVnX2Fw
cGx5X3JhZGFyX2ZsYWdzKCkgZnVuY3Rpb24gYWRkZWQgaW4gdGhpcw0KPiA+IHBhdGNoIGNvcnJl
Y3RseSB1c2VzIHJhZGFyIGZsYWcuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBLYXJ0aGlrIEQg
QSA8a2FydGhpZGFAbWFydmVsbC5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogQW1pdGt1bWFyIEth
cndhciA8YWthcndhckBtYXJ2ZWxsLmNvbT4NCj4gDQo+IFBsZWFzZSB1c2UgS2FydGhpaydzIGZ1
bGwgbmFtZS4NCg0KT2sgS2FsbGUuIEkgd2lsbCBzdWJtaXQgdjIgd2l0aCBjb3JyZWN0aW9uLg0K
DQo+IA0KPiBQYXRjaCBzZXQgdG8gQ2hhbmdlcyBSZXF1ZXN0ZWQuDQo+IA0KPiAtLQ0KDQoNClJl
Z2FyZHMsDQpHYW5hcGF0aGkNCg0K
