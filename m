Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cluster-f.mailcontrol.com ([85.115.62.190]:60030 "EHLO
	cluster-f.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab0JDQgV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 12:36:21 -0400
Received: from rly29f.srv.mailcontrol.com (localhost.localdomain [127.0.0.1])
	by rly29f.srv.mailcontrol.com (MailControl) with ESMTP id o94FgAp1010712
	for <linux-wireless@vger.kernel.org>; Mon, 4 Oct 2010 16:42:15 +0100
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by rly29f.srv.mailcontrol.com (MailControl) id o94FfiBM007430
	for <linux-wireless@vger.kernel.org>; Mon, 4 Oct 2010 16:41:44 +0100
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Subject: RE: [ath9k-devel] Modulation schemes on ath9k
Date: Mon, 4 Oct 2010 16:41:21 +0100
Message-ID: <9D3ED2EB2589B641B6CCA9F529CAA6A201018E47@exbe12.nasstar-t1.net>
References: <9D3ED2EB2589B641B6CCA9F529CAA6A2F258CB@exbe12.nasstar-t1.net> <AANLkTi=aBPTYZB62Jup4=10_D2wxEgVaBormJcZb6qyT@mail.gmail.com> <9D3ED2EB2589B641B6CCA9F529CAA6A2FC5433@exbe12.nasstar-t1.net> <AANLkTinAnawV3JThYNdovcBY4HaUOH-Sydwi1JKKoz+W@mail.gmail.com> <1285868215.5137.6.camel@jlt3.sipsolutions.net> 
From: "Mike Pithouse" <mike.pithouse@vegastream.com>
To: "Johannes Berg" <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGksDQoNCklzIGFueW9uZSBhYmxlIHRvIGNvbmZpcm0gd2hldGhlciBvciBub3QgaXQncyBwb3Nz
aWJsZSAoYnkgYW55IG1lYW5zKSB0byBzZXQgdGhlIE1DUyBJbmRleCBmb3IgYW4gYXRoOWsgQWNj
ZXNzIFBvaW50Pw0KDQpUaGFua3MsIE1pa2UuDQoNCg0KLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0t
LS0NCkZyb206IE1pa2UgUGl0aG91c2UgDQpTZW50OiAwMSBPY3RvYmVyIDIwMTAgMDk6NTUNClRv
OiAnSm9oYW5uZXMgQmVyZyc7IEx1aXMgUi4gUm9kcmlndWV6DQpDYzogYXRoOWstZGV2ZWxAdmVu
ZW1hLmg0Y2tyLm5ldDsgbGludXgtd2lyZWxlc3MNClN1YmplY3Q6IFJFOiBbYXRoOWstZGV2ZWxd
IE1vZHVsYXRpb24gc2NoZW1lcyBvbiBhdGg5aw0KDQpPSy4NCg0KSXMgdGhlcmUgYW55IG90aGVy
IHdheSB0byBhY2hpZXZlIHRoaXM/ICBJIG5lZWQgdG8gZG8gc29tZSB0ZXN0aW5nIGZvciBlYWNo
IE1DUyBpbmRleC4gIEl0IGRvZXNuJ3QgbmVlZCB0byBiZSBlbGVnYW50ISAgV2UgY2FuIGNvZGUg
c29tZXRoaW5nIHVwIGlmIHdlIGhhdmUgc29tZSBwb2ludGVycy4NCg0KQ2hlZXJzLCBNaWtlLg0K
DQoNCg0KLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IEpvaGFubmVzIEJlcmcgW21h
aWx0bzpqb2hhbm5lc0BzaXBzb2x1dGlvbnMubmV0XSANClNlbnQ6IDMwIFNlcHRlbWJlciAyMDEw
IDE4OjM3DQpUbzogTHVpcyBSLiBSb2RyaWd1ZXoNCkNjOiBNaWtlIFBpdGhvdXNlOyBhdGg5ay1k
ZXZlbEB2ZW5lbWEuaDRja3IubmV0OyBsaW51eC13aXJlbGVzcw0KU3ViamVjdDogUmU6IFthdGg5
ay1kZXZlbF0gTW9kdWxhdGlvbiBzY2hlbWVzIG9uIGF0aDlrDQoNCk9uIFRodSwgMjAxMC0wOS0z
MCBhdCAxMDozMyAtMDcwMCwgTHVpcyBSLiBSb2RyaWd1ZXogd3JvdGU6DQo+IE9uIFRodSwgU2Vw
IDMwLCAyMDEwIGF0IDEwOjI2IEFNLCBNaWtlIFBpdGhvdXNlDQo+IDxtaWtlLnBpdGhvdXNlQHZl
Z2FzdHJlYW0uY29tPiB3cm90ZToNCj4gPiBKdXN0IHRoZSB0aWNrZXQgLSB0aGFuayB5b3UuDQo+
ID4NCj4gPiBJIHNlZSB0aGVyZSdzIGN1cnJlbnRseSBzb21lICdpbmFjdGl2ZScgY29kZSB0aGF0
IHdpbGwgYWxsb3cgdGhlIHNhbWUgY29tbWFuZCB0byBiZSB1c2VkIHRvIHNldCB0aGUgTUNTIGlu
ZGV4Lg0KPiA+DQo+ID4gRG8geW91IGtub3cgd2hlbi9pZiB0aGlzIGNvZGUgd2lsbCBiZSBhdmFp
bGFibGU/ICBBbHRlcm5hdGl2ZWx5LCBpcyB0aGVyZSBhbm90aGVyIG1ldGhvZCBjdXJyZW50bHkg
YXZhaWxhYmxlIHRvIHNldCBNQ1MgaW5kZXg/DQo+IA0KPiBKb2hhbm5lcywgaXMgdGhpcyBhIFRP
RE8gc3RpbGw/DQoNCllvdSBjYW4gb25seSBkbyBsZWdhY3kgcmlnaHQgbm93LCB3ZSBkb24ndCBo
YXZlIHRoZQ0Kbmw4MDIxMS9jZmc4MDIxMS9tYWM4MDIxMSBpbmZyYXN0cnVjdHVyZSBpbiBwbGFj
ZSBmb3IgaXQgYXQgdGhpcyBwb2ludC4NCg0Kam9oYW5uZXMNCg0K
