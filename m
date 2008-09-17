Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.190]:2468 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450AbYIQWDJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Sep 2008 18:03:09 -0400
Received: by rn-out-0910.google.com with SMTP id k40so2013182rnd.17
        for <linux-wireless@vger.kernel.org>; Wed, 17 Sep 2008 15:03:07 -0700 (PDT)
Message-ID: <43e72e890809171503i50bd86d5h5adef88f6214ef27@mail.gmail.com> (sfid-20080918_000314_825265_7B54176E)
Date: Wed, 17 Sep 2008 15:03:07 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "=?UTF-8?Q?Stefanik_G=C3=A1bor?=" <netrolller.3d@gmail.com>
Subject: Re: iw packaging
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Davide Pesavento" <davidepesa@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <69e28c910809171458q70763189lde2e2710c64fc70c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1221596962.9262.12.camel@johannes.berg>
	 <48D0E463.70008@le-vert.net> <1221649638.9262.50.camel@johannes.berg>
	 <48D0E5CE.8050401@le-vert.net>
	 <1221650286.9262.57.camel@johannes.berg>
	 <69e28c910809171319r30d763cse24744a198e41f92@mail.gmail.com>
	 <1221683467.7412.6.camel@localhost>
	 <2da21fe50809171446y56cd5b2ctc864650be6030621@mail.gmail.com>
	 <1221688366.7412.13.camel@localhost>
	 <69e28c910809171458q70763189lde2e2710c64fc70c@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gV2VkLCBTZXAgMTcsIDIwMDggYXQgMjo1OCBQTSwgU3RlZmFuaWsgR8OhYm9yIDxuZXRyb2xs
bGVyLjNkQGdtYWlsLmNvbT4gd3JvdGU6Cj4gT24gV2VkLCBTZXAgMTcsIDIwMDggYXQgMTE6NTIg
UE0sIEpvaGFubmVzIEJlcmcKPiA8am9oYW5uZXNAc2lwc29sdXRpb25zLm5ldD4gd3JvdGU6Cj4+
IE9uIFdlZCwgMjAwOC0wOS0xNyBhdCAyMzo0NiArMDIwMCwgRGF2aWRlIFBlc2F2ZW50byB3cm90
ZToKPj4+ICQgbWFrZQo+Pj4gIEdFTiAgdmVyc2lvbi5oCj4+PiAgQ0MgICBpdy5vCj4+PiAgQ0Mg
ICBpbmZvLm8KPj4+IGluZm8uYzogSW4gZnVuY3Rpb24gJ3ByaW50X3BoeV9oYW5kbGVyJzoKPj4+
IGluZm8uYzoxMDg6IGVycm9yOiAnTkw4MDIxMV9BVFRSX1NVUFBPUlRFRF9JRlRZUEVTJyB1bmRl
Y2xhcmVkIChmaXJzdAo+Pj4gdXNlIGluIHRoaXMgZnVuY3Rpb24pCj4+PiBpbmZvLmM6MTA4OiBl
cnJvcjogKEVhY2ggdW5kZWNsYXJlZCBpZGVudGlmaWVyIGlzIHJlcG9ydGVkIG9ubHkgb25jZQo+
Pj4gaW5mby5jOjEwODogZXJyb3I6IGZvciBlYWNoIGZ1bmN0aW9uIGl0IGFwcGVhcnMgaW4uKQo+
Pj4gbWFrZTogKioqIFtpbmZvLm9dIEVycm9yIDEKPj4+Cj4+PiBJIGd1ZXNzIEkgaGF2ZSB0byBi
dWlsZCBpdyBhZ2FpbnN0ID49Mi42LjI3LXJjWCBrZXJuZWwgaGVhZGVycywgcmlnaHQ/Cj4+Cj4+
IEFjdHVhbGx5IHRoaXMgb25lIGlzIG5ldyBpbiB3aXJlbGVzcy10ZXN0aW5nLCBJIGhhdmUgYSBi
cmFuY2ggeW91IGNhbgo+PiBidWlsZCBhZ2FpbnN0IDIuNi4yNyBidXQgaXQncyBub3QgdmVyeSB1
cC10by1kYXRlLgo+Pgo+PiBBbnkgaWRlYXMgaG93IHRvIGhhbmRsZSB0aGlzIGFyZSB3ZWxjb21l
LiBTaG91bGQgaXQganVzdCBzaGlwIHRoZSBoZWFkZXIKPj4gZmlsZT8gSSdkIHByZWZlciBub3Qg
dG8sIG90b2ggZG9pbmcgaXQgaXNuJ3QgcmVhbGx5IGhhcm1mdWwgYmVjYXVzZSB3aGVuCj4+IGFk
ZGluZyBhIG5ldyBjb21tYW5kIGNsZWFybHkgeW91IG5lZWQgdG8gZWRpdCBpdyBzb3VyY2VzLgo+
Pgo+PiBqb2hhbm5lcwo+Pgo+Pgo+Cj4gSU1PIHRoYXQncyB0aGUgYmVzdCB0aGluZyB0byBkbyAt
IGluIGZhY3QsIHRoYXQncyBleGFjdGx5IHdoeSBJCj4gYnJhbmNoZWQuIERpc3Ryb3MgbGlrZWx5
IHdvbid0IHNoaXAga2VybmVsIGhlYWRlcnMgdGhhdCBkb24ndCBtYXRjaAo+IHRoZSBrZXJuZWwg
YmluYXJpZXMgYW5kIHNvdXJjZXMuIChUaGlzIGlzIGxpa2VseSB3aHkgRGViaWFuIGlzCj4gc2hp
cHBpbmcgbXkgYnJhbmNoZWQgdmVyc2lvbiwgcmF0aGVyIHRoYW4gdGhlIG9mZmljaWFsLikKClBl
b3BsZSB3YW50aW5nIHRvIHRlc3QgYmxlZWRpbmcgZWRnZSBhbmQgbm90IGNvbXBpbGUgdGhlaXIg
b3duIGtlcm5lbApzaW1wbHkgY2FuIHVzZSBjb21wYXQtd2lyZWxlc3MgY3JhcCBhbmQgdGhhdCBo
YXMgaXRzIG93biBubDgwMjExLmguIFdlCmNhbiBtb2RpZnkgaXcgdG8gbGV0IENPTVBBVF9UUkVF
IGJlIGRlZmluZWQgYW5kIGlmIHNvIGxvb2sgdGhlcmUKZmlyc3QuIFRoaXMgaXMgd2hhdCBDUkRB
IGRvZXMgZm9yIGV4YW1wbGUuCgpJIGRvbid0IHNlZSB3aHkgcGFja2FnZXMgc2hvdWxkIHNoaXAg
dGhlaXIgb3duIG5sODAyMTEuaCB1bmxlc3MgeW91CmFyZSByZXBsYWNpbmcgb3IgcHJvdmlkaW5n
IGEgbmV3IGNmZzgwMjExLmtvLgoKICBMdWlzCg==
