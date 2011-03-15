Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:38225 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750920Ab1COEqN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2011 00:46:13 -0400
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
Date: Mon, 14 Mar 2011 21:46:04 -0700
Subject: RE: [PATCH v2] wireless: mwifiex: initial commit for Marvell
 mwifiex driver
Message-ID: <477F20668A386D41ADCC57781B1F704307FA4C2D82@SC-VEXCH1.marvell.com>
References: <1299873746-29484-1-git-send-email-bzhao@marvell.com>
 <1299874885.4320.5.camel@jlt3.sipsolutions.net>
In-Reply-To: <1299874885.4320.5.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgSm9oYW5uZXMsDQoNCj4gQWxzbywgeW91IGhhdmUgYSB0b24gb2YgZGVidWdmcyBmaWxlIEFQ
SS4gQXJlIHlvdSBzdXJlIHRoYXQncyBhIGdvb2QNCj4gdGhpbmc/IElzIGl0IGFsbCByZWFsbHkg
Zm9yIGRlYnVnZ2luZyBvbmx5PyBBbHNvIHRoaW5ncyBsaWtlDQo+ICJwYXNzcGhyYXNlIiB0aGVy
ZSBtYWtlIG1lIHZlcnkgc3VzcGljaW91cyBhYm91dCB3aGF0IHRoZSBkcml2ZXIgaXMNCj4gZG9p
bmcgdGhlcmUuIFRoZXJlIGRvZXNuJ3Qgc2VlbSB0byBiZSBhbnkgcmVhc29uIGF0IGFsbCB0byBw
cm92aWRlIGFuDQo+IGludGVyZmFjZSBmb3IgYSBwYXNzcGhyYXNlPw0KDQpUaGUgZm9sbG93aW5n
IDUgQVBJcyBhcmUgZm9yIGRlYnVnZ2luZyBwdXJwb3NlLg0KDQonaW5mbycsICdkZWJ1ZycsICdn
ZXRsb2cnLCAncmVncmR3cicsICdyZGVlcHJvbScNCg0KQWxsIG90aGVyIEFQSXMgKGxpc3RlZCBi
ZWxvdykgYXJlIGZvciBkcml2ZXIgY29uZmlndXJhdGlvbnMuDQoNCm1wYWN0bCwgYW50Y2ZnLCBw
YXNzcGhyYXNlLCBlc3VwcG1vZGUNCmFkZGJhcGFyYSwgdHhhZ2dycHJpbywgYWRkYmFyZWplY3Qs
IHR4YnVmY2ZnLCBhbXNkdWFnZ3JjdHJsLCANCnR4cmF0ZWNmZywgaHR0eGNmZywgaHRjYXBpbmZv
LCANCmF0aW13aW5kb3csIGRlZXBzbGVlcCwgaHNjZmcsIHFvc2NmZywgc2xlZXBwZA0KDQpXZSB3
aWxsIHJlbW92ZSB0aG9zZSBBUElzLCBpbmNsdWRpbmcgdGhlIEFQSXMgdG8gYWNoaWV2ZSB0aGUg
aGlnaGVzdCB0aHJvdWdocHV0IChlLmcuLCB0aGUgb25lIHRoYXQgc2V0cyA0ME1IeiBjaGFubmVs
IHdpZHRoKS4gQWxsIGRlZmF1bHQgc2V0dGluZ3Mgd2lsbCBiZSB1c2VkIGludGVybmFsbHkuDQoN
Cg0KSSBoYXZlIGEgcXVlc3Rpb24gcmVnYXJkaW5nIHRoZSAxMW4gMjBNSHovNDBNSHogY2hhbm5l
bCB3aWR0aCBjb25maWd1cmF0aW9uOg0KDQpTaW5jZSB0aGUgODAyLjExbiBEcmFmdCAyLjAgU3lz
dGVtIEludGVyb3BlcmFiaWxpdHkgVGVzdCBQbGFuIHYxLjEgcmVxdWlyZXMgdGhlIGRlZmF1bHQg
Y29uZmlndXJhdGlvbiBiZWluZyBzZXQgdG8gMjBNSHosIGlzIHRoZXJlIGFueSB3YXkgdG8gc2V0
IHRoZSBjaGFubmVsIHdpZHRoIHRvIDQwTUh6IGF0IHJ1bi10aW1lPw0KDQpUaGFua3MgZm9yIHlv
dXIgaGVscCwNCg0KQmluZw0KDQo=
