Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga12.intel.com ([192.55.52.136]:63058 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725955AbeICN7b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Sep 2018 09:59:31 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        Luca Coelho <luca@coelho.fi>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Coelho, Luciano" <luciano.coelho@intel.com>
Subject: RE: [PATCH 09/28] mac80211: pass the TWT support bits in extended
 caps to the driver
Date: Mon, 3 Sep 2018 09:38:57 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB30126D281DE@HASMSX112.ger.corp.intel.com> (sfid-20180903_114018_428043_75407523)
References: <20180831083130.15525-1-luca@coelho.fi>
         <20180831083130.15525-10-luca@coelho.fi>
         (sfid-20180831_103155_573128_7D703B85)
 <1535964771.3437.17.camel@sipsolutions.net>
         <0BA3FCBA62E2DC44AF3030971E174FB30126D281A5@HASMSX112.ger.corp.intel.com>
 <1535967088.3437.25.camel@sipsolutions.net>
In-Reply-To: <1535967088.3437.25.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PiANCj4gT24gTW9uLCAyMDE4LTA5LTAzIGF0IDA5OjI4ICswMDAwLCBHcnVtYmFjaCwgRW1tYW51
ZWwgd3JvdGU6DQo+ID4gPg0KPiA+IEZvciBtYW5hZ2VkIG1vZGUsIHRoZSBkcml2ZXIgd2lsbCBu
ZWVkIHRvIGNoZWNrIHRoZSBIRSBjYXAgYWxvbmcgd2l0aA0KPiA+IHRoZSBleHRlbmRlZCBjYXBh
YmlsaXRpZXMgdG8gZGV0ZXJtaW5lIHdoZXRoZXIgQVAgc3VwcG9ydHMgVFdUIG9yIG5vdC4NCj4g
DQo+IERvIHlvdSBoYXZlIGFueSBpZGVhIHdoeSBpdCdzIHRoZXJlIHR3aWNlPyBTb3VuZHMgbGlr
ZSB3ZSBzaG91bGQgcmVzb2x2ZQ0KPiB0aGF0IGluIG1hYzgwMjExLCByYXRoZXIgdGhhbiByZXF1
aXJpbmcgdGhlIGRyaXZlciB0byBjaGVjayB0d28gcGxhY2VzLi4uDQo+DQoNCkkgYW0gbm93IGxv
b2tpbmcgYXQgdGFibGUgOS0xMzUgaW4gRDMuMCBhbmQgYXQgVGFibGUtOS0yNjJ6LiBUaGUgZmly
c3QgZGVzY3JpYmVzDQp0aGUgZXh0ZW5kZWQgY2FwcyBJRSwgdGhlIHNlY29uZCwgdGhlIEhFIENB
UCBJRS4gSSBjYW4ndCByZWFsbHkgZmluZCBhbnkgZGlmZmVyZW5jZS4NClNpbmNlIHRoZSBkcml2
ZXIgYWxyZWFkeSBoYXMgdGhlIGZ1bGwgSEUgQ0FQIElFLCBJIHRob3VnaHQgd2UnZCBqdXN0IHJl
ZmxlY3Qgd2hhdCB3ZQ0KaGFkIGluIHRoZSBleHRlbmRlZCBjYXBzIElFIHNvIHRoYXQgaXQgaGFz
IHRoZSAicmF3IiBkYXRhLCBidXQgSSBhZ3JlZSB0aGF0IG1hYzgwMjExDQpjb3VsZCAvIHNob3Vs
ZCBhZ2dyZWdhdGUgdGhlIGRhdGEuDQo=
