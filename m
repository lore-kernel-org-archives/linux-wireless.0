Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:40824 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752354Ab3KPTBB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Nov 2013 14:01:01 -0500
From: "Coelho, Luciano" <luciano.coelho@intel.com>
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
CC: Simon Wunderlich <sw@simonwunderlich.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
Subject: Re: [PATCH v5 5/5] mac80211: only set CSA beacon when at least one
 beacon must be transmitted
Date: Sat, 16 Nov 2013 19:00:57 +0000
Message-ID: <1384628430.22010.36.camel@porter.coelho.fi> (sfid-20131116_200112_278306_45EDB657)
References: <1384430976-13708-1-git-send-email-luciano.coelho@intel.com>
	 <1384430976-13708-5-git-send-email-luciano.coelho@intel.com>
	 <201311141553.16912.sw@simonwunderlich.de>
	 <CAEFj987dHiYcdX0+_FH9W4x9s1M9BGwGWdz-ik5r_KO7gxEY7A@mail.gmail.com>
In-Reply-To: <CAEFj987dHiYcdX0+_FH9W4x9s1M9BGwGWdz-ik5r_KO7gxEY7A@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gU2F0LCAyMDEzLTExLTE2IGF0IDE5OjU0ICswODAwLCBZZW9oIENodW4tWWVvdyB3cm90ZToN
Cj4gSSBoYXZlIHNlZW4gdGhlIGZvbGxvd2luZyBrZXJuZWwgb29wcyBpZiBzZXQgdGhlIGNvdW50
IHRvIDAgb3IgMSBpbg0KPiB1c2Vyc3BhY2UuIE90aGVyIHRoYW4gdGhhdCwgc2VlbXMgYWxyaWdo
dC4NCg0KT3VjaCEgVGhpcyBkb2Vzbid0IGxvb2sgZ29vZC4gIEkgaGF2ZSB0byBjaGVjayB3aGF0
IGlzIGhhcHBlbmluZy4NCg0KSSdsbCBsb29rIGludG8gaXQgb24gTW9uZGF5Lg0KDQpUaGFua3Mg
Zm9yIHRlc3RpbmchDQoNCi0tDQpMdWNhLg0KDQo=
