Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plainfield.sei.cmu.edu ([192.58.107.45]:40648 "EHLO
	plainfield.sei.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934279AbbLPRad (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2015 12:30:33 -0500
From: "Adam R. Welle" <arwelle@cert.org>
To: Johannes Berg <johannes@sipsolutions.net>,
	Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Bob Copeland <me@bobcopeland.com>
Subject: RE: question on "mac80211_hwsim: support any address in userspace"
Date: Wed, 16 Dec 2015 17:30:20 +0000
Message-ID: <2DE9F46DD36D2A458CD6347950113F2535C1ED@marathon> (sfid-20151216_183036_647494_7CC85A34)
References: <5670DA9A.4010102@candelatech.com>
			 (sfid-20151216_042934_976896_DCE1A2B3)
 <1450257464.3159.1.camel@sipsolutions.net>
		 <56716386.4070107@candelatech.com>
	 <1450272308.8247.11.camel@sipsolutions.net>
	 <567168AF.4060804@candelatech.com>
 <1450273362.8247.15.camel@sipsolutions.net>
In-Reply-To: <1450273362.8247.15.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

DQo+IFdlbGwsIGl0IHdhcyBhbHdheXMgcmF0aGVyIGF3a3dhcmQgc2luY2UgaXQgd2FzIHRoZSAq
c2Vjb25kKiBhZGRyZXNzIDopDQoNCkNvdWxkIHNvbWVib2R5IHByb3ZpZGUgYmFja2dyb3VuZCBp
bmZvcm1hdGlvbiBvbiB3aHkgdGhlIGRlY2lzaW9uIHdhcw0KbWFkZSB0byB1c2UgYSBzZWNvbmQg
YWRkcmVzcyBmb3IgdGhlIG5ldGxpbmsgZnJhbWVzIGluc3RlYWQgb2YgdGhlIHNhbWUNCmFkZHJl
c3MgYXMgd2FzIHVzZWQgZm9yIHRoZSBub24tbmV0bGluayBmcmFtZXM/IA0KDQpJIHRvbyBoYXZl
IGFuIG9ic2N1cmUgdXNlci1zcGFjZSBhcHAgd2hpY2ggdXNlcyB0aGlzIEFQSSA6KQ0KDQpNeSBh
cHAgd2FzIHdyaXR0ZW4gdG8gYWNjb3VudCBmb3IgYm90aCB0aGUgb2xkIGFuZCBuZXcgbG9naWMg
YmVpbmcgZGViYXRlZCwNCnNvIEkgY2FuIGNvcGUgZWl0aGVyIHdheSB3aXRoIHRoZSBmbGlwIG9m
IGEgc3dpdGNoLiBJIHdvdWxkIGp1c3QgbGlrZSB0bw0Kc2F5IHRoYXQgZm9yIG15IHB1cnBvc2Vz
IHRoZSBwYXRjaCB3b3JrZWQgYmV0dGVyIGFzIEkgYWxyZWFkeSBpbnRlbmRlZCBmb3INCm15IGFw
cCB0byB0cmFjayBNQUMgYWRkcmVzcyBjaGFuZ2VzIG1hZGUgYnkgYSB1c2VyLg0KDQpJIHNob3Vs
ZCBub3RlIHRoYXQgSSBhbSBwYXNzaW5nIHRoZXNlIGZyYW1lcyBiZXR3ZWVuIHZpcnR1YWwgbWFj
aGluZXMgc28NCnRoZSB1c2Ugb2YgdW5pcXVlIGFkZHJlc3NlcyAoaW5zdGVhZCBvZiBoYXJkLWNv
ZGVkIDB4NDIgYWRkcmVzc2VzKSBhcyBhIGtleQ0Kc2ltcGxpZmllcyB0aGluZ3Mgd2hlbiBkZXRl
cm1pbmluZyB3aGljaCByYWRpbyB0cmFuc21pdHRlZCBhIGdpdmVuIGZyYW1lDQphbmQgd2hpY2gg
cmFkaW8gbmVlZHMgdG8gcmVjZWl2ZSB0aGUgZnJhbWUuIE15IGFwcCBoYXMgYWx3YXlzIHJlbGll
ZCBvbiB0aGUNCk1BQyBhZGRyZXNzIGFzc2lnbmVkIGJ5IHRoZSB1c2VyIGFzIGEgdW5pcXVlIGtl
eSBhY3Jvc3MgdmlydHVhbCBtYWNoaW5lcy4NCkFsc28sIEkgd2lsbCBwb2ludCBvdXQgdGhhdCBJ
IGFtIG5vdCB1c2luZyBtdWx0aXBsZSB2aWZzIG9uIGEgcmFkaW8gYnV0IGlmDQpJIHdlcmUsIEkg
aW1hZ2luZSB0aGF0IEkgd291bGQgc2VuZCBhIGNvcHkgb2YgdGhlIGZyYW1lIHRvIGVhY2ggdmlm
Lg0KDQpBZGFtDQo=
