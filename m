Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:45770 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088Ab3LTIQD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Dec 2013 03:16:03 -0500
From: "BAHINI, Henri" <hbahini@qca.qualcomm.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	"Chauhan, Rajesh" <rajeshc@qca.qualcomm.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Malinen, Jouni" <jouni@qca.qualcomm.com>,
	"Johnson, Jeff" <jjohnson@qca.qualcomm.com>,
	"Chang, Leo" <schang@qca.qualcomm.com>,
	"Luo, Xun" <xunl@qca.qualcomm.com>,
	"Thalappil, Sameer" <sameert@qca.qualcomm.com>,
	"Hussain, Arif" <c_arifh@qca.qualcomm.com>
Subject: RE: [PATCHv3] cfg80211: add support for frequency interference event
Date: Fri, 20 Dec 2013 08:16:01 +0000
Message-ID: <8AC12462F1AA0E4EA8FEB46307AAD6F650AAB068@nasanexd02f.na.qualcomm.com> (sfid-20131220_091607_877284_86DB31BB)
References: <1384198356-427-1-git-send-email-rajeshc@qca.qualcomm.com>
 <1386077130.4393.21.camel@jlt4.sipsolutions.net>
 <CAB=NE6Xa-bdLQm8uAg9wCE0fdp4KPBZ46d5FHVHp6wCvN5=dUA@mail.gmail.com>
 <1386145204.4284.4.camel@jlt4.sipsolutions.net>
 <1386145241.4284.5.camel@jlt4.sipsolutions.net>
 <D19FD2B13A40CD4B8DA64DB9B8F112E93E5CF51C@nasanexd01a.na.qualcomm.com>
 <CAB=NE6VNZDwGj4WWkgCmWxs_xLBZhXn44vo0TEdqo84xsRbZ2Q@mail.gmail.com>
In-Reply-To: <CAB=NE6VNZDwGj4WWkgCmWxs_xLBZhXn44vo0TEdqo84xsRbZ2Q@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

THVpcy0NCiAgQ2FuIHdlIGJlIGEgYml0IHByb2Zlc3Npb25hbCBoZXJlIGFuZCBsaW1pdCB0aGUg
ZGlzY3Vzc2lvbiB0byB0aGUgcGF0Y2ggdGhhdCB3ZSdyZSBpbnRyb2R1Y2luZy4NCiAgUmFqZXNo
IGRvZXMgbm90IGRlY2lkZSB3aGVuIHRoZSBkcml2ZXIgZ2V0cyB1cCBzdHJlYW1lZC4gQ2FuIHdl
IGdldCB0aGlzIGRpc2N1c3Npb24gb3V0c2lkZSBvZiB0aGUgY29udGV4dCBvZiB0aGlzIHBhdGNo
Pw0KDQpUaGFua3MsDQotSGVucmkgDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTog
bWNncm9mQGdtYWlsLmNvbSBbbWFpbHRvOm1jZ3JvZkBnbWFpbC5jb21dIE9uIEJlaGFsZiBPZiBM
dWlzIFIuIFJvZHJpZ3Vleg0KU2VudDogRnJpZGF5LCBEZWNlbWJlciAyMCwgMjAxMyAxMjoxMiBB
TQ0KVG86IENoYXVoYW4sIFJhamVzaA0KQ2M6IEpvaGFubmVzIEJlcmc7IGxpbnV4LXdpcmVsZXNz
OyBNYWxpbmVuLCBKb3VuaTsgQkFISU5JLCBIZW5yaTsgSm9obnNvbiwgSmVmZjsgQ2hhbmcsIExl
bzsgTHVvLCBYdW47IFRoYWxhcHBpbCwgU2FtZWVyOyBIdXNzYWluLCBBcmlmDQpTdWJqZWN0OiBS
ZTogW1BBVENIdjNdIGNmZzgwMjExOiBhZGQgc3VwcG9ydCBmb3IgZnJlcXVlbmN5IGludGVyZmVy
ZW5jZSBldmVudA0KDQpPbiBUaHUsIERlYyAxOSwgMjAxMyBhdCAxMTo0NCBQTSwgQ2hhdWhhbiwg
UmFqZXNoIDxyYWplc2hjQHFjYS5xdWFsY29tbS5jb20+IHdyb3RlOg0KPiBUaGUgQVBJIGNmZzgw
MjExX2F2b2lkX2ZyZXF1ZW5jeV9ldmVudCgpIHdoaWNoIGlzIGludHJvZHVjZWQgaW4gdGhpcyBw
YXRjaCBzaGFsbCBiZSB1c2VkIGJ5IG91ciBXTEFOIGRyaXZlciB3aGljaCBpcyBhbiBvcGVuIHNv
dXJjZSBkcml2ZXIuDQoNCkdldCB5b3VyIHNoaXQgdXBzdHJlYW0uIEZvciBmdWNrJ3Mgc2FrZS4N
Cg0KICBMdWlzDQo=
