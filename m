Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:22320 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932331Ab2GANr4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Jul 2012 09:47:56 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Paul Bolle <pebolle@tiscali.nl>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: RE: [RFT] iwlegacy: don't mess up the SCD when removing a key
Date: Sun, 1 Jul 2012 13:47:51 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB3172498@HASMSX103.ger.corp.intel.com> (sfid-20120701_154759_570639_00EBC1BB)
References: <1341148023-17673-1-git-send-email-emmanuel.grumbach@intel.com>
	 <1341144092.1911.95.camel@x61.thuisdomein>
	 <0BA3FCBA62E2DC44AF3030971E174FB317245E@HASMSX103.ger.corp.intel.com>
 <1341149770.1911.101.camel@x61.thuisdomein>
In-Reply-To: <1341149770.1911.101.camel@x61.thuisdomein>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

DQo+IEVtbWFudWVsLA0KPiANCj4gT24gU3VuLCAyMDEyLTA3LTAxIGF0IDEzOjI5ICswMDAwLCBH
cnVtYmFjaCwgRW1tYW51ZWwgd3JvdGU6DQo+ID4gWW91IGNhbiBhbHNvIHRyeSB0byBzaW1wbHkg
YXNzb2NpYXRlIC8gZGlzYXNzb2NpYXRlIGluIGEgbG9vcCB3aXRoIGFuZA0KPiA+IHdpdGhvdXQg
bXkgcGF0Y2guIFRoaXMgd2FzIHRoZSBzY2VuYXJpbyB0aGF0IHdhcyBmaXhlZCBieSBteSBwYXRj
aCBpbg0KPiA+IGl3bHdpZmkuDQo+IA0KPiBJJ20gYWN0dWFsbHkgdW5mYW1pbGlhciB3aXRoIGFz
c29jaWF0aW5nIGFuZCBkaXNhc3NvY2lhdGluZy4gSG93IGNhbiBJIGRvIHRoYXQgaW4NCj4gYSBs
b29wPw0KPiANCg0KSSBndWVzcyB5b3UgaGF2ZSBhIHNlY3VyZWQgcHJvZmlsZSByaWdodD8gSWYg
eW91IGRvbid0LCBteSBwYXRjaCBpcyBpcnJlbGV2YW50Lg0KSnVzdCBjbGljayBvbiBkaXNjb25u
ZWN0IGluIHlvdXIgR1VJLCBJIGd1ZXNzIGl0IHNob3VsZCBtYWtlIGl0Lg0KDQpZb3UgY2FuIGFs
c28gZG86DQoNCndwYV9jbGkgZGlzY29ubmVjdA0Kd3BhX2NsaSByZWNvbm5lY3QNCg0Kb3Igc29t
ZXRoaW5nIGxpa2UgdGhhdC4NCi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQpJbnRlbCBJc3JhZWwgKDc0KSBMaW1pdGVk
CgpUaGlzIGUtbWFpbCBhbmQgYW55IGF0dGFjaG1lbnRzIG1heSBjb250YWluIGNvbmZpZGVudGlh
bCBtYXRlcmlhbCBmb3IKdGhlIHNvbGUgdXNlIG9mIHRoZSBpbnRlbmRlZCByZWNpcGllbnQocyku
IEFueSByZXZpZXcgb3IgZGlzdHJpYnV0aW9uCmJ5IG90aGVycyBpcyBzdHJpY3RseSBwcm9oaWJp
dGVkLiBJZiB5b3UgYXJlIG5vdCB0aGUgaW50ZW5kZWQKcmVjaXBpZW50LCBwbGVhc2UgY29udGFj
dCB0aGUgc2VuZGVyIGFuZCBkZWxldGUgYWxsIGNvcGllcy4K

