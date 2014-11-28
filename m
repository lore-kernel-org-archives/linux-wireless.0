Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:3087 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751953AbaK1QgH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2014 11:36:07 -0500
From: Avinash Patil <patila@marvell.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Cathy Luo <cluo@marvell.com>,
	"John W. Linville" <linville@tuxdriver.com>
Date: Fri, 28 Nov 2014 08:35:52 -0800
Subject: Re: [PATCH] cfg80211: do not check for carrier during
 start_radar_detect
Message-ID: <CBACCFA0AEB13A41977475BCF3E896FC66736E7972@SC-VEXCH2.marvell.com> (sfid-20141128_173613_859011_ACFAC403)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

WWVzOyBiZWF0cyBtZSBhcyB3ZWxsLgoKVGhhdCdzIHdoeSBJIGFkZGVkIG9yaWdpbmFsIGF1dGhv
cnMgLSBTaW1vbiBhbmQgSmFudXN6LgoKLUF2aW5hc2gKCk9uIE5vdiAyOCwgMjAxNCA4OjQxIFBN
LCBKb2hhbm5lcyBCZXJnIDxqb2hhbm5lc0BzaXBzb2x1dGlvbnMubmV0PiB3cm90ZToKPgo+IE9u
IEZyaSwgMjAxNC0xMS0yOCBhdCAxNjo1OCArMDUzMCwgQXZpbmFzaCBQYXRpbCB3cm90ZToKPiA+
IFJhZGFyIGRldGVjdGlvbiBoYXBwZW5zIGJlZm9yZSBzdGFydGluZyBBUDsgc28gbmV0ZGV2IGNh
cnJpZXIgbWF5IGJlIGRvcm1hbnQKPiA+IGF0IHRoaXMgdGltZS4gUmVtb3ZlIHRoaXMgY2hlY2sg
ZnJvbSBjZmc4MDIxMV9zdGFydF9yYWRhcl9kZXRlY3Rpb24uCj4KPiBMb29rcyBmaW5lIHRvIG1l
LCBidXQgSSB3b25kZXIgaG93IGl0IGV2ZXIgd29ya2VkPwo+Cj4gam9oYW5uZXMKPgo+IC0tCj4g
VG8gdW5zdWJzY3JpYmUgZnJvbSB0aGlzIGxpc3Q6IHNlbmQgdGhlIGxpbmUgInVuc3Vic2NyaWJl
IGxpbnV4LXdpcmVsZXNzIiBpbgo+IHRoZSBib2R5IG9mIGEgbWVzc2FnZSB0byBtYWpvcmRvbW9A
dmdlci5rZXJuZWwub3JnCj4gTW9yZSBtYWpvcmRvbW8gaW5mbyBhdMKgIGh0dHA6Ly92Z2VyLmtl
cm5lbC5vcmcvbWFqb3Jkb21vLWluZm8uaHRtbAo=
