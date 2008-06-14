Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.249]:1385 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559AbYFNQuE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Jun 2008 12:50:04 -0400
Received: by an-out-0708.google.com with SMTP id d40so1071647and.103
        for <linux-wireless@vger.kernel.org>; Sat, 14 Jun 2008 09:50:03 -0700 (PDT)
Message-ID: <43e72e890806140950x1540fa81l9e7045ed63f4b912@mail.gmail.com> (sfid-20080614_185010_412535_D6EF02DF)
Date: Sat, 14 Jun 2008 09:50:03 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: [ipw3945-devel] [BUG] iwlwifi 3945 works only with disable_hw_scan=1
Cc: "Maxim Levitsky" <maximlevitsky@gmail.com>,
	"Zhu Yi" <yi.zhu@intel.com>, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1ba2fa240806131304n442972eatfd2f35034476c380@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <484FEA26.1040305@gmail.com>
	 <1213241315.7814.696.camel@debian.sh.intel.com>
	 <20080612135936.GA5031@tuxdriver.com>
	 <1213342523.7814.865.camel@debian.sh.intel.com>
	 <20080613130310.GA5333@tuxdriver.com> <48528B63.5030403@gmail.com>
	 <48528CF0.8050204@gmail.com>
	 <1ba2fa240806131304n442972eatfd2f35034476c380@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gRnJpLCBKdW4gMTMsIDIwMDggYXQgMTowNCBQTSwgVG9tYXMgV2lua2xlciA8dG9tYXN3QGdt
YWlsLmNvbT4gd3JvdGU6Cj4gT24gRnJpLCBKdW4gMTMsIDIwMDggYXQgNjowNiBQTSwgTWF4aW0g
TGV2aXRza3kgPG1heGltbGV2aXRza3lAZ21haWwuY29tPiB3cm90ZToKPj4gVG9yIEjDpWtvbiBI
YXVnZW4gd3JvdGU6Cj4+Pgo+Pj4gSm9obiBXLiBMaW52aWxsZSB3cm90ZToKPj4+PiBPbiBGcmks
IEp1biAxMywgMjAwOCBhdCAwMzozNToyM1BNICswODAwLCBaaHUgWWkgd3JvdGU6Cj4+Pj4+IE9u
IFRodSwgMjAwOC0wNi0xMiBhdCAwOTo1OSAtMDQwMCwgSm9obiBXLiBMaW52aWxsZSB3cm90ZToK
Pj4+Pj4+IEhvbmVzdGx5IEknbSB0ZW1wdGVkIHRvIGNoYW5nZSBpdCB0byAiZW5hYmxlX2h3X3Nj
YW4iIGluc3RlYWQuLi4KPj4+Pj4gR2l2ZSB0aGUgYWR2YW50YWdlcywgSSdkIGxpa2UgdG8gdXNl
IGl0IGlmIHdlIGNhbiBmaXggdGhlIGJ1ZyAoSSBoYXZlbid0Cj4+Pj4+IHNlZW4gd2hhdCB0aGUg
YnVnIGlzIG15c2VsZikuIEJ1dCB5b3UgYXJlIGZyZWUgdG8gY2hhbmdlIHRoZSBkZWZhdWx0Cj4+
Pj4+IHZhbHVlIHVudGlsIGl0IGlzIGZpeGVkLiBUaGVyZSBpcyBubyBzdWNoIHByb2JsZW0gZm9y
IDQ5NjUsIHJpZ2h0Pwo+Pj4+IEFGQUlDVCBvbmx5IHRoZSAzOTQ1IHNlZW1zIHRvIG5lZWQgaXQu
Cj4+Pj4KPj4+Cj4+PiBJIGNhbiBjb25maXJtIHRoYXQgdGhpcyBhbHNvIGFwcGxpZXMgdG8gNDk2
NSBhcyBhIGZyaWVuZCBvZiBtaW5lIGhhcwo+Pj4gdGhpcyBjYXJkLiBBY2NvcmRpbmcgdG8gaGlt
IHRoZSBjYXJkIHdvcmtzIGEgbG90IGJldHRlciB3aXRoIHRoZQo+Pj4gcGFyYW1ldGVycyAic3dj
cnlwdG89MSIgYW5kICJkaXNhYmxlX2h3X3NjYW49MSIuCj4+Cj4+IEp1c3QgdG8gbWFrZSBpdCBj
bGVhciwKPj4gaXdsMzk0NSBkb2Vzbid0IHdvcmsgYXQgYWxsIHdpdGhvdXQgZGlzYWJsZV9od19z
Y2FuPTEgaGVyZS4KPj4gVGhlIGRyaXZlciBqdXN0IHNodXRzIGRvd24gdGhlZSBjYXJkIHNpbmNl
IGl0IGRldGVjdHMgbWljcm9jb2RlIGVycm9yLgo+Pgo+Cj4gSXQgbG9va3MgbGlrZSB0aGlzIGlz
IGFsbCBjYXVzZWQgYnkgdGhlIGJpZyByYXRlLCBiYW5kIHBhdGNoLiBMb29rcwo+IGxpa2UgQSBi
YW5kIHNjYW4gY2hhbm5lbHMgYXJlIG5vdCBjb25maWd1cmVkIGNvcnJlY3RseSBmb3IgdGhlCj4g
c2Nhbm5pbmcuIFRoaXMgY3Jhc2hlcyB0aGUgZmlybXdhcmUuCgpXaHkgd291bGQgdGhpcyBjcmFz
aCBmaXJtd2FyZT8KCiAgTHVpcwo=
