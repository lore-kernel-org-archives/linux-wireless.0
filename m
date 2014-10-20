Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:7204 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752950AbaJTKpD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 06:45:03 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [RFC] mac80211: don't flush when probing the AP
Date: Mon, 20 Oct 2014 10:44:38 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB31B545094@hasmsx107.ger.corp.intel.com> (sfid-20141020_124507_724132_6E777ECE)
References: <1413491157-5352-1-git-send-email-emmanuel.grumbach@intel.com>
 <1413801688.10246.18.camel@jlt4.sipsolutions.net>
In-Reply-To: <1413801688.10246.18.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PiANCj4gT24gVGh1LCAyMDE0LTEwLTE2IGF0IDIzOjI1ICswMzAwLCBFbW1hbnVlbCBHcnVtYmFj
aCB3cm90ZToNCj4gPiBBbGwgdGhlIGNhbGxlcnMgb2YgaWVlZTgwMjExX21nZF9wcm9iZV9hcF9z
ZW5kIHJldHVybiByaWdodCBhZnRlciB0aGV5DQo+ID4gY2FsbCB0aGUgZmx1c2goKSBjYWxsYmFj
ay4gVGhpcyBtZWFucyB0aGF0IGNhbGxpbmcNCj4gPiBmbHVzaCgpIGlzIHVuZWVkZWQgc2luY2Ug
aXRzIG1lYW5pbmcgaXMgdG8gd2FpdCB1bnRpbCB0aGUgcXVldWVzIG9mDQo+ID4gdGhlIGRldmlj
ZSBhcmUgZW1wdHkuIEl0IGlzIHBvaW50bGVzcyB0byB3YWl0IGlmIHRoZXJlIGlzIG5vdGhpbmcg
dGhhdA0KPiA+IG11c3QgZW5zdXJlIHRoYXQgdGhlIGZyYW1lIGhhcyBsZWZ0IHRoZSBUeCBxdWV1
ZS4NCj4gPiBpZWVlODAyMTFfbWdkX3Byb2JlX2FwX3NlbmQgaXMgY2FsbGVkIGF0IHRoZSB2ZXJ5
IGVuZCBvZiBhIHdvcmtlciAtIHNvDQo+ID4gZmx1c2goKSBpcyBub3QgbmVlZGVkLg0KPiANCj4g
VGhlcmUgbWF5IGhhdmUgYmVlbiBzb21lIGNvbmNlcm4gdGhhdCB0aGUgdGltZXIvd29yayBjb3Vs
ZCBydW4gYWdhaW4NCj4gd2hpbGUgdGhlIHBhY2tldHMgYXJlIHN0aWxsIG9uIHRoZSAocG9zc2li
bHkgbG9uZykgcXVldWUsIGJ1dCBJIGd1ZXNzIHRoaXMgaXMNCj4gcmVhc29uYWJsZT8gV2UgbWln
aHQgd2FudCB0byBhdm9pZCB0aGF0IGJ5IHRyYWNraW5nIHdoZXRoZXIgd2UndmUgc2VudCBvdXQN
Cj4gYSBmcmFtZSBhbmQgKG5vdCkgZ290dGVuIGEgcmVzcG9uc2U/DQo+IA0KDQpSaWdodCAtIGJ1
dCB0aGUgZmxvdyB0aGF0IGNoZWNrcyB0aGUgc3RhdHVzIGlzIHRyaWdnZXJlZCBidXQgdGhlIHN0
YXR1cyBnaXZlbiBieSB0aGUgZHJpdmVyIGFueXdheS4NCg==
