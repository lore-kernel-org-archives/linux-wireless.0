Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:9124 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928AbaAMLP6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 06:15:58 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Karl Beldan <karl.beldan@gmail.com>,
	Emmanuel Grumbach <egrumbach@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Bondar, Alexander" <alexander.bondar@intel.com>
Subject: RE: [PATCH 08/36] iwlwifi: mvm: Change power management dependency
 on multi MAC
Date: Mon, 13 Jan 2014 11:15:53 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB303D3C4A5@HASMSX103.ger.corp.intel.com> (sfid-20140113_121601_644674_6B9764EE)
References: <52B0B72A.5070704@gmail.com>
 <1387313079-28123-8-git-send-email-egrumbach@gmail.com>
 <20140113111357.GA4611@magnum.frso.rivierawaves.com>
In-Reply-To: <20140113111357.GA4611@magnum.frso.rivierawaves.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PiA+DQo+ID4gRlcgc3RpbGwgZG9lcyBub3Qgc3VwcG9ydCBwb3dlciBtYW5hZ2VtZW50IG9uIG11
bHRpcGxlIE1BQyBpbnRlcmZhY2VzLg0KPiA+IEN1cnJlbnRseSB0aGUgZHJpdmVyIGVuZm9yY2Ug
dGhpcyBsaW1pdGF0aW9uIGJ5IGRpc2FibGluZyBQTSBpZiBzZWNvbmQNCj4gPiBpbnRlcmZhY2Ug
aXMgYWRkZWQuIENoYW5nZSB0aGlzIGJlaGF2aW9yIHRvIGFsbG93IFBNIG9uIGEgc2luZ2xlDQo+
ID4gaW50ZXJmYWNlIGV2ZW4gaWYgb3RoZXIgaW50ZXJmYWNlcyBleGlzdCBidXQgbm90IGJvdW5k
IHRvIGFueSBzcGVjaWZpYyBQSFkuDQo+ID4gUE0gd2lsbCBiZSBlbmFibGVkIGlmIG9ubHkgb25l
IHNpbmdsZSBpbnRlcmZhY2UgaXMgYm91bmQuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBBbGV4
YW5kZXIgQm9uZGFyIDxhbGV4YW5kZXIuYm9uZGFyQGludGVsLmNvbT4NCj4gPiBSZXZpZXdlZC1i
eTogSm9oYW5uZXMgQmVyZyA8am9oYW5uZXMuYmVyZ0BpbnRlbC5jb20+DQo+ID4gU2lnbmVkLW9m
Zi1ieTogRW1tYW51ZWwgR3J1bWJhY2ggPGVtbWFudWVsLmdydW1iYWNoQGludGVsLmNvbT4NCj4g
DQo+IEhpLA0KPiANCj4gVGhpcyBicm9rZSBtb25pdG9yIG1vZGU6DQo+ICh1bnNldHRpbmcgLnBv
d2VyX3VwZGF0ZV9iaW5kaW5nIGRvZXMgbm90IGhhbmcpDQo+IA0KPiBtb2Rwcm9iZSBpd2xtdm0N
Cj4gaXcgZGV2IHdsYW4wIHNldCB0eXBlIG1vbml0b3INCj4gaXcgZGV2IHdsYW4wIHNldCBmcmVx
IDUxODAgNDAgNTE5MCAgIyBoYW5ncw0KPiANCj4gQ2FuIHlvdSByZXByb2R1Y2UgaXQgZWFzaWx5
IG9yIGRvIHlvdSBuZWVkIG1lIHRvIHBvc3QgZnVydGhlciBkYmcgaW5mbyA/DQo+IA0KDQpXZSBo
YXZlIGFuIG9wZW4gYnVnIG9uIHRoaXMgaW50ZXJuYWxseSAtIHRoYW5rcyBmb3IgcmVwb3J0aW5n
Lg0K
