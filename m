Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:58238 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804AbYKLWme (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2008 17:42:34 -0500
Received: by yw-out-2324.google.com with SMTP id 9so307419ywe.1
        for <linux-wireless@vger.kernel.org>; Wed, 12 Nov 2008 14:42:33 -0800 (PST)
Message-ID: <43e72e890811121432k2ffd1902p665df2a11cf3b3d7@mail.gmail.com> (sfid-20081112_234238_369097_F6456CCF)
Date: Wed, 12 Nov 2008 14:32:31 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "=?UTF-8?Q?Stefanik_G=C3=A1bor?=" <netrolller.3d@gmail.com>
Subject: Re: libertas_tf should replace libertas_usb on compat-wireless?
Cc: "Andrey Yurovsky" <andrey@cozybit.com>,
	"Luis Rodriguez" <Luis.Rodriguez@atheros.com>,
	"Dan Williams" <dcbw@redhat.com>,
	"David Woodhouse" <dwmw2@infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis Carlos Cobo" <luisca@cozybit.com>
In-Reply-To: <69e28c910811121429y298158e0i59c39f50fb9b4bc8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <43e72e890811111632x2c641d2cmeb69c0a0ea95382e@mail.gmail.com>
	 <1226505205.13536.13.camel@localhost.localdomain>
	 <1226512649.3940.0.camel@localhost.localdomain>
	 <20081112195515.GA15803@tesla>
	 <45e8e6c40811121307v32ca4c2cq77714ff14bec4563@mail.gmail.com>
	 <69e28c910811121316i285ec2dbr7acf6c3fe660536a@mail.gmail.com>
	 <20081112222758.GB15803@tesla>
	 <69e28c910811121429y298158e0i59c39f50fb9b4bc8@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gV2VkLCBOb3YgMTIsIDIwMDggYXQgMjoyOSBQTSwgU3RlZmFuaWsgR8OhYm9yIDxuZXRyb2xs
bGVyLjNkQGdtYWlsLmNvbT4gd3JvdGU6Cj4gT24gV2VkLCBOb3YgMTIsIDIwMDggYXQgMTE6Mjcg
UE0sIEx1aXMgUi4gUm9kcmlndWV6Cj4gPGxyb2RyaWd1ZXpAYXRoZXJvcy5jb20+IHdyb3RlOgo+
PiBPbiBXZWQsIE5vdiAxMiwgMjAwOCBhdCAwMToxNjozNlBNIC0wODAwLCBTdGVmYW5payBHw6Fi
b3Igd3JvdGU6Cj4+PiBPbiBXZWQsIE5vdiAxMiwgMjAwOCBhdCAxMDowNyBQTSwgQW5kcmV5IFl1
cm92c2t5IDxhbmRyZXlAY296eWJpdC5jb20+IHdyb3RlOgo+Pj4gPiBsaWJlcnRhc190ZiBpcyBh
IHNvZnRtYWMgZHJpdmVyIGRldmVsb3BlZCBtYWlubHkgc28gdGhhdCBYTydzIGNhbiBydW4KPj4+
ID4gaG9zdGFwZCBhbmQgdGhlIGxpa2UuICBsaWJlcnRhcyBpcyB0aGUgZ2VuZXJhbCAoZnVsbG1h
YykgZHJpdmVyIGFuZCwKPj4+ID4gaW4gbXkgb3Bpbmlvbiwgc2hvdWxkIGJlIHRoZSBvbmUgdXNl
cnMgZ2V0IHVubGVzcyB0aGV5IHNwZWNpZmljYWxseQo+Pj4gPiB3YW50ZWQgbGliZXJ0YXNfdGYg
YmVjYXVzZSB0aGV5J3JlIGV4cGVyaW1lbnRpbmcgd2l0aCBBUCBtb2RlIG9yIG90aGVyCj4+PiA+
IG1hYzgwMjExIGZlYXR1cmVzLiAgU28gSSBndWVzcyBJJ2Qgdm90ZSBmb3IgbGliZXJ0YXMgb3Zl
ciBsaWJlcnRhc190Zgo+Pj4gPiBhdCB0aGlzIHRpbWUsIGZvciB3aGF0IGl0J3Mgd29ydGguCj4+
PiA+Cj4+PiA+ICAtQW5kcmV5Cj4+Pgo+Pj4gSSB0aGluayBsaWJlcnRhc191c2Igc2hvdWxkIGJl
IGEgZGVmYXVsdCAoYXMgaXQncyBIVyBhY2NlbGVyYXRlZCksIGJ1dAo+Pj4gbGliZXJ0YXNfdGYg
c2hvdWxkIGJlIGluY2x1ZGVkIGFzIGFuIG9wdGlvbiAoZGlzYWJsZWQgYnkgZGVmYXVsdCBpbgo+
Pj4gY29uZmlnLm1rLCBvciBhdXRvLWFkZGVkIHRvIC9ldGMvbW9kcHJvYmUuZC9ibGFja2xpc3Qg
dXBvbiBtYWtlCj4+PiBpbnN0YWxsKS4KPj4KPj4gT0sgc28gSSd2ZSBkb25lIHRoaXMgb24gY29u
ZmlnLm1rOgo+Pgo+PiBpZm5lcSAoJChDT05GSUdfVVNCKSwpCj4+IGlmbmVxICgkKENPTkZJR19M
SUJFUlRBU19USElORklSTV9VU0IpLG0pCj4+IENPTkZJR19MSUJFUlRBU19VU0I9bQo+PiBORUVE
X0xJQkVSVEFTPXkKPj4gZW5kaWYKPj4gZW5kaWYKPj4KPj4gVGhpcyBtZWFucyB5b3UnbGwgZ2V0
IENPTkZJR19MSUJFUlRBU19VU0IgdW5sZXNzIHlvdXIga2VybmVsCj4+IGFscmVhZHkgd2FzIGJ1
aWx0IHdpdGggQ09ORklHX0xJQkVSVEFTX1RISU5GSVJNX1VTQiBmb3IgYWxsIHRob3NlCj4+IGJ1
aWxkaW5nIHdpdGggaXQuIElmIHlvdXIga2VybmVsIHdhcyBidWlsdCB3aXRoIGJvdGggdGhlbiBp
dHMgeW91cgo+PiBwcm9ibGVtLgo+Pgo+PiAgTHVpcwo+Pgo+Cj4gSWYgdGhlIGtlcm5lbCBoYXMg
Ym90aCwgY29tcGF0LXdpcmVsZXNzIHNob3VsZCBhbHNvIGJ1aWxkIGJvdGguCgpUaGUga2VybmVs
IGhhcyBib3RoLCBjb21wYXQtd2lyZWxlc3MgaGFzIGJvdGggYnV0IHdlIHJlc3BlY3QgeW91cgpr
ZXJuZWwgLmNvbmZpZyB1bmxlc3Mgd2Uga25vdyBiZXR0ZXIgKHdlIHBpY2tlZCBiNDMgb3ZlciBi
Y200M3h4CmJlZm9yZSkuIEluIHRoaXMgY2FzZSB3ZSBkb24ndCB3YW50IHRvIHByZWZlciBvbmUg
b3ZlciB0aGUgb3RoZXIgc28gd2UKc2ltcGx5IHN0aWNrIHRvIHRoZSBkZWNpc2lvbiBvZiB3aG9l
dmVyIGJ1aWx0IHlvdXIga2VybmVsLgoKICBMdWlzCg==
