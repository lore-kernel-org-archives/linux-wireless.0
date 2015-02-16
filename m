Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out4.electric.net ([192.162.216.185]:54818 "EHLO
	smtp-out4.electric.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755154AbbBPJvM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2015 04:51:12 -0500
From: David Laight <David.Laight@ACULAB.COM>
To: "'Fu, Zhonghui'" <zhonghui.fu@linux.intel.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	"brudley@broadcom.com" <brudley@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>,
	Franky Lin <frankyl@broadcom.com>,
	"meuleman@broadcom.com" <meuleman@broadcom.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"pieterpg@broadcom.com" <pieterpg@broadcom.com>,
	"hdegoede@redhat.com" <hdegoede@redhat.com>,
	"wens@csie.org" <wens@csie.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3] brcmfmac: avoid duplicated suspend/resume operation
Date: Mon, 16 Feb 2015 09:50:44 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1CAE430C@AcuExch.aculab.com> (sfid-20150216_105129_428151_84C524D0)
References: <54DC1D7D.5050407@linux.intel.com>
 <54E0072D.3020802@linux.intel.com>
In-Reply-To: <54E0072D.3020802@linux.intel.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PiA+IFdpRmkgY2hpcCBoYXMgMiBTRElPIGZ1bmN0aW9ucywgYW5kIFBNIGNvcmUgd2lsbCB0cmln
Z2VyDQo+ID4gdHdpY2Ugc3VzcGVuZC9yZXN1bWUgb3BlcmF0aW9ucyBmb3Igb25lIFdpRmkgY2hp
cCB0byBkbw0KPiA+IHRoZSBzYW1lIHRoaW5ncy4gVGhpcyBwYXRjaCBhdm9pZCB0aGlzIGNhc2Uu
DQoNCkRvIHlvdSB3YW50IHRvIHN1c3BlbmQgb24gdGhlIGZpcnN0IG9yIGxhc3QgcmVxdWVzdD8N
Cg0KSW4gZ2VuZXJhbCBpdCBtaWdodCBiZSB0aGF0IG9uZSBmdW5jdGlvbiBpcyBpbiB1c2UgYW5k
DQpzb21ldGhpbmcgd2FudHMgdG8gc3VzcGVuZCB0aGUgb3RoZXIgKGFzIGluYWN0aXZlKS4NCg0K
SWYgdGhleSBzdXNwZW5kIHRvZ2V0aGVyIHlvdSBtaWdodCBuZWVkIHRvIHByZXRlbmQgdGhlDQpm
aXJzdCBmdW5jdGlvbiBpcyBzdXNwZW5kZWQgYnV0IG9ubHkgZG8gdGhlIHJlYWwgcG93ZXItc2F2
aW5nDQpkZXZpY2Ugc3VzcGVuZCB3aGVuIGFsbCB0aGUgZnVuY3Rpb25zIGhhdmUgYmVlbiBzdXNw
ZW5kZWQuDQoNCglEYXZpZA0KDQo=
