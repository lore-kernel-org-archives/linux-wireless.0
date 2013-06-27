Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:55873 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685Ab3F0QHy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jun 2013 12:07:54 -0400
Date: Thu, 27 Jun 2013 18:07:48 +0200
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCHv4 01/18] nl80211: add scan width to bss and scan request
Message-ID: <20130627160748.GC19965@pandem0nium> (sfid-20130627_180757_466590_0BFFDBD1)
References: <1372337064-19254-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1372337064-19254-2-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1372337877.8160.2.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DSayHWYpDlRfCAAQ"
In-Reply-To: <1372337877.8160.2.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--DSayHWYpDlRfCAAQ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 27, 2013 at 02:57:57PM +0200, Johannes Berg wrote:
> On Thu, 2013-06-27 at 14:44 +0200, Simon Wunderlich wrote:
>=20
> > + * @NL80211_BSS_CHAN_WIDTH_20: control channel is 20 MHz wide or compa=
tible
> > + * @NL80211_BSS_CHAN_WIDTH_10: control channel is 10 MHz wide
> > + * @NL80211_BSS_CHAN_WIDTH_5: control channel is 10 MHz wide
>=20
> copy/paste error

Thanks
>=20
> This also looks incomplete? You say you add it to scan but didn't
> really?

yeah, I'm only changing the structs because it is only used in IBSS internal
scanning for now. Will change the title of the patch.

Thanks,
	Simon

--DSayHWYpDlRfCAAQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlHMY1QACgkQrzg/fFk7axYThQCeMJtIg4AB9Ro1uvAF2cmZEO2p
wtEAnjDnJ8q+2SogRKc1M8gH8ZVGkAyK
=i4fC
-----END PGP SIGNATURE-----

--DSayHWYpDlRfCAAQ--
