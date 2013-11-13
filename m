Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:4608 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758789Ab3KMMVP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Nov 2013 07:21:15 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: wzyboy <wzyboy@wzyboy.org>
CC: Bjorn Helgaas <bhelgaas@google.com>,
	Emmanuel Grumbach <egrumbach@gmail.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: RE: [Ilw] Intel Wireless 7260 hardware timed out randomly
Date: Wed, 13 Nov 2013 12:21:10 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB301E002F0@HASMSX103.ger.corp.intel.com> (sfid-20131113_132119_674843_356B00B6)
References: <0BA3FCBA62E2DC44AF3030971E174FB301DEA052@HASMSX103.ger.corp.intel.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301DEA097@HASMSX103.ger.corp.intel.com>
 <CALkVjQY7uRFQ3Qs9T_bgqnYRNcWgsk5gfd=R8RfGFxOdDpFYTQ@mail.gmail.com>
 <527A8166.6000701@gmail.com>
 <CAErSpo5H9Mf-xmdzThudNO2WHAOt-1T7CQZvgGUmK4jm7_zf+g@mail.gmail.com>
 <CALkVjQaHYpR4Tifbt7nh4VeQSrOz5J-xxSrUBKX2kXCZcvkivA@mail.gmail.com>
 <CAErSpo5dX=cPdThxi-ok=B4beo_jPv2n2n0C1u4UyZMbQDMxqg@mail.gmail.com>
 <CALkVjQYkAWrwRabQfBSvC1pm47ZyRT5jQ0mYBwbiGh-Bt29gbg@mail.gmail.com>
 <20131111224439.GA30638@google.com>
 <CALkVjQb-AJRSGARCQaDFkd+mHBk2qFkAVyVBTW7RHSaxzbZsbw@mail.gmail.com>
 <CALkVjQaXEBpbwu9Qy3+17Eg-nSg-k7iin8G3f1RsTLkCOB-2XQ@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301DF044C@HASMSX103.ger.corp.intel.com>
 <CAErSpo5iU15AoSVL9WmLp4gNCiNmt6pFZuTsd-Vui4SCrSc_Hw@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301DF0865@HASMSX103.ger.corp.intel.com>
 <CAErSpo77vnfRvEdgj470WWKo_8p8cv2xQUdaGQvvkY3tPBXzyQ@mail.gmail.com>
 <52828364.6080103@gmail.com>
 <CAErSpo6JdKgU0M-wu84_U2Hb4-4mdSr_V8f70Pi-ox8H45+Diw@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301E00262@HASMSX103.ger.corp.intel.com>
 <CALkVjQZfc3SHv8j1Kp-N1_+nQ5_WUsk6mf1BBG9MikzkaHZECA@mail.gmail.com>
In-Reply-To: <CALkVjQZfc3SHv8j1Kp-N1_+nQ5_WUsk6mf1BBG9MikzkaHZECA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PiANCj4gMjAxMy8xMS8xMyBHcnVtYmFjaCwgRW1tYW51ZWwgPGVtbWFudWVsLmdydW1iYWNoQGlu
dGVsLmNvbT46DQo+ID4gQWNjb3JkaW5nIHRvIFN5c3RlbSAvIEhXLCBpdCBpcyB1bnNhZmUgdG8g
ZGlzYWJsZSBMMSBQTSBTdWJzdGF0ZSB1c2luZw0KPiBzZXRwY2ksIGV2ZW4gaWYgd2UgZGlzYWJs
ZSBpdCBmcm9tIGJvdGggc2lkZXMgKGRldmljZSBhbmQgYnJpZGdlKS4gVGhpcyBraW5kIG9mDQo+
IHNldHRpbmdzIHNob3VsZCBiZSBkb25lIGJ5IEJJT1Mgb25seS4NCj4gPiBTbyB3ZSBoYXZlIDIg
b3B0aW9ucyBoZXJlIChhc3N1bWluZyB0aGF0IHdlIGNhbid0IGRpc2FibGUgdGhhdCBpbiBCSU9T
KToNCj4gPiAqIGVpdGhlciB3ZSB0cnkgdG8gZGlzYWJsZSBMMSBQTSBTdWJzdGF0ZSBldmVuIG15
IGNvbGxlYWd1ZXMgdGhpbmsgaXQNCj4gPiBpcyBub3Qgc2FmZQ0KPiA+ICogZWl0aGVyIHdlIGp1
c3QgZGlzYWJsZSBMMSBhbHRvZ2V0aGVyDQo+IA0KPiANCj4gVW5zYWZlIG1lYW5zIGJhdHRlcnkg
Ymxvd3MgdXAgbGlrZSBhIFNhbXN1bmc/IDotKQ0KPiANCg0KWW91IGFscmVhZHkgYmxldyB5b3Vy
IHdhcnJhbnR5IHRoZSBtaW51dGUgeW91ciBpbnN0YWxsZWQgTGludXgsIGRpZG4ndCB5b3U/IDop
DQoNCj4gTXkgbGFwdG9wIGlzIG5vdyBjb25uZWN0ZWQgdG8gY2xhc3Nyb29tJ3MgV2lGaSAod2l0
aCBzZXRwY2kNCj4gd29ya2Fyb3VuZCkgYW5kIHJ1bm5pbmcgb24gYmF0dGVyeSwgaXQgc2VlbXMg
dGhlIHBvd2VyIGNvbnN1bXB0aW9uIGlzDQo+IGFjY2VwdGFibGUgLi4uIGF0IGxlYXN0IG5vdCB0
b28gbXVjaCBtb3JlIHRoYW4gYmVmb3JlLg0KDQpDb29sIC0gd2Ugd29yayBmb3Igbm90aGluZyAt
IGVuY291cmFnaW5nIDopDQo=
