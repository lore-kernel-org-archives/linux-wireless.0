Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:55897 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab3GHOhU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jul 2013 10:37:20 -0400
Date: Mon, 8 Jul 2013 16:37:15 +0200
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCHv5 00/18] Add support for 5 and 10 MHz channels
Message-ID: <20130708143715.GA12631@pandem0nium> (sfid-20130708_163733_620133_3FCD8E9D)
References: <1372352340-20663-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1373281421.8312.8.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
In-Reply-To: <1373281421.8312.8.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 08, 2013 at 01:03:41PM +0200, Johannes Berg wrote:
> On Thu, 2013-06-27 at 18:58 +0200, Simon Wunderlich wrote:
>=20
> > As always, any comments are appreciated!
>=20
> Compilation is broken in the middle of this series so I'm dropping this.

Whoops, you are right. I'll send a fixed patchset later, also including the
whitespace left-over you've noticed. I'll leave the DIV_ROUND_UP() as it is
though, as we discusseed.

Thanks,
	Simon

--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlHazpsACgkQrzg/fFk7axbR1wCgxPeAUiJX1aajDPtz3yvhdb+/
K44AoMBNVn/uDPEkIh1nHGBiWVyLCGbB
=Ymup
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--
