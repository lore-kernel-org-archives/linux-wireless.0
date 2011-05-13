Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:59429 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755421Ab1EMRnW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 13:43:22 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>
Date: Fri, 13 May 2011 10:40:02 -0700
Subject: RE: [PATCH] cfg80211: make stripping of 802.11 header optional from
 AMSDU
Message-ID: <477F20668A386D41ADCC57781B1F704307FD238BBA@SC-VEXCH1.marvell.com> (sfid-20110513_194324_711708_A2EB1C7C)
References: <1305168432-15569-1-git-send-email-bzhao@marvell.com>
	 <1305168432-15569-2-git-send-email-bzhao@marvell.com>
 <1305188893.3461.8.camel@jlt3.sipsolutions.net>
In-Reply-To: <1305188893.3461.8.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgSm9oYW5uZXMsDQoNCj4gPiBDdXJyZW50bHkgdGhlIGRldmljZXMgdGhhdCBoYXZlIGFscmVh
ZHkgc3RyaXBwZWQgSUVFRSA4MDIuMTENCj4gPiBoZWFkZXIgZnJvbSB0aGUgQU1TRFUgU0tCIGNh
biBub3QgdXNlIGllZWU4MDIxMV9hbXNkdV90b184MDIzcw0KPiA+IHJvdXRpbmUuIFRoaXMgcGF0
Y2ggZW5oYW5jZXMgaWVlZTgwMjExX2Ftc2R1X3RvXzgwMjNzKCkgQVBJIGJ5DQo+ID4gY2hhbmdp
bmcgbWFuZGF0b3J5IHJlbW92aW5nIG9mIElFRUUgODAyLjExIGhlYWRlciBmcm9tIEFNU0RVDQo+
ID4gdG8gb3B0aW9uYWwuDQo+IA0KPiBOaWNlLg0KPiANCj4gPiBAQCAtMjE3MywxMCArMjE3Mywx
MyBAQCBpbnQgaWVlZTgwMjExX2RhdGFfZnJvbV84MDIzKHN0cnVjdCBza19idWZmICpza2IsIGNv
bnN0IHU4ICphZGRyLA0KPiA+ICAgKiBAYWRkcjogVGhlIGRldmljZSBNQUMgYWRkcmVzcy4NCj4g
PiAgICogQGlmdHlwZTogVGhlIGRldmljZSBpbnRlcmZhY2UgdHlwZS4NCj4gPiAgICogQGV4dHJh
X2hlYWRyb29tOiBUaGUgaGFyZHdhcmUgZXh0cmEgaGVhZHJvb20gZm9yIFNLQnMgaW4gdGhlIEBs
aXN0Lg0KPiA+ICsgKiBAc3RyaXBwZWRfODAyMTFfaGVhZGVyOiBTZXQgaXQgdHJ1ZSBpZiBTS0Ig
aXMgd2l0aG91dCBJRUVFIDgwMi4xMQ0KPiA+ICsgKgloZWFkZXIuDQo+IA0KPiBJIHRoaW5rIEkn
ZCBwcmVmZXIgdGhpcyBiZSB0aGUgb3RoZXIgd2F5IGFyb3VuZCB0aG91Z2gsIGxpa2UNCj4gImhh
c184MDIxMV9oZWFkZXIiIChvciBzbyksIHRoYXQgc2VlbXMgbW9yZSBuYXR1cmFsIGhlcmUgYW5k
IGluIHRoZQ0KPiBjb2RlPyBOb3QgdGhhdCBpdCBtYXR0ZXJzIG11Y2guDQoNClRoYW5rcyBmb3Ig
eW91ciBzdWdnZXN0aW9uLiBJIHdpbGwgcmVzZW5kIHRoZSB1cGRhdGVkIHBhdGNoLg0KDQpSZWdh
cmRzLA0KQmluZw0KDQo=
