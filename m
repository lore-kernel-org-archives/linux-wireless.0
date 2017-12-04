Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-eopbgr10074.outbound.protection.outlook.com ([40.107.1.74]:35648
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751941AbdLDTAj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Dec 2017 14:00:39 -0500
From: Vanessa Maegima <vanessa.maegima@nxp.com>
To: "arend.vanspriel@broadcom.com" <arend.vanspriel@broadcom.com>,
        "van.ayumi@gmail.com" <van.ayumi@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "embed3d@gmail.com" <embed3d@gmail.com>
Subject: Re: AP6335 with mainline kernel
Date: Mon, 4 Dec 2017 19:00:36 +0000
Message-ID: <1512413992.18900.3.camel@nxp.com> (sfid-20171204_200043_493022_D787675C)
References: <CABACg+yVE+fuzT-qwjNnACqq24KQbNJOae22=v+J+0Q=8kuKRQ@mail.gmail.com>
         <85717463-11e2-e2e3-b08e-b758986687b5@broadcom.com>
         <1510916848.26896.2.camel@nxp.com> <5A0EDC25.7030505@broadcom.com>
         <1510932224.22506.0.camel@nxp.com>
         <d9a80a75-b3d4-d78e-a5bf-ab31732f040d@broadcom.com>
         <e14bdc26-5092-18c9-4caa-c45fd1d12984@broadcom.com>
         <1511347672.18886.2.camel@nxp.com> <5A15584A.9090601@broadcom.com>
         <1511450638.9102.1.camel@nxp.com> <5A1FFA17.6000703@broadcom.com>
In-Reply-To: <5A1FFA17.6000703@broadcom.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgQXJlbmQsDQoNCk9uIFF1aSwgMjAxNy0xMS0zMCBhdCAxMzozMSArMDEwMCwgQXJlbmQgdmFu
IFNwcmllbCB3cm90ZToNCj4gT24gMTEvMjMvMjAxNyA0OjI0IFBNLCBWYW5lc3NhIE1hZWdpbWEg
d3JvdGU6DQo+ID4gDQo+ID4gPiANCj4gPiA+ID4gDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiAN
Cj4gPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiA+IEJ1aWxkcm9vdDoNCj4gPiA+ID4gPiA+ID4g
IyBkbWVzZyB8IGdyZXAgYnJjbWZtYWMNCj4gPiA+ID4gPiA+ID4gW8KgwqDCoMKgNS4zNDMxMThd
IGJyY21mbWFjOiBicmNtZl9md19tYXBfY2hpcF90b19uYW1lOiB1c2luZw0KPiA+ID4gPiA+ID4g
PiBicmNtL2JyY21mbWFjNDMzOS1zZGlvLmJpbiBmb3IgY2hpcCAweDAwNDMzDQo+ID4gPiA+ID4g
PiA+IDkoMTcyMDkpIHJldiAweDAwMDAwMg0KPiA+ID4gPiA+ID4gPiBbwqDCoMKgwqA2LjQyMDA3
MF0gYnJjbWZtYWM6IGJyY21mX3NkaW9faHRjbGs6IEhUIEF2YWlsDQo+ID4gPiA+ID4gPiA+IHRp
bWVvdXQNCj4gPiA+ID4gPiA+ID4gKDEwMDAwMDApOg0KPiA+ID4gPiA+ID4gPiBjbGtjdGwgMHg1
MA0KPiA+ID4gPiA+ID4gPiBbwqDCoMKgwqA2LjQyNzcyMl0gYnJjbWZtYWM6DQo+ID4gPiA+ID4g
PiA+IGJyY21mX3NkaW9faHRjbGs6wqDCoMKgcG11Y29udHJvbMKgwqDCoD0NCj4gPiA+ID4gPiA+
ID4gMDE3NzQzODENCj4gPiA+ID4gPiA+ID4gW8KgwqDCoMKgNi40MzQ4NjVdIGJyY21mbWFjOg0K
PiA+ID4gPiA+ID4gPiBicmNtZl9zZGlvX2h0Y2xrOsKgwqDCoHBtdXN0YXR1c8KgwqDCoMKgPQ0K
PiA+ID4gPiA+ID4gPiAwMDAwMDAyYQ0KPiA+ID4gPiA+ID4gPiBbwqDCoMKgwqA2LjQ0MTE3NF0g
YnJjbWZtYWM6IGJyY21mX3NkaW9faHRjbGs6wqDCoMKgbWluX3Jlc19tYXNrDQo+ID4gPiA+ID4g
PiA+ID0NCj4gPiA+ID4gPiA+ID4gMGZjYWZmNzcNCj4gPiA+ID4gPiA+ID4gW8KgwqDCoMKgNi40
NDczNzldIGJyY21mbWFjOiBicmNtZl9zZGlvX2h0Y2xrOsKgwqDCoG1heF9yZXNfbWFzaw0KPiA+
ID4gPiA+ID4gPiA9DQo+ID4gPiA+ID4gPiA+IDBmY2VmZjc3DQo+IEl0IHRvb29rIG1lIGEgd2hp
bGUgdG8gbG9vayBpbnRvIHRoaXMuIFVuZm9ydHVuYXRlbHkgSSBkbyBub3QgaGF2ZSBhwqANCj4g
NDMzOSB0byByZXBsaWNhdGUgeW91ciBpc3N1ZS4gVGhlIGNsb3Nlc3QgSSBoYXZlIGlzIGEgNDMz
NS4gV2hhdA0KPiBsb29rc8KgDQo+IHdyb25nIGhlcmUgaXMgdGhlIG1heF9yZXNfbWFzayBiZWNh
dXNlIHRoZSBIVCBBdmFpbCByZXNvdXJjZSBpcyBiaXQNCj4gMjnCoA0KPiB3aGljaCBuZWVkcyB0
byBiZSBzZXQgaW4gbWF4X3Jlc19tYXNrIGluIG9yZGVyIHRvIG1ha2UgdGhlIHJlcXVlc3QNCj4g
d29yay7CoA0KPiBPbiBteSA0MzM1IHRoZSBtYXhfcmVzX21hc2sgaXMgMHg3ZmZmZmZmZiBiZWZv
cmUgY2FsbGluZ8KgDQo+IGJyY21mX3NkaW9faHRjbGsoKS4gU28gdGhhdCBpcyB0aGUgY2F1c2Ug
b2YgdGhlIGZhaWx1cmUgaW7CoA0KPiBicmNtZl9zZGlvX2h0Y2xrKCkuIEhvd2V2ZXIsIG5vdyB0
aGUgcXVlc3Rpb24gaXMgd2h5IGl0IGlzIG5vdA0KPiBwcm9wZXJseSBzZXQuDQo+IA0KPiBCZXR3
ZWVuIHlvdXIgZGV2aWNlIGFuZCBtaW5lIHRoZXJlIGlzIG9uY2UgZGlzY3JlcGFuY3kgaW4gdGhl
DQo+IHBtdWNvbnRyb2zCoA0KPiByZWdpc3RlciwgaWUuIGJpdCA5IGlzIHNldCBmb3IgeW91ciBk
ZXZpY2UuIEFjY29yZGluZyB0aGUNCj4gZG9jdW1lbnRhdGlvbsKgDQo+IHRoZSBwb3dlci1vbiBy
ZXNldCB2YWx1ZSBmb3IgdGhpcyBiaXQgaXMgMCBhbmQgSSBkb24ndCBzZWVuIGFueSBjb2RlDQo+
IGluwqANCj4gb3VyIHByb3ByaWV0YXJ5IGRyaXZlciB0b3VjaGluZyBpdC4NCj4gDQo+ID4gDQo+
ID4gU29ycnkgZm9yIHRoZSBkZWxheWVkIGFuc3dlciwgSSBoYWQgc29tZSB0cm91YmxlIHRvIGNv
cHkgdGhlDQo+ID4gc3ltbGlua3MNCj4gPiBmaWxlcyBjb3JyZXRseSBmcm9tIC9zeXMvY2xhc3Mv
ZGV2Y29yZWR1bXAuDQo+ID4gDQo+ID4gSSB1cGxvYWRlZCB0aGlzIGZvbGRlciB0bzogaHR0cHM6
Ly9lbWVhMDEuc2FmZWxpbmtzLnByb3RlY3Rpb24ub3V0bA0KPiA+IG9vay5jb20vP3VybD1odHRw
cyUzQSUyRiUyRmRyaXZlLmdvb2dsZS5jb20lMkZvcGVuJTNGaWQlM0QxZm9zYWhqTE4NCj4gPiAx
SyZkYXRhPTAyJTdDMDElN0N2YW5lc3NhLm1hZWdpbWElNDBueHAuY29tJTdDYjY0M2U1Nzg3NmU0
NDE0MGFhMzAwDQo+ID4gOGQ1MzdlZTQ0YWElN0M2ODZlYTFkM2JjMmI0YzZmYTkyY2Q5OWM1YzMw
MTYzNSU3QzAlN0MwJTdDNjM2NDc2NDE4OA0KPiA+IDQ5NDY0MjE0JnNkYXRhPUJyc0R6ME5jbTc4
NmcxNjlUUU9xRmxiV3V5bFIxcGMxSmtsRWtxZUwlMkZBMCUzRCZyZXMNCj4gPiBlcnZlZD0wDQo+
ID4gSTVOS1M1OV9hUFpkSExwRU5QRkh0Sw0KPiBUaGF0IHdvcmtlZCBuaWNlbHkuIFNvIHRoZSBm
aXJtd2FyZSBzZWVtcyB0byBjcmFzaCB2ZXJ5IGVhcmx5LiBJDQo+IGhhdmXCoA0KPiByZWJ1aWx0
IHRoZSBmaXJtd2FyZSB0byBwcm92aWRlIG1lIG1vcmUgaW5mby4gQ2FuIHlvdSByZWRvIHRoZcKg
DQo+IGRldmNvcmVkdW1wIHRyaWNrIHdpdGggdGhhdCBmaXJtd2FyZS4NCj4gDQo+IFJlZ2FyZHMs
DQo+IEFyZW5kDQoNClRoYW5rcyBmb3IgeW91ciByZXBseSENCg0KSSB0cmllZCB5b3VyIG5ldyBm
aXJtd2FyZSBhbmQgaGVyZSBpcyB0aGUgb3V0cHV0IChuZXdfZmlybXdhcmUgZm9sZGVyKToNCmh0
dHBzOi8vZHJpdmUuZ29vZ2xlLmNvbS9kcml2ZS9mb2xkZXJzLzFmb3NhaGpMTjFLSTVOS1M1OV9h
UFpkSExwRU5QRkh0DQpLDQoNClRoYW5rcyENCg0KUmVnYXJkcywNClZhbmVzc2E=
