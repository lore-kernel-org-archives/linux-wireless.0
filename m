Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp4.mundo-r.com ([212.51.32.151]:37083 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472Ab2AZWOq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jan 2012 17:14:46 -0500
Received: from 82.25.60.213.dynamic.mundo-r.com ([213.60.25.82] helo=[192.168.0.11])
	by fanzine.igalia.com with esmtpsa
	(Cipher TLS1.0:RSA_AES_256_CBC_SHA1:32) (Exim)
	id 1RqXQz-0001HE-Fs
	for <linux-wireless@vger.kernel.org>; Thu, 26 Jan 2012 23:04:45 +0100
Message-ID: <4F21CDF4.4000505@igalia.com> (sfid-20120126_231449_612614_917B2A34)
Date: Thu, 26 Jan 2012 23:04:36 +0100
From: Carlos Alberto Lopez Perez <clopez@igalia.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: 802.11K in mac80211
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig1CBACB5442A3AB23CCD884D6"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig1CBACB5442A3AB23CCD884D6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello,


I wish to know what is the status (or future plans) for 802.11k in mac802=
11.


As far as I can see it is still not implemented. However, after googling
a lot, I found a patch for mac80211 that claims to implement 802.11k [1]
(not tested).


What you think about it?



Any comment will be welcome



Thanks a lot!
--------------------------------------------
[1]
http://pages.cs.aueb.gr/~pfrag/11k.diff
http://pages.cs.aueb.gr/~pfrag/software.php


--=20
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Carlos Alberto Lopez Perez                           http://neutrino.es
Igalia - Free Software Engineering                http://www.igalia.com
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


--------------enig1CBACB5442A3AB23CCD884D6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBCgAGBQJPIc30AAoJEJZQic5rlfiCTxgQAMCX5tsr5o4XwOPkZvEzEFjp
n4SVsZhZB7V1oWdrohXwntoyyOlaY90EOTekK6u1la5+Y4Xw8iLK77woJWQkqTVt
JGD24ZLW2nncN6+JVXBU73noYSdIq9gIrj+hWxR9fu0LPksI+fO6Q+zEAf575/L/
o8WfSR4Tv7Va4zKXMD5g50f8GeUz6DA+PUAXjSfvbQ6yPxFqZs4XU8Z7rYkXp8oU
rgyF9x6skFvTDGXfl1TQ/C/6tF+yQFN4JW62bzR8tqPA8VBmZNu8oHZAMW0EMxny
hq6l85YZPW/ChS/9at3Z+xD9Jjqm5P7TWJELbFjJhhO5jmwP+G+nFXoFHozeOC1w
xWnFEyh4twOiWq0P7CafMllCTI4faW6J1XoVGK1dTHE3VrEw1d3VS9/gk/tQGvID
X5DMZLFUOyl/qlb/Szx4K+2Dh4tBZw75IAcUQZ7NzopSju4xeBG7JqrN5ix4vfzC
Jnqj8IbJKBWb9aZ1OME2GlIW1djYexcyPJd/lGcKcRksed0NkEdH0dXBNGQmroKd
GPvn67AggVXSTCR6EBE1a2P2e9sdAV7v62i/V3RCd5xUS6S1v9OeznkRhFNNf1O4
ceidN+NWJCDtLgwngDSOwVd3PZmsoLNcuAqjJ0ps4GR4VBjaUuBb4zg+C249746u
OHF5i/rKmv1YPM1ZuCjw
=gP6X
-----END PGP SIGNATURE-----

--------------enig1CBACB5442A3AB23CCD884D6--
