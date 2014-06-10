Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:45968 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750800AbaFJPcZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jun 2014 11:32:25 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Andreas Fenkart <afenkart@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Chin-Ran Lo <crlo@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>,
	Zhiyuan Yang <yangzy@marvell.com>
Date: Tue, 10 Jun 2014 08:29:58 -0700
Subject: RE: [PATCH 1/3] mwifiex: support wowlan magic-packet encapsulated
 as UDP packet
Message-ID: <477F20668A386D41ADCC57781B1F70430FE1BF390C@SC-VEXCH1.marvell.com> (sfid-20140610_173228_475316_68AC8D96)
References: <1402109264-7095-1-git-send-email-bzhao@marvell.com>
 <CALtMJEAddX_O2bmi-bPRxXsmSVk8yCr7K8eLTBZOy-f_MfLRNw@mail.gmail.com>
In-Reply-To: <CALtMJEAddX_O2bmi-bPRxXsmSVk8yCr7K8eLTBZOy-f_MfLRNw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgQW5kcmVhcywNCg0KPiBIIEJpbmcsDQo+IA0KPiBsZ3RtLA0KDQpUaGFua3MgZm9yIHlvdXIg
cmV2aWV3Lg0KDQo+IA0KPiBvbmUgcXVlc3Rpb24gYWJvdXQgdGhlIGZvbGxvd3VwIHBhdGNoLA0K
PiBodHRwOi8vd3d3LnNwaW5pY3MubmV0L2xpc3RzL2xpbnV4LXdpcmVsZXNzL21zZzEyMzUwMy5o
dG1sDQo+IA0KPiBob3cgd2lsbCBtYWMgZXZlbnRzIGJlIHN1cHBvcnRlZCBpbiB0aGUgZnV0dXJl
Pw0KPiBldGh0b29sIHdvbCBwICAtIFdha2Ugb24gcGh5IGFjdGl2aXR5DQo+IA0KPiBHdWVzcyB0
aGV5IGNhbid0IGJlIG1vZGVsZWQgd2l0aCBwYXR0ZXJucw0KDQpHb29kIGNhdGNoISBJJ3ZlIG92
ZXJsb29rZWQgdGhpcyAicGh5IGFjdGl2aXR5IiBjYXNlIHdoaWNoIGlzbid0IGNvbmZpZ3VyYWJs
ZSB2aWEgaXcgd293bGFuIGNvbW1hbmQuDQpJIHdpbGwgcmVwbHkgdG8gdGhlIHBhdGNoIGluIHRo
YXQgdGhyZWFkLg0KDQpUaGFua3MsDQpCaW5nDQoNCg==
