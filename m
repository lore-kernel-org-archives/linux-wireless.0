Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:43501 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752774Ab3LMTJM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Dec 2013 14:09:12 -0500
From: "Coelho, Luciano" <luciano.coelho@intel.com>
To: Simon Wunderlich <sw@simonwunderlich.de>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"yeohchunyeow@gmail.com" <yeohchunyeow@gmail.com>,
	"yeohchunyeow@cozybit.com" <yeohchunyeow@cozybit.com>
Subject: Re: [PATCH v9 2/5] mac80211: align ieee80211_ibss_csa_beacon() with
 ieee80211_csa_beacon()
Date: Fri, 13 Dec 2013 19:09:06 +0000
Message-ID: <1386961746.3214.0.camel@porter.coelho.fi> (sfid-20131213_200915_889567_94C95613)
References: <1386935675-24548-1-git-send-email-luciano.coelho@intel.com>
	 <1386935675-24548-3-git-send-email-luciano.coelho@intel.com>
	 <201312131812.41312.sw@simonwunderlich.de>
In-Reply-To: <201312131812.41312.sw@simonwunderlich.de>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gRnJpLCAyMDEzLTEyLTEzIGF0IDE4OjEyICswMTAwLCBTaW1vbiBXdW5kZXJsaWNoIHdyb3Rl
Og0KPiA+IFRoZSByZXR1cm4gdmFsdWUgb2YgaWVlZTgwMjExX2lic3NfY3NhX2JlYWNvbiBpcyBu
b3QgYWxpZ25lZCB3aXRoIHRoZQ0KPiA+IHJldHVybiB2YWx1ZSBvZiBpZWVlODAyMTFfY3NhX2Jl
YWNvbigpLiAgRm9yIGNvbnNpc3RlbmN5IGFuZCB0byBiZQ0KPiANCj4gWW91IHByb2JhYmx5IG1l
YW4gImllZWU4MDIxMV9hc3NpZ25fYmVhY29uKCkiIGhlcmU/IFRoZXJlIGlzIG5vIA0KPiBpZWVl
ODAyMTFfY3NhX2JlYWNvbigpLCBidXQgQVAgdXNlcyBpZWVlODAyMTFfYXNzaWduX2JlYWNvbigp
LiBTYW1lIGdvZXMgZm9yIA0KPiB0aGUgY29tbWl0IG1lc3NhZ2Ugb2YgcGF0Y2ggNC4gQ29udGVu
dCBsb29rcyBnb29kLg0KDQpIZWghIEdvb2QgY2F0Y2guICBJJ2xsIGNoYW5nZSBpdC4NCg0KLS0N
Ckx1Y2EuDQo=
