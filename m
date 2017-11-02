Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:20183 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933025AbdKBSGX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Nov 2017 14:06:23 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "rmanohar@codeaurora.org" <rmanohar@codeaurora.org>
Subject: RE: [PATCH] mac80211: Update last_ack status for all except probing
 frames
Date: Thu, 2 Nov 2017 18:06:22 +0000
Message-ID: <c622c7faf4db4d22b55da2f8be99537d@NALASEXR01H.na.qualcomm.com> (sfid-20171102_190658_386454_EA23465B)
References: <1509409746-26592-1-git-send-email-rmanohar@qti.qualcomm.com>
 <46362ff1-acfb-701c-5f71-7d117d223e1a@quantenna.com>
In-Reply-To: <46362ff1-acfb-701c-5f71-7d117d223e1a@quantenna.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PiBUbyBjbGFyaWZ5OiB3b3VsZG4ndCBpdCBicmVhayBob3N0YXBkJ3MgImluYWN0aXZpdHkgdGlt
ZW90IGtpY2stb3V0Ig0KPiBsb2dpYyBpbiBob3N0YXBkPyBBcyBob3N0YXBkIGdlbmVyYXRlcyBO
VUxMIGZyYW1lcyB0byBpZGxlIHN0YXRpb25zIHRvIHJlc2V0DQo+IHRoZWlyIGluYWN0aXZpdHkg
dGltZSwgb3RoZXJ3aXNlIGl0IHdpbGwgZGlzYXNzb2NpYXRlIGEgc3RhdGlvbiwgYWZ0ZXIgYW4N
Cj4gYXBfbWF4X2luYWN0aXZpdHkgcGVyaW9kLg0KDQpJZ29yLA0KDQpJIHZhbGlkYXRlZCBob3N0
cGFkIGluYWN0aXZpdHkgbW9uaXRvcmluZyB3aXRoIHRoaXMgY2hhbmdlIGFuZCBIb3N0YXBkIGlz
IHNlbmRpbmcNCk51bGxkYXRhIHBlcmlvZGljYWxseSBmb3IgaW5hY3RpdmUgc3RhdGlvbnMuIEhv
c3RhcGQgcmVzZXRzIHRpbWVyIGJhc2VkIG9uIHR4IGFjaw0Kc3RhdHVzIG9mIG51bGxkYXRhLiBT
byByZXRhaW5pbmcgYWN0dWFsIHN0YXRpb24gaW5hY3RpdmUgcGVyaW9kIHdpbGwgbm90IGJyZWFr
DQpob3N0YXBkIG1vbml0b3JpbmcuDQoNClBsZWFzZSByZXBvcnQgaWYgeW91IHNlZSBhbnkgaXNz
dWUgd2l0aCB0aGlzIGNoYW5nZS4gVGhhbmtzIGZvciB5b3VyIGZlZWRiYWNrLg0KDQotUmFqa3Vt
YXINCg0K
