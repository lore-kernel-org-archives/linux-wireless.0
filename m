Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:47729 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751097AbaJIJaM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2014 05:30:12 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Belisko Marek <marek.belisko@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Avinash Patil <patila@marvell.com>
Date: Thu, 9 Oct 2014 02:30:04 -0700
Subject: RE: mwifiex_usb_submit_rx_urb: dev_alloc_skb failed when conected
 to 5GHz
Message-ID: <5FF020A1CFFEEC49BD1E09530C4FF5951821936285@SC-VEXCH1.marvell.com> (sfid-20141009_113016_384943_4975C4F3)
References: <CAAfyv35k1mgQh6FcWaaMciAo8Vkp055k=5xF7zu+yrHmrQbbLA@mail.gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951819DB12F1@SC-VEXCH1.marvell.com>
	<CAAfyv35j-77AURB4fHcecbEvyGS6U+1APNRFCf3FDAd_rrWnJw@mail.gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951821351855@SC-VEXCH1.marvell.com>
 <CAAfyv35E2HUReFpnpdsebPETKk9VPA_hfQHUEJmoJfQt6Q-Puw@mail.gmail.com>
In-Reply-To: <CAAfyv35E2HUReFpnpdsebPETKk9VPA_hfQHUEJmoJfQt6Q-Puw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgTWFyZWssDQoNClNvcnJ5IGZvciBsYXRlIHJlcGx5LiBXZSBoYXZlIHRyaWVkIHRvIHNpbXVs
YXRlIGRldl9hbGxvY19za2IoKSBmYWlsdXJlIG9uIG91ciByZWZlcmVuY2UgcGxhdGZvcm0gYWZ0
ZXIgMTAwdGgsIDIwMHRoLCAzMDB0aCBldGMuIHBhY2tldHMuIE91ciBvYnNlcnZhdGlvbiBpcyB3
aGVuIHRoZSBmYWlsdXJlIG9jY3VycywgY29ycmVzcG9uZGluZyBVUkIgd29uJ3QgZ2V0IHN1Ym1p
dHRlZCwgYnV0IHRyYWZmaWMgY29udGludWVzLiBUcmFmZmljIHN0b3BzIHdoZW4gdGhlIGZhaWx1
cmUgY291bnQgcmVhY2hlcyA2IChtd2lmaWV4IFJ4IFVSQiBjb3VudCkuIFdlIGRvbid0IHNlZSBh
bnkgY3Jhc2ggb3Igc3lzdGVtIHVucmVzcG9uc2l2ZW5lc3MuDQoNCg0KPiBJIGRpZCBzbWFsbCBp
bnZlc3RpZ2F0aW9uICh3aWxsIG15IGxpbWl0ZWQgbmV0d29ya2luZyBrbm93bGVkZ2UgOikpIGFu
ZA0KPiB0byBhdm9pZCB1c2IgaXNzdWUgSSBkaWQgc21hbGwgaGFjayB0byBmcmVlIHJlY2VpdmVk
IHBhY2tldCBpbiBza2INCj4gKHdpdGggc3BlY2lmaWMgc2l6ZQ0KPiAxNTc0IHdoaWNoIHNlbmRz
IGlwZXJmKSBiZWZvcmUgc2VuZGluZyBmb3IgcHJvY2Vzc2luZyB0byBkcml2ZXINCj4gd29ya3F1
ZXVlLiBXaXRoIHRoaXMgc21hbGwgaGFjayBJIGNhbiBydW4gaXBlcmYgLWIxMDBtIG9uIGNsaWVu
dCBzaXplDQo+IHdpdGhvdXQgYW55IGFsbG9jYXRpb24gaXNzdWUuDQoNClRoYXQncyBnb29kIDop
IEFjdHVhbGx5IGtlcm5lbCB3aWxsIHRha2UgY2FyZSBvZiBmcmVlaW5nIHNrYiB3aGVuIGRyaXZl
ciBzdWJtaXRzIHJlY2VpdmVkIHBhY2tldCB1c2luZyBuZXRpZl9yeCgpLiBDb3VsZCB5b3UgcGxl
YXNlIHNoYXJlIHlvdXIgaGFjaz8NCg0KUmVnYXJkcywNCkFtaXQNCg==
