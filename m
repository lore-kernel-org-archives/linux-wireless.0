Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49612 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755900AbZE3Utl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 May 2009 16:49:41 -0400
Subject: Re: commit #1868cf308a3b3a336fcfe52c5aea4ac12d5e42ac breaks
 wireless on my system
From: Johannes Berg <johannes@sipsolutions.net>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1243716437.26585.4.camel@maxim-laptop>
References: <1243716437.26585.4.camel@maxim-laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-T3YCNA5Dz2WVlxSeSqPu"
Date: Sat, 30 May 2009 22:49:00 +0200
Message-Id: <1243716540.13863.32.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-T3YCNA5Dz2WVlxSeSqPu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-05-30 at 23:47 +0300, Maxim Levitsky wrote:
> I use nl80211 wpa_suppicant driver.
> With this commit (have just bisected) I can't connect to same AP twice,
> and usually only a module reload, or somtimes restart of supplicant
> help.
> Actually usually I can't connect again after first successful connection
> at all.

Grab Luis's fix.

johannes

--=-T3YCNA5Dz2WVlxSeSqPu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKIZu5AAoJEODzc/N7+QmaT+gQAIpMlUDObBxHgwTu488o7RGI
44yp9FWzWmkx1xRFSzUwrUqynNaSHrI7OPn++ucl3yDaFpRHYF3fsVrzF+mgBuzm
cQVtzQB+xY5EoetDu0jwdDNoD2uxTnb+U7BSpeGzO1jgWb2ssnlkHBaqdY/RIPTc
e018XlqjzRUdDrt1grHZ6CPhNuOaqUnXsmpzBHzOXqKeHd5jBA+aNrinhNNf0BPN
jxey6uIOkGEk6AVBgATAwhNorMsam4ps4kwc6OHu8/vq2OM0nLjpC9Hbe6Dbdyyr
S4wXGgWT+ma5U2LpWxSER4a6/i2dgfbGt/r6/YBNf0fqihKeMbRzXRONpzTgtyq/
0t2frBRKrS9F71h2ttN8gKE9MEE0fFfraT6TOarM618MV+pvYnSys350J/1P4t6J
Exqaye/wkyoDWE5CskBSt/7i/IgZeORhOMj5nkkRVkodhcaO0KXg+0PLu9VK22C/
Md3Zc2wF945AJ0kqDRi5Y7+bFKfVkX8YoCdHBIZy7pTx9ayq7Kq6CRAwKfpFw/Ej
zkf512q3HzkHQhHN8gqA3XxwyqNW89eIirB1WjlcIxrqgHAOgXSSi1K6v4ghP9mf
GG2AISBvDlDUTYtTvZs3Ae9xU76do3Jat6kR08N/42XdVM5oc1tWofsbbcYDnM14
E4BNqiS5KobhKsXghKz9
=m+bM
-----END PGP SIGNATURE-----

--=-T3YCNA5Dz2WVlxSeSqPu--

