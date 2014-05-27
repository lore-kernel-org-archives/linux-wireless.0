Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:54866 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752075AbaE0Sgf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 14:36:35 -0400
From: Bing Zhao <bzhao@marvell.com>
To: =?utf-8?B?TWFudWVsIFNjaMO2bGxpbmc=?= <manuel.schoelling@gmx.de>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Date: Tue, 27 May 2014 11:36:26 -0700
Subject: RE: [PATCH] mwifiex: use time_after()
Message-ID: <477F20668A386D41ADCC57781B1F70430F70F5E285@SC-VEXCH1.marvell.com> (sfid-20140527_203657_854032_FEB8DD16)
References: <1401040776-13711-1-git-send-email-manuel.schoelling@gmx.de>
In-Reply-To: <1401040776-13711-1-git-send-email-manuel.schoelling@gmx.de>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgTWFudWVsLA0KDQpUaGFua3MgZm9yIHRoZSBwYXRjaC4NCg0KPiBUbyBiZSBmdXR1cmUtcHJv
b2YgYW5kIGZvciBiZXR0ZXIgcmVhZGFiaWxpdHkgdGhlIHRpbWUgY29tcGFyaXNvbnMgYXJlDQo+
IG1vZGlmaWVkIHRvIHVzZSB0aW1lX2FmdGVyKCkgaW5zdGVhZCBvZiBwbGFpbiwgZXJyb3ItcHJv
bmUgbWF0aC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IE1hbnVlbCBTY2jDtmxsaW5nIDxtYW51ZWwu
c2Nob2VsbGluZ0BnbXguZGU+DQoNCkFja2VkLWJ5OiBCaW5nIFpoYW8gPGJ6aGFvQG1hcnZlbGwu
Y29tPg0KDQpSZWdhcmRzLA0KQmluZw0KDQo+IC0tLQ0KPiAgZHJpdmVycy9uZXQvd2lyZWxlc3Mv
bXdpZmlleC9tYWluLmggfCAgICAyICstDQo+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24o
KyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVz
cy9td2lmaWV4L21haW4uaCBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL213aWZpZXgvbWFpbi5oDQo+
IGluZGV4IGQ1M2UxZTguLjMxOTEwNjYgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L3dpcmVs
ZXNzL213aWZpZXgvbWFpbi5oDQo+ICsrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL213aWZpZXgv
bWFpbi5oDQo+IEBAIC0xMTAxLDcgKzExMDEsNyBAQCBtd2lmaWV4XzExaF9nZXRfY3NhX2Nsb3Nl
ZF9jaGFubmVsKHN0cnVjdCBtd2lmaWV4X3ByaXZhdGUgKnByaXYpDQo+ICAJCXJldHVybiAwOw0K
PiANCj4gIAkvKiBDbGVhciBjc2EgY2hhbm5lbCwgaWYgREZTIGNoYW5uZWwgbW92ZSB0aW1lIGhh
cyBwYXNzZWQgKi8NCj4gLQlpZiAoamlmZmllcyA+IHByaXYtPmNzYV9leHBpcmVfdGltZSkgew0K
PiArCWlmICh0aW1lX2FmdGVyKGppZmZpZXMsIHByaXYtPmNzYV9leHBpcmVfdGltZSkpIHsNCj4g
IAkJcHJpdi0+Y3NhX2NoYW4gPSAwOw0KPiAgCQlwcml2LT5jc2FfZXhwaXJlX3RpbWUgPSAwOw0K
PiAgCX0NCj4gLS0NCj4gMS43LjEwLjQNCg0K
