Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cluster-d.mailcontrol.com ([85.115.60.190]:54286 "EHLO
	cluster-d.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125Ab0JAIzb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Oct 2010 04:55:31 -0400
Received: from rly47d.srv.mailcontrol.com (localhost.localdomain [127.0.0.1])
	by rly47d.srv.mailcontrol.com (MailControl) with ESMTP id o918tOir030483
	for <linux-wireless@vger.kernel.org>; Fri, 1 Oct 2010 09:55:27 +0100
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by rly47d.srv.mailcontrol.com (MailControl) id o918tBtT029052
	for <linux-wireless@vger.kernel.org>; Fri, 1 Oct 2010 09:55:11 +0100
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Subject: RE: [ath9k-devel] Modulation schemes on ath9k
Date: Fri, 1 Oct 2010 09:55:08 +0100
Message-ID: <9D3ED2EB2589B641B6CCA9F529CAA6A2FC557D@exbe12.nasstar-t1.net>
References: <9D3ED2EB2589B641B6CCA9F529CAA6A2F258CB@exbe12.nasstar-t1.net> <AANLkTi=aBPTYZB62Jup4=10_D2wxEgVaBormJcZb6qyT@mail.gmail.com> <9D3ED2EB2589B641B6CCA9F529CAA6A2FC5433@exbe12.nasstar-t1.net> <AANLkTinAnawV3JThYNdovcBY4HaUOH-Sydwi1JKKoz+W@mail.gmail.com> <1285868215.5137.6.camel@jlt3.sipsolutions.net>
From: "Mike Pithouse" <mike.pithouse@vegastream.com>
To: "Johannes Berg" <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T0suDQoNCklzIHRoZXJlIGFueSBvdGhlciB3YXkgdG8gYWNoaWV2ZSB0aGlzPyAgSSBuZWVkIHRv
IGRvIHNvbWUgdGVzdGluZyBmb3IgZWFjaCBNQ1MgaW5kZXguICBJdCBkb2Vzbid0IG5lZWQgdG8g
YmUgZWxlZ2FudCEgIFdlIGNhbiBjb2RlIHNvbWV0aGluZyB1cCBpZiB3ZSBoYXZlIHNvbWUgcG9p
bnRlcnMuDQoNCkNoZWVycywgTWlrZS4NCg0KDQoNCi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0t
DQpGcm9tOiBKb2hhbm5lcyBCZXJnIFttYWlsdG86am9oYW5uZXNAc2lwc29sdXRpb25zLm5ldF0g
DQpTZW50OiAzMCBTZXB0ZW1iZXIgMjAxMCAxODozNw0KVG86IEx1aXMgUi4gUm9kcmlndWV6DQpD
YzogTWlrZSBQaXRob3VzZTsgYXRoOWstZGV2ZWxAdmVuZW1hLmg0Y2tyLm5ldDsgbGludXgtd2ly
ZWxlc3MNClN1YmplY3Q6IFJlOiBbYXRoOWstZGV2ZWxdIE1vZHVsYXRpb24gc2NoZW1lcyBvbiBh
dGg5aw0KDQpPbiBUaHUsIDIwMTAtMDktMzAgYXQgMTA6MzMgLTA3MDAsIEx1aXMgUi4gUm9kcmln
dWV6IHdyb3RlOg0KPiBPbiBUaHUsIFNlcCAzMCwgMjAxMCBhdCAxMDoyNiBBTSwgTWlrZSBQaXRo
b3VzZQ0KPiA8bWlrZS5waXRob3VzZUB2ZWdhc3RyZWFtLmNvbT4gd3JvdGU6DQo+ID4gSnVzdCB0
aGUgdGlja2V0IC0gdGhhbmsgeW91Lg0KPiA+DQo+ID4gSSBzZWUgdGhlcmUncyBjdXJyZW50bHkg
c29tZSAnaW5hY3RpdmUnIGNvZGUgdGhhdCB3aWxsIGFsbG93IHRoZSBzYW1lIGNvbW1hbmQgdG8g
YmUgdXNlZCB0byBzZXQgdGhlIE1DUyBpbmRleC4NCj4gPg0KPiA+IERvIHlvdSBrbm93IHdoZW4v
aWYgdGhpcyBjb2RlIHdpbGwgYmUgYXZhaWxhYmxlPyAgQWx0ZXJuYXRpdmVseSwgaXMgdGhlcmUg
YW5vdGhlciBtZXRob2QgY3VycmVudGx5IGF2YWlsYWJsZSB0byBzZXQgTUNTIGluZGV4Pw0KPiAN
Cj4gSm9oYW5uZXMsIGlzIHRoaXMgYSBUT0RPIHN0aWxsPw0KDQpZb3UgY2FuIG9ubHkgZG8gbGVn
YWN5IHJpZ2h0IG5vdywgd2UgZG9uJ3QgaGF2ZSB0aGUNCm5sODAyMTEvY2ZnODAyMTEvbWFjODAy
MTEgaW5mcmFzdHJ1Y3R1cmUgaW4gcGxhY2UgZm9yIGl0IGF0IHRoaXMgcG9pbnQuDQoNCmpvaGFu
bmVzDQoNCg==
