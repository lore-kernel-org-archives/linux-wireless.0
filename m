Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:40162 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965297Ab2COTKa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 15:10:30 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 15 Mar 2012 12:04:29 -0700
Subject: RE: [PATCH v3] wireless: rename ht_info to ht_operation
Message-ID: <477F20668A386D41ADCC57781B1F704308369096A5@SC-VEXCH1.marvell.com> (sfid-20120315_201034_380759_10103100)
References: <1331806879.3432.7.camel@jlt3.sipsolutions.net>
	 (sfid-20120315_112131_819302_49364FC7)
  <1331823014.3432.23.camel@jlt3.sipsolutions.net>
	 (sfid-20120315_155029_590112_CAFFA07D)
 <1331837116.3432.33.camel@jlt3.sipsolutions.net>
In-Reply-To: <1331837116.3432.33.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgSm9oYW5uZXMsDQoNCj4gRnJvbTogSm9oYW5uZXMgQmVyZyA8am9oYW5uZXMuYmVyZ0BpbnRl
bC5jb20+DQo+IA0KPiBTaW5jZSBzb21lIG9mIHRoZSBIVCBjb2RlIHByZS1kYXRlcyA4MDIuMTFu
LTIwMDkNCj4gc29tZSBuYW1lcyBhcmUgd3JvbmcuIFRoZSBvbmUgdGhhdCBib3RoZXJzIG1lIG1v
c3QNCj4gaXMgdGhhdCAiSFQgb3BlcmF0aW9uIiBpcyBjYWxsZWQgIkhUIGluZm9ybWF0aW9uIg0K
PiBpbiBvdXIgY29kZSBhbmQgdGhhdCBjYXVzZXMgY29uZnVzaW9uLg0KPiANCj4gUmVuYW1lICJI
VCBpbmZvcm1hdGlvbiIgdG8gIkhUIG9wZXJhdGlvbiIgYW5kIGFsc28NCj4gdGhlIGNvbnRyb2xf
Y2hhbiBmaWVsZCB0byBwcmltYXJ5X2NoYW4gdG8gbWF0Y2gNCj4gdGhlIG5hbWUgdXNlZCBpbiB0
aGUgc3BlYy4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEpvaGFubmVzIEJlcmcgPGpvaGFubmVzLmJl
cmdAaW50ZWwuY29tPg0KDQpGb3IgbXdpZmlleCBwYXJ0LA0KQWNrZWQtYnk6IEJpbmcgWmhhbyA8
YnpoYW9AbWFydmVsbC5jb20+DQoNClRoYW5rcywNCkJpbmcNCg0KPiAtLS0NCj4gdjI6IGZpeCBw
YXRjaCBmb3IgbmV3IG13aWZpZXggY2hhbmdlcw0KPiB2MzogZml4IGNoZWNrcGF0Y2gNCg0K
