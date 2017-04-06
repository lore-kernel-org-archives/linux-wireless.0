Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:39903 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752093AbdDFIOq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Apr 2017 04:14:46 -0400
From: Xinming Hu <huxm@marvell.com>
To: Kalle Valo <kvalo@codeaurora.org>,
        Xinming Hu <huxinming820@gmail.com>
CC: Linux Wireless <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@qca.qualcomm.com>,
        Brian Norris <briannorris@google.com>,
        "Dmitry Torokhov" <dtor@google.com>,
        "rajatja@google.com" <rajatja@google.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Cathy Luo <cluo@marvell.com>
Subject: RE:] Re: [3/3] mwifiex: pcie: avoid hardcode wifi-only firmware name
Date: Thu, 6 Apr 2017 08:14:36 +0000
Message-ID: <d229021835e64e2c8db8c1f6936828b7@SC-EXCH02.marvell.com> (sfid-20170406_101453_282571_C9B9C1CF)
References: <1490865547-10208-3-git-send-email-huxinming820@gmail.com>
 <20170405104711.1092260DC7@smtp.codeaurora.org>
In-Reply-To: <20170405104711.1092260DC7@smtp.codeaurora.org>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgS2FsbGUsDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogS2FsbGUg
VmFsbyBbbWFpbHRvOmt2YWxvQGNvZGVhdXJvcmEub3JnXQ0KPiBTZW50OiAyMDE35bm0NOaciDXm
l6UgMTg6NDcNCj4gVG86IFhpbm1pbmcgSHUNCj4gQ2M6IExpbnV4IFdpcmVsZXNzOyBLYWxsZSBW
YWxvOyBCcmlhbiBOb3JyaXM7IERtaXRyeSBUb3Jva2hvdjsNCj4gcmFqYXRqYUBnb29nbGUuY29t
OyBBbWl0a3VtYXIgS2Fyd2FyOyBDYXRoeSBMdW87IFhpbm1pbmcgSHUNCj4gU3ViamVjdDogW0VY
VF0gUmU6IFszLzNdIG13aWZpZXg6IHBjaWU6IGF2b2lkIGhhcmRjb2RlIHdpZmktb25seSBmaXJt
d2FyZSBuYW1lDQo+IA0KPiBFeHRlcm5hbCBFbWFpbA0KPiANCj4gLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiBY
aW5taW5nIEh1IDxodXhpbm1pbmc4MjBAZ21haWwuY29tPiB3cm90ZToNCj4gPiBGcm9tOiBYaW5t
aW5nIEh1IDxodXhtQG1hcnZlbGwuY29tPg0KPiA+DQo+ID4gV2lmaS1vbmx5IGZpcm13YXJlIG5h
bWUgc2hvdWxkIGJlIGNoaXBzZXQgc3BlY2lmaWMuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBY
aW5taW5nIEh1IDxodXhtQG1hcnZlbGwuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEFtaXRrdW1h
ciBLYXJ3YXIgPGFrYXJ3YXJAbWFydmVsbC5jb20+DQo+IA0KPiBUaGUgY29tbWl0IGxvZyBpcyBu
b3QgdGVsbGluZyBhbnl0aGluZy4gV2h5IGFyZSB5b3UgY2hhbmdpbmcgdGhpcz8gQW5kIGhvdw0K
PiBkb2VzIHRoZSBmdW5jdGlvbmFsaXR5IGNoYW5nZSBmcm9tIHVzZXIgc3BhY2UgcG9pbnQgb2Yg
dmlldz8NCj4gDQoNClRoYW5rcyBmb3IgdGhlIHJldmlldywgd2UgaGF2ZSBpbXBsZW1lbnRlZCBh
IG5ldyB3YXkgdG8gZXh0cmFjdCB3aWZpLW9ubHkgcGFydCBmcm9tIGNvbWJvIGZpcm13YXJlLCB3
aWxsIGFkZCBtb3JlIGRlc2NyaXB0aW9uIGluIHYyDQoNClRoYW5rcywNClNpbW9uDQo+IC0tDQo+
IGh0dHBzOi8vcGF0Y2h3b3JrLmtlcm5lbC5vcmcvcGF0Y2gvOTY1MzM4Ny8NCj4gDQo+IGh0dHBz
Oi8vd2lyZWxlc3Mud2lraS5rZXJuZWwub3JnL2VuL2RldmVsb3BlcnMvZG9jdW1lbnRhdGlvbi9z
dWJtaXR0aW5ncGF0DQo+IGNoZXMNCg0K
