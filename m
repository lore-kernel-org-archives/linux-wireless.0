Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:51490 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751086AbdKTNxK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Nov 2017 08:53:10 -0500
From: Ganapathi Bhat <gbhat@marvell.com>
To: Ellie Reeves <ellierevves@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "amitkarwar@gmail.com" <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Xinming Hu <huxm@marvell.com>
Subject: RE: [EXT] Marvell Mwifiex wireless driver: mwifiex_pcie broken on
 Marvell ESPRESSOBin
Date: Mon, 20 Nov 2017 13:53:07 +0000
Message-ID: <a4233e0d08f1400fa30ef112e0fda464@SC-EXCH02.marvell.com> (sfid-20171120_145317_641675_4E66B584)
References: <6dc0221c-c7ec-d107-02e8-0ab443807e51@gmail.com>
In-Reply-To: <6dc0221c-c7ec-d107-02e8-0ab443807e51@gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgRWxpZSwNCg0KPiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+IEhlbGxvLA0KPiBJIG5vdGljZWQgdGhlIE1h
cnZlbGwgTXdpZmlleCB3aXJlbGVzcyBkcml2ZXIgZW5kZWQgdXAgYnJva2VuIHNpbmNlIGtlcm5l
bA0KPiA0LjEzLjAsIGFuZCBpdCBpcyBzdGlsbCB0aGUgY2FzZSB3aXRoIDQuMTQuMCBvbiB0aGUg
TWFydmVsbCBFU1BSRVNTT0Jpbiwgc29sZWQgYnkNCj4gR2xvYmFsc2NhbGUgVGVjaG5vbG9neS4g
SSBib3VnaHQgdGhlIG9mZmljaWFsIHdpcmVsZXNzIGNhcmQgZnJvbSB0aGVtIGF0IHRoZQ0KPiBz
YW1lIHRpbWUgYXMgdGhlIGJvYXJkLiBIb3dldmVyIHNpbmNlIGtlcm5lbCA0LjEzLjAsIHdpZmkg
YXMgcHJvdmlkZWQgdmlhDQo+IG13aWZpZXhfcGNpZSBtb2R1bGUgc3RvcHBlZCB3b3JraW5nLg0K
PiBJIGRvbid0IGhhdmUgbXVjaCBpbmZvIG9uIHRoZSB1c2Vyc3BhY2Ugc2lkZSwgYXMgYWxsIHRo
YXQgaGFwcGVucyBpcyB0aGUNCj4gd2lyZWxlc3MgaW50ZXJmYWNlIGlzIG5ldmVyIGJyb3VnaHQg
dXAgYW5kIHN0YXlzIGluICdOTy1DQVJSSUVSJz8gc3RhdGUNCj4gYWNjb3JkaW5nIHRvICdpcCBh
Jy4gSG93ZXZlciBvbiBrZXJuZWwgc2lkZSwgSSBob3BlIEkgaGF2ZSBzb21lIGluZm8gdGhhdCBh
cmUNCj4gbW9yZSB1c2VmdWwgISA6KSBUaGlzIHdhcyBsb2dnZWQgdmlhIHN5c3RlbWQtam91cm5h
bGQgd2l0aCBkZWJ1ZyB0dXJuZWQgb24NCj4gaW4gbXdpZmlleCBkcml2ZXIuIEkgYW0gd2lsbGlu
ZyB0byB0cnkgYW55dGhpbmcgdG8gZ2V0IHRoaXMga2VybmVsIHdvcmtpbmcsIGFzIGl0J3MNCj4g
YSBsdHMga2VybmVsIGNvbnRyYXJ5IHRvIDQuMTIuMTIgb24gd2hpY2ggSSdtIGZvcmNlZCB0byBy
dW4gZm9yIG5vdy4NCj4NCj4gaHR0cHM6Ly9naXN0LmdpdGh1YnVzZXJjb250ZW50LmNvbS9tay0N
Cj4gZmcvMjdjMjUwNWZkM2JmZmNmMGFmODc3NzdhYWFmYjcxZmUvcmF3L2ZkYTcwZmY5ZjhlYWFi
MjQ4YTEwNGUwMzkyMjMyDQo+IDNjZjJmNDc1NGJmL3RtcC50eHQNCj4NCj4gSSBob3BlIHRoZXNl
IGluZm8gd2lsbCBiZSB1c2VmdWwgaW4gZGVidWdnaW5nLiBJJ20gbmV3IHRvIGFsbCB0aGVzZSBr
ZXJuZWwNCj4gc3R1ZmYsIHNvIEkgbWF5IGhhdmUgcG9zdGVkIHRvIHRoZSB3cm9uZyBwbGFjZSBv
ciBpbiBhIHdyb25nIHdheSwgaWYgc28sDQo+IHBsZWFzZSBsZXQgbWUga25vdy4NCj4NCj4gVGhh
bmtzIGluIGFkdmFuY2UNCj4NCg0KVGhhbmtzIGZvciB0aGUgbm90aWZpY2F0aW9uIGFuZCBsb2dz
LiAgV2UgaGF2ZSBhIGZpeCBmb3IgdGhpcyBpc3N1ZSwgd2hpY2ggd2lsbCBiZSBzZW5kIHVwc3Ry
ZWFtIHNvb24uDQoNCj4gLS0NCj4gRWxsaWUgUmVldmVzDQoNCg0KUmVnYXJkcywNCkdhbmFwYXRo
aQ0K
