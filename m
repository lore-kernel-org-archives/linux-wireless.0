Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:11659 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbaAMI0P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 03:26:15 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: wzyboy <wzyboy@wzyboy.org>
CC: Bjorn Helgaas <bhelgaas@google.com>,
	Emmanuel Grumbach <egrumbach@gmail.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	Bj?rn Mork <bjorn@mork.no>
Subject: RE: [Ilw] Intel Wireless 7260 hardware timed out randomly
Date: Mon, 13 Jan 2014 08:26:09 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB303D3C1CB@HASMSX103.ger.corp.intel.com> (sfid-20140113_092620_090504_E49649B7)
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
In-Reply-To: <CALkVjQavGvumxnghCc5R8E=7rzDSy1_q+LVZ=vR6--OJxhp7CA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PiBIaSwNCj4gDQo+IEkgYW0gc29ycnkgYnV0IGhlcmUgaXMgYmFkIG5ld3MuDQo+IA0KPiBEdXJp
bmcgcHJldmlvdXMgZGVidWdnaW5nIHByb2Nlc3MsIEkgaGF2ZSBhIG1vZGNvbmYgZmlsZQ0KPiAv
ZXRjL21vZHByb2JlLmQvaXdsd2lmaS5jb25mLCBjb250YWluaW5nICJvcHRpb25zIGl3bG12bQ0K
PiBwb3dlcl9zY2hlbWU9MSIuIEkgcmVtb3ZlZCBpdCBqdXN0IG5vdyAoRW1tYW51ZWwgc2F5cyBJ
IGNhbiByZW1vdmUgaXQNCj4gbm93KSBhbmQgZW5jb3VudGVyZWQgKG1heWJlKSBuZXcgYnVncy4g
SGVyZSBpcyB3aGF0IEkgZGlkIGp1c3Qgbm93Og0KPiANCj4gMC4gQ3VycmVudCBrZXJuZWw6IHBh
dGNoZWQgd2l0aA0KPiBodHRwczovL2J1Z3ppbGxhLmtlcm5lbC5vcmcvYXR0YWNobWVudC5jZ2k/
aWQ9MTIxNjcxJmFjdGlvbj1kaWZmIDsNCj4gc2V0cGNpIHRyaWNrOiBub25lIDsgTklDIHN0YXR1
czogd29ya3MgbmljZSBhZnRlciB+MTYgaG91cnMgaGVhdnkNCj4gdXNhZ2UuDQo+IDEuIERlbGV0
ZSB0aGF0IG1vZGNvbmYgZmlsZSwgcmVib290Lg0KPiAyLiBOZXR3b3JrIGNvbm5lY3Rpb24gYmVj
b21lcyBwYWluZnVsbHkgbGFnZ3kgYW5kIGxvc3N5Lg0KPiAzLiBSZS1jcmVhdGUgdGhhdCBtb2Rj
b25mIGZpbGUsIHJlYm9vdC4NCj4gNC4gTmV0d29yayBjb25uZWN0aW9uIHdvcmtzIGZpbmUuDQo+
IDUuIENvbW1lbnQgb3V0IHRoYXQgbGluZSwgcmVib290Lg0KPiA2LiBOZXR3b3JrIGNvbm5lY3Rp
b24gYmVjb21lcyBwYWluZnVsbHkgbGFnZ3kgYW5kIGxvc3N5Lg0KPiA3LiBVbmNvbW1lbnQgdGhh
dCBsaW5lLCByZWJvb3QuDQo+IDguIE5ldHdvcmsgY29ubmVjdGlvbiB3b3JrcyBmaW5lLg0KPiAN
Cj4gV2hhdCBJIG1lYW4gInBhaW5mdWxseSBsYWdneSBhbmQgbG9zc3kiIGlzIHRoYXQsIHRvIHdo
b21ldmVyIEkgInBpbmciDQo+IChHb29nbGUsIDguOC44LjgsIGxvY2FsIEROUyBzZXJ2ZXIuLi4p
LCB0aGUgUlRUIGlzIHJhdGhlciBoaWdoIHRoYW4NCj4gbm9ybWFsLCBhbmQgcGFja2V0IGxvc3Mg
cmF0ZSBpcyBhYm92ZSA5MCUgKHNvbWUgYWRkcmVzc2VzIDEwMCUgbG9zcykuDQo+IFdoaWxlIGF0
IHRoZSBzYW1lIHRpbWUsIG90aGVyIG5ldHdvcmsgZGV2aWNlIGluIHRoZSBzYW1lIExBTiB3b3Jr
cw0KPiBmaW5lLg0KPiANCj4gSSd2ZSBhdHRhY2hlZCBkbWVzZyBhbmQgbHNwY2kgb3V0cHV0IGF0
IHN0ZXAgNiBhbmQgOC4NCj4gDQoNCkFyZSB5b3Ugc3VyZSBhYm91dCBzdGVwIDEgYW5kIDU/DQpJ
dCBzZWVtcyBjb21wbGV0ZWx5IHdlaXJkIHRoYXQgYW4gZXhpc3RpbmcgZmlsZSB3aXRoIGEgbGlu
ZSBjb21tZW50ZWQgb3V0IGhhdmUgYW55IGltcGFjdC4NCkNhbiB5b3UgcGxlYXNlIHNlbmQgdGhl
IG91dHB1dCBvZjoNCgljYXQgL3N5cy9tb2R1bGUvaXdsbXZtL3BhcmFtZXRlcnMvcG93ZXJfc2No
ZW1lDQppbiBib3RoIGNhc2VzLg0KDQpBbHNvIC0gd2hhdCBjb2RlIGJhc2UgYXJlIHlvdSB1c2lu
Zz8NClNpbmNlICB0aGlzIGlzIHN1cmVseSBub3QgcmVsYXRlZCB0byBQQ0ksIHBsZWFzZSByZW1v
dmUgdGhlbSBpbiB5b3VyIHJlcGx5Lg0KKEkga2VlcCB0aGVtIGhlcmUgdG8gaGF2ZSB0aGVtIHNl
ZSBteSBtYWlsIDopKQ0K
