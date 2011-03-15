Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:48641 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758257Ab1COS1M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2011 14:27:12 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Joe Perches <joe@perches.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Ramesh Radhakrishnan <rramesh@marvell.com>,
	Frank Huang <frankh@marvell.com>
Date: Tue, 15 Mar 2011 11:26:55 -0700
Subject: RE: [PATCH v2] wireless: mwifiex: initial commit for Marvell
 mwifiex driver
Message-ID: <477F20668A386D41ADCC57781B1F704307FA4C2EC4@SC-VEXCH1.marvell.com>
References: <1299873746-29484-1-git-send-email-bzhao@marvell.com>
	 <1299874885.4320.5.camel@jlt3.sipsolutions.net>
	 <477F20668A386D41ADCC57781B1F704307FA4C2D82@SC-VEXCH1.marvell.com>
 <1300190698.5596.15.camel@jlt3.sipsolutions.net>
In-Reply-To: <1300190698.5596.15.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgSm9oYW5uZXMsDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSm9o
YW5uZXMgQmVyZyBbbWFpbHRvOmpvaGFubmVzQHNpcHNvbHV0aW9ucy5uZXRdDQo+IFNlbnQ6IFR1
ZXNkYXksIE1hcmNoIDE1LCAyMDExIDU6MDUgQU0NCj4gVG86IEJpbmcgWmhhbw0KPiBDYzogbGlu
dXgtd2lyZWxlc3NAdmdlci5rZXJuZWwub3JnOyBKb2huIFcuIExpbnZpbGxlOyBKb2UgUGVyY2hl
czsgTmlzaGFudCBTYXJtdWthZGFtOyBBbWl0a3VtYXINCj4gS2Fyd2FyOyBLaXJhbiBEaXZla2Fy
OyBZb2dlc2ggUG93YXI7IE1hcmMgWWFuZzsgUmFtZXNoIFJhZGhha3Jpc2huYW47IEZyYW5rIEh1
YW5nDQo+IFN1YmplY3Q6IFJFOiBbUEFUQ0ggdjJdIHdpcmVsZXNzOiBtd2lmaWV4OiBpbml0aWFs
IGNvbW1pdCBmb3IgTWFydmVsbCBtd2lmaWV4IGRyaXZlcg0KPiANCj4gSGksDQo+IA0KPiA+IEkg
aGF2ZSBhIHF1ZXN0aW9uIHJlZ2FyZGluZyB0aGUgMTFuIDIwTUh6LzQwTUh6IGNoYW5uZWwgd2lk
dGgNCj4gPiBjb25maWd1cmF0aW9uOg0KPiA+DQo+ID4gU2luY2UgdGhlIDgwMi4xMW4gRHJhZnQg
Mi4wIFN5c3RlbSBJbnRlcm9wZXJhYmlsaXR5IFRlc3QgUGxhbiB2MS4xDQo+ID4gcmVxdWlyZXMg
dGhlIGRlZmF1bHQgY29uZmlndXJhdGlvbiBiZWluZyBzZXQgdG8gMjBNSHosIGlzIHRoZXJlIGFu
eQ0KPiA+IHdheSB0byBzZXQgdGhlIGNoYW5uZWwgd2lkdGggdG8gNDBNSHogYXQgcnVuLXRpbWU/
DQo+IA0KPiBJbiBtYWM4MDIxMSBoYXZlIGEgbW9kdWxlIHBhcmFtZXRlciAiaWVlZTgwMjExX2Rp
c2FibGVfNDBtaHpfMjRnaHoiDQo+IHdoaWNoLCBmb3IgYmFja3dhcmQgY29tcGF0aWJpbGl0eSBy
ZWFzb25zLCBhY3R1YWxseSBkZWZhdWx0cyB0byBmYWxzZSwNCj4gc28geW91IG5lZWQgdG8gc2V0
IGl0IHRvIHRydWUgdG8gZ2V0IGEgY29tcGxpYW50IHN5c3RlbS4gV2hlbiBhIHN5c3RlbQ0KPiBp
cyBpbnRlZ3JhdGVkLCB0aGlzIHBhcmFtZXRlciBjYW4gYmUgc2V0IGFzIGRlZmF1bHQuDQoNClRo
YW5rcyBmb3IgdGhlIGluZm8uDQoNCj4gDQo+IEkgZG9uJ3QgdGhpbmsgaXQgcmVhbGx5IGlzIG5l
Y2Vzc2FyeSB0byBzZXQgdGhpcyBhdCBydW50aW1lLg0KPiANCj4gSSBndWVzcyBJIHNlZSB0d28g
b3B0aW9uczoNCj4gIDEpIG1vdmUgdGhlIG1vZHVsZSBwYXJhbWV0ZXIgdG8gY2ZnODAyMTEsIGFu
ZCBjaGVjayB0aGUgc2RhdGEgSFQgY29uZmlnDQo+ICAgICBpbiB0aGUgZHJpdmVyIGFnYWluIHdo
ZW4gdGhpcyBpcyBuZWVkZWQNCj4gIDIpIGhhdmUgeW91ciBvd24gbW9kdWxlIHBhcmFtZXRlciBs
aWtlIGl0DQoNCkkgd2lsbCB0cnkgb3B0aW9uIDEpIGFmdGVyIHRoZSBkZWJ1Z2ZzIGNsZWFudXBz
Lg0KDQpSZWdhcmRzLA0KDQpCaW5nDQoNCj4gDQo+IFRoZSBmaXJzdCB3b3VsZCBiZSBzbGlnaHRs
eSBtb3JlIGdlbmVyaWMsIGJ1dCBhbiBPRU0gaW50ZWdyYXRpbmcgYQ0KPiBkZXZpY2UgaW50byB0
aGVpciBzeXN0ZW0gYW5kIGRvaW5nIFdGQSB0ZXN0aW5nIHdpbGwgZG8gZGV2aWNlLXNwZWNpZmlj
DQo+IHRoaW5ncyBhbnl3YXkgLi4uDQo+IA0KPiBqb2hhbm5lcw0KPiANCg0K
