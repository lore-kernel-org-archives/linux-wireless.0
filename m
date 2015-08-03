Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:49447 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752143AbbHCL0z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2015 07:26:55 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Paul Stewart <pstew@chromium.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Cathy Luo <cluo@marvell.com>, Jeff CF Chen <jeffc@marvell.com>
Subject: RE: [PATCH 3/3] mwifiex:fix unable to connect hidden SSID AP on DFS
 channel
Date: Mon, 3 Aug 2015 11:26:52 +0000
Message-ID: <24342112f03841139892d7c2388afe1e@SC-EXCH04.marvell.com> (sfid-20150803_132658_660421_A973B3FE)
References: <1438352271-31827-1-git-send-email-akarwar@marvell.com>
 <CAMcMvshXwBPH-j0-DLAaRkRnbnvnu+tC9z-PAyAwSjRc139mCQ@mail.gmail.com>
In-Reply-To: <CAMcMvshXwBPH-j0-DLAaRkRnbnvnu+tC9z-PAyAwSjRc139mCQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgUGF1bCwNCg0KPiA+ICsgICAgICAgaW50IHJldDsNCj4gPiArICAgICAgIGludCBjaGlkOw0K
PiA+ICsgICAgICAgdTggbnVsbF9zc2lkW0lFRUU4MDIxMV9NQVhfU1NJRF9MRU5dID0gezB9Ow0K
PiANCj4gQWxhcywgdGhpcyBpcyBub3QgdGhlIG9ubHkgZm9ybSBvZiAiaGlkZGVuIFNTSUQiLiAg
VGhpcyBiZWhhdmlvciBpcyBub3QNCj4gc3RhbmRhcmRpemVkLiAgWW91IG5lZWQgdG8gZWl0aGVy
IGV4cGFuZCB5b3VyIHNlYXJjaCB0byBvdGhlciBoaWRkZW4NCj4gU1NJRCBzaWduYXR1cmVzICh6
ZXJvLWxlbmd0aCBTU0lELCBhbGwtbnVsbHMtdXAtdG8tbGVuZ3RoIFNTSUQpLCBvcg0KPiB0aGlu
ayBhYm91dCB0dXJuaW5nIHRoaXMgYmVoYXZpb3Igb24gaWYgeW91IGdldCBhbnkgc2NhbiByZXN1
bHRzIGF0IGFsbC4NCj4gDQoNClRoYW5rcyBmb3IgeW91ciByZXZpZXcuDQpXZSB3aWxsIHVwZGF0
ZSB0aGUgY29kZSB0byBjaGVjayBmb3IgYm90aCB6ZXJvLWxlbmd0aCBTU0lEIGFzIHdlbGwgYXMg
YWxsLW51bGxzLXVwLXRvLWxlbmd0aCBTU0lELg0KDQpSZWdhcmRzLA0KQW1pdGt1bWFyDQo=
