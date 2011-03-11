Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:54921 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753833Ab1CKUex (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Mar 2011 15:34:53 -0500
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
Date: Fri, 11 Mar 2011 12:33:32 -0800
Subject: RE: [PATCH v2] wireless: mwifiex: initial commit for Marvell
 mwifiex driver
Message-ID: <477F20668A386D41ADCC57781B1F704307F5244E43@SC-VEXCH1.marvell.com>
References: <1299873746-29484-1-git-send-email-bzhao@marvell.com>
 <1299874885.4320.5.camel@jlt3.sipsolutions.net>
In-Reply-To: <1299874885.4320.5.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgSm9oYW5uZXMsDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSm9o
YW5uZXMgQmVyZyBbbWFpbHRvOmpvaGFubmVzQHNpcHNvbHV0aW9ucy5uZXRdDQo+IFNlbnQ6IEZy
aWRheSwgTWFyY2ggMTEsIDIwMTEgMTI6MjEgUE0NCj4gVG86IEJpbmcgWmhhbw0KPiBDYzogbGlu
dXgtd2lyZWxlc3NAdmdlci5rZXJuZWwub3JnOyBKb2huIFcuIExpbnZpbGxlOyBKb2UgUGVyY2hl
czsgTmlzaGFudCBTYXJtdWthZGFtOyBBbWl0a3VtYXINCj4gS2Fyd2FyOyBLaXJhbiBEaXZla2Fy
OyBZb2dlc2ggUG93YXI7IE1hcmMgWWFuZzsgUmFtZXNoIFJhZGhha3Jpc2huYW47IEZyYW5rIEh1
YW5nDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjJdIHdpcmVsZXNzOiBtd2lmaWV4OiBpbml0aWFs
IGNvbW1pdCBmb3IgTWFydmVsbCBtd2lmaWV4IGRyaXZlcg0KPiANCj4gSnVzdCByYW5kb20gY29t
bWVudHMsIG1heWJlIEknbGwgZmluZCB0aW1lIGZvciBhIG1vcmUgaW4tZGVwdGggcmV2aWV3Lg0K
DQpUaGFua3MgZm9yIHRoZSBjb21tZW50cy4NCg0KPiANCj4gDQo+ID4gKyAqIENGRzgwMi4xMSBv
cGVyYXRpb24gaGFuZGxlciB0byBzZXQgdGhlIGRlZmF1bHQgbmV0d29yayBrZXkuDQo+ID4gKyAq
Lw0KPiA+ICtzdGF0aWMgaW50DQo+ID4gK213aWZpZXhfY2ZnODAyMTFfc2V0X2RlZmF1bHRfa2V5
KHN0cnVjdCB3aXBoeSAqd2lwaHksIHN0cnVjdCBuZXRfZGV2aWNlICpuZXRkZXYsDQo+ID4gKyAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdTgga2V5X2luZGV4LCBib29sIHVuaWNhc3Qs
DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgYm9vbCBtdWx0aWNhc3QpDQo+
ID4gK3sNCj4gPiArICAgICAgIHJldHVybiAwOw0KPiA+ICt9DQo+IA0KPiBUaGlzIGRvZXNuJ3Qg
c2VlbSByaWdodC4gSXQgbWlnaHQgd29yayBpbiBzb21lL21vc3QgdGVzdCBjYXNlcywgYnV0IGl0
DQo+IHN0aWxsIHNlZW1zIGxpa2UgYW4gQVBJIHdvcmthcm91bmQuDQoNCkl0IHdpbGwgYmUgZml4
ZWQuDQoNCj4gDQo+IA0KPiBBbHNvLCB5b3UgaGF2ZSBhIHRvbiBvZiBkZWJ1Z2ZzIGZpbGUgQVBJ
LiBBcmUgeW91IHN1cmUgdGhhdCdzIGEgZ29vZA0KPiB0aGluZz8gSXMgaXQgYWxsIHJlYWxseSBm
b3IgZGVidWdnaW5nIG9ubHk/IEFsc28gdGhpbmdzIGxpa2UNCj4gInBhc3NwaHJhc2UiIHRoZXJl
IG1ha2UgbWUgdmVyeSBzdXNwaWNpb3VzIGFib3V0IHdoYXQgdGhlIGRyaXZlciBpcw0KPiBkb2lu
ZyB0aGVyZS4gVGhlcmUgZG9lc24ndCBzZWVtIHRvIGJlIGFueSByZWFzb24gYXQgYWxsIHRvIHBy
b3ZpZGUgYW4NCj4gaW50ZXJmYWNlIGZvciBhIHBhc3NwaHJhc2U/DQoNCkkgd2lsbCBjaGVjayBv
biB0aGUgZGVidWdmcyBBUElzLg0KDQo+IA0KPiBCdXQgcmVhbGx5IEknbSB0b28gdGlyZWQgcmln
aHQgbm93IHRvIGxvb2sgYXQgdGhpcywgbWF5YmUgTW9uZGF5Lg0KDQpUaGFua3MgdmVyeSBtdWNo
IGZvciB5b3VyIHRpbWUuIEkgcmVhbGx5IGFwcHJlY2lhdGUgaXQuDQoNClJlZ2FyZHMsDQoNCkJp
bmcNCg0KPiANCj4gam9oYW5uZXMNCg0K
