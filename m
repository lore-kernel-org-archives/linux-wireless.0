Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:45025 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751455Ab2FLSqe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2012 14:46:34 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Jouni Malinen <j@w1.fi>
Date: Tue, 12 Jun 2012 11:44:09 -0700
Subject: RE: [PATCH 3/4] mwifiex: add 11n support for AP mode
Message-ID: <477F20668A386D41ADCC57781B1F7043083A7F11AD@SC-VEXCH1.marvell.com> (sfid-20120612_204637_895342_73A8CBC9)
References: <1339463659-10736-1-git-send-email-bzhao@marvell.com>
	 <1339463659-10736-3-git-send-email-bzhao@marvell.com>
	 (sfid-20120612_031449_661395_EE5E9722)
 <1339502065.4531.3.camel@jlt3.sipsolutions.net>
In-Reply-To: <1339502065.4531.3.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgSm9oYW5uZXMsDQoNClRoYW5rcyBmb3IgeW91ciBjb21tZW50Lg0KDQo+ID4gUGFyc2UgSFQg
SUUgZnJvbSBjZmc4MDIxMSBhbmQgc2V0IEhUIGNhcGFiaWxpdGllcyBhY2NvcmRpbmdseQ0KPiA+
IHRvIEZXLiBJZiBIVCBJRSBpcyBtaXNzaW5nLCAxMW4gd291bGQgYmUgZGlzYWJsZWQgaW4gRlcu
DQo+IA0KPiBObyBvYmplY3Rpb25zLCBidXQgaXQgbWlnaHQgYmUgd29ydGh3aGlsZSB0byBleHRl
bmQgdGhlIEFQSXMgdG8gbm90IGhhdmUNCj4gdG8gcGFyc2UgdGhpcz8NCg0KSWYgSSB1bmRlcnN0
YW5kIGl0IGNvcnJlY3RseSwgd2UgY2FuIHByb2JhYmx5IGRvIHNvbWV0aGluZyBsaWtlIHRoaXM6
DQoNCjEpIGFkZCBuZXcgdmFyaWFibGVzICJjb25zdCB1OCAqaHRfY2FwIiBhbmQgInNpemVfdCBo
dF9jYXBfbGVuIiB0byBzdHJ1Y3QgY2ZnODAyMTFfYXBfc2V0dGluZ3MNCjIpIHBhcnNlIFdMQU5f
RUlEX0hUX0NBUEFCSUxJVFkgaW4gbmw4MDIxMV9zdGFydF9hcCgpIGFuZCB1cGRhdGUgaHRfY2Fw
L2h0X2NhcF9sZW4gYWNjb3JkaW5nbHkNCjMpIGRyaXZlcnMgKG13aWZpZXgsIGV0Yy4pIG1ha2Ug
dXNlIG9mIGh0X2NhcC9odF9jYXBfbGVuIGRpcmVjdGx5IGluIHN0YXJ0X2FwKCkgaGFuZGxlcg0K
DQpSZWdhcmRsZXNzIHdlIGhhdmUgdG8gcGFyc2UgSFRfQ0FQIElFIGZyb20gYmVhY29uLnRhaWws
IGVpdGhlciBpbiBkcml2ZXIgc3RhcnRfdXAgaGFuZGxlciwgb3IgaW5zaWRlIG9mIGNmZzgwMjEx
L25sODAyMTEuIFBsZWFzZSBsZXQgbWUga25vdyBpZiBhYm92ZSBjaGFuZ2UgaXMgT0sgZm9yIHlv
dS4NCg0KVGhhbmtzLA0KQmluZw0KDQo=
