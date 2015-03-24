Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:40663 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751980AbbCXJn2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2015 05:43:28 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"kvalo@codeaurora.org" <kvalo@codeaurora.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"Berg, Johannes" <johannes.berg@intel.com>
Subject: Re: [PATCH] iwlwifi: Fix memory leak in iwl_req_fw_callback()
Date: Tue, 24 Mar 2015 09:43:14 +0000
Message-ID: <1427190194.6454.0.camel@egrumbacBox> (sfid-20150324_104334_153035_F8D1A8AC)
References: <1427137677-2879-1-git-send-email-Larry.Finger@lwfinger.net>
In-Reply-To: <1427137677-2879-1-git-send-email-Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gTW9uLCAyMDE1LTAzLTIzIGF0IDE0OjA3IC0wNTAwLCBMYXJyeSBGaW5nZXIgd3JvdGU6DQo+
IEluIHRoaXMgcm91dGluZSwga3phbGxvYyBhbGxvY2F0ZXMgYSBtZW1vcnkgYmxvY2suIFRoaXMg
YWxsb2NhdGlvbiBpcw0KPiBmcmVlZCBpbiB0aGUgZXJyb3IgcGF0aHMsIGJ1dCBub3QgaW4gdGhl
IG5vcm1hbCBleGl0LCB0aHVzIHRoZSBhbGxvY2F0aW9uDQo+IGlzIGxlYWtlZC4NCj4gDQo+IFRo
ZSBrbWVtbGVhayBmYWNpbGl0eSB3YXMgdXNlZCB0byBmaW5kIHRoZSBsZWFrLg0KPiANCg0KUGlj
a2VkIHVwIC0gdGhhbmtzLg0KDQo+IFNpZ25lZC1vZmYtYnk6IExhcnJ5IEZpbmdlciA8TGFycnku
RmluZ2VyQGx3ZmluZ2VyLm5ldD4NCj4gQ2M6IEpvaGFubmVzIEJlcmcgPGpvaGFubmVzLmJlcmdA
aW50ZWwuY29tPg0KPiBDYzogRW1tYW51ZWwgR3J1bWJhY2ggPGVtbWFudWVsLmdydW1iYWNoQGlu
dGVsLmNvbT4NCj4gQ2M6IEludGVsIExpbnV4IFdpcmVsZXNzIDxpbHdAbGludXguaW50ZWwuY29t
Pg0KPiAtLS0NCj4gIGRyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvaXdsLWRydi5jIHwgMSAr
DQo+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKykNCj4gDQo+IGRpZmYgLS1naXQgYS9k
cml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL2l3bC1kcnYuYyBiL2RyaXZlcnMvbmV0L3dpcmVs
ZXNzL2l3bHdpZmkvaXdsLWRydi5jDQo+IGluZGV4IDY2Y2EwMDAuLmFlZmRkOWIgMTAwNjQ0DQo+
IC0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvaXdsLWRydi5jDQo+ICsrKyBiL2Ry
aXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvaXdsLWRydi5jDQo+IEBAIC0xMzE5LDYgKzEzMTks
NyBAQCBzdGF0aWMgdm9pZCBpd2xfcmVxX2Z3X2NhbGxiYWNrKGNvbnN0IHN0cnVjdCBmaXJtd2Fy
ZSAqdWNvZGVfcmF3LCB2b2lkICpjb250ZXh0KQ0KPiAgCQkJCW9wLT5uYW1lLCBlcnIpOw0KPiAg
I2VuZGlmDQo+ICAJfQ0KPiArCWtmcmVlKHBpZWNlcyk7DQo+ICAJcmV0dXJuOw0KPiAgDQo+ICAg
dHJ5X2FnYWluOg0KDQo=
