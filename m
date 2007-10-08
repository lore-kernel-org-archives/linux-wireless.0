Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from durandal.kismetwireless.net ([199.201.145.179]:37209 "EHLO
	durandal.nerv-un.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbXJHOcQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Oct 2007 10:32:16 -0400
Date: Mon, 8 Oct 2007 10:32:07 -0400
From: Mike Kershaw <dragorn@kismetwireless.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Mode selection in mac80211
Message-ID: <20071008143207.GB7430@drd1813.lan> (sfid-20071008_153221_915813_C7AA54B3)
Reply-To: Mike Kershaw <dragorn@kismetwireless.net>
References: <200710052319.10600.linux@baker-net.org.uk> <1191837339.4063.25.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QKdGvSO+nmPlgiQ/"
In-Reply-To: <1191837339.4063.25.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--QKdGvSO+nmPlgiQ/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 08, 2007 at 11:55:39AM +0200, Johannes Berg wrote:
> That's actually a can of worms. Luis is working (I hope) on resolving
> these issues with mode vs. frequency selection. However, I'm not
> entirely convinced that mode selection should be done by userspace when
> we are acting as a client. I think we should simply exploit hardware
> capabilities as much as possible and then use the set that the AP
> advertised (or rather as much as we can support of that).

I'd vote for allowing the user to set a mode - just like they're
allowed to lock an AP association to a specific MAC, bypassing the
hardware roaming algos.

I've hit situations in the past where a card can get a very weak 11g
link but a perfectly usable 11b link, and the hw did not want to drop
back to 11b on its own.  Being able to lock to 11b only was key. =20

-m

--=20
Mike Kershaw/Dragorn <dragorn@kismetwireless.net>
GPG Fingerprint: 3546 89DF 3C9D ED80 3381  A661 D7B2 8822 738B BDB1

"Remember the book store down the road?  That then became a book and coffee
shop?  Now it's a 24-hour just-coffee shop.  It's like evolution, only, wit=
hout
the getting better."

--QKdGvSO+nmPlgiQ/
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFHCj9n17KIInOLvbERAlJsAJ9HLw8fWAOzWTtb2dEDvUEAfHjeowCfTmEy
UirYXN2L9dKvrnbAJz6h5Ag=
=yPPx
-----END PGP SIGNATURE-----

--QKdGvSO+nmPlgiQ/--
