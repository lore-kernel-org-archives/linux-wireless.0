Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:3888 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754990AbcC1LkA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Mar 2016 07:40:00 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: linuxwifi <linuxwifi@intel.com>,
	"colin.king@canonical.com" <colin.king@canonical.com>,
	"kvalo@codeaurora.org" <kvalo@codeaurora.org>,
	"Sharon, Sara" <sara.sharon@intel.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"Berg, Johannes" <johannes.berg@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] iwlwifi: pcie: remove duplicate assignment of variable
 isr_stats
Date: Mon, 28 Mar 2016 11:39:14 +0000
Message-ID: <1459165154.9638.3.camel@intel.com> (sfid-20160328_134020_877060_C1A05AFF)
References: <1459164824-6994-1-git-send-email-colin.king@canonical.com>
In-Reply-To: <1459164824-6994-1-git-send-email-colin.king@canonical.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gTW9uLCAyMDE2LTAzLTI4IGF0IDEyOjMzICswMTAwLCBDb2xpbiBLaW5nIHdyb3RlOg0KPiBG
cm9tOiBDb2xpbiBJYW4gS2luZyA8Y29saW4ua2luZ0BjYW5vbmljYWwuY29tPg0KPiANCj4gaXNy
X3N0YXRzIGlzIHdyaXR0ZW4gdHdpY2Ugd2l0aCB0aGUgc2FtZSB2YWx1ZSwgcmVtb3ZlIG9uZSBv
ZiB0aGUNCj4gcmVkdW5kYW50IGFzc2lnbm1lbnRzIHRvIGlzcl9zdGF0cy4NCj4gDQo+IFNpZ25l
ZC1vZmYtYnk6IENvbGluIElhbiBLaW5nIDxjb2xpbi5raW5nQGNhbm9uaWNhbC5jb20+DQo+IC0t
LQ0KDQoNCkFwcGxpZWQgLSB0aGFua3MuDQoNCj4gIGRyaXZlcnMvbmV0L3dpcmVsZXNzL2ludGVs
L2l3bHdpZmkvcGNpZS9yeC5jIHwgMiArLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9u
KCspLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxl
c3MvaW50ZWwvaXdsd2lmaS9wY2llL3J4LmMNCj4gYi9kcml2ZXJzL25ldC93aXJlbGVzcy9pbnRl
bC9pd2x3aWZpL3BjaWUvcnguYw0KPiBpbmRleCA0YmUzYzM1Li4yNTNlNGYwIDEwMDY0NA0KPiAt
LS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9pbnRlbC9pd2x3aWZpL3BjaWUvcnguYw0KPiArKysg
Yi9kcml2ZXJzL25ldC93aXJlbGVzcy9pbnRlbC9pd2x3aWZpL3BjaWUvcnguYw0KPiBAQCAtMTgw
NSw3ICsxODA1LDcgQEAgaXJxcmV0dXJuX3QgaXdsX3BjaWVfaXJxX21zaXhfaGFuZGxlcihpbnQg
aXJxLA0KPiB2b2lkICpkZXZfaWQpDQo+ICAJc3RydWN0IG1zaXhfZW50cnkgKmVudHJ5ID0gZGV2
X2lkOw0KPiAgCXN0cnVjdCBpd2xfdHJhbnNfcGNpZSAqdHJhbnNfcGNpZSA9DQo+IGl3bF9wY2ll
X2dldF90cmFuc19wY2llKGVudHJ5KTsNCj4gIAlzdHJ1Y3QgaXdsX3RyYW5zICp0cmFucyA9IHRy
YW5zX3BjaWUtPnRyYW5zOw0KPiAtCXN0cnVjdCBpc3Jfc3RhdGlzdGljcyAqaXNyX3N0YXRzID0g
aXNyX3N0YXRzID0gJnRyYW5zX3BjaWUNCj4gLT5pc3Jfc3RhdHM7DQo+ICsJc3RydWN0IGlzcl9z
dGF0aXN0aWNzICppc3Jfc3RhdHMgPSAmdHJhbnNfcGNpZS0+aXNyX3N0YXRzOw0KPiAgCXUzMiBp
bnRhX2ZoLCBpbnRhX2h3Ow0KPiAgDQo+ICAJbG9ja19tYXBfYWNxdWlyZSgmdHJhbnMtPnN5bmNf
Y21kX2xvY2tkZXBfbWFwKTs=
