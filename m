Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:38841 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030344Ab2I1TrT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Sep 2012 15:47:19 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Sam Leffler <sleffler@chromium.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>
Date: Fri, 28 Sep 2012 12:47:10 -0700
Subject: RE: [PATCH v2 3/5] cfg80211: add support for flushing old scan
 results
Message-ID: <477F20668A386D41ADCC57781B1F7043083B590CDE@SC-VEXCH1.marvell.com> (sfid-20120928_214725_870137_B3DF8C86)
References: <1348772354-15936-1-git-send-email-bzhao@marvell.com>
	 <1348772354-15936-4-git-send-email-bzhao@marvell.com>
 <1348830246.13298.24.camel@jlt4.sipsolutions.net>
In-Reply-To: <1348830246.13298.24.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgSm9oYW5uZXMsDQoNClRoYW5rcyBmb3IgeW91ciBjb21tZW50cy4NCg0KPiA+ICAvKiBtdXN0
IGhvbGQgZGV2LT5ic3NfbG9jayEgKi8NCj4gPiAtdm9pZCBjZmc4MDIxMV9ic3NfZXhwaXJlKHN0
cnVjdCBjZmc4MDIxMV9yZWdpc3RlcmVkX2RldmljZSAqZGV2KQ0KPiA+ICtzdGF0aWMgdm9pZCBf
X2NmZzgwMjExX2Jzc19leHBpcmUoc3RydWN0IGNmZzgwMjExX3JlZ2lzdGVyZWRfZGV2aWNlICpk
ZXYsDQo+ID4gKwkJCQkgIGludCBtYXhhZ2UsIHVuc2lnbmVkIGxvbmcgZXhwaXJlX3RpbWUpDQo+
IA0KPiBJIGRvbid0IHJlYWxseSBzZWUgd2h5IHlvdSBuZWVkIG1heGFnZSBhbmQgZXhwaXJlX3Rp
bWU/DQo+IA0KPiA+ICt2b2lkIGNmZzgwMjExX2Jzc19leHBpcmUoc3RydWN0IGNmZzgwMjExX3Jl
Z2lzdGVyZWRfZGV2aWNlICpkZXYpDQo+ID4gK3sNCj4gPiArCV9fY2ZnODAyMTFfYnNzX2V4cGly
ZShkZXYsIElFRUU4MDIxMV9TQ0FOX1JFU1VMVF9FWFBJUkUsIDApOw0KPiANCj4gSGVyZSwgeW91
IGNvdWxkIGp1c3QgcGFzcyAiamlmZmllcyAtIFNDQU5fUkVTVUxUX0VYUElSRSIgYXMgdGhlIG1h
eGFnZQ0KPiBhbmQgZ2V0IHByZXR0eSBtdWNoIHRoZSBzYW1lIGJlaGF2aW91ciBhcyBiZWZvcmUg
d2l0aG91dCBhIHNlY29uZA0KPiBwYXJhbWV0ZXIuDQoNCl9fY2ZnODAyMTFfYnNzX2V4cGlyZShk
ZXYsIGppZmZpZXMgLSBJRUVFODAyMTFfU0NBTl9SRVNVTFRfRVhQSVJFKTsNCg0KVGhpcyBpcyBz
aW1pbGFyIHRvIHRoZSBjb2RlIGluIHYxIChiZWxvdyk6DQoNCl9fY2ZnODAyMTFfYnNzX2V4cGly
ZShyZGV2LCBqaWZmaWVzIC0gcmVxdWVzdC0+c2Nhbl9zdGFydCk7DQoNCkl0IG1heSBzdGlsbCBo
YXZlIHRoZSBzbWFsbCByYWNlIGNvbmRpdGlvbiB5b3UgY29tbWVudGVkIGluIHYxPw0KUGxlYXNl
IGxldCBtZSBrbm93IGlmIEkgbWlzdW5kZXJzdG9vZCBpdC4NCg0KVGhhbmtzLA0KQmluZw0K
