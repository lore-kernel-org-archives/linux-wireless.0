Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:7763 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458AbYKGAb5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2008 19:31:57 -0500
Received: by yw-out-2324.google.com with SMTP id 9so368639ywe.1
        for <linux-wireless@vger.kernel.org>; Thu, 06 Nov 2008 16:31:55 -0800 (PST)
Message-ID: <43e72e890811061631rafe44acr7b2ca0137b555bab@mail.gmail.com> (sfid-20081107_013200_850363_A791BFAA)
Date: Thu, 6 Nov 2008 16:31:51 -0800
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Benoit PAPILLAULT" <benoit.papillault@free.fr>
Subject: Re: [PATCH] ath9k : Display MAC/BB and RF version at startup
Cc: "Kalle Valo" <kalle.valo@nokia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890811061628v2858a86s172afa0a1e6c5257@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <490F63B6.8080600@free.fr> <878ws0ar2u.fsf@nokia.com>
	 <20081105030223.GD16413@tesla> <49119C3D.1060406@free.fr>
	 <43e72e890811061628v2858a86s172afa0a1e6c5257@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gVGh1LCBOb3YgNiwgMjAwOCBhdCA0OjI4IFBNLCBMdWlzIFIuIFJvZHJpZ3Vlego8bHJvZHJp
Z3VlekBhdGhlcm9zLmNvbT4gd3JvdGU6Cj4gT24gV2VkLCBOb3YgNSwgMjAwOCBhdCA1OjE0IEFN
LCBCZW5vaXQgUEFQSUxMQVVMVAo+IDxiZW5vaXQucGFwaWxsYXVsdEBmcmVlLmZyPiB3cm90ZToK
Pj4gLS0tLS1CRUdJTiBQR1AgU0lHTkVEIE1FU1NBR0UtLS0tLQo+PiBIYXNoOiBTSEExCj4+Cj4+
IEx1aXMgUi4gUm9kcmlndWV6IGEgw6ljcml0IDoKPj4+PiBJIHJlY29tbWVuZCBhZGRpbmcgYSBz
ZXBhcmF0ZSBmdW5jdGlvbiByZXR1cm5pbmcgdGhlIHN0cmluZyBpbnN0ZWFkIG9mCj4+Pj4gdGhp
cyB1Z2x5ICIlcyVzJXMlcyIgdHJpY2suIE11Y2ggY2xlYW5lciB0aGF0IHdheS4KPj4KPj4gSSdt
IGdvaW5nIHRvIHNlbmQgYW4gdXBkYXRlZCBwYXRjaC4KPj4KPj4+Cj4+PiBBZ3JlZWQsIGFsc28g
cGxlYXNlIHJlbW92ZSAzeDMgY29tbWVudCBhcyB3ZSBkb24ndCBoYXZlIHN1cHBvcnQgZm9yCj4+
PiB0aG9zZSB5ZXQgbm9yIGRvIEkgZXZlbiBoYXZlIGhhcmR3YXJlIGZvciBpdC4gVG8gYmUgY2xl
YXIgYXRoOWsgc3VwcG9ydHMKPj4+IDJ4MiByaWdodCBub3cuIDopCj4+Cj4+IEh1bW1tLi4uIFRo
aXMgaXMgd2hhdCB0aGUgQXRoZXJvcyB3ZWIgc2l0ZSBzYXlzIGFuZCBJIGhhdmUgMyBhbnRlbm5h
cwo+PiAodmVyeSBuaWNlIGNvbm5lY3RvciBmcm9tIFVCTlQgYnR3KS4gT2YgY291cnNlLCBpIGRv
bid0IGtub3cgaWYgaXQgaXMKPj4gc3VwcG9ydGVkIGJ5IHRoZSBkcml2ZXIsIGJ1dCBhdCBsZWFz
dCwgSSB0aGluaywgaXQncyBzdXBwb3J0ZWQgYnkgdGhlCj4+IGhhcmR3YXJlLgo+Pgo+PiBSZWZl
cmVuY2UgOiBodHRwOi8vd3d3LmF0aGVyb3MuY29tL3B0L0FSOTAwMUFQLTNOWDIuaHRtCj4KPiBU
aGFua3MgZm9yIHRoaXMsIEkgcmV2aWV3ZWQgdGhpcyBub3cgYW5kIHlvdSBhcmUgY29ycmVjdCwg
SSB3YXMKPiBjb21wbGV0ZWx5IG1pc3Rha2luZyB0aGUgbnVtYmVyIG9mIHN0cmVhbXMgd2l0aCB0
aGUgbnVtYmVyIG9mIGNoYWlucy4KPiAzeDMgbWVhbnMgbnVtYmVyIG9mIFRYL1JYIGNoYWlucywg
dGhlc2UgZGV2aWNlcyBob3dldmVyIHN0aWxsIG9ubHkKPiBzdXBwb3J0IDIgc3RyZWFtcyB3aGlj
aCBtZWFuIG1heCB0aGVvcmV0aWNhbCB0aHJvdWdocHV0IGlzIHN0aWxsIDMwMAo+IE1icHMuIFNv
IDN4MyB3YXMgY29ycmVjdCwgYXBvbG9naWVzIGZvciB0aGUgbWlzY29tbXVuaWNhdGlvbiB0aGVy
ZS4KCk9uIEhUNDAgOikgYWxzbyBJIHVwZGF0ZWQgdGhlIGRvYyBoZXJlOgoKaHR0cDovL3dpcmVs
ZXNzLmtlcm5lbC5vcmcvZW4vZGV2ZWxvcGVycy9Eb2N1bWVudGF0aW9uL2llZWU4MDIxMS84MDIu
MTFuCgogIEx1aXMK
