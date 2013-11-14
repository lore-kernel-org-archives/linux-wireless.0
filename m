Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:34429 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474Ab3KNIkC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Nov 2013 03:40:02 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: wzyboy <wzyboy@wzyboy.org>
CC: Bjorn Helgaas <bhelgaas@google.com>,
	Emmanuel Grumbach <egrumbach@gmail.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	Bj?rn Mork <bjorn@mork.no>
Subject: RE: [Ilw] Intel Wireless 7260 hardware timed out randomly
Date: Thu, 14 Nov 2013 08:39:57 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB301E02FC6@HASMSX103.ger.corp.intel.com> (sfid-20131114_094008_496220_8A53FB61)
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
 <CALkVjQZZVHUxuBkS+ret23Bt61TV_x_kj-ey=y93gC0e3cw__Q@mail.gmail.com>
 <CAErSpo6xCUDqfvKB66nZJYBOWnZLEcSJ39+aTGnKKnuZP6+dRQ@mail.gmail.com>
 <CALkVjQaTnocYnV4GM=LHuYwMRZ=sOZnSrtna4C6anNAWr4O7=A@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301E02E49@HASMSX103.ger.corp.intel.com>
 <CALkVjQZdPuE2F+ZARBLha-+iOMA4AjDWHO4=ssnuF2Uu87RyuQ@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301E02EC1@HASMSX103.ger.corp.intel.com>
 <CALkVjQbPTkGuEa8hLVZE0OVatw7ho=D+D51Qu68PRx-0dYay7w@mail.gmail.com>
In-Reply-To: <CALkVjQbPTkGuEa8hLVZE0OVatw7ho=D+D51Qu68PRx-0dYay7w@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PiA+IEF3ZXNvbWUgLSB5b3UgaGF2ZSBMMSBlbmFibGVkOg0KPiANCj4gDQo+IFRob3VnaCBkbyBu
b3QgdW5kZXJzdGFuZCBidXQgaXQgc2VlbXMgbGlrZSBhIGdvb2QgbmV3cyA6LSkNCj4gDQoNCllv
dSBhcmUgc2F2aW5nIHBvd2VyIChhbmQgSSBrbm93IHRoYXQgYXQgbGVhc3QsIEwxIHdvcmtzKS4N
CkwxIFBNIHN1YnN0YXRlcyBkb2Vzbid0IHdvcmsgKGJ1dCB0aGF0J3MgYSBicmFuZCBuZXcgZmVh
dHVyZSkNCg0KPiBEb2VzIHRoYXQgbWVhbiB5b3UgZmluZCBhIHJlYWwgZml4IGluc3RlYWQgb2Yg
YSB3b3JrYXJvdW5kPyBDb25ncmF0dWxhdGlvbnMhDQoNCk5vLiBUaGUgcmVhbCBmaXggc2hvdWxk
IGNvbWUgZnJvbSB0aGUgZHJpdmVyICh1bmxpa2VseSBmcm9tIHdoYXQgSSBoZWFyIGZyb20gc3lz
dGVtIHBlb3BsZSBoZXJlKSBvciBkaXNhYmxlIGluIEJJT1MuDQpTbyBJIGd1ZXNzIHlvdSdkIG5l
ZWQgdG8gYXNrIExlbm92byBob3cgdG8gZGlzYWJsZSBMMSBQTSBTdWJzdGF0ZSBpbiBCSU9TLg0K
