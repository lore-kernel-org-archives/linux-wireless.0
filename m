Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:57043 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754945AbaGRTHU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2014 15:07:20 -0400
From: Bing Zhao <bzhao@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Andreas Fenkart <afenkart@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"daniel@zonque.org" <daniel@zonque.org>
Date: Fri, 18 Jul 2014 12:07:00 -0700
Subject: RE: [PATCH] mwifiex: card reset: enable rescan of non-removable card
Message-ID: <477F20668A386D41ADCC57781B1F7043122FE2C62A@SC-VEXCH1.marvell.com> (sfid-20140718_210723_877161_216C311A)
References: <1405670437-18723-1-git-send-email-afenkart@gmail.com>
 <20140718175915.GG31114@tuxdriver.com>
In-Reply-To: <20140718175915.GG31114@tuxdriver.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgQW5kcmVhcywNCg0KPiA+IEBAIC0xOTMxLDYgKzE5MzEsNyBAQCBzdGF0aWMgdm9pZCBzZGlv
X2NhcmRfcmVzZXRfd29ya2VyKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykNCj4gPiAgCW1tY19y
ZW1vdmVfaG9zdCh0YXJnZXQpOw0KPiA+ICAJLyogMjBtcyBkZWxheSBpcyBiYXNlZCBvbiBleHBl
cmltZW50IHdpdGggc2RoY2kgY29udHJvbGxlciAqLw0KPiA+ICAJbWRlbGF5KDIwKTsNCj4gPiAr
CXJlc2V0X2hvc3QtPnJlc2Nhbl9lbnRlcmVkID0gMDsgLyogcmVzY2FuIG5vbi1yZW1vdmFibGUg
Y2FyZHMgKi8NCg0KWW91IG1lYW50IHRoaXM/DQoNCisJdGFyZ2V0LT5yZXNjYW5fZW50ZXJlZCA9
IDA7IC8qIHJlc2NhbiBub24tcmVtb3ZhYmxlIGNhcmRzICovDQoNClJlZ2FyZHMsDQpCaW5nDQoN
Cj4gPiAgCW1tY19hZGRfaG9zdCh0YXJnZXQpOw0KPiA+ICB9DQo+ID4gIHN0YXRpYyBERUNMQVJF
X1dPUksoY2FyZF9yZXNldF93b3JrLCBzZGlvX2NhcmRfcmVzZXRfd29ya2VyKTsNCj4gDQo+IEJ1
aWxkaW5nIHdpcmVsZXNzLW5leHQ6DQo+IA0KPiAgIENDICAgICAgZHJpdmVycy9uZXQvd2lyZWxl
c3MvbXdpZmlleC9zZGlvLm8NCj4gZHJpdmVycy9uZXQvd2lyZWxlc3MvbXdpZmlleC9zZGlvLmM6
IEluIGZ1bmN0aW9uIOKAmG13aWZpZXhfc2Rpb19jYXJkX3Jlc2V0X3dvcmvigJk6DQo+IGRyaXZl
cnMvbmV0L3dpcmVsZXNzL213aWZpZXgvc2Rpby5jOjE5NTc6MjogZXJyb3I6IOKAmHJlc2V0X2hv
c3TigJkgdW5kZWNsYXJlZCAoZmlyc3QgdXNlIGluIHRoaXMNCj4gZnVuY3Rpb24pDQo+ICAgcmVz
ZXRfaG9zdC0+cmVzY2FuX2VudGVyZWQgPSAwOyAvKiByZXNjYW4gbm9uLXJlbW92YWJsZSBjYXJk
cyAqLw0KPiAgIF4NCj4gZHJpdmVycy9uZXQvd2lyZWxlc3MvbXdpZmlleC9zZGlvLmM6MTk1Nzoy
OiBub3RlOiBlYWNoIHVuZGVjbGFyZWQgaWRlbnRpZmllciBpcyByZXBvcnRlZCBvbmx5IG9uY2UN
Cj4gZm9yIGVhY2ggZnVuY3Rpb24gaXQgYXBwZWFycyBpbg0KIA0KDQoNCg==
