Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:33322 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910Ab3LRJSm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Dec 2013 04:18:42 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Arend van Spriel <arend@broadcom.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sander Eikelenboom <linux@eikelenboom.it>
CC: Ben Hutchings <ben@decadent.org.uk>,
	Julian Calaby <julian.calaby@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	"Berg, Johannes" <johannes.berg@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <avinashapatil@gmail.com>
Subject: RE: [cfg80211 / iwlwifi] setting wireless regulatory domain doesn't
 work.
Date: Wed, 18 Dec 2013 09:18:39 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB303D23ABD@HASMSX103.ger.corp.intel.com> (sfid-20131218_101848_231984_EF9ACE29)
References: <1342235583.20131211182804@eikelenboom.it>
	<CAB=NE6UfumA2xez1DvtDSBDZ72WF_tOozFo_8LRnMryYiSqD-A@mail.gmail.com>
	<871324710.20131211191104@eikelenboom.it>
	<CAB=NE6XRnE0j9NMW0K1vKzEO9v70arSH4YXZjudqa0ZxiLB4AA@mail.gmail.com>
	<1937118387.20131216122200@eikelenboom.it>	<52AEE60B.6030509@broadcom.com>
	<19210260274.20131216135644@eikelenboom.it>
	<CAGRGNgXHemM2FfnXgW5RbzhFT+9SfUfVkjdysK3+=_u3hWSacw@mail.gmail.com>
	<1534126119.20131217104548@eikelenboom.it>
	<387552477.20131217213319@eikelenboom.it>
	<20131217212709.GB5624@decadent.org.uk>
	<1254825772.20131217224914@eikelenboom.it>
 <CA+55aFxQg6=MAWEkEGz64Hz8OawvPyX=fpBOjY8cGBL5XgB9WQ@mail.gmail.com>
 <52B167F6.5060209@broadcom.com>
In-Reply-To: <52B167F6.5060209@broadcom.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PiANCj4gT24gMTIvMTcvMjAxMyAxMTowNiBQTSwgTGludXMgVG9ydmFsZHMgd3JvdGU6DQo+ID4g
V2UgaGF2ZSBsaXRlcmFsbHkgaGFkIHRoaXMgKmV4YWN0KiBzYW1lIGlzc3VlIHdpdGggZmlybXdh
cmUgbG9hZGluZy4NCj4gPiBOZXR3b3JrIGRyaXZlcnMgc2hvdWxkbid0IHRyeSB0byBsb2FkIGZp
cm13YXJlIGF0IG1vZHVsZSBsb2FkIHRpbWUuDQo+ID4gU2FtZSBkZWFsLg0KPiANCj4gSXQgaXMg
a2luZCBvZiBhIGNoaWNrZW4gYW5kIGVnZyBwcm9ibGVtIGZvciAod2lyZWxlc3MpIG5ldHdvcmtp
bmcgZHJpdmVycy4gVG8NCj4gZ2V0IElGRl9VUCBmcm9tIHRoZSBuZXR3b3JrIGxheWVyIHlvdSBo
YXZlIHRvIHJlZ2lzdGVyIGEgbmV0ZGV2aWNlLiBGb3INCj4gd2lyZWxlc3MgZHJpdmVycyB0aGlz
IG1lYW5zIHlvdSBoYXZlIHRvIHJlZ2lzdGVyIGEgd2lwaHkgZGV2aWNlIHdpdGggY2ZnODAyMTEN
Cj4gd2hpY2ggZmxhZ3MgY2FwYWJpbGl0aWVzIGFuZCBvcHRpb25hbGx5IGFyZSBjdXN0b20gcmVn
dWxhdG9yeSBkb21haW4uIFRoYXQNCj4gaW5mb3JtYXRpb24gZGVwZW5kcyBvbiB0aGUgZGV2aWNl
IGFuZCBmaXJtd2FyZSB1c2VkLiBBbmQgdGhlcmUgd2UgaGF2ZSBhDQo+IGZ1bGwgY2lyY2xlLg0K
PiANCg0KVG8gc29sdmUgdGhpcyAtIGl3bHdpZmkgdXNlcyByZXF1ZXN0X2Zpcm13YXJlX25vd2Fp
dC4gSXRzIGRvYyByZWFkczoNCg0KIkFzeW5jaHJvbm91cyB2YXJpYW50IG9mIHJlcXVlc3RfZmly
bXdhcmUgZm9yIHVzZXIgY29udGV4dHM6IC0gc2xlZXAgZm9yIGFzIHNtYWxsIHBlcmlvZHMgYXMg
cG9zc2libGUgc2luY2UgaXQgbWF5IGluY3JlYXNlIGtlcm5lbCBib290IHRpbWUgb2YgYnVpbHQt
aW4gZGV2aWNlIGRyaXZlcnMgcmVxdWVzdGluZyBmaXJtd2FyZSBpbiB0aGVpciAtPnByb2JlIG1l
dGhvZHMsIGlmIGdmcCBpcyBHRlBfS0VSTkVMLiINCg==
