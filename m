Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:56935 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751418AbaAMI7m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 03:59:42 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: wzyboy <wzyboy@wzyboy.org>
CC: Emmanuel Grumbach <egrumbach@gmail.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [Ilw] Intel Wireless 7260 hardware timed out randomly
Date: Mon, 13 Jan 2014 08:59:37 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB303D3C2B9@HASMSX103.ger.corp.intel.com> (sfid-20140113_095945_991533_3FA9C3FB)
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
 <0BA3FCBA62E2DC44AF3030971E174FB303D2D2C5@HASMSX103.ger.corp.intel.com>
 <CALkVjQaWBq6--sekifyGfJt9FDigsk56eXMUv9YR3sDVnVcX=Q@mail.gmail.com>
 <CAErSpo4ZxJ8T8ih1+svqjpUNbJo-WezP=9OatDTuLk3u=zkCLw@mail.gmail.com>
 <CALkVjQbjnAk0mFZ-3zjx_15xXEaaiMaVxMMLD1HEUJhVtYXg4g@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB303D3C00A@HASMSX103.ger.corp.intel.com>
 <CALkVjQZ9Tc7Xx9ANzcp_4_7_=BCLM7EHS+oJUxQ57QXuSiv+YA@mail.gmail.com>
 <CALkVjQavGvumxnghCc5R8E=7rzDSy1_q+LVZ=vR6--OJxhp7CA@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB303D3C1CB@HASMSX103.ger.corp.intel.com>
 <CALkVjQYSHb-dYckxeq2t4yj3DY8n=j-RrtrB53+ddJstS_qXUw@mail.gmail.com>
In-Reply-To: <CALkVjQYSHb-dYckxeq2t4yj3DY8n=j-RrtrB53+ddJstS_qXUw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PiANCj4gSGksIHRoZSBwb2ludCBpczoNCj4gDQo+ICogV2l0aCAib3B0aW9ucyBpd2xtdm0gcG93
ZXJfc2NoZW1lPTEiIC0+IGV2ZXJ5dGhpbmcncyBmaW5lDQo+ICogV2l0aG91dCAib3B0aW9ucyBp
d2xtdm0gcG93ZXJfc2NoZW1lPTEiIC0+IG5ldHdvcmsgaXMgYmFkDQo+IA0KPiBBYnNlbnNlIG9m
IHRoZSBtb2Rjb25mIGZpbGUgYW5kIGEgbW9kY29uZiB3aXRoIG9ubHkgb25lIGNvbW1lbnQgbGlu
ZQ0KPiBoYXZlIHRoZSAqc2FtZSogZWZmZWN0IC0gbmV0d29yayBpcyBiYWQuDQo+IA0KPiBjYXQg
L3N5cy9tb2R1bGUvaXdsbXZtL3BhcmFtZXRlcnMvcG93ZXJfc2NoZW1lIG5vdyByZXR1cm5zIDEs
IGFuZA0KPiB0aGUgbmV0d29yayBpcyBnb29kLg0KPiANCj4gPiBBbHNvIC0gd2hhdCBjb2RlIGJh
c2UgYXJlIHlvdSB1c2luZz8NCj4gDQo+IFdoYXQgaXMgImNvZGUgYmFzZSIuLi4/DQoNCldoYXQg
a2VybmVsIHZlcnNpb24gOikNCklmIHlvdSB1c2UgMy4xMywgeW91IGNhbiB0cnkgYSBuZXdlciBm
aXJtd2FyZS4NCg0KPiANCj4gRW5nbGlzaCBpcyBub3QgbXkgbmF0aXZlIGxhbmd1YWdlIHNvIEkg
Y2hlY2tlZCBpZiBJIG1pc3VzZSB0aGUgcGhyYXNlDQo+ICJjb21tZW50IG91dCI6IGh0dHA6Ly9l
bmdsaXNoLnN0YWNrZXhjaGFuZ2UuY29tL3F1ZXN0aW9ucy8zMzQ4My93aGVuLQ0KPiBpLXNheS1j
b21tZW50LW91dC1kb2VzLWl0LW1lYW4tdG8tdW5jb21tZW50LXNvbWV0aGluZy1vci1jb21tZW50
LWl0DQo+IA0KPiBTZWVtcyBub3QuLi4NCg0KRW5nbGlzaCBpc24ndCBteSBtb3RoZXIgdG9uZ3Vl
IGVpdGhlcjopDQoNCj4gDQo+IC0tDQo+IHd6eWJveQ0K
