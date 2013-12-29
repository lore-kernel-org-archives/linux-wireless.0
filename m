Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:14792 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048Ab3L2IPF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Dec 2013 03:15:05 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: wzyboy <wzyboy@wzyboy.org>
CC: Emmanuel Grumbach <egrumbach@gmail.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	Bj?rn Mork <bjorn@mork.no>
Subject: RE: [Ilw] Intel Wireless 7260 hardware timed out randomly
Date: Sun, 29 Dec 2013 08:14:50 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB303D2D2C5@HASMSX103.ger.corp.intel.com> (sfid-20131229_091538_815922_192F9242)
References: <0BA3FCBA62E2DC44AF3030971E174FB301DEA052@HASMSX103.ger.corp.intel.com>
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
 <0BA3FCBA62E2DC44AF3030971E174FB301E02FC6@HASMSX103.ger.corp.intel.com>
 <CAErSpo6bKOpycD=cp08aBqp2U-u7sdbTSBYoHop1-1Hkmr3F-g@mail.gmail.com>
 <CALkVjQaOHix5uxFGd-62negbfubz-rdP+zmj9w5wDEa1rCA75Q@mail.gmail.com>
 <5285E028.20906@gmail.com>
 <CALkVjQYT9P--dgez064je4vM-xve4uF5ptOVVk3DuVoQiWQvew@mail.gmail.com>
 <CANUX_P1j9QNGQ2n02KpXsuMQcZo9uOsSN-zZ8yNS1e5+Y9bJOA@mail.gmail.com>
 <CALkVjQYFJzP1E_YayPOjRu3u85WdpDojDD+DmU9ZehY7ZHF0AA@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB303D297F0@HASMSX103.ger.corp.intel.com>
 <CALkVjQaJ94osfBwnrpKBk4tE_+=XMqznXY=qVv5KdzSkvsthaA@mail.gmail.com>
In-Reply-To: <CALkVjQaJ94osfBwnrpKBk4tE_+=XMqznXY=qVv5KdzSkvsthaA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PiBIaSwNCj4gDQo+IHllc3RlcmRheSBhIGZyaWVuZCBvZiBtaW5lIHRvbGQgbWUgdGhhdCBvbmUg
Y2FuIG5vdyBpbnN0YWxsIFdpbmRvd3MNCj4gOC84LjEgb24gYSBVU0IgZGV2aWNlIG5hdGl2ZWx5
LiBTbyBJIHRyaWVkIHRoaXMgc28tY2FsbGVkICJXaW5kb3dzIFRvIEdvIg0KPiB0ZWNobm9sb2d5
Lg0KPiANCj4gTm93IEkgaGF2ZSBzdWNjZXNzZnVsbHkgZGVwbG95ZWQgYSBXaW5kb3dzIDguMSBp
bnN0YWxsYXRpb24gb24gbXkgZXh0ZXJuYWwNCj4gVVNCIEhERCBhbmQgYm9vdGVkIG15IGxhcHRv
cCB1cCB3aXRoIGl0LiBUaGF0IGlzIHRvIHNheSwgSSBjYW4gbm93IG9ic2VydmUNCj4gaG93IElu
dGVsIDcyNjAgYWN0cyB1bmRlciBXaW5kb3dzLg0KPiANCj4gQ291bGQgeW91IHRlbGwgbWUgd2hh
dCBzaG91bGQgSSBkbyB0byBnYXRoZXIgZGVidWdnaW5nIGluZm9ybWF0aW9uIHN1Y2ggYXMNCj4g
TDEgbW9kZSBldGMgaW4gV2luZG93cz8gSSB3aWxsIHNlbmQgdGhlbSB0byB5b3UgdGhlbi4gTWF5
YmUgdGhpcyBjb3VsZA0KPiBoZWxwLCB0byBmaWd1cmUgb3V0IHdoYXQgdGhlIGJ1ZyBvZiBpd2x3
aWZpIGlzLg0KDQpodHRwOi8vcndldmVyeXRoaW5nLmNvbS8NCg==
