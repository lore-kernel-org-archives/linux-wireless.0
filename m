Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:52227 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753994AbaAHDEi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jan 2014 22:04:38 -0500
From: Bing Zhao <bzhao@marvell.com>
To: Ding Tianhong <dingtianhong@huawei.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Netdev <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 7 Jan 2014 19:04:15 -0800
Subject: RE: [PATCH v3.6 17/19] mwifiex: slight optimization of addr compare
Message-ID: <477F20668A386D41ADCC57781B1F70430F534B5550@SC-VEXCH1.marvell.com> (sfid-20140108_040444_770477_4871E897)
References: <52CCBDDC.1050503@huawei.com>
In-Reply-To: <52CCBDDC.1050503@huawei.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgRGluZywNCg0KPiAtCWlmIChtZW1jbXAocHJpdi0+Y3Vycl9ic3NfcGFyYW1zLmJzc19kZXNj
cmlwdG9yLm1hY19hZGRyZXNzLA0KPiAtCQkgICBpYnNzX2NvYWxfcmVzcC0+YnNzaWQsIEVUSF9B
TEVOKSkgew0KPiArCWlmICghZXRoZXJfYWRkcl9lcXVhbChwcml2LT5jdXJyX2Jzc19wYXJhbXMu
YnNzX2Rlc2NyaXB0b3IubWFjX2FkZHJlc3MsIGlic3NfY29hbF9yZXNwLT5ic3NpZCkpDQoNClN0
aWxsIHdyb25nLi4uIDspDQoNCkhhdmUgeW91IGFjdHVhbGx5IHJ1biB0aGUgY2hlY2twYXRjaC5w
bCBzY3JpcHQ/DQoNCkJ5IHRoZSB3YXksIHlvdXIgc3ViamVjdCBwcmVmaXggIlBBVENIIHYzLjYi
IGlzIGNvbmZ1c2luZy4gSXQgb3VnaHQgdG8gYmUgIlBBVENIIHY2IiwgSSBndWVzcy4NCg0KVGhh
bmtzLA0KQmluZw0KDQo=
