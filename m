Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:32971 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754097Ab1D2WfX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Apr 2011 18:35:23 -0400
From: Bing Zhao <bzhao@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Yogesh Powar <yogeshp@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>
Date: Fri, 29 Apr 2011 15:32:47 -0700
Subject: RE: [PATCH] mwifiex: fix copy-n-paste 'thinko' for tsf_val
Message-ID: <477F20668A386D41ADCC57781B1F704307FCE850F6@SC-VEXCH1.marvell.com> (sfid-20110430_003526_010246_34D72F85)
References: <1304104067-29124-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1304104067-29124-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgSm9obiwNCg0KPiBTdWJqZWN0OiBbUEFUQ0hdIG13aWZpZXg6IGZpeCBjb3B5LW4tcGFzdGUg
J3RoaW5rbycgZm9yIHRzZl92YWwNCj4gDQo+ICAgQ0MgW01dICBkcml2ZXJzL25ldC93aXJlbGVz
cy9td2lmaWV4L2pvaW4ubw0KPiBkcml2ZXJzL25ldC93aXJlbGVzcy9td2lmaWV4L2pvaW4uYzog
SW4gZnVuY3Rpb24g4oCYbXdpZmlleF9jbWRfODAyXzExX2Fzc29jaWF0ZeKAmToNCj4gZHJpdmVy
cy9uZXQvd2lyZWxlc3MvbXdpZmlleC9qb2luLmM6MTE5Ojg6IHdhcm5pbmc6IOKAmHRzZl92YWzi
gJkgbWF5IGJlIHVzZWQgdW5pbml0aWFsaXplZCBpbiB0aGlzDQo+IGZ1bmN0aW9uDQo+IGRyaXZl
cnMvbmV0L3dpcmVsZXNzL213aWZpZXgvam9pbi5jOjEwMzoxMjogbm90ZTog4oCYdHNmX3ZhbOKA
mSB3YXMgZGVjbGFyZWQgaGVyZQ0KDQpUaGFua3MgZm9yIHNwb3R0aW5nIHRoaXMgZXJyb3IuIEkg
d2lsbCB1cGRhdGUgbXkgZ2NjIGFzIG15IGN1cnJlbnQgdmVyc2lvbiA0LjQuMSAyMDA5MDcyNSBj
YW5ub3QgZmluZCB0aGlzIHdhcm5pbmcuIA0KDQo+IA0KPiBMb29rcyBsaWtlIGEgY29weS1uLXBh
c3RlIGVycm9yLCBpZGVudGljYWwgbGluZXMgYXJlIGEgZmV3IGxpbmVzIGJlbG93DQo+IHRoZSBv
bmVzIHJlbW92ZWQsIHdpdGggYW4gYWN0dWFsIG1lbWNweSB0byB0c2ZfdmFsIGluIGJldHdlZW4u
Li4NCg0KSXQncyBub3QgYSBjb3B5LW4tcGFzdGUgZXJyb3IsIGJ1dCB5b3UgaGl0IGEgYnVnIGhl
cmUuDQoNCkFjdHVhbGx5IHR3byBzZXRzIG9mIHRzZl92YWwgYXJlIGNvcGllZCB0byB0aGUgYnVm
ZmVyLiBJIG1pc3NlZCB0aGUgaW5pdGlhbGl6YXRpb24gY29kZSBmb3IgdGhlIGZpcnN0IHRzZl92
YWwuDQoNCkkgd2lsbCBzZW5kIGEgcGF0Y2ggdG8gZml4IGl0Lg0KDQpUaGFua3MsDQoNCkJpbmcN
Cg0KDQo=
