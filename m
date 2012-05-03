Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:48227 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755401Ab2ECToC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 15:44:02 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>,
	harvey yang <harvey.huawei.yang@gmail.com>
Date: Thu, 3 May 2012 12:43:03 -0700
Subject: RE: [PATCH 17/18] mwifiex: parse beacon, probe response and assoc
 response IEs from start_ap
Message-ID: <477F20668A386D41ADCC57781B1F7043083A4AD5B1@SC-VEXCH1.marvell.com> (sfid-20120503_214408_137813_943D22F3)
References: <1336029760-22565-1-git-send-email-bzhao@marvell.com>
	 <1336029760-22565-18-git-send-email-bzhao@marvell.com>
	 (sfid-20120503_092407_448446_1D53B766)
 <1336054745.5167.0.camel@jlt3.sipsolutions.net>
In-Reply-To: <1336054745.5167.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgSm9oYW5uZXMsDQoNClRoYW5rcyBmb3IgeW91ciBjb21tZW50Lg0KDQo+ID4gQWRkIGxvZ2lj
IGZvciBwYXJzaW5nIHRhaWwgSUVzLCBiZWFjb24gSUVzLCBwcm9iZSByZXNwb25zZSBJRXMNCj4g
PiBhbmQgYXNzb2MgcmVzcG9uc2UgSUVzIGZyb20gY2ZnODAyMTFfYXBfc2V0dGluZ3MgcGFyYW1l
dGVyIG9mDQo+ID4gc3RhcnRfYXAgaGFuZGxlci4NCj4gPg0KPiA+IFRoaXMgcGF0Y2ggYWxzbyBp
bXBsZW1lbnRzIGZ1bmN0aW9uYWxpdHkgdG8gcmV0cmlldmUgUlNOIElFIGZyb20NCj4gPiB0YWls
IElFIGFuZCBzZW5kIGl0IHRvIEZXLg0KPiANCj4gVGhpcyBkb2Vzbid0IHNlZW0gcmlnaHQgLS0g
eW91IHNob3VsZCB1c2UgQVAgU01FIG1vZGUgYW5kIGdldCBtdWNoIG1vcmUNCj4gZGV0YWlsIGlu
IG90aGVyIGF0dHJpYnV0ZXM/IExvb2sgYXQgYXRoNmtsPw0KDQpXaWxsIGxvb2sgaW50byB0aGlz
Lg0KDQpUaGFua3MsDQpCaW5nDQoNCg==
