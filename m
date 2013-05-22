Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:36073 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756859Ab3EVSqz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 May 2013 14:46:55 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	Luciano Coelho <coelho@ti.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Wed, 22 May 2013 11:46:49 -0700
Subject: RE: [PATCH 2/2] cfg80211/nl80211: Add coalesce support
Message-ID: <477F20668A386D41ADCC57781B1F70430E801DC19F@SC-VEXCH1.marvell.com> (sfid-20130522_204705_617933_073F21E6)
References: <1369099918-4921-1-git-send-email-bzhao@marvell.com>
	 <1369099918-4921-2-git-send-email-bzhao@marvell.com>
	 <20130521232303.GX6529@pogo>
	 <477F20668A386D41ADCC57781B1F70430E0ADCE97D@SC-VEXCH1.marvell.com>
	 <1369210344.8207.0.camel@jlt4.sipsolutions.net>
	 <477F20668A386D41ADCC57781B1F70430E801DC176@SC-VEXCH1.marvell.com>
 <1369246994.8207.24.camel@jlt4.sipsolutions.net>
In-Reply-To: <1369246994.8207.24.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgSm9oYW5uZXMsDQoNCj4gPiA+IEJlZm9yZSB5b3UgbWFrZSBhbnkgY2hhbmdlcyAoSSBkaWRu
J3QgZ2V0IGFyb3VuZCB0byBjb21tZW50aW5nIG9uIHlvdXINCj4gPiA+IHBhdGNoZXMgeWVzdGVy
ZGF5KSwgSSB0aGluayB5b3UgaGF2ZSB0byBiZSBtb3JlIGNhcmVmdWwgd2l0aCB0aGUgcmVuYW1l
cw0KPiA+ID4gdG8gbm90IGJyZWFrIHRoZSBBUEkuIFBsZWFzZSBwcm92aWRlIGRlZmluZXMgb3Ig
c28gdG8gbm90IGJyZWFrDQo+ID4gPiBjb21waWxhdGlvbiBpbiB0aGUgcmVuYW1lLg0KPiA+DQo+
ID4gIltQQVRDSCAxLzJdIGNmZzgwMjExL25sODAyMTE6IHJlbmFtZSBwYWNrZXQgcGF0dGVybiBy
ZWxhdGVkDQo+ID4gc3RydWN0dXJlcyBhbmQgZW51bXMiIHNob3VsZCBoYXZlIHRha2VuIGNhcmUg
b2YgdGhlIHJlbmFtZXMuIFBsZWFzZQ0KPiA+IGxldCBtZSBrbm93IGlmIEkgbWlzc2VkIGFueXRo
aW5nIGhlcmUuDQo+IA0KPiBJdCBkaWQgaW4gdGhlIGtlcm5lbCwgSSB3YXMgcmVmZXJyaW5nIHRv
IHRoZSBjaGFuZ2VzIGluIG5sODAyMTEuaCwgYXMNCj4gZmFyIGFzIEkgY2FuIHRlbGwgdGhvc2Ug
YnJlYWsgZXhpc3RpbmcgdXNlcnNwYWNlIHRvb2xzLiBZb3Ugc2hvdWxkIGJlDQo+IGFibGUgdG8g
Y29tcGlsZSB0b29scyBsaWtlIGl3IGFuZCB3cGFfc3VwcGxpY2FudCB3aXRoIHRoZSBuZXcgbmw4
MDIxMS5oDQo+IHdpdGhvdXQgY2hhbmdpbmcgYW55dGhpbmcgaW4gdGhlbS4NCg0KSSBzZWUuIFRo
YW5rcyBmb3IgeW91ciBoZWxwLg0KDQpSZWdhcmRzLA0KQmluZw0KDQo=
