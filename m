Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:29318 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1037331AbdDUKno (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Apr 2017 06:43:44 -0400
From: "Coelho, Luciano" <luciano.coelho@intel.com>
To: "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>,
        "Sharon, Sara" <sara.sharon@intel.com>,
        "Berg, Johannes" <johannes.berg@intel.com>
CC: linuxwifi <linuxwifi@intel.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH] iwlwifi: pcie: missing unlock on error path
Date: Fri, 21 Apr 2017 10:43:40 +0000
Message-ID: <1492771419.31741.124.camel@intel.com> (sfid-20170421_124347_345741_E9509416)
References: <20170421103937.jko3eguvfn3i6r3v@mwanda>
In-Reply-To: <20170421103937.jko3eguvfn3i6r3v@mwanda>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgRGFuDQoNCk9uIEZyaSwgMjAxNy0wNC0yMSBhdCAxMzozOSArMDMwMCwgRGFuIENhcnBlbnRl
ciB3cm90ZToNCj4gV2Ugc2hvdWxkIHVubG9jayBiZWZvcmUgcmV0dXJuaW5nLg0KPiANCj4gRml4
ZXM6IGVkYTUwY2RlNThkZSAoIml3bHdpZmk6IHBjaWU6IGFkZCBjb250ZXh0IGluZm9ybWF0aW9u
IHN1cHBvcnQiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBEYW4gQ2FycGVudGVyIDxkYW4uY2FycGVudGVy
QG9yYWNsZS5jb20+DQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvaW50
ZWwvaXdsd2lmaS9wY2llL3RyYW5zLWdlbjIuYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2ludGVs
L2l3bHdpZmkvcGNpZS90cmFucy1nZW4yLmMNCj4gaW5kZXggMzAyMzEwZGZlZjllLi40ZTg0OTU1
ZDU1YzggMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2ludGVsL2l3bHdpZmkv
cGNpZS90cmFucy1nZW4yLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvaW50ZWwvaXds
d2lmaS9wY2llL3RyYW5zLWdlbjIuYw0KPiBAQCAtMjEyLDggKzIxMiwxMCBAQCBpbnQgaXdsX3Ry
YW5zX3BjaWVfZ2VuMl9zdGFydF9mdyhzdHJ1Y3QgaXdsX3RyYW5zICp0cmFucywNCj4gIAkJZ290
byBvdXQ7DQo+ICAJfQ0KPiAgDQo+IC0JaWYgKGl3bF9wY2llX2N0eHRfaW5mb19pbml0KHRyYW5z
LCBmdykpDQo+IC0JCXJldHVybiAtRU5PTUVNOw0KPiArCWlmIChpd2xfcGNpZV9jdHh0X2luZm9f
aW5pdCh0cmFucywgZncpKSB7DQo+ICsJCXJldCA9IC1FTk9NRU07DQo+ICsJCWdvdG8gb3V0Ow0K
PiArCX0NCj4gIA0KPiAgCS8qIHJlLWNoZWNrIFJGLUtpbGwgc3RhdGUgc2luY2Ugd2UgbWF5IGhh
dmUgbWlzc2VkIHRoZSBpbnRlcnJ1cHQgKi8NCj4gIAlod19yZmtpbGwgPSBpd2xfdHJhbnNfY2hl
Y2tfaHdfcmZfa2lsbCh0cmFucyk7DQoNClRoYW5rcyBmb3IgeW91ciBwYXRjaCEgQnV0IHRoaXMg
aGFzIGFscmVhZHkgYmVlbiBmaXhlZCBieSBKb2hhbm5lcyBpbg0KdGhlIHBhdGNoIEkgc2VudCBv
dXQgeWVzdGVyZGF5WzFdLg0KDQpbMV0gaHR0cHM6Ly93d3cuc3Bpbmljcy5uZXQvbGlzdHMvbGlu
dXgtd2lyZWxlc3MvbXNnMTYxNTgyLmh0bWwNCg0KLS0NCkNoZWVycywNCkx1Y2Eu
