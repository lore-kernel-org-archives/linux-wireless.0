Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:45654 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751481AbbHGKva (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2015 06:51:30 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Julien Cubizolles <j.cubizolles@free.fr>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: firmware in a bad state (module mwifiex)
Date: Fri, 7 Aug 2015 10:51:26 +0000
Message-ID: <fcd8e2fce67542f8910108a6078dc123@SC-EXCH04.marvell.com> (sfid-20150807_125134_107827_E7DF7A32)
References: <871tfzast5.fsf@free.fr>
	<0e2dc4e2bd9f4486979cedb4c47e60f2@SC-EXCH04.marvell.com>
	<87zj26z1pd.fsf_-_@free.fr>
	<d74ef56802d24c8e90e1b82eb5003172@SC-EXCH04.marvell.com>
	<87oaim85fq.fsf@free.fr>
	<e4dd6d588a114db8894e0abbeb34fbc7@SC-EXCH04.marvell.com>
 <87wpx9nd3k.fsf@free.fr>
In-Reply-To: <87wpx9nd3k.fsf@free.fr>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgSnVsaWVuLA0KDQo+IA0KPiA+IFRoYW5rcyBmb3IgcmVwb3J0aW5nIHRoaXMuIFdlIHdpbGwg
dGFrZSBhIGxvb2sgYXQgdGhpcyByaWdodCBhd2F5Lg0KPiA+IFdlIGRvbid0IGhhdmUgc2lnbmlm
aWNhbnQgY2hhbmdlcyBhZnRlciA0LjIuMC1yYzMuDQo+IA0KPiBXZWxsIHRoZXJlIHdlcmUgdGhl
IHR3byBwYXRjaGVzIHlvdSBwb2ludGVkIGF0IHRoYXQgZml4ZWQgYSB2ZXJ5IHNlcmlvdXMNCj4g
cHJvYmxlbSBmb3IgbWUuIEFjdHVhbGx5IGFyZSB0aGVzZSBpbmNsdWRlZCBpbiBzb21lIGJyYW5j
aCBvZiB0aGUgbWFpbg0KPiBrZXJuZWwgZ2l0IHRyZWXCoD8gSSBjb3VsZG4ndCBmaW5kIHRoZSBj
b21taXQgZm9yDQo+IGh0dHA6Ly93d3cuc3Bpbmljcy5uZXQvbGlzdHMvbmV0ZGV2L21zZzMzNDM2
Ny5odG1sIGF0DQo+IGh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvY2dpdC9saW51eC9rZXJuZWwvZ2l0
L3RvcnZhbGRzL2xpbnV4LmdpdC8NCj4gDQo+ID4gWW91IGNhbiB0cnkgdG8gZmluZCBvbGRlciB3
b3JraW5nIGNvbW1pdC4NCj4gDQo+IEknbSBhZnJhaWQgdGhhdCB3aWxsIGJlIGRpZmZpY3VsdCBz
aW5jZSB0aGlzIGRyaXZlciBoYXMgYmVlbiBicm9rZW4gZm9yDQo+IG1lIHNpbmNlIHRoZSAzLjE5
IHNlcmllcy4NCj4gDQo+IFRoYW5rcyBhZ2FpbiBmb3IgeW91ciB2ZXJ5IHByZWNpb3VzIGhlbHAu
DQo+IA0KDQpXZSByYW4gb3Zlcm5pZ2h0IGRhdGEgcGF0aCBzdHJlc3MgdGVzdCwgYnV0IGNvdWxk
IG5vdCBoaXQgYW55IGlzc3VlLiBEbyB5b3Ugc2VlIGNvbW1hbmQgdGltZW91dCBtZXNzYWdlIGV2
ZXJ5IHRpbWUgd2hlbiB0aGUgcHJvYmxlbSBpcyBoaXQ/DQpDb3VsZCB5b3UgcHJvdmlkZSBzb21l
IG1vcmUgbG9ncz8gV2UgaGFkIGZvbGxvd2luZyBmaXhlcyBmb3IgdGltZW91dCBpc3N1ZS4gTGlz
dGluZyBoZXJlIGp1c3QgaW4gY2FzZSBpZiB5b3UgbWlzc2VkIHRoZW0obGVzcyBsaWtlbHkpLg0K
aHR0cDovL3d3dy5zcGluaWNzLm5ldC9saXN0cy9saW51eC13aXJlbGVzcy9tc2cxMjM5NTkuaHRt
bA0KaHR0cDovL3d3dy5zcGluaWNzLm5ldC9saXN0cy9saW51eC13aXJlbGVzcy9tc2cxMjQzNjYu
aHRtbA0KDQpTZXR1cCBpbmZvOg0KS2VybmVsIC0gNC4yLjAtcmM0DQpDaGlwIC0gVVNCODc5Nw0K
RmlybXdhcmUgLSAxNC42OC4yOS5wMzgNCg0KUmVnYXJkcywNCkFtaXRrdW1hcg0K
