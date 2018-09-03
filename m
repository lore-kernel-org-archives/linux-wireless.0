Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:51418 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725927AbeICLAi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Sep 2018 07:00:38 -0400
From: Ganapathi Bhat <gbhat@marvell.com>
To: Jia-Ju Bai <baijiaju1990@gmail.com>,
        "amitkarwar@gmail.com" <amitkarwar@gmail.com>,
        "nishants@marvell.com" <nishants@marvell.com>,
        "huxinming820@gmail.com" <huxinming820@gmail.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [BUG] net: wireless: mwifiex: A possible
 sleep-in-atomic-context bug in mwifiex_wait_queue_complete()
Date: Mon, 3 Sep 2018 06:41:50 +0000
Message-ID: <5fbe17917c344f318c25a688f2e94823@SC-EXCH02.marvell.com> (sfid-20180903_084220_952247_85F31138)
References: <35980039-f268-2db3-5c7d-19ab0c917d44@gmail.com>
In-Reply-To: <35980039-f268-2db3-5c7d-19ab0c917d44@gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgSmlhLUp1LA0KDQo+DQo+IFtGVU5DXSBzY2hlZHVsZV90aW1lb3V0DQo+IGRyaXZlcnMvbmV0
L3dpcmVsZXNzL21hcnZlbGwvbXdpZmlleC9zdGFfaW9jdGwuYywgNjM6DQo+ICAgICAgc2NoZWR1
bGVfdGltZW91dCBpbiBtd2lmaWV4X3dhaXRfcXVldWVfY29tcGxldGUNCj4gZHJpdmVycy9uZXQv
d2lyZWxlc3MvbWFydmVsbC9td2lmaWV4L2NtZGV2dC5jLCA2NzM6DQo+ICAgICAgbXdpZmlleF93
YWl0X3F1ZXVlX2NvbXBsZXRlIGluIG13aWZpZXhfc2VuZF9jbWQNCkhlcmUsIG13aWZpZXhfc2Vu
ZF9jbWQgZG9lcyBub3QgY2FsbCBtd2lmaWV4X3dhaXRfcXVldWVfY29tcGxldGUsIGJlY2F1c2Ug
dGhlIHN5bmMgcGFyYW1ldGVyIGlzIGZhbHNlLg0KTm90ZSB0aGF0IHRoZSBmdW5jdGlvbiBtd2lm
aWV4X211bHRpX2NoYW5fcmVzeW5jIGRpZCBjYWxsIG13aWZpZXhfc2VuZF9jbWQgd2l0aCBzeW5j
ID0gZmFsc2UuDQo+IGRyaXZlcnMvbmV0L3dpcmVsZXNzL21hcnZlbGwvbXdpZmlleC9tYWluLmMs
IDEwNDY6DQo+ICAgICAgbXdpZmlleF9zZW5kX2NtZCBpbiBtd2lmaWV4X211bHRpX2NoYW5fcmVz
eW5jDQo+IGRyaXZlcnMvbmV0L3dpcmVsZXNzL21hcnZlbGwvbXdpZmlleC91c2IuYywgMjg4Og0K
PiAgICAgIG13aWZpZXhfbXVsdGlfY2hhbl9yZXN5bmMgaW4gbXdpZmlleF91c2JfdHhfY29tcGxl
dGUNCj4NClRoYW5rcywNCkdhbmFwYXRoaQ0K
