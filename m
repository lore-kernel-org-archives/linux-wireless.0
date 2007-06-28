Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:47846 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754718AbXF1J4r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2007 05:56:47 -0400
Subject: Re: [PATCH] mac80211: Export short-preamble bit to drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: Michael Buesch <mb@bu3sch.de>, Jiri Benc <jbenc@suse.cz>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200706271840.09719.flamingice@sourmilk.net>
References: <200706251628.00838.mb@bu3sch.de>
	 <200706271840.09719.flamingice@sourmilk.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-0svyYmcuoKNXnojwvx+M"
Date: Thu, 28 Jun 2007 11:57:00 +0200
Message-Id: <1183024620.4769.80.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0svyYmcuoKNXnojwvx+M
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-06-27 at 18:40 -0700, Michael Wu wrote:
> On Monday 25 June 2007 07:28, Michael Buesch wrote:
> > +#define IEEE80211_CONF_SHORT_PREAMBLE	(1<<3) /* use short preamble
> > +						* with IEEE 802.11b */
> Shouldn't this be more of a "short preamble allowed" bit rather than "use=
=20
> short preamble"? After all, short preamble is usually configured per fram=
e.

I don't think we ever care about configuring it per-frame and currently
can't afaik, so I don't think we can rightfully say "short preamble
allowed" unless we want to confuse driver authors about who is
responsible for then determining whether to use it or not for each
frame.

johannes

--=-0svyYmcuoKNXnojwvx+M
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGg4Xs/ETPhpq3jKURAv2FAJ0R6oFgsHhH3K0ypZGuEIBTY+ZOSgCdF7Ff
uRpUKjeoLGUHfp2zIjpCeHo=
=XIJd
-----END PGP SIGNATURE-----

--=-0svyYmcuoKNXnojwvx+M--

