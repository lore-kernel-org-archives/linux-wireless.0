Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:50361 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751558Ab0HUOSC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Aug 2010 10:18:02 -0400
From: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Sat, 21 Aug 2010 07:18:00 -0700
Subject: RE: [PATCH 1/1] mac80211: fix warning for un-used parameter
Message-ID: <E9954878DD1FB34FAE5187FB88C58A35012774EE0E@orsmsx506.amr.corp.intel.com>
References: <1282340976-10665-1-git-send-email-wey-yi.w.guy@intel.com>
 <1282385065.3759.1.camel@jlt3.sipsolutions.net>
In-Reply-To: <1282385065.3759.1.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

LS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IEpvaGFubmVzIEJlcmcgW21haWx0bzpq
b2hhbm5lc0BzaXBzb2x1dGlvbnMubmV0XSANClNlbnQ6IFNhdHVyZGF5LCBBdWd1c3QgMjEsIDIw
MTAgMzowNCBBTQ0KVG86IEd1eSwgV2V5LVlpIFcNCkNjOiBsaW51eC13aXJlbGVzc0B2Z2VyLmtl
cm5lbC5vcmcNClN1YmplY3Q6IFJlOiBbUEFUQ0ggMS8xXSBtYWM4MDIxMTogZml4IHdhcm5pbmcg
Zm9yIHVuLXVzZWQgcGFyYW1ldGVyDQoNCk9uIEZyaSwgMjAxMC0wOC0yMCBhdCAxNDo0OSAtMDcw
MCwgd2V5LXlpLncuZ3V5QGludGVsLmNvbSB3cm90ZToNCg0KPiBAQCAtMTcwMSw3ICsxNzAxLDkg
QEAgbmV0ZGV2X3R4X3QgaWVlZTgwMjExX3N1YmlmX3N0YXJ0X3htaXQoc3RydWN0IHNrX2J1ZmYg
KnNrYiwNCj4gIAl1MTYgZXRoZXJ0eXBlLCBoZHJsZW4sICBtZXNoaGRybGVuID0gMDsNCj4gIAlf
X2xlMTYgZmM7DQo+ICAJc3RydWN0IGllZWU4MDIxMV9oZHIgaGRyOw0KPiArI2lmZGVmIENPTkZJ
R19NQUM4MDIxMV9NRVNIDQo+ICAJc3RydWN0IGllZWU4MDIxMXNfaGRyIG1lc2hfaGRyOw0KPiAr
I2VuZGlmDQoNCkdvb2QgY2F0Y2guIEkgdGhpbmsganVzdCBhZGRpbmcgX19tYXliZV91bnVzZWQg
d291bGQgYmUgYmV0dGVyIHRob3VnaD8NCg0KWWVhaCwgY291bGQgZG8gdGhhdCwgd2lsbCByZS1z
dWJtaXQNCg0KV2V5DQoNCg==
