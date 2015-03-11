Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:26801 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259AbbCKIRn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2015 04:17:43 -0400
From: "Stepanov, Max" <Max.Stepanov@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Cedric Izoard <Cedric.Izoard@ceva-dsp.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH v2] mac80211: Get IV len from key conf and not cipher
 scheme
Date: Wed, 11 Mar 2015 08:17:19 +0000
Message-ID: <3A934E7FDB083A4683727C7D377065954A237007@hasmsx109.ger.corp.intel.com> (sfid-20150311_091749_219003_0AB13063)
References: <5842EA9CC042B141995329508713AD672105A9B0@ILMAIL1.corp.local>
	 <1426003477.1926.5.camel@sipsolutions.net>
	 <5842EA9CC042B141995329508713AD672105A9FB@ILMAIL1.corp.local>
	 <1426006121.1926.6.camel@sipsolutions.net>
	 <5842EA9CC042B141995329508713AD672105AA3E@ILMAIL1.corp.local>
 <1426008781.1926.7.camel@sipsolutions.net>
In-Reply-To: <1426008781.1926.7.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PiBPbiBUdWUsIDIwMTUtMDMtMTAgYXQgMTk6MzMgKzAwMDAsIEpvaGFubmVzIEJlcmcgd3JvdGU6
DQo+PiBPbiBUdWUsIDIwMTUtMDMtMTAgYXQgMTc6MjggKzAwMDAsIENlZHJpYyBJem9hcmQgd3Jv
dGU6DQo+Pg0KPj4gVGhlIG90aGVyIG9wdGlvbiBJIHNlZSwgd291bGQgYmUgdG8gYWRkIGEgcG9p
bnRlciB0byB0aGUgY2lwaGVyIHNjaGVtZSANCj4+IGluIHN0cnVjdCBpZWVlODAyMTFfa2V5LiBT
byB0aGF0IGluIFRYIGNpcGhlcl9zY2hlbWUgd291bGQgYmUgDQo+PiB0ZXN0L2FjY2Vzc2VkIHVz
aW5nIGtleSBwdHIuIHN0YS0+Y2lwaGVyX3NjaGVtZSB3b3VsZCBzdGlsbCBiZSB1c2VkIGZvciBS
WC4NCj4+IERvIHlvdSBjb25zaWRlciB0aGlzIGFzIGEgYmV0dGVyIG9wdGlvbiA/DQo+DQo+IEEg
d2hvbGUgcG9pbnRlciBzZWVtcyBhIGJpdCBwb2ludGxlc3MsIG1heWJlIGEga2V5IGZsYWcgd291
bGQgYmUgYmV0dGVyPw0KDQpJIGFncmVlIHdpdGggSm9oYW5uZXMgLSBhIGtleSBmbGFnIGlzIGJl
dHRlci4gQW5vdGhlciBwb2ludCBpcyB0aGF0IGllZWU4MDIxMV9jcnlwdG9fY3NfZW5jcnlwdCgp
IGZ1bmN0aW9uIGlzIGNhbGxlZCBmb3Igbm9uIGNzIGNhc2VzLiBJdCBtYWtlcyBzZW5zZSB0byBj
YWxsIGl0IG9ubHkgaWYgdGhlIGtleSBmbGFnIGlzIHNldC4NCg==
