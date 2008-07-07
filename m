Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.176]:7295 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756796AbYGGVXb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jul 2008 17:23:31 -0400
Received: by wa-out-1112.google.com with SMTP id j37so1467183waf.23
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jul 2008 14:23:29 -0700 (PDT)
Message-ID: <1ba2fa240807071423n755d4e5ay81a6543be7761a92@mail.gmail.com> (sfid-20080707_232343_301240_C9065E9E)
Date: Tue, 8 Jul 2008 00:23:29 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Harvey Harrison" <harvey.harrison@gmail.com>
Subject: Re: [PATCH 1/1 V2] mac80211: Fix ieee80211_rx_reorder_ampdu: ignore QoS null packets
Cc: "Michael Buesch" <mb@bu3sch.de>, linville@tuxdriver.com,
	johannes@sipsolutions.net, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	"Emmanuel Grumbach" <emmanuel.grumbach@intel.com>
In-Reply-To: <1215458792.14247.7.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1215434881-5410-1-git-send-email-tomas.winkler@intel.com>
	 <1215447824.14247.2.camel@brick> <200807071902.51683.mb@bu3sch.de>
	 <1215458792.14247.7.camel@brick>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gTW9uLCBKdWwgNywgMjAwOCBhdCAxMDoyNiBQTSwgSGFydmV5IEhhcnJpc29uCjxoYXJ2ZXku
aGFycmlzb25AZ21haWwuY29tPiB3cm90ZToKPiBPbiBNb24sIDIwMDgtMDctMDcgYXQgMTk6MDIg
KzAyMDAsIE1pY2hhZWwgQnVlc2NoIHdyb3RlOgo+PiBPbiBNb25kYXkgMDcgSnVseSAyMDA4IDE4
OjIzOjQ0IEhhcnZleSBIYXJyaXNvbiB3cm90ZToKPj4gPiBPbiBNb24sIDIwMDgtMDctMDcgYXQg
MTU6NDggKzAzMDAsIFRvbWFzIFdpbmtsZXIgd3JvdGU6Cj4+ID4gPiBGcm9tOiBFbW1hbnVlbCBH
cnVtYmFjaCA8ZW1tYW51ZWwuZ3J1bWJhY2hAaW50ZWwuY29tPgo+PiA+ID4KPj4gPiA+IFRoaXMg
cGF0Y2ggZml4ZXMgdGhlIGNoZWNrIGF0IHRoZSBlbnRyYW5jZSB0byBpZWVlODAyMTFfcnhfcmVv
cmRlcl9hbXBkdS4KPj4gPiA+IFRoaXMgY2hlY2sgaGFzIGJlZW4gYnJva2VuIGJ5IDUxMWZlM2Yz
YzRiYTBiNWI3NzQyMTMzNmY2NGExOWI2Y2QwMGU2NWYKPj4gPiA+ICdtYWM4MDIxMTogcnguYyB1
c2UgbmV3IGhlbHBlcnMnCj4+ID4gPgo+PiA+IEFjdHVhbGx5LCBkbyB3ZSB3YW50IHNvbWV0aGlu
ZyBsaWtlIHRoaXMgaW5zdGVhZDoKPj4gPgo+Cj4gT3IsIGFmdGVyIGhhdmluZyBhIGNvZmZlZSBh
bmQgYWN0dWFsbHkgZW5nYWdpbmcgYnJhaW4gKHNpbWlsYXIgdG8KPiBpZWVlODAyMTFfaXNfZGF0
YV9xb3MpCj4KPiBpbnQgaWVlZTgwMjExX2lzX2RhdGFfbnVsbGZ1bmMoX19sZTE2IGZjKQo+IHsK
PiAgICAgICAgcmV0dXJuIChmYyAmIGNwdV90b19sZTE2KElFRUU4MDIxMV9GQ1RMX0ZUWVBFIHwg
77u/SUVFRTgwMjExX++7v1NUWVBFX05VTExGVU5DKSkgPT0KPiAgICAgICAgICAgICAgICBjcHVf
dG9fbGUxNihJRUVFODAyMTFfRlRZUEVfREFUQSB8IElFRUU4MDIxMV9TVFlQRV9OVUxMRlVOQyk7
Cj4gfQo+Cj4gVG9tYXMsIHlvdSB3YW50IGEgcGF0Y2g/Cj4KPiBIYXJ2ZXkKCk1heWJlIGl0J3Mg
dGhlIGxhdGUgaG91ciBidXQgSSdtIG5vdCBzdXJlIHdoYXQgaXMgd3Jvbmcgd2l0aCB0aGUKRW1t
YW51ZWwncyAgcGF0Y2guIE1vc3RseSBpdCBmaXhlcyBiaWcgc3RhbGwgaW4gUlguCkNoZWNrZWQg
YW5kIHZhbGlkYXRlZC4KVGhhbmtzClRvbWFzCg==
