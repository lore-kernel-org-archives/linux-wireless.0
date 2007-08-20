Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39918 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759240AbXHTLVQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Aug 2007 07:21:16 -0400
Subject: Re: [PATCH 05/20] mac80211: remove unused ioctls (1)
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: John Linville <linville@tuxdriver.com>, Jiri Benc <jbenc@suse.cz>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20070818040423.GF1415@jm.kir.nu>
References: <20070815144920.135826000@sipsolutions.net>
	 <20070815145043.551508000@sipsolutions.net>
	 <20070818040423.GF1415@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-TUs8chl1aHMiU/Ukt9Cy"
Date: Mon, 20 Aug 2007 11:10:05 +0200
Message-Id: <1187601005.6090.41.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-TUs8chl1aHMiU/Ukt9Cy
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-08-17 at 21:04 -0700, Jouni Malinen wrote:

> No, but some of them can be assumed to be used with iwpriv..=20

As for that, see my other mail.

> First one
> is useful should one be interested in WFA certifications tests.=20

That should, imho, rather live in debugfs. Somebody doing certification
tests ought to be able to enable debugfs on their system.

> Scan
> flags can be useful in filtering out scan results in cases where there
> are huge numbers of APs around.=20

Plan has it that the new cfg80211 API for scanning allows scanning for
things rather than filtering the results after the fact, e.g. (like
iwlist already supports) scanning for a particular SSID. I suppose
hardware designs like iwlwifi could make much better use of that than
mac80211 itself though.


> Even if you end up removing scan_flags, you could leave these pieces of
> information available in scan results.

Sure, I can do that.

johannes

--=-TUs8chl1aHMiU/Ukt9Cy
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGyVpt/ETPhpq3jKURAh1DAJ94/JjY+9D/VtmqC2wWyQWG7QZPzgCfYtPA
ol7e7QPciod5qT0KEC/02+w=
=uYdT
-----END PGP SIGNATURE-----

--=-TUs8chl1aHMiU/Ukt9Cy--

