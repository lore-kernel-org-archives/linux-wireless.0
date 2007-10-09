Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:34002 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbXJIJUH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Oct 2007 05:20:07 -0400
Subject: Re: [Rt2400-devel] Mode selection in mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: rt2400-devel@lists.sourceforge.net,
	Adam Baker <linux@baker-net.org.uk>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200710082308.38260.IvDoorn@gmail.com> (sfid-20071008_215232_295042_67439970)
References: <200710052319.10600.linux@baker-net.org.uk>
	 <1191837339.4063.25.camel@johannes.berg>
	 <200710082308.38260.IvDoorn@gmail.com>
	 (sfid-20071008_215232_295042_67439970)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-k/MybcnNlieXpBtA6du+"
Date: Tue, 09 Oct 2007 11:20:41 +0200
Message-Id: <1191921642.4013.13.camel@johannes.berg> (sfid-20071009_102015_125166_60090817)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-k/MybcnNlieXpBtA6du+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-10-08 at 23:08 +0200, Ivo van Doorn wrote:

> The only difference currently in rt2x00 is for rt2500usb. The initializat=
ion
> of the IFS and EIFS register is different.

Ok so that's something we have to do in G-mode-compatible-with-B as
well.

> And is mac80211 doing that correctly at this time?

I'm not entirely sure. Are you setting the IFS/EIFS from any other
place? :) I don't think it is doing that correctly.

> Only registering the supported rates and channels and let mac80211 sort
> out the modes itself does sound like a good idea. :)

:)

johannes

--=-k/MybcnNlieXpBtA6du+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARwtH6aVg1VMiehFYAQI6Dg/9EJnAY2zQZLUHzHE3hJ9QVTnCpRwR3e66
z65+d3/lZvJTW950Hj+8C/gN4q3rfQFClzzmPr2MR9RsaNXU1chqxErnqiW8cuLd
7k3soziBRsDQUdewXoFwqz1iWRLDOHOpUtw3/0dz9/IdvSF3h+usBkagM+XSauAV
naOIYyfUt0/vEQsaEiyFFWLWNEX/E7q9R4M2FNz2dRbAbaHQjwZTfqYbZQmGQO7S
tcErxcPZ3yc9kroPANHVnPQN6OQ3skta/QEdu4fizfokSW5tEme4dMcYJ7lVVoZe
Hlik5/vZvguA5hboEA5n39jnOPybPv8vZi7RKUCHUO6wjdUZRrohKs9obAzAVV02
qT00+ApUX5+tctSqNTqgt2OpyRqAqygIYZGUwfalsP4DDR8mfkCCmSDNhTUDRcQe
VVlZ5a1Jc9Gh0oySPDhko1/nc0PYMiqJqDw614KAsL+CuoGgw5MzFs6xgSRAVGmV
yn7QL4nG4NonI6pJE4BQBkXVvwBVTfHkFbgixPqaZ/YhpLMH1sjr37x3tGZE2JB4
UAuWTb3+CSg53vQi9D+/chq9fNMCgm7vuyoicS4njHwPVH6UsqAMhVI1CUT//yom
f0bzQDMf6p8jFmyrHv8bNGj1SVqPQH0esay0ZmRQ4/VExWn6d8WPJlMp36xKWjHI
ZqoAq36aUj0=
=88w/
-----END PGP SIGNATURE-----

--=-k/MybcnNlieXpBtA6du+--

