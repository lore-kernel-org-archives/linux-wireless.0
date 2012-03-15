Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog138.obsmtp.com ([74.125.149.19]:56508 "EHLO
	psmtp.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964981Ab2COSmY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 14:42:24 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 15 Mar 2012 11:38:16 -0700
Subject: RE: [PATCH v2] wireless: rename ht_info to ht_operation
Message-ID: <477F20668A386D41ADCC57781B1F70430836909680@SC-VEXCH1.marvell.com> (sfid-20120315_194227_639615_CAC4EEBC)
References: <1331806879.3432.7.camel@jlt3.sipsolutions.net>
	 (sfid-20120315_112131_819302_49364FC7)
 <1331823014.3432.23.camel@jlt3.sipsolutions.net>
	 <477F20668A386D41ADCC57781B1F70430836909651@SC-VEXCH1.marvell.com>
	 <1331835550.3432.29.camel@jlt3.sipsolutions.net>
	 (sfid-20120315_191923_464898_44F0B52C)
 <1331836263.3432.30.camel@jlt3.sipsolutions.net>
In-Reply-To: <1331836263.3432.30.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgSm9oYW5uZXMsDQoNCj4gT24gVGh1LCAyMDEyLTAzLTE1IGF0IDE5OjE5ICswMTAwLCBKb2hh
bm5lcyBCZXJnIHdyb3RlOg0KPiA+IEhpLA0KPiA+DQo+ID4gPiBGb3IgbXdpZmlleCBwYXJ0LCB0
aGUgY2hhbmdlIGxvb2tzIGZpbmUgZXhjZXB0IGZvciBhIGNvdXBsZSBjaGVja3BhdGNoIHdhcm5p
bmdzLg0KPiA+DQo+ID4gT2ssIHRoYW5rcy4gSSBrbmV3IHRoZXJlIHdlcmUgZ29pbmcgdG8gYmUg
Y2hlY2twYXRjaCB3YXJuaW5ncyBidXQNCj4gPiBkZWNpZGVkIHRoYXQgdGhlIGNvZGUgd2Fzbid0
IGdvaW5nIHRvIGJlIGVhc2llciB0byByZWFkIGlmIEkgZm9yY2VkIGl0DQo+ID4gZG93biB0byA4
MCBjb2x1bXMsIHNvIGRlY2lkZWQgdG8gbGVhdmUgdGhlbS4NCj4gDQo+IEkgc2hvdWxkIHNheSB0
aGF0IEkgYW0sIG9mIGNvdXJzZSwgaGFwcHkgdG8gY2hhbmdlIGl0IGlmIHlvdSdkIGxpa2UgbWUN
Cj4gdG8uDQoNClRoZXJlIGlzIGFsc28gYSBjaGVja3BhdGNoIEVSUk9SIGluIG5ldC9tYWM4MDIx
MS9tbG1lLmM6MjI2Og0KDQotCQkgICAgKGh0aS0+aHRfcGFyYW0gJiBJRUVFODAyMTFfSFRfUEFS
QU1fQ0hBTl9XSURUSF9BTlkpKSB7DQotCQkJc3dpdGNoKGh0aS0+aHRfcGFyYW0gJiBJRUVFODAy
MTFfSFRfUEFSQU1fQ0hBX1NFQ19PRkZTRVQpIHsNCisJCSAgICAoaHRfb3Blci0+aHRfcGFyYW0g
JiBJRUVFODAyMTFfSFRfUEFSQU1fQ0hBTl9XSURUSF9BTlkpKSB7DQorCQkJc3dpdGNoKGh0X29w
ZXItPmh0X3BhcmFtICYgSUVFRTgwMjExX0hUX1BBUkFNX0NIQV9TRUNfT0ZGU0VUKSB7DQoNCldB
Uk5JTkc6IGxpbmUgb3ZlciA4MCBjaGFyYWN0ZXJzDQpFUlJPUjogc3BhY2UgcmVxdWlyZWQgYmVm
b3JlIHRoZSBvcGVuIHBhcmVudGhlc2lzICcoJw0KDQpDb3VsZCB5b3UgcGxlYXNlIGZpeCB0aGlz
Pw0KDQpGb3IgdGhlIHdhcm5pbmdzIGluIG13aWZpZXgsIGl04oCZcyBuaWNlciBpZiB5b3UgY2Fu
IGZpeCBpdCBpbiB0aGlzIHBhdGNoLiBPciwgSSBjYW4gZml4IGl0IGxhdGVyIGluIGEgc2VwYXJh
dGUgcGF0Y2guDQoNClRoYW5rcywNCkJpbmcNCg0K
