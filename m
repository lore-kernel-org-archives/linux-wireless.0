Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:39287 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132Ab3KNGUx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Nov 2013 01:20:53 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: wzyboy <wzyboy@wzyboy.org>, Bjorn Helgaas <bhelgaas@google.com>
CC: Emmanuel Grumbach <egrumbach@gmail.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	Bj?rn Mork <bjorn@mork.no>
Subject: RE: [Ilw] Intel Wireless 7260 hardware timed out randomly
Date: Thu, 14 Nov 2013 06:20:48 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB301E02E49@HASMSX103.ger.corp.intel.com> (sfid-20131114_072057_866609_3B3E5C06)
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
In-Reply-To: <CALkVjQaTnocYnV4GM=LHuYwMRZ=sOZnSrtna4C6anNAWr4O7=A@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PiANCj4gMjAxMy8xMS8xNCBCam9ybiBIZWxnYWFzIDxiaGVsZ2Fhc0Bnb29nbGUuY29tPjoNCj4g
PiBUaGFua3MuICBBcmUgeW91IDEwMCUgc3VyZSB0aGUgbHNwY2kgb3V0cHV0IGlzIGJlZm9yZSB0
aGUgc2V0cGNpDQo+ID4gd29ya2Fyb3VuZD8NCj4gDQo+IA0KPiBUbyBlbnN1cmUgdGhhdCwgSSBk
aWQgaXQgYWdhaW46DQo+IA0KPiBib290IHVwIGxhcHRvcCAtPiBjb25uZWN0IHRvIGRvbWl0b3J5
J3MgV2lGaSAtPiBydW4gbHNwY2kgLT4gcnVuIHNldHBjaSAtPiBydW4NCj4gZG1lc2cuDQo+IA0K
PiBIZXJlIGFyZSB0aGUgb3V0cHV0cy4NCg0KQ2FuIHlvdSBwbGVhc2UgdHJ5IHRoZSBmb2xsb3dp
bmc6DQoqIEJvb3Qgd2l0aG91dCBhbnkgY2hhbmdlcw0KKiBzZXRwY2kgLXMwMzowMC4wIDB4MTYw
LkI9MHgwMA0KKiBzZXRwY2kgLXMwMDoxYy4xIDB4MjA0LkI9MHgxMA0KbHNwY2kgLXZ2DQoNCmFu
ZCB0ZWxsIG1lIGlmIFdpRmkgd29ya3MgdGhlbi4NCih0aGlzIHJlcGxhY2VzIHRoZSBwcmV2aW91
cyBzZXRwY2kgY29tbWFuZHMpDQoNCg0KVGhhbmsgeW91DQo=
