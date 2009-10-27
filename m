Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53576 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755459AbZJ0HDO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2009 03:03:14 -0400
Subject: Re: RECAP: indication of channel noise
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Holger Schurig <h.schurig@mn-solutions.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
In-Reply-To: <20091027034514.GA20995@jm.kir.nu>
References: <200910261442.44774.h.schurig@mn-solutions.de>
	 <20091027034514.GA20995@jm.kir.nu>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-6kuY+Shtzqs9qM0KoSmO"
Date: Tue, 27 Oct 2009 08:03:16 +0100
Message-ID: <1256626996.4237.4.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-6kuY+Shtzqs9qM0KoSmO
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-10-26 at 20:45 -0700, Jouni Malinen wrote:
> On Mon, Oct 26, 2009 at 02:42:44PM +0100, Holger Schurig wrote:
>=20
> > The idea is to have one API call "do site survey", where you tell=20
> > the driver to scan on specified/all channels to determine those=20
> > values.
>=20
> What would this command be? Just the existing scan trigger command with
> a new attribute indicating that site survey is requested? In my first
> use case (select best channel for an AP), I would like to combine the
> normal scan (get all BSSes) and site survey (get tx/rx/idle hw counters
> for each channel). Fetching the site survey data with a new command
> would be fine, but trigger command should be shared.

That was my thinking (shared trigger) as well. Fetching the data cannot
be done with the same command anyway.

johannes

--=-6kuY+Shtzqs9qM0KoSmO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK5pswAAoJEODzc/N7+Qmavz0P/i0pvXtl0CNBbFTwp5cgi/O/
aEKMlX/nysYxoAS4Cs94k66tgmxUAkCwwESZK9445nECmykp8wsnRQh5zmZ1jsRG
/iyFGLZHCqcj0nSpINzJSlzYTwPLl7l73kmD49YU5ZgLYmEUoo9XpHXLdrMLvRS3
bieghnAZxgaxouvPMrcbjrtn+hmjWRqlFQ6lGyBJVlfqxxklF4MzVJlCeOWyT30q
HJBhLSUgh8gm7f/WFkTDLeAqa2A+jNEg4Y6X4oeOw25DNuW72ioxuLEhUNHuxpqW
kwAO0AhTuR+OmGtA231u87lPR8Cf3K2yT6sjglvVfd4HkxSrRu4K2vCHgnOJrdov
cTvIcZXez7iGIGEz8yHcs+u1/DJYv2X1YPp+Anv0d7zxMU/h71ZCzAi3ql5peO6f
OazIIwKULSJeBIeX1cdrUUpmgo0n5KUuKQ+Erq5v4PRqffdwhevZbCiKK9hbPHMD
AlDMTBHURpx30548fV9wX/dvyR8otce4q6Wf+2PfOJkJtxViEyY6V12vf7Uj8MAd
JmOLeAC1XvEyiysr8kw8yM420SYOdOU2jJ5xzNTTAaLHNt/caWw6iy9JPWwHrk5v
9FE2q/59FX+lY5FTSQY7mlc7Y5AgD6rYBseZnWwzmYY9e2mYFyzWe2WPIKL/GC1x
GDKy2m3eq9httcoeBxdz
=IbGu
-----END PGP SIGNATURE-----

--=-6kuY+Shtzqs9qM0KoSmO--

