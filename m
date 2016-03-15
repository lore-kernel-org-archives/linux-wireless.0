Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54724 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965777AbcCPMKH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2016 08:10:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1agAH6-0005cd-SF
	for linux-wireless@vger.kernel.org; Wed, 16 Mar 2016 13:10:05 +0100
Received: from host81-136-204-83.in-addr.btopenworld.com ([81.136.204.83])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 16 Mar 2016 13:10:04 +0100
Received: from roger by host81-136-204-83.in-addr.btopenworld.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 16 Mar 2016 13:10:04 +0100
To: linux-wireless@vger.kernel.org
From: Roger James <roger@beardandsandals.co.uk>
Subject: Re: The mac80211 softmac driver subsystem and handling of monitor interfaces
Date: Tue, 15 Mar 2016 16:42:47 +0000 (UTC)
Message-ID: <loom.20160315T173753-336@post.gmane.org> (sfid-20160316_131011_009953_5F5A2A5D)
References: <56E7E707.2050900@beardandsandals.co.uk>  <1458044118.2871.1.camel@sipsolutions.net>  <56E807A3.4010907@beardandsandals.co.uk>  (sfid-20160315_140130_234604_B5549BBB) <1458047286.2871.5.camel@sipsolutions.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sm9oYW5uZXMgQmVyZyA8am9oYW5uZXNALi4uPiB3cml0ZXM6Cgo+IAo+IE9uIFR1ZSwgMjAxNi0wMy0xNSBhdCAxMzowMSArMDAwMCwgUm9nZXIgSmFtZXMgd3JvdGU6Cj4gPsKgCj4gPiByb2dlciA8YXQ+IGRyYWdvbjp+L2xpbnV4LW1haW5saW5lJCBmaW5kIC4gLW5hbWUgIiouW2NoXSIgLWV4ZWMgZ3JlcCAtbsKgCj4gPiBJRUVFODAyMTFfSFdfV0FOVF9NT05JVE9SX1ZJRiB7fSBcOyAtcHJpbnQKPiA+IDE4NTE6ICogIDxhdD4gSUVFRTgwMjExX0hXX1dBTlRfTU9OSVRPUl9WSUY6IFRoZSBkcml2ZXIgd291bGQgbGlrZSB0byBiZcKgCj4gPiBpbmZvcm1lZCBvZgo+ID4gMTkyODrCoMKgwqDCoElFRUU4MDIxMV9IV19XQU5UX01PTklUT1JfVklGLAo+ID4gLi9pbmNsdWRlL25ldC9tYWM4MDIxMS5oCj4gPiAKPiA+IElzIHRoYXQgd2hhdCB5b3UgbWVhbnQuIE5vYm9keSBzZWVtcyB0byBiZSB1c2luZyBpdC4gRXZlbiBtYWM4MDIxMcKgCj4gPiBpdHNlbGYuIE9yIGFtIEkgYmVpbmcgc3R1cGlkIGFnYWluIAo+ID4gCj4gCj4gVGhlcmUgYXJlIG1hY3JvcyBnZW5lcmF0aW5nIHRoZSBjaGVja3MgYW5kIHNldHRpbmcgaXQsIHNvIHlvdSB3YW50IHRvCj4gZ3JlcCB3aXRob3V0IHRoZSBJRUVFODAyMTFfSFdfIHByZWZpeAo+IAo+IGpvaGFubmVzCj4gLS0KPiBUbyB1bnN1YnNjcmliZSBmcm9tIHRoaXMgbGlzdDogc2VuZCB0aGUgbGluZSAidW5zdWJzY3JpYmUgbGludXgtd2lyZWxlc3MiIGluCj4gdGhlIGJvZHkgb2YgYSBtZXNzYWdlIHRvIG1ham9yZG9tb0AuLi4KPiBNb3JlIG1ham9yZG9tbyBpbmZvIGF0ICBodHRwOi8vdmdlci5rZXJuZWwub3JnL21ham9yZG9tby1pbmZvLmh0bWwKPiAKPiAKClRoYW5rcyBndXlzIEkgaGF2ZSBnb3QgaXQgbm93LgoKSG93ZXZlciB0aGF0IG9ubHkgYWNjb3VudHMgZm9yIHRoZSBhdGgxMGssIGl3bGR2bSwgYW5kIGl3bG12bSBkcml2ZXJzLiBJCnJlYWxpc2UgdGhhdCB0aGVyZSBpcyBhIGxvdCBvZiBoaXN0b3J5IGhlcmUsIGJ1dCBpcyB3aGF0IHRoZSByZW1haW5pbmcKZHJpdmVycyBkb2luZyBpbiBhbnkgd2F5IGRlcHJlY2F0ZWQ/IEFsc28gY2FuIGFueW9uZSBnaXZlIG1lIGEgaGVhZHMgdXAgb24Kd2hhdCB0aGUgYXJjaGl0ZWN0dXJhbCBkaWZmZXJlbmNlIGlzIGJldHdlZW4gaG9va2luZyB0aGUgbW9uaXRvciBjb25maWcKY2hhbmdlIGFuZCBhbmQgc2V0dGluZyB0aGUgd2FudCBtb25pdG9yIGZsYWcuIElzIG9uZSB3YXkgcHJlZmVyYWJsZSB0byB0aGUKb3RoZXI/IEJvdGggc2VlbSB0byBpbmZvcm0gdGhlIGRyaXZlciB0aGF0IHRoZXJlIGlzIGEgdHJhbnNpdGlvbiBiZXR3ZWVuCmhhdmluZyBubyBtb25pdG9yIHZpcnR1YWwgaW50ZXJmYWNlcyBhbmQgaGF2aW5nIG9uZSBvciBtb3JlLgoKQ2hlZXJzLAoKUm9nZXIKCgo=

