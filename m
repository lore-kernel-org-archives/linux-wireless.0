Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:36012
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933783Ab3D3Wzq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Apr 2013 18:55:46 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Emmanuel Grumbach <egrumbach@gmail.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	Roman Yepishev <roman.yepishev@gmail.com>,
	"Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Subject: Re: is L1 really disabled in iwlwifi
Date: Tue, 30 Apr 2013 22:55:36 +0000
Message-ID: <1367362536.9976.9.camel@x230> (sfid-20130501_005551_871458_F6917709)
References: <CANUX_P3F5YhbZX3WGU-j1AGpbXb_T9Bis2ErhvKkFMtDvzatVQ@mail.gmail.com>
	 <20130304134949.GB3021@redhat.com>
	 <CANUX_P0JhuVWcQjTckYzG8eBb2MtT_=prKqV38mCpVjfLmGtCA@mail.gmail.com>
	 <20130304154832.GD3021@redhat.com>
	 <CANUX_P22AkqeOROP1QHzp20wGWgDbRzy+9FZy2KvHLXCQ5AVnA@mail.gmail.com>
	 <CAErSpo5gVsUxB6ebQGAN-7jsZiRYZ+SyJn5gKZrSuOzzkJ-QjQ@mail.gmail.com>
	 <CANUX_P2-V0-=sfofxYwAYCRvqPPf5Z2wy6CUNQmGQQ2NqjZJ_A@mail.gmail.com>
	 <CAErSpo4xmDU2O35ge342nMuiVyDkzSGNRaz2O7-w6jDz_eBgyg@mail.gmail.com>
	 <CANUX_P2Hy02SnyYS24dyUGLv3wB3L5xkXt8Y1s+8_RG9d5ReAw@mail.gmail.com>
	 <CANUX_P3znXgMN5aBZbEVx_zKpTQ98my1C_cBG5+mERFWrrrLEw@mail.gmail.com>
	 <CANUX_P3Mt3X8JXq5siSijrWGkjeWbTCcdmJ-Fuv6U8jUqrFouQ@mail.gmail.com>
	 <CAErSpo66=UngrHNcEDeh4gXnt5c0qJHwbxum0mBz-rSWGduLhg@mail.gmail.com>
	 <CANUX_P0hpx8NNvX6cJXfOZMNYN8hrEF-gzf9hBN2Uz=k0WiwgA@mail.gmail.com>
	 <CANUX_P1JnFk7yovC7kXBMDWiErGhvzDQrNCm8te39m41SonCNg@mail.gmail.com>
	 <CAErSpo5WbdCx0iyt14bJxCiNBtUWjT2rMeg5YwNQaRt=M+_v8Q@mail.gmail.com>
In-Reply-To: <CAErSpo5WbdCx0iyt14bJxCiNBtUWjT2rMeg5YwNQaRt=M+_v8Q@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gVHVlLCAyMDEzLTA0LTMwIGF0IDE2OjQ1IC0wNjAwLCBCam9ybiBIZWxnYWFzIHdyb3RlOg0K
DQo+IEknbSBub3QgY29udmluY2VkIGl3bHdpZmkgcmVhbGx5IG5lZWRzIHRvIGRpc2FibGUgdGhl
IGxpbmsgcG93ZXINCj4gbWFuYWdlbWVudCBzdGF0ZXMgaW4gdGhlIGZpcnN0IHBsYWNlIC0tIHRo
ZSAxYTcxMjNjZGQ5IGNoYW5nZWxvZyBpc24ndA0KPiB2ZXJ5IGNvbnZpbmNpbmcsIGFuZCBJJ20g
bm90IGF3YXJlIG9mIGFueSByZXBvcnRlZCBpc3N1ZXMgZXZlbiB0aG91Z2gNCj4gd2UncmUgYWN0
dWFsbHkgbGVhdmluZyB0aGVtIGVuYWJsZWQgaW4gbWFueSBjYXNlcy4NCj4gDQo+IE1vcmUgZ2Vu
ZXJhbGx5LCBJIGRvbid0IHRoaW5rIHRoZSBwY2lfZGlzYWJsZV9saW5rX3N0YXRlKCkgaW50ZXJm
YWNlDQo+IGlzIHZlcnkgdXNlZnVsIGJlY2F1c2UgaXQgb2Z0ZW4gZG9lc24ndCBkbyB3aGF0IGl0
IGNsYWltcywgYW5kIHRoZQ0KPiBjYWxsZXIgaGFzIG5vIGluZGljYXRpb24uDQoNClRoZSBnZW5l
cmFsIGlzc3VlIGhlcmUgaXMgdGhhdCBXaW5kb3dzIHdpbGwgKGFzIGZhciBhcyB3ZSd2ZSBiZWVu
IGFibGUNCnRvIGRldGVybWluZSkgbmV2ZXIgdG91Y2ggQVNQTSByZWdpc3RlcnMgdW5sZXNzIGdp
dmVuIFBDSWUgY29udHJvbCB2aWENCl9PU0MuIERyaXZlcnMgYXJlIHByZXN1bWFibHkgYWJsZSB0
byBvdmVycmlkZSB0aGlzIGJ5IGhpdHRpbmcNCmNvbmZpZ3VyYXRpb24gcmVnaXN0ZXJzIHRoZW1z
ZWx2ZXMuIFRoZSBwY2lfZGlzYWJsZV9saW5rX3N0YXRlKCkNCmZ1bmN0aW9ucyBhcmUgY3VycmVu
dGx5IGJyb2FkbHkgZXF1aXZhbGVudCB0byB0aGUgaGVscGVyIGZ1bmN0aW9ucw0KcHJvdmlkZWQg
aW4gdGhlIFdpbmRvd3MgLmluZiBmaWxlcywgYW5kIGlmIGRyaXZlcnMgcmVhbGx5IHdhbnQgdG8N
CmRpc2FibGUgdGhlIGNvbnRyb2wgdGhlbXNlbHZlcyB0aGVuIHRoZXkgY2FuIGRvIHNvLiBSZW5h
bWluZyB0aGUNCmZ1bmN0aW9ucyB0byBtYWtlIHRoYXQgY2xlYXJlciwgYW5kIHBvc3NpYmx5IGFk
ZGluZyBzb21lIGFkZGl0aW9uYWwNCmZ1bmN0aW9ucyB0byBmb3JjZSB0aGUgY2FzZSwgbWF5IGJl
IHdvcnRod2hpbGUuDQoNClRoZSBvbmx5IHRpbWUgdGhpcyBzaG91bGQgYmUgcmVsZXZhbnQgaXMg
aWYgKGEpIHRoZSBCSU9TIGhhcyBlbmFibGVkIEwxDQpvbiBpd2x3aWZpLCAoYikgdGhlIEJJT1Mg
aGFzIGRpc2FibGVkIEFTUE0gY29udHJvbCwgYW5kIChjKSB0aGUgaGFyZHdhcmUNCmRvZXNuJ3Qg
d29yayB3aXRoIEwxIGVuYWJsZWQuIEFyZSB0aGVyZSByZWFsbHkgY2FzZXMgd2hlcmUgdGhhdCdz
IHRydWU/DQoNCi0tIA0KTWF0dGhldyBHYXJyZXR0IHwgbWpnNTlAc3JjZi51Y2FtLm9yZw0K

