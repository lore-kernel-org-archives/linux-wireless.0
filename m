Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:41422 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbbGNIqq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jul 2015 04:46:46 -0400
Received: from epcpsbgr5.samsung.com
 (u145.gpu120.samsung.co.kr [203.254.230.145])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NRG02ESAZ1W93A0@mailout4.samsung.com> for
 linux-wireless@vger.kernel.org; Tue, 14 Jul 2015 17:46:44 +0900 (KST)
Date: Tue, 14 Jul 2015 08:46:44 +0000 (GMT)
From: Rahul Jain <rahul.jain@samsung.com>
Subject: [PATCH v2] cfg80211-wext: deleting dead code
To: =?windows-1252?Q?Rafa=3F_Mi=3Fecki?= <zajec5@gmail.com>
Cc: David Miller <davem@davemloft.net>,
	Johannes Berg <johannes.berg@intel.com>,
	Network Development <netdev@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Nitin Jhanwar <nitin.j@samsung.com>,
	HEMANSHU SRIVASTAVA <hemanshu.s@samsung.com>,
	Amit Khatri <amit.khatri@samsung.com>
Reply-to: rahul.jain@samsung.com
MIME-version: 1.0
Content-type: text/plain; charset=windows-1252
MIME-version: 1.0
Message-id: <10994553.722921436863601814.JavaMail.weblogic@ep2mlwas06c> (sfid-20150714_104747_045833_76019E67)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RnJvbSBlOTQ1NzM3ZWYyZTNhNWI3MTk4Yjk3OTVkNjM3NWRlODViMmZhYzA4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQ0KRnJvbTogUmFodWwgSmFpbiA8cmFodWwuamFpbkBzYW1zdW5nLmNvbT4N
CkRhdGU6IFR1ZSwgMTQgSnVsIDIwMTUgMTQ6MDQ6MDkgKzA1MzANClN1YmplY3Q6IFtQQVRDSF0g
Y2ZnODAyMTEtd2V4dDogZGVsZXRpbmcgZGVhZCBjb2RlDQoNCkluIGZ1bmMgY2ZnODAyMTFfd2V4
dF9zaXdyZXRyeSgpLCB0aGUgdmFsdWUgb2YgY2hhbmdlZCBpcyBnZXR0aW5nDQptb2RpZmllZCB0
byBub24temVybyB2YWx1ZSB3aXRoaW4gaWYtZWxzZSBjb25kaXRpb24gYW5kIGl0IGlzIGJlY29t
aW5nIGEgbm9uLXplcm8gdmFsdWUuDQpTbywgdGhlIGNvbmRpdGlvbiAiaWYgKCFjaGFuZ2VkKSIg
YmVjb21lcyB1bnJlYWNoYWJsZS4NCg0KU2lnbmVkLW9mZi1ieTogUmFodWwgSmFpbiA8cmFodWwu
amFpbkBzYW1zdW5nLmNvbT4NClNpZ25lZC1vZmYtYnk6IEFtaXQgS2hhdHJpIDxhbWl0LmtoYXRy
aUBzYW1zdW5nLmNvbT4NCi0tLQ0KIG5ldC93aXJlbGVzcy93ZXh0LWNvbXBhdC5jIHwgMyAtLS0N
CiAxIGZpbGUgY2hhbmdlZCwgMyBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL25ldC93aXJl
bGVzcy93ZXh0LWNvbXBhdC5jIGIvbmV0L3dpcmVsZXNzL3dleHQtY29tcGF0LmMNCmluZGV4IGZk
NjgyODMuLjhkZTFiNjQgMTAwNjQ0DQotLS0gYS9uZXQvd2lyZWxlc3Mvd2V4dC1jb21wYXQuYw0K
KysrIGIvbmV0L3dpcmVsZXNzL3dleHQtY29tcGF0LmMNCkBAIC0zODcsOSArMzg3LDYgQEAgc3Rh
dGljIGludCBjZmc4MDIxMV93ZXh0X3Npd3JldHJ5KHN0cnVjdCBuZXRfZGV2aWNlICpkZXYsDQog
CQljaGFuZ2VkIHw9IFdJUEhZX1BBUkFNX1JFVFJZX1NIT1JUOw0KIAl9DQogDQotCWlmICghY2hh
bmdlZCkNCi0JCXJldHVybiAwOw0KLQ0KIAllcnIgPSByZGV2X3NldF93aXBoeV9wYXJhbXMocmRl
diwgY2hhbmdlZCk7DQogCWlmIChlcnIpIHsNCiAJCXdkZXYtPndpcGh5LT5yZXRyeV9zaG9ydCA9
IG9zaG9ydDsNCi0tIA0KMS45LjENCg0KLS0tLS0tLSBPcmlnaW5hbCBNZXNzYWdlIC0tLS0tLS0N
ClNlbmRlciA6IFJhZmE/IE1pP2Vja2k8emFqZWM1QGdtYWlsLmNvbT4NCkRhdGUgOiBKdWwgMTQs
IDIwMTUgMDE6MjggKEdNVCswNTozMCkNClRpdGxlIDogUmU6IFtQQVRDSF0gTG9naWNhbGx5IERl
YWRDb2RlDQoNCk9uIDMgSnVseSAyMDE1IGF0IDA2OjUyLCBSYWh1bCBKYWluIHdyb3RlOg0KPiBG
cm9tIDBjMzQwMzAxNjZhMTUwZDZkOWYxYWI1MmU3YmI0MGE1NDQwYTY4YzIgTW9uIFNlcCAxNyAw
MDowMDowMCAyMDAxDQo+IEZyb206IFJhaHVsIEphaW4gDQo+IERhdGU6IEZyaSwgMyBKdWwgMjAx
NSAxMDoxOToxMiArMDUzMA0KPiBTdWJqZWN0OiBbUEFUQ0hdIExvZ2ljYWxseSBEZWFkQ29kZQ0K
DQpZb3UgZGlkbid0IHVzZSBhbnkgcHJlZml4IGZvciB0aGUgY29tbWl0IG1lc3NhZ2UsIGl0J3Mg
dW5jbGVhcg0KKExvZ2ljYWxseSBEZWFkQ29kZSB3aGF0PyksIG5vIGRlc2NyaXB0aW9uLCB5b3Ug
dG91Y2ggdHdvIGNvZGUgcGxhY2VzDQphdCBvbmNlLg0KDQpQbGVhc2UgZml4IGFib3ZlIHByb2Js
ZW1zIGFuZCByZXNlbmQu


