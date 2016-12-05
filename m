Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4025 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751373AbcLETYQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Dec 2016 14:24:16 -0500
From: "Nagarajan, Ashok Raj" <arnagara@qti.qualcomm.com>
To: Benjamin Morgan <bmorgan@cococorp.com>,
        Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
CC: "agreen@cococorp.com" <agreen@cococorp.com>,
        "lede-dev@lists.infradead.org" <lede-dev@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: RE: ath10k firmware crashes in mesh mode on QCA9880
Date: Mon, 5 Dec 2016 19:24:08 +0000
Message-ID: <d8eb0ba5828d43dd83030247ba443b88@aphydexm01f.ap.qualcomm.com> (sfid-20161205_202420_209018_A53E015F)
References: <583DD564.8040704@cococorp.com>
 <20161201070908.GB11953@atheros-ThinkPad-T61> <58421FA2.2020004@cococorp.com>
 <20161203124358.GB31861@atheros-ThinkPad-T61>
 <20161203124600.GC31861@atheros-ThinkPad-T61> <5845B325.6060002@cococorp.com>
In-Reply-To: <5845B325.6060002@cococorp.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pj4gQXBwbGllZCB0aGUgcGF0Y2ggYW5kIHRyaWVkIHdpdGggMTAuMi40LjcwLjU0IGZpcm13YXJl
IGFuZCBpdCBzdGlsbCBjcmFzaGVzOg0KDQo+PiBbICAxNDIuNDM4Mzc3XSBhdGgxMGtfcGNpIDAw
MDA6MDE6MDAuMDogZmlybXdhcmUgY3Jhc2hlZCEgKHV1aWQgDQo+PiBhNTQ5OTU4Mi1lMjIwLTQ2
ZDItOTM1OS0wYjQ0MjE5ZjY5ZWEpDQo+PiBbICAxNDIuNDQ3NTEyXSBhdGgxMGtfcGNpIDAwMDA6
MDE6MDAuMDogcWNhOTg4eCBodzIuMCB0YXJnZXQgMHg0MTAwMDE2YyANCj4+IGNoaXBfaWQgMHgw
NDMyMDJmZiBzdWIgMDAwMDowMDAwDQo+PiBbICAxNDIuNDU2ODc5XSBhdGgxMGtfcGNpIDAwMDA6
MDE6MDAuMDoga2NvbmZpZyBkZWJ1ZyAwIGRlYnVnZnMgMSANCj4+IHRyYWNpbmcgMCBkZnMgMSB0
ZXN0bW9kZSAxDQo+PiBbICAxNDIuNDY5OTE2XSBhdGgxMGtfcGNpIDAwMDA6MDE6MDAuMDogZmly
bXdhcmUgdmVyIDEwLjIuNC43MC41NCBhcGkgNSANCmZlYXR1cmVzIG5vLXAycCxyYXctbW9kZSxt
ZnAgY3JjMzIgOWQzNDBkZDkNCj4+IFsgIDE0Mi40ODAyOTVdIGF0aDEwa19wY2kgMDAwMDowMTow
MC4wOiBib2FyZF9maWxlIGFwaSAxIGJtaV9pZCBOL0EgDQo+PiBjcmMzMiBiZWJjN2MwOA0KPj4g
WyAgMTQyLjQ4NzcxN10gYXRoMTBrX3BjaSAwMDAwOjAxOjAwLjA6IGh0dC12ZXIgMi4xIHdtaS1v
cCA1IGh0dC1vcCAyIA0KPj4gY2FsIGZpbGUgbWF4LXN0YSAxMjggcmF3IDAgaHdjcnlwdG8gMQ0K
Pj4gWyAgMTQyLjQ5OTM2MV0gYXRoMTBrX3BjaSAwMDAwOjAxOjAwLjA6IGZpcm13YXJlIHJlZ2lz
dGVyIGR1bXA6DQo+PiBbICAxNDIuNTA1MTI0XSBhdGgxMGtfcGNpIDAwMDA6MDE6MDAuMDogWzAw
XTogMHg0MTAwMDE2QyAweDAwMDAxNUIzIA0KMHgwMDlBNDU3NyAweDAwOTU1QjMxDQoNCkJlbmph
bWluLCBUaGFua3MgZm9yIHRoZSBsb2dzLg0KUXVpY2sgcXVlc3Rpb25zIHRvIGZ1cnRoZXIgZGVi
dWcgdGhlIGlzc3VlIGhlcmUsDQoNCjEuIElzIHRoaXMgaXNzdWUgc2VlbiBldmVyeSB0aW1lIHlv
dSBzdGFydCBzZW5kaW5nIGRhdGEgdHJhZmZpYz8NCjIuIElzc3VlIHNlZW4gd2l0aCBvbGRlciBm
aXJtd2FyZXM/IChGWVIsIGh0dHA6Ly9saW51eHdpcmVsZXNzLm9yZy9lbi91c2Vycy9Ecml2ZXJz
L2F0aDEway9maXJtd2FyZS8gKQ0KMy4gQ291bGQgeW91IHBsZWFzZSBzaGFyZSB0aGUgZG1lc2cg
ZnJvbSB5b3VyIGRldmljZSBhZnRlciBlbmFibGluZyBNQUMgYW5kIFdNSSBsb2dzIGluIGF0aDEw
ayBkcml2ZXINCglUbyBlbmFibGUgZGVidWcgbG9ncyBwbGVhc2Ugc2VlIGh0dHA6Ly9saW51eHdp
cmVsZXNzLm9yZy9lbi91c2Vycy9Ecml2ZXJzL2F0aDEway9kZWJ1Zy8JDQo0LiBEbyB5b3Uga25v
dyB3aGF0IGlzIHRoZSBOdW1iZXIgb2YgU3BhdGlhbCBTdHJlYW1zIHNlZW4gaW4gbWVzaCBiZWFj
b25zIGFuZCBpbiBtZXNoIGRhdGEgcGFja2V0Pw0KDQpUaGFua3MsDQpBc2hvaw0K
