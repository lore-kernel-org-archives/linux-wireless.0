Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:51910 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771AbaAMGCG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 01:02:06 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: wzyboy <wzyboy@wzyboy.org>, Bjorn Helgaas <bhelgaas@google.com>
CC: Emmanuel Grumbach <egrumbach@gmail.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	Bj?rn Mork <bjorn@mork.no>
Subject: RE: [Ilw] Intel Wireless 7260 hardware timed out randomly
Date: Mon, 13 Jan 2014 06:01:46 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB303D3C00A@HASMSX103.ger.corp.intel.com> (sfid-20140113_070211_508319_A2BD76A1)
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
In-Reply-To: <CALkVjQbjnAk0mFZ-3zjx_15xXEaaiMaVxMMLD1HEUJhVtYXg4g@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PiA+IEFTUE0gbXVzdCBiZSBjb25maWd1cmVkIG9uIGJvdGggZW5kcyBvZiB0aGUgbGluaywgc28g
Zm9yIGNvbXBsZXRlbmVzcywNCj4gPiBjYW4geW91IGFsc28gY29sbGVjdCB0aGUgIlBDSSIgb3V0
cHV0IGZvciB0aGUgYnJpZGdlIGxlYWRpbmcgdG8gdGhlDQo+ID4gNzI2MCBkZXZpY2U/ICBCYXNl
ZCBvbiB0aGUgTGludXggbHNwY2kgb3V0cHV0LCB0aGlzIHNob3VsZCBiZQ0KPiA+IDAwMDA6MDA6
MWMuMS4NCj4gPg0KPiA+IEFuZCBJIGFzc3VtZSB0aGUgZGV2aWNlIHdvcmtzIHdlbGwgd2l0aCB0
aGUgV2luZG93cyBkcml2ZXI/DQo+IA0KPiANCj4gSGVyZSBhcmUgdGhlICJQQ0kiIGFuZCAiUENJ
IEluZGV4IiBkYXRhIGZvciAwMDAwOjAwOjFjOjEuDQo+IA0KPiBBbmQgeWVzIHRoZSBOSUMgd29y
a3MgbmljZSBpbiBXaW5kb3dzLg0KPiANCg0KU21hbGwgdXBkYXRlIGZyb20gdGhlIGJ1Z3ppbGxh
IChodHRwczovL2J1Z3ppbGxhLmtlcm5lbC5vcmcvc2hvd19idWcuY2dpP2lkPTY0NTQxKS4NClRo
ZSBidWcgaXMgc29sdmVkLi4uIFRoZXJlIHNlZW0gdG8gYmUgYSBoYXJkd2FyZSBidWcgd2l0aCB0
aGUgTDEgT0ZGIGV4aXQgdGltZXIuIFRvIHNvbHZlIHRoaXMgYnVnIHdlIG5lZWQgKm5vdCogdG8g
cmVseSBvbiB0aGUgaW50ZXJuYWwgY2xvY2sgYW5kIG5lZWQgdG8ga2VlcCB1c2luZyB0aGUgZXh0
ZXJuYWwgY2xvY2suIFRoZSBpbnRlcm5hbCBjbG9jayBpc24ndCByZWxpYWJsZSBlbm91Z2ggYW5k
IGNhbiBsZWFkIHRvIGxvc3Mgb2Ygc3luY2hyb25pemF0aW9uIGJldHdlZW4gdGhlIGJyaWRnZSBh
bmQgdGhlIGRldmljZSB1cG9uIEwxIE9GRiB0cmFuc2l0aW9uLg0KVGhpcyBpc3N1ZSBoYXMgYmVl
biBzZWVuIGluIHNpbXVsYXRpb24gYW5kIG5vdCBvbiByZWFsIGhhcmR3YXJlLi4uIHVudGlsIG5v
dy4uLiBUaGUgd2luZG93cyBkcml2ZXIgaGFzIGEgd29ya2Fyb3VuZCBmb3IgdGhpcyBoYXJkd2Fy
ZSBidWcsIHRoaXMgaXMgd2h5IHRoZSBpc3N1ZSB3YXNuJ3Qgc2VlbiBvbiBXaW5kb3dzLiBJIGFt
IHBvcnRpbmcgdGhlIHdvcmsgYXJvdW5kIHRvIHRoZSBMaW51eCBkcml2ZXIuDQoNClRoYW5rIHlv
dSB3enlib3kgZm9yIHlvdXIgcGF0aWVuY2UuLi4NCg0KVGhlbiBlbmQuDQo=
