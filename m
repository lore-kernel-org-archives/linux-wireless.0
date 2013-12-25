Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:39382 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751666Ab3LYKiY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Dec 2013 05:38:24 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: wzyboy <wzyboy@wzyboy.org>, Emmanuel Grumbach <egrumbach@gmail.com>
CC: Bjorn Helgaas <bhelgaas@google.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	Bj?rn Mork <bjorn@mork.no>
Subject: RE: [Ilw] Intel Wireless 7260 hardware timed out randomly
Date: Wed, 25 Dec 2013 10:38:20 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB303D297F0@HASMSX103.ger.corp.intel.com> (sfid-20131225_113837_781459_EA46E2A3)
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
In-Reply-To: <CALkVjQYFJzP1E_YayPOjRu3u85WdpDojDD+DmU9ZehY7ZHF0AA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PiANCj4gDQo+IEdsYWQgdG8gc2VlIHlvdSBhZ2FpbiA6LSkNCj4gDQo+IEkndmUgY29tcGlsZWQg
TGludXggMy4xMi41IHdpdGggeW91ciBwYXRjaCwgcmVtb3ZlZCAic2V0cGNpIiB0cmljayBhbmQN
Cj4gcmVib290ZWQuDQo+IA0KPiBEdXJpbmcgdGhlIGJvb3Qgb2YgbmV3IGtlcm5lbCwgSSBjYW4g
c2VlIGFkZGl0aW9uYWwgKGVycm9yKSBtZXNzYWdlcyBhbW9uZw0KPiAic3lzdGVtZC1mc2NrIiBs
aW5lcyBidXQgSSB3YXMgbm90IGZhc3QgZW5vdWdoIHRvIHRha2UgcGhvdG9zIGZvciB0aGVtDQo+
IGJlZm9yZSB0aGV5IGRpc2FwcGVhcmVkIChmbHVzaGVkIGF3YXkpIGJ5IHR0eSBsb2dpbiBpbnRl
cmZhY2UuDQo+IA0KPiBBZnRlciBsb2dnaW5nIGluLCBJIGZpbmQgdGhhdCBuZXRjZmcgZGlkIG5v
dCBjb25uZWN0IHRvIGRvcm1pdG9yeSdzIFdpLUZpIGFzDQo+IGJlZm9yZS4gSSBydW4gImxzcGNp
IC12dnh4eCIgYW5kIGZpbmQgdGhhdCB0aGUgaW50ZXJmYWNlIGlzIGZpbGxlZCB3aXRoICJmZiIu
IEkndmUNCj4gYXR0YWNoZWQgdGhlIG91dHB1dCBvZiAibHNwY2kgLXZ2eHh4IiBhbmQgImRtZXNn
Ii4NCj4gDQoNClNvIGl0IGRpZG4ndCB3b3JrIC0gb2suIEkgYW0gbm90IHN1cnByaXNlZCwgYnV0
IEkgc3RpbGwgd2FudGVkIHRvIGtub3cuDQpUaGlzIHBhdGNoIGlzIHN1cHBvc2VkIHRvIGZpeCBz
b21lIHRpbWluZyBpc3N1ZSBpbiB0aGUgd2FrZSB1cCBmcm9tIEwxLg0KVGhhbmtzIGZvciB0ZXN0
aW5nLg0KDQo+IA0KPiAoQW5kIGhlcmUgaXMgc29tZXRoaW5nICJmdW4iOiBJIHJldmVydGVkIG15
IGtlcm5lbCB0byBBcmNoJ3Mgb2ZmaWNpYWwNCj4gMy4xMi41IGFuZCByZWJvb3RlZCwgYW5kIHRo
ZSBpbnRlcmZhY2UgaXMgdG90YWxseSBtaXNzaW5nISBJIG1lYW4sIGl0DQo+IGRpc2FwcGVhcmVk
IGZyb20gdGhlIG91dHB1dCBvZiAiaXAgbGluayIuIEkgY2Fubm90IGV2ZW4gc2VlIGl0IGluICJs
c3BjaSAtDQo+IHZ2eHh4Iiwgbm90IGV2ZW4gImZmIi4gVGhlIHN0cmFuZ2UgZWZmZWN0IHZhbmlz
aGVkIGFmdGVyIG9uZSBtb3JlIHJlYm9vdA0KPiBhbmQgYSBjb2xkIGJvb3QuKQ0KDQpHcmVhdCAt
IHRoYXQgY2FuIGhhcHBlbiBzb21ldGltZXMgd2hlbiBzb21ldGhpbmcgZ29lcyB3cm9uZy4uLg0K
