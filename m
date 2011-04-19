Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:29642 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751703Ab1DSMBq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2011 08:01:46 -0400
Subject: Re: [PATCH 02/10] iwlagn: remove most BUG_ON instances
From: Johannes Berg <johannes.berg@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
In-Reply-To: <20110419120002.GA2220@redhat.com>
References: <1303145057-6545-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1303145057-6545-3-git-send-email-wey-yi.w.guy@intel.com>
	 <20110419120002.GA2220@redhat.com>
Date: Tue, 19 Apr 2011 14:01:42 +0200
Message-ID: <1303214502.3603.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gVHVlLCAyMDExLTA0LTE5IGF0IDE0OjAwICswMjAwLCBTdGFuaXNsYXcgR3J1c3prYSB3cm90
ZToKPiBPbiBNb24sIEFwciAxOCwgMjAxMSBhdCAwOTo0NDowOUFNIC0wNzAwLCBXZXktWWkgR3V5
IHdyb3RlOgo+ID4gRnJvbTogSm9oYW5uZXMgQmVyZyA8am9oYW5uZXMuYmVyZ0BpbnRlbC5jb20+
Cj4gPiBAQCAtMzk0LDcgKzM5NCw5IEBAIGludCBpd2xfaHdfdHhxX2F0dGFjaF9idWZfdG9fdGZk
KHN0cnVjdCBpd2xfcHJpdiAqcHJpdiwKPiA+ICAJCXJldHVybiAtRUlOVkFMOwo+ID4gIAl9Cj4g
PiAgCj4gPiAtCUJVR19PTihhZGRyICYgfkRNQV9CSVRfTUFTSygzNikpOwo+ID4gKwlpZiAoV0FS
Tl9PTihhZGRyICYgfkRNQV9CSVRfTUFTSygzNikpKQo+ID4gKwkJcmV0dXJuIC1FSU5WQUw7Cj4g
U2VlbXMgdXNlbGVzcy4KCkJldHRlciB0aGFuIHRoZSBCVUdfT04sIG1vc3RseSB0byBjYXRjaCBw
cm9ncmFtbWVyIGVycm9ycyB0aG91Z2ggSQpndWVzcy4KCj4gPiBAQCAtMTY5LDEwICsxNzEsMTIg
QEAgaW50IGl3bF9zZW5kX2NtZF9zeW5jKHN0cnVjdCBpd2xfcHJpdiAqcHJpdiwgc3RydWN0IGl3
bF9ob3N0X2NtZCAqY21kKQo+ID4gIAlpbnQgY21kX2lkeDsKPiA+ICAJaW50IHJldDsKPiA+ICAK
PiA+IC0JbG9ja2RlcF9hc3NlcnRfaGVsZCgmcHJpdi0+bXV0ZXgpOwo+IEkgdGhpbmsgYmV0dGVy
IGtlZXAgaXQuCgpPaCwgdGhhdCBtdXN0IGJlIGEgbWVyZ2UgZXJyb3IsIEkgZG9uJ3QgcmVtZW1i
ZXIgZG9pbmcgdGhhdC4KCmpvaGFubmVzCgotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQpJ
bnRlbCBHbWJICkRvcm5hY2hlciBTdHJhc3NlIDEKODU2MjIgRmVsZGtpcmNoZW4vTXVlbmNoZW4s
IERldXRzY2hsYW5kIApTaXR6IGRlciBHZXNlbGxzY2hhZnQ6IEZlbGRraXJjaGVuIGJlaSBNdWVu
Y2hlbgpHZXNjaGFlZnRzZnVlaHJlcjogRG91Z2xhcyBMdXNrLCBQZXRlciBHbGVpc3NuZXIsIEhh
bm5lcyBTY2h3YWRlcmVyClJlZ2lzdGVyZ2VyaWNodDogTXVlbmNoZW4gSFJCIDQ3NDU2IApVc3Qu
LUlkTnIuL1ZBVCBSZWdpc3RyYXRpb24gTm8uOiBERTEyOTM4NTg5NQpDaXRpYmFuayBGcmFua2Z1
cnQgYS5NLiAoQkxaIDUwMiAxMDkgMDApIDYwMDExOTA1Mgo=

