Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:63635 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759817AbaEMNKK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2014 09:10:10 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Gottlieb, Matti" <matti.gottlieb@intel.com>
Subject: RE: [PATCH] mac80211: add TX frame consecutive loss statistics
Date: Tue, 13 May 2014 13:10:06 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB303DF2E29@HASMSX103.ger.corp.intel.com> (sfid-20140513_151015_574121_5AA0F807)
References: <1399798043-20891-1-git-send-email-emmanuel.grumbach@intel.com>
 <1399986467.4137.15.camel@jlt4.sipsolutions.net>
In-Reply-To: <1399986467.4137.15.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PiANCj4gT24gU3VuLCAyMDE0LTA1LTExIGF0IDExOjQ3ICswMzAwLCBFbW1hbnVlbCBHcnVtYmFj
aCB3cm90ZToNCj4gPiBGcm9tOiBNYXR0aSBHb3R0bGllYiA8bWF0dGkuZ290dGxpZWJAaW50ZWwu
Y29tPg0KPiA+DQo+ID4gTWVhc3VyZSBUWCBmcmFtZXMgY29uc2VjdXRpdmUgbG9zcyBzdGF0aXN0
aWNzIHBlciBzdGF0aW9uL1RJRC4NCj4gPiBUaGVzZSBNZWFzdXJlbWVudHMgYXJlIGRpc2FibGVk
IGJ5IGRlZmF1bHQgYW5kIGNhbiBiZSBlbmFibGVkIHZpYQ0KPiA+IGRlYnVnZnMuDQo+IA0KPiBJ
J20gZ3Vlc3NpbmcgdGhhdCB3ZSdyZSB0aGUgb25seSB1c2VyIG9mIHRoaXMsIGFuZCB3ZSdyZSBl
dmFsdWF0aW5nIG1vdmluZyB0bw0KPiB0cmFjaW5nLiBBcyBzdWNoLCBJJ20gbm90IGdvaW5nIHRv
IGFwcGx5IHRoaXMgYW5kIGhvcGUgdGhhdCB3ZSdsbCBiZSBhYmxlIHRvIHVzZQ0KPiB0cmFjaW5n
ICh3aXRoIHNvbWUgYWRkZWQgdHJhY2Vwb2ludHMpIGluc3RlYWQgLSBtYXliZSBldmVuIHJlbW92
aW5nIHRoZQ0KPiBvdGhlciBjb2RlIHRoYXQgd2UgYWxyZWFkeSBoYXZlIGhlcmUuDQo+IA0KDQpJ
IGFtIGFsbCBmb3IgaXQgOikNCg==
