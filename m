Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from edge20.ethz.ch ([82.130.99.26]:25079 "EHLO edge20.ethz.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753201AbaC3LnP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Mar 2014 07:43:15 -0400
Date: Sun, 30 Mar 2014 13:37:02 +0200
Subject: Re: tx_retries and tx_failures on iwlwifi
From: Daniel Sim <simd@student.ethz.ch>
To: Emmanuel Grumbach <egrumbach@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	" ilw@linux.intel.com" <ilw@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-ID: <fe413605-8f49-491e-87f2-7bfd1c90ef66@CAS20.d.ethz.ch> (sfid-20140330_134319_239434_B675596F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgRW1tYW51ZWwsCgo+Cj4gVGhlIGRlZmF1bHQgbnVtYmVyIG9mIHJldHJpZXMgaXMgMTYuIFRo
ZSByZWFzb24geW91IGhhdmUgb2RkIG51bWJlcnMgCj4gaXMgYmVjYXVzZSB3ZSBkb24ndCByZXBv
cnQgdGhpcyBwcm9wZXJseS4gVGhlIGJpZyBwcm9ibGVtIGlzIGFib3V0IAo+IEFNUERVIG1haW5s
eSAtIHRoZSBmcmFtZXMgYXJlIHBpY2tlZCB1cCBieSB0aGUgSFcgYW5kIHJldHJhbnNtaXNzaW9u
cyAKPiBhcmUgaGFuZGxlZCBieSB0aGUgRlcgLyBIVy4gV2hpbGUgd2Uga25vdyBob3cgbWFueSBw
YWNrZXRzIGZhaWxlZCB2cy4gCj4gaG93IG1hbnkgd2VyZSBzZW50IChmb3IgcmF0ZSBjb250cm9s
IHB1cnBvc2VzKSwgd2UgY2FuJ3Qga25vdyBleGFjdGx5IAo+IHdoYXQgZnJhbWUgd2UgcmV0cmFu
c21pdHRlZCBhbmQgaG93IG1hbnkgdGltZXMgKHdlbGwuLi4gd2UgY2FuIC0gYnV0IAo+IGl0IGlz
IG5vdCB0cml2aWFsKS4gU2luY2UgdGhlIHRoZSBvbmx5IHdheSB0byB0ZWxsIG1hYzgwMjExIC8g
Y2ZnODAyMTEgCj4gLyBpdyBpcyBwZXItcGFja2V0IChpbiBpZWVlODAyMTFfdHhfc3RhdHVzIGlu
IGVhY2ggVHggc3RhdHVzIGZvciBlYWNoIAo+IHBhY2tldCksIHRoZSBpbmZvcm1hdGlvbiB0aGVy
ZSBpcyBub3QgYWNjdXJhdGUuIAo+Cj4gSSB3YW50IHRvIGhvcGUgdGhhdCBpZiB5b3UgZGlzYWJs
ZWQgQU1QRFUgKFR4KSB5b3UnbGwgZ2V0IG1vcmUgCj4gYWNjdXJhdGUgcmVzdWx0cyAtIEkgaGF2
ZW4ndCB0ZXN0ZWQgbXlzZWxmIHRob3VnaC4KCkRvZXMgdGhpcyBtZWFuIHRoYXQgaWYgQU1QRFUg
aXMgZGlzYWJsZWQsIHRoZSByZXRyYW5zbWlzc2lvbnMgd2lsbCBiZSBlaXRoZXIgaGFuZGxlZCBp
biBzb2Z0d2FyZSwgb3IgdGhlIGhhcmR3YXJlIHdpbGwgcmVwb3J0IHJldHJhbnNtaXNzaW9ucyBt
b3JlIGFjY3VyYXRlbHk/CgpIb3cgc2hvdWxkIEkgZGlzYWJsZSBBTVBEVT8KCkRhbmllbAo=

