Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:7011 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752205AbcDZH2W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2016 03:28:22 -0400
From: "Coelho, Luciano" <luciano.coelho@intel.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
	"Sharon, Sara" <sara.sharon@intel.com>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	"pat-lkml@erley.org" <pat-lkml@erley.org>
Subject: Re: [PATCH] iwlwifi: fix fw version reading for DVM devices
Date: Tue, 26 Apr 2016 07:28:18 +0000
Message-ID: <1461655699.13240.21.camel@intel.com> (sfid-20160426_092826_667127_E977D5D1)
References: <1461603729-20973-1-git-send-email-luca@coelho.fi>
In-Reply-To: <1461603729-20973-1-git-send-email-luca@coelho.fi>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gTW9uLCAyMDE2LTA0LTI1IGF0IDIwOjAyICswMzAwLCBMdWNhIENvZWxobyB3cm90ZToNCj4g
RnJvbTogTHVjYSBDb2VsaG8gPGx1Y2lhbm8uY29lbGhvQGludGVsLmNvbT4NCj4gDQo+IEluIGNv
bW1pdCA5N2Y5NWM5M2M4ZWQgKCJpd2x3aWZpOiByZW1vdmUgc3VwcG9ydCBmb3IgZncgb2xkZXIg
dGhhbg0KPiAtMTYudWNvZGUiKSB3ZSBhY2NpZGVudGFsbHkgY2hhbmdlZCB0aGUgZncgdmVyc2lv
biByZWFkaW5nIGNvZGUgZm9yDQo+IERWTSBkZXZpY2VzLsKgwqBUaGUgY29kZSBpbnRlbmRlZCB0
byByZW1vdmUgdGhlIG9sZCBmdyB2ZXJzaW9uIEFQSSwNCj4gYmVjYXVzZSBhbGwgTVZNIGZpcm13
YXJlcyB2ZXJzaW9uIDE2IGFuZCBhYm92ZSB0aGF0IHdlIHN1cHBvcnQgZG9uJ3QNCj4gdXNlIGl0
IGFueW1vcmUuwqDCoEJ1dCBEVk0gZGV2aWNlcyBzdGlsbCB1c2UgdGhlIG9sZCBGVyBBUEkuDQo+
IA0KPiBGaXggdGhhdCBieSBicmluZ2luZyB0aGUgY29kZSBiYWNrIGluLg0KPiANCj4gUmVwb3J0
ZWQtYnk6IFBhdCBFcmxleSA8cGF0LWxrbWxAZXJsZXkub3JnPg0KPiBGaXhlczogOTdmOTVjOTNj
OGVkICgiaXdsd2lmaTogcmVtb3ZlIHN1cHBvcnQgZm9yIGZ3IG9sZGVyIHRoYW4tDQo+IDE2LnVj
b2RlIikNCj4gU2lnbmVkLW9mZi1ieTogTHVjYSBDb2VsaG8gPGx1Y2lhbm8uY29lbGhvQGludGVs
LmNvbT4NCj4gLS0twqANCg0KS2FsbGUsIEkgZm9yZ290IHRvIGFkZCB5b3VyIFRlc3RlZC1ieS4g
wqBGZWVsIGZyZWUgdG8gYWRkIGl0IGlmIHlvdSB3YW50DQooYXMgaWYgSSBoYXZlIHRoZSBhdXRo
b3JpdHkgb2Ygc2F5aW5nIHRoaXMgdG8gdGhlIG1haW50YWluZXIgOlApLg0KDQotLQ0KQ2hlZXJz
LA0KTHVjYS4=
