Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:48209 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932087Ab2JPTpb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Oct 2012 15:45:31 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Sam Leffler <sleffler@chromium.org>,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Tue, 16 Oct 2012 12:43:07 -0700
Subject: RE: [PATCH] iw: add lowpri and flush scan operands
Message-ID: <477F20668A386D41ADCC57781B1F7043083B80DEE2@SC-VEXCH1.marvell.com> (sfid-20121016_214534_996909_D71B7C0A)
References: <1350346947-21280-1-git-send-email-bzhao@marvell.com>
 <1350412864.10177.9.camel@jlt4.sipsolutions.net>
In-Reply-To: <1350412864.10177.9.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgSm9oYW5uZXMsDQoNCj4gPiAtLS0gYS9ubDgwMjExLmgNCj4gPiArKysgYi9ubDgwMjExLmgN
Cj4gDQo+IE5vIG5lZWQgdG8gc2VuZCBubDgwMjExLmggdXBkYXRlcywgSSBkbyB0aG9zZSBkaXJl
Y3RseSBieSBjb3B5aW5nIHRoZQ0KPiBuZXcgZmlsZSB0byBhdm9pZCBtaXNtYXRjaCBpc3N1ZXMu
DQoNCk9LLCB3aWxsIHJlbW92ZSBubDgwMjExIGNoYW5nZS4NCg0KPiANCj4gDQo+ID4gLVRPUExF
VkVMKHNjYW4sICJbLXVdIFtmcmVxIDxmcmVxPipdIFtpZXMgPGhleCBhcyAwMDoxMTouLj5dIFtz
c2lkIDxzc2lkPip8cGFzc2l2ZV0iLCAwLCAwLA0KPiA+ICtUT1BMRVZFTChzY2FuLCAiWy11XSBb
ZnJlcSA8ZnJlcT4qXSBbaWVzIDxoZXggYXMgMDA6MTE6Li4+XSBbc3NpZCA8c3NpZD4qfHBhc3Np
dmV8bG93cHJpfGZsdXNoXSIsDQo+IDAsIDAsDQo+IA0KPiBUaGlzIHNlZW1zIGEgbGl0dGxlIHdy
b25nLCB5b3UgY2FuJ3QgZ2l2ZSBsb3dwcmkvZmx1c2ggYWZ0ZXIgZ2l2aW5nDQo+IFNTSURzLCBz
byBpdCBzaG91bGQgcHJvYmFibHkgYmUgd3JpdHRlbiBhcw0KDQpJIHRoaW5rIHdlIGFyZSBhZGRp
bmcgbG93cHJpL2ZsdXNoIHN1cHBvcnQgYXMgc2ltaWxhciB0byAncGFzc2l2ZScgZmxhZy4NCg0K
PiANCj4gLi4uIFtpZXMgPC4uLj5dIFtsb3dwcml8Zmx1c2hdIFtzc2lkIC4uLl0NCj4gDQo+IFRo
ZSBTU0lEIGxpc3QgaGFzIHRvIGJlIGxhc3Qgc2luY2Ugbm8ga2V5d29yZCBjYW4gdGVybWluYXRl
IGl0DQo+IChldmVyeXRoaW5nIGNvdWxkIGJlIGEgdmFsaWQgU1NJRCkNCg0KTGV0IG1lIGtub3cg
aWYgeW91IHN0aWxsIHdhbnQgdG8gaW1wbGVtZW50IGxvd3ByaS9mbHVzaCB0aGlzIHdheS4NCg0K
PiANCj4gPiAgCU5MODAyMTFfQ01EX1RSSUdHRVJfU0NBTiwgMCwgQ0lCX05FVERFViwgaGFuZGxl
X3NjYW4sDQo+ID4gIAkgIlRyaWdnZXIgYSBzY2FuIG9uIHRoZSBnaXZlbiBmcmVxdWVuY2llcyB3
aXRoIHByb2JpbmcgZm9yIHRoZSBnaXZlblxuIg0KPiA+ICsNCj4gDQo+IHNwdXJpb3VzIG5ld2xp
bmU/DQoNCkl0IHdpbGwgYmUgcmVtb3ZlZCBpbiB2Mi4NCg0KVGhhbmtzLA0KQmluZw0K
