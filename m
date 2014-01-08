Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:6416 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753691AbaAHCuj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jan 2014 21:50:39 -0500
From: Bing Zhao <bzhao@marvell.com>
To: Ding Tianhong <dingtianhong@huawei.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Netdev <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 7 Jan 2014 18:50:28 -0800
Subject: RE: [PATCH v3.5 17/19] mwifiex: slight optimization of addr compare
Message-ID: <477F20668A386D41ADCC57781B1F70430F534B5541@SC-VEXCH1.marvell.com> (sfid-20140108_035115_763699_993C4997)
References: <52BC15E7.7050205@huawei.com>
In-Reply-To: <52BC15E7.7050205@huawei.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgRGluZywNCg0KPiBVc2UgcG9zc2libHkgbW9yZSBlZmZpY2llbnQgZXRoZXJfYWRkcl9lcXVh
bA0KPiBpbnN0ZWFkIG9mIG1lbWNtcC4NCg0KPiBAQCAtNzgyLDggKzc4Miw3IEBAIHN0YXRpYyBp
bnQgbXdpZmlleF9yZXRfaWJzc19jb2FsZXNjaW5nX3N0YXR1cyhzdHJ1Y3QgbXdpZmlleF9wcml2
YXRlICpwcml2LA0KPiAgCX0NCj4gDQo+ICAJLyogSWYgQlNTSUQgaXMgZGlmZiwgbW9kaWZ5IGN1
cnJlbnQgQlNTIHBhcmFtZXRlcnMgKi8NCj4gLQlpZiAobWVtY21wKHByaXYtPmN1cnJfYnNzX3Bh
cmFtcy5ic3NfZGVzY3JpcHRvci5tYWNfYWRkcmVzcywNCj4gLQkJICAgaWJzc19jb2FsX3Jlc3At
PmJzc2lkLCBFVEhfQUxFTikpIHsNCj4gKwlpZiAoIWV0aGVyX2FkZHJfZXF1YWwocHJpdi0+Y3Vy
cl9ic3NfcGFyYW1zLmJzc19kZXNjcmlwdG9yLm1hY19hZGRyZXNzLCBpYnNzX2NvYWxfcmVzcC0+
YnNzaWQpKQ0KDQpDb3VsZCB5b3UgYnJlYWsgdGhlIGxpbmU/DQpJZiB5b3UgcnVuICJjaGVja3Bh
dGNoLnBsIiB5b3Ugd2lsbCBzcG90IHRoaXMgd2FybmluZy4NCg0KPiAgCWlmICghSVNfMTFOX0VO
QUJMRUQocHJpdikgfHwNCj4gLQkgICAgbWVtY21wKHByaXYtPmN1cnJfYWRkciwgcnhfcGt0X2hk
ci0+ZXRoODAzX2hkci5oX2Rlc3QsIEVUSF9BTEVOKSkgew0KPiArCSAgICAhZXRoZXJfYWRkcl9l
cXVhbF91bmFsaWduZWQocHJpdi0+Y3Vycl9hZGRyLCByeF9wa3RfaGRyLT5ldGg4MDNfaGRyLmhf
ZGVzdCkpIHsNCg0KQWxzbyBvdmVyIDgwIGNoYXJhY3RlcnMgaGVyZS4NCg0KVGhhbmtzLA0KQmlu
Zw0KDQo=
