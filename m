Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:31599 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433AbbDALht (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Apr 2015 07:37:49 -0400
From: "Peer, Ilan" <ilan.peer@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"mcgrof@suse.com" <mcgrof@suse.com>
Subject: RE: [PATCH v2] cfg80211: Stop calling crda if it is not responsive
Date: Wed, 1 Apr 2015 11:37:12 +0000
Message-ID: <CB3B3D4774441E42AA3EA0E1BA8230A04D0932A4@HASMSX106.ger.corp.intel.com> (sfid-20150401_133753_048026_B7257690)
References: <1427717749-27225-1-git-send-email-ilan.peer@intel.com>
	 (sfid-20150330_141354_463006_F82C75ED)
 <1427878274.3428.2.camel@sipsolutions.net>
	 <CB3B3D4774441E42AA3EA0E1BA8230A04D092DC4@HASMSX106.ger.corp.intel.com>
 <1427880174.3428.4.camel@sipsolutions.net>
In-Reply-To: <1427880174.3428.4.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBsaW51eC13aXJlbGVzcy1vd25l
ckB2Z2VyLmtlcm5lbC5vcmcgW21haWx0bzpsaW51eC13aXJlbGVzcy0NCj4gb3duZXJAdmdlci5r
ZXJuZWwub3JnXSBPbiBCZWhhbGYgT2YgSm9oYW5uZXMgQmVyZw0KPiBTZW50OiBXZWRuZXNkYXks
IEFwcmlsIDAxLCAyMDE1IDEyOjIzDQo+IFRvOiBQZWVyLCBJbGFuDQo+IENjOiBsaW51eC13aXJl
bGVzc0B2Z2VyLmtlcm5lbC5vcmc7IG1jZ3JvZkBzdXNlLmNvbQ0KPiBTdWJqZWN0OiBSZTogW1BB
VENIIHYyXSBjZmc4MDIxMTogU3RvcCBjYWxsaW5nIGNyZGEgaWYgaXQgaXMgbm90IHJlc3BvbnNp
dmUNCj4gDQo+IE9uIFdlZCwgMjAxNS0wNC0wMSBhdCAwOToxOSArMDAwMCwgUGVlciwgSWxhbiB3
cm90ZToNCj4gDQo+ID4gPiBBcHBsaWVkLCBidXQgSSBwdXQgdGhlIGNvbmRpdGlvbiBpbiBhIHBs
YWNlIGJlZm9yZSBwcmludGluZyBtb3JlDQo+ID4gPiBtZXNzYWdlcywgYW5kIGNoYW5nZWQgdGhl
IG1lc3NhZ2VzIGJhY2sgdG8gdGhlIG9yaWdpbmFsIG9uZXMuDQo+ID4gPg0KPiA+DQo+ID4gQnV0
IHRoaXMgd291bGQgbWlzcyB0aGUgdXBkYXRlIGluIGNhc2UgdGhhdCB0aGUgaW50ZXJuYWwgREIg
aXMgYWxzbyB1c2VkLg0KPiANCj4gSG0sIHRydWUsIEknbGwgbW92ZSB0aGUgcHJpbnRzIGxhdGVy
IGluc3RlYWQuDQo+IA0KDQpUaGF0J3Mgd2h5IEkgY2hhbmdlZCB0aGVtIGluIHRoZSBmaXJzdCBw
bGFjZSwgdG8gaW5kaWNhdGUgdGhhdCBhIGNvdW50cnkgdXBkYXRlIGlzIGRvbmUsIHJlZ2FyZGxl
c3MgaWYgQ1JEQSBpcyBjYWxsZWQgb3Igbm90Lg0KDQpJbGFuLg0KDQo=
