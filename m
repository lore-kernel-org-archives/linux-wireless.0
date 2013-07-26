Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:48046 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750873Ab3GZEhU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jul 2013 00:37:20 -0400
From: Bing Zhao <bzhao@marvell.com>
To: =?utf-8?B?VG9tYXN6IE1vxYQ=?= <desowin@gmail.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 25 Jul 2013 21:34:18 -0700
Subject: RE: [PATCH] mwifiex: Add missing endian conversion.
Message-ID: <477F20668A386D41ADCC57781B1F70430EA3117E85@SC-VEXCH1.marvell.com> (sfid-20130726_063723_901554_09153CD6)
References: <1374558169-6888-1-git-send-email-desowin@gmail.com>
In-Reply-To: <1374558169-6888-1-git-send-email-desowin@gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgSm9obiwNCg0KPiBCb3RoIHR5cGUgYW5kIHBrdF9sZW4gdmFyaWFibGVzIGFyZSBpbiBob3N0
IGVuZGlhbiBhbmQgdGhlc2Ugc2hvdWxkIGJlIGluDQo+IExpdHRsZSBFbmRpYW4gaW4gdGhlIHBh
eWxvYWQuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBUb21hc3ogTW/FhCA8ZGVzb3dpbkBnbWFpbC5j
b20+DQo+IEFja2VkLWJ5OiBCaW5nIFpoYW8gPGJ6aGFvQG1hcnZlbGwuY29tPg0KDQpDYzogPHN0
YWJsZUB2Z2VyLmtlcm5lbC5vcmc+DQoNCkNvdWxkIHlvdSBwbGVhc2UgYXBwbHkgdGhpcyBwYXRj
aCB0byB3aXJlbGVzcy5naXQgZm9yIDMuMTE/DQoNClRoYW5rcywNCkJpbmcNCg0KPiAtLS0NCj4g
IGRyaXZlcnMvbmV0L3dpcmVsZXNzL213aWZpZXgvc2Rpby5jIHwgNCArKy0tDQo+ICAxIGZpbGUg
Y2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdp
dCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL213aWZpZXgvc2Rpby5jIGIvZHJpdmVycy9uZXQvd2ly
ZWxlc3MvbXdpZmlleC9zZGlvLmMNCj4gaW5kZXggNWVlNWVkMC4uYzlmM2VjZiAxMDA2NDQNCj4g
LS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvbXdpZmlleC9zZGlvLmMNCj4gKysrIGIvZHJpdmVy
cy9uZXQvd2lyZWxlc3MvbXdpZmlleC9zZGlvLmMNCj4gQEAgLTE2MjUsOCArMTYyNSw4IEBAIHN0
YXRpYyBpbnQgbXdpZmlleF9zZGlvX2hvc3RfdG9fY2FyZChzdHJ1Y3QgbXdpZmlleF9hZGFwdGVy
ICphZGFwdGVyLA0KPiAgCS8qIEFsbG9jYXRlIGJ1ZmZlciBhbmQgY29weSBwYXlsb2FkICovDQo+
ICAJYmxrX3NpemUgPSBNV0lGSUVYX1NESU9fQkxPQ0tfU0laRTsNCj4gIAlidWZfYmxvY2tfbGVu
ID0gKHBrdF9sZW4gKyBibGtfc2l6ZSAtIDEpIC8gYmxrX3NpemU7DQo+IC0JKih1MTYgKikgJnBh
eWxvYWRbMF0gPSAodTE2KSBwa3RfbGVuOw0KPiAtCSoodTE2ICopICZwYXlsb2FkWzJdID0gdHlw
ZTsNCj4gKwkqKF9fbGUxNiAqKSZwYXlsb2FkWzBdID0gY3B1X3RvX2xlMTYoKHUxNilwa3RfbGVu
KTsNCj4gKwkqKF9fbGUxNiAqKSZwYXlsb2FkWzJdID0gY3B1X3RvX2xlMTYodHlwZSk7DQo+IA0K
PiAgCS8qDQo+ICAJICogVGhpcyBpcyBTRElPIHNwZWNpZmljIGhlYWRlcg0KPiAtLQ0KPiAxLjgu
My5tc3lzZ2l0LjANCg0K
