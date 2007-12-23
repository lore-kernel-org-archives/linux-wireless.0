Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:47551 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbXLWJYo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Dec 2007 04:24:44 -0500
Subject: Re: [PATCH] mac80211: Restore rx.fc before every invocation of
	ieee80211_invoke_rx_handlers
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <hschaa@suse.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <200712211516.35731.hschaa@suse.de> (sfid-20071221_141215_108356_0F4BE6F7)
References: <200712211516.35731.hschaa@suse.de>
	 (sfid-20071221_141215_108356_0F4BE6F7)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-wkS4exTXjKr42FiHpEV8"
Date: Sun, 23 Dec 2007 10:24:39 +0100
Message-Id: <1198401880.4116.6.camel@johannes.berg> (sfid-20071223_092448_478279_A706C9CE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-wkS4exTXjKr42FiHpEV8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Fri, 2007-12-21 at 15:16 +0100, Helmut Schaa wrote:
> This patch fixes a problem with rx handling on multiple interfaces. Espec=
ially=20
> when using hardware-scanning and a wireless driver (i.e. iwlwifi) which i=
s=20
> able to receive data while scanning.

Can you explain how you even got multiple interfaces with iwlwifi? The
patch looks (superficially) correct, but I'm a bit confused.

johannes

--=-wkS4exTXjKr42FiHpEV8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR24pVqVg1VMiehFYAQKRVg/+OB3vkBN/xwIxwE5QGr9b4/AI4ks2z01i
g5uXe24/Prs+SnQBK5GktBHgfCOgXM3iXuj/eINXnkr6SuVU3UmPQDWc9dzwT3ZP
mMLQ6QWEGpzFCjmX4ogXImo2+XMkxIErkr5DsV8gfgcP6B12/J/aNDTNGo4MH2hF
N0J5wkNUp8L5kzGepPZ46zrPmTsIS2j31SMPzERdKJtdOCEDY4t9y8r6BN//I5Rp
A2+XUY8P9q2AiYIjL/CTiMtF8k8AEoxY3Ji/en07+WgkAd4tnIWUbytc8E/fhbRD
YqBVy8Q6iUHyfWF+45Tp4dzaOTLmbqcYY/p6pVbL7lZs6vEwc6XWJ5P1hsfACZRs
4siNJ+pOW3KR/HYmiS0e6eHHTtQe43zCw+dLa3YGlE0ZJy2VfnbHrQd/N5QmfCY+
RDZWl9EUlqdfrxRlaE24TYMv0szeqjWlciF+fph+RVuxtEXy5bksETgXicna/45y
/7QQWD1lnb4UMNA3uXZtwcPehbqcdf7TMpunxlLkJlUx03yoScn49gwD4NdQiQo+
G4Nqrz2OdYEzVz0I3XCBFY8aHzJp6obtawCuH/oPA3BVmbM9Fh68GST+1pSUCB4Y
Hf5RXEj4nRnBsgh5cFd2C9LCjVlXGgId4/hw1b3SYBUya7e1bkDo3lJ9Cvc1gIb6
e/4twNV6R+8=
=/cfg
-----END PGP SIGNATURE-----

--=-wkS4exTXjKr42FiHpEV8--

