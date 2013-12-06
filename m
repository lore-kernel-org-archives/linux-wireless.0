Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:46643 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757742Ab3LFMDu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Dec 2013 07:03:50 -0500
From: "Coelho, Luciano" <luciano.coelho@intel.com>
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Simon Wunderlich" <sw@simonwunderlich.de>,
	Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>,
	"Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>
Subject: Re: [PATCH v8 5/5] mac80211: only set CSA beacon when at least one
 beacon must be transmitted
Date: Fri, 6 Dec 2013 12:03:45 +0000
Message-ID: <1386331424.3878.29.camel@porter.coelho.fi> (sfid-20131206_130354_741745_FCD10A76)
References: <1386257143-29840-1-git-send-email-luciano.coelho@intel.com>
	 <1386257143-29840-6-git-send-email-luciano.coelho@intel.com>
	 <CAEFj9868EWZVx-6hst8bBCjghKgjdGEbHY3L98uf812Rc4Sjmg@mail.gmail.com>
In-Reply-To: <CAEFj9868EWZVx-6hst8bBCjghKgjdGEbHY3L98uf812Rc4Sjmg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gRnJpLCAyMDEzLTEyLTA2IGF0IDE4OjM0ICswODAwLCBZZW9oIENodW4tWWVvdyB3cm90ZToN
Cj4gPiBkaWZmIC0tZ2l0IGEvbmV0L21hYzgwMjExL21lc2guYyBiL25ldC9tYWM4MDIxMS9tZXNo
LmMNCj4gPiBpbmRleCA1NDc2YWQ5Li5hN2ZhZDBkIDEwMDY0NA0KPiA+IC0tLSBhL25ldC9tYWM4
MDIxMS9tZXNoLmMNCj4gPiArKysgYi9uZXQvbWFjODAyMTEvbWVzaC5jDQo+ID4gQEAgLTEwNTEs
NyArMTA1MSw4IEBAIGludCBpZWVlODAyMTFfbWVzaF9maW5pc2hfY3NhKHN0cnVjdCBpZWVlODAy
MTFfc3ViX2lmX2RhdGEgKnNkYXRhKQ0KPiA+ICAgICAgICAgLyogUmVtb3ZlIHRoZSBDU0EgYW5k
IE1DU1AgZWxlbWVudHMgZnJvbSB0aGUgYmVhY29uICovDQo+ID4gICAgICAgICB0bXBfY3NhX3Nl
dHRpbmdzID0gcmN1X2RlcmVmZXJlbmNlKGlmbXNoLT5jc2EpOw0KPiA+ICAgICAgICAgcmN1X2Fz
c2lnbl9wb2ludGVyKGlmbXNoLT5jc2EsIE5VTEwpOw0KPiA+IC0gICAgICAga2ZyZWVfcmN1KHRt
cF9jc2Ffc2V0dGluZ3MsIHJjdV9oZWFkKTsNCj4gPiArICAgICAgIGlmICh0bXBfY3NhX3NldHRp
bmdzKQ0KPiA+ICsgICAgICAgICAgICAgICBrZnJlZV9yY3UodG1wX2NzYV9zZXR0aW5ncywgcmN1
X2hlYWQpOw0KPiANCj4gWWVzLCB0aGlzIHNvbHZlcyB0aGUgcHJvYmxlbSBvZiBrZXJuZWwgb29w
cy4NCg0KR3JlYXQsIHRoYW5rcyBmb3IgdGVzdGluZyENCg0KSSdsbCBzZW5kIGEgdjkgd2l0aCBm
aXhlcyBmb3IgU2ltb24ncyBjb21tZW50cyBhbmQgcmViYXNlIGl0IG9uIHRvcCBvZg0KaGlzIGxv
Y2sgZml4IGFzIHdlbGwuICBUb2RheSBpcyBob2xpZGF5IGhlcmUsIHNvIHByb2JhYmx5IG9uIE1v
bmRheS4NCg0KLS0NCkx1Y2EuDQoNCg0K
