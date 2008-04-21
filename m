Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.180]:32232 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758439AbYDUSuI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2008 14:50:08 -0400
Received: by el-out-1112.google.com with SMTP id n30so500211elf.21
        for <linux-wireless@vger.kernel.org>; Mon, 21 Apr 2008 11:50:07 -0700 (PDT)
Message-ID: <a44ae5cd0804211150l1ede6030t5844458e4f92c73c@mail.gmail.com> (sfid-20080421_205127_334819_095B0784)
Date: Mon, 21 Apr 2008 14:50:06 -0400
From: "Miles Lane" <miles.lane@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: b43 speed problem over 2.6.24 (was: One more log file from when the network was unusable)
Cc: "Michael Buesch" <mb@bu3sch.de>,
	"Stefano Brivio" <stefano.brivio@polimi.it>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	bcm43xx-dev <bcm43xx-dev@lists.berlios.de>
In-Reply-To: <1208779022.26186.91.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <a44ae5cd0804161701k1014f3dkebaa1d35f1a8e20a@mail.gmail.com>
	 <a44ae5cd0804181446g596daa2yd1be5b1ac7e5e472@mail.gmail.com>
	 <1208555536.4848.54.camel@johannes.berg>
	 <a44ae5cd0804190801n66035332ubedbae99a7b635ce@mail.gmail.com>
	 <a44ae5cd0804190811g10335c22mf10b9ddb2ab568ec@mail.gmail.com>
	 <a44ae5cd0804190814i434dc92bwba3bb33737fbec1f@mail.gmail.com>
	 <a44ae5cd0804191905qb281d7ehf839f80cd753a82@mail.gmail.com>
	 <1208766258.26186.35.camel@johannes.berg>
	 <a44ae5cd0804210400o1ed662aeqb00b9ba5abc61126@mail.gmail.com>
	 <1208779022.26186.91.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gTW9uLCBBcHIgMjEsIDIwMDggYXQgNzo1NyBBTSwgSm9oYW5uZXMgQmVyZwo8am9oYW5uZXNA
c2lwc29sdXRpb25zLm5ldD4gd3JvdGU6Cj4gSGksCj4KPiAgTWlsZXMgZGVzY3JpYmVkIGEgYjQz
IHNwZWVkIHByb2JsZW0gaW4gdGhlIHRocmVhZAo+Cj4gICAgICAgICDvu78yLjYuMjUtcmM5IC0t
IGJjbTQzMDYgcGVyZm9ybWFuY2UgaXMgaW4gdGhlIHRvaWxldAo+Cj4gIChvdmVyIDIuNi4yNCkg
YW5kIG5vdCBiZWluZyBhYmxlIHRvIHNlZSBhbnl0aGluZyBmcm9tIGhpcyBsb2dzL3BhY2tldAo+
ICBjYXB0dXJlcy8uLi4gSSBhc2tlZCBoaW0gdG8gYmlzZWN0LiBUaGlzIHJlc3VsdGVkIGluCj4K
PiAgY29tbWl0IDYxYmNhNmViODVjODYzNjAzZDYwNTQ1MzBlMmY2NWMzYjlhYmE4NWIKPiAgQXV0
aG9yOiBTdGVmYW5vIEJyaXZpbyA8c3RlZmFuby5icml2aW9AcG9saW1pLml0Pgo+ICBEYXRlOiAg
IFR1ZSBOb3YgNiAyMjo0OTowNSAyMDA3ICswMTAwCj4KPiAgICAgYjQzOiByZXdyaXRlIEEgUEhZ
IGluaXRpYWxpemF0aW9uCj4KPiAgd2hpY2ggaXMgYSBodWdlIGNvbW1pdCBhbmQgaGVuY2UgYSBi
aXQgb2YgYSBwcm9ibGVtLiBEb2VzIGFueW9uZSBoYXZlCj4gIHN1Z2dlc3Rpb25zIGhvdyB0byBw
cm9jZWVkPwo+Cj4gIEkgaGF2ZSB2ZXJ5IHNpbWlsYXIgaGFyZHdhcmUsIG1heWJlIHRoaXMgY2Fy
ZCBpcyBhZmZlY3RlZCBieSB0aGUKPiAgYm9hcmRmbGFncyBwcm9ibGVtcyB3ZSBmb3VuZCByZWNl
bnRseT8gTWlsZXMsIGNhbiB5b3UgZ2l2ZSB1cwo+ICAgKiBsc3BjaSAtdm4gLXMg77u/MDE6MDYu
MAo+ICAgKiB0aGUga2VybmVsIGluaXQgbWVzc2FnZXMgd2hlbiBzc2IgaXMgYnVpbHQgd2l0aCBk
ZWJ1Z2dpbmcKCkhlcmUgeW91IGdvOgoKIyBsc3BjaSAtdm4gLXMgMDE6MDYuMAowMTowNi4wIDAy
ODA6IDE0ZTQ6NDMyMCAocmV2IDAzKQoJU3Vic3lzdGVtOiAxMDU3OjcxMTAKCUZsYWdzOiBidXMg
bWFzdGVyLCBmYXN0IGRldnNlbCwgbGF0ZW5jeSAxNiwgSVJRIDUKCU1lbW9yeSBhdCBlZDAwMDAw
MCAoMzItYml0LCBub24tcHJlZmV0Y2hhYmxlKSBbc2l6ZT04S10KClsgICAgMy45Nzc5MzBdIHNz
YjogQ29yZSAwIGZvdW5kOiBDaGlwQ29tbW9uIChjYyAweDgwMCwgcmV2IDB4MDQsIHZlbmRvciAw
eDQyNDMpClsgICAgMy45Nzc5NDJdIHNzYjogQ29yZSAxIGZvdW5kOiBJRUVFIDgwMi4xMSAoY2Mg
MHg4MTIsIHJldiAweDA1LAp2ZW5kb3IgMHg0MjQzKQpbICAgIDMuOTc3OTUyXSBzc2I6IENvcmUg
MiBmb3VuZDogUENNQ0lBIChjYyAweDgwRCwgcmV2IDB4MDIsIHZlbmRvciAweDQyNDMpClsgICAg
My45Nzc5NjJdIHNzYjogQ29yZSAzIGZvdW5kOiBWOTAgKGNjIDB4ODA3LCByZXYgMHgwMiwgdmVu
ZG9yIDB4NDI0MykKWyAgICAzLjk3Nzk3MV0gc3NiOiBDb3JlIDQgZm91bmQ6IFBDSSAoY2MgMHg4
MDQsIHJldiAweDA5LCB2ZW5kb3IgMHg0MjQzKQpbICAgIDMuOTkzOTY1XSBzc2I6IFNQUk9NIHJl
dmlzaW9uIDIgZGV0ZWN0ZWQuClsgICAgMy45OTQ4MTZdIHNzYjogU29uaWNzIFNpbGljb24gQmFj
a3BsYW5lIGZvdW5kIG9uIFBDSSBkZXZpY2UgMDAwMDowMTowNi4wCgpUaGFua3MsCiAgICAgIE1p
bGVzCg==
