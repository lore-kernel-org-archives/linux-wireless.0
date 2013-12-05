Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:35607 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752362Ab3LETbN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 14:31:13 -0500
From: "Coelho, Luciano" <luciano.coelho@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"sw@simonwunderlich.de" <sw@simonwunderlich.de>,
	"yeohchunyeow@gmail.com" <yeohchunyeow@gmail.com>,
	"yeohchunyeow@cozybit.com" <yeohchunyeow@cozybit.com>,
	"Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>
Subject: Re: [PATCH v8 3/5] mac80211: refactor
 ieee80211_mesh_process_chanswitch()
Date: Thu, 5 Dec 2013 19:31:08 +0000
Message-ID: <1386271868.3878.26.camel@porter.coelho.fi> (sfid-20131205_203121_156183_E0A05D52)
References: <1386257143-29840-1-git-send-email-luciano.coelho@intel.com>
	 <1386257143-29840-4-git-send-email-luciano.coelho@intel.com>
	 (sfid-20131205_162558_512881_D06BF6C3)
 <1386259544.4182.14.camel@jlt4.sipsolutions.net>
In-Reply-To: <1386259544.4182.14.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gVGh1LCAyMDEzLTEyLTA1IGF0IDE3OjA1ICswMTAwLCBKb2hhbm5lcyBCZXJnIHdyb3RlOg0K
PiBPbiBUaHUsIDIwMTMtMTItMDUgYXQgMTc6MjUgKzAyMDAsIEx1Y2lhbm8gQ29lbGhvIHdyb3Rl
Og0KPiANCj4gPiArKysgYi9uZXQvbWFjODAyMTEvdXRpbC5jDQo+ID4gQEAgLTI0OTgsNyArMjQ5
OCw2IEBAIGludCBpZWVlODAyMTFfc2VuZF9hY3Rpb25fY3NhKHN0cnVjdCBpZWVlODAyMTFfc3Vi
X2lmX2RhdGEgKnNkYXRhLA0KPiA+ICAJCQlpZm1zaC0+cHJlX3ZhbHVlKys7DQo+ID4gIAkJcHV0
X3VuYWxpZ25lZF9sZTE2KGlmbXNoLT5wcmVfdmFsdWUsIHBvcyk7LyogUHJlY2VkZW5jZSBWYWx1
ZSAqLw0KPiA+ICAJCXBvcyArPSAyOw0KPiA+IC0JCWlmbXNoLT5jaHN3X2luaXQgPSB0cnVlOw0K
PiANCj4gV2hlcmUgZGlkIHRoaXMgZ28/IEknbSBhc2tpbmcgbW9zdGx5IGJlY2F1c2UgbWFjODAy
MTEuZ2l0IGhhcyBhIHBhdGNoDQo+IHRoYXQgY2hhbmdlZCB0aGlzIGNvZGUgc28gSSdtIHdvbmRl
cmluZyBob3cgdG8gcmVzb2x2ZSB0aGUgY29uZmxpY3QgLi4uDQoNClRoaXMgYmVjYW1lIHRoZSBp
Zm1zaC0+Y3NhX3JvbGUuICBpZm1zaC0+Y2hzd19pbml0ID09IHRydWUgaXMgbm93DQppZm1zaC0+
Y3NhX3JvbGUgPT0gSUVFRTgwMjExX01FU0hfQ1NBX1JPTEVfSU5JVC4NCg0KLS0NCkx1Y2EuDQo=
