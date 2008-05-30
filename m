Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36862 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbYE3Mc6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2008 08:32:58 -0400
Subject: suspend vs. b43
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Michael Buesch <mb@bu3sch.de>,
	bcm43xx-dev <bcm43xx-dev@lists.berlios.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-y+mP7NIEwXijBAHAFsAS"
Date: Fri, 30 May 2008 14:31:53 +0200
Message-Id: <1212150713.4117.2.camel@johannes.berg> (sfid-20080530_143301_686440_AFFF0BAC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-y+mP7NIEwXijBAHAFsAS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

Since a while ago I've had trouble resuming when b43 was connected to an
AP while suspended.

I did a test today where this was the only difference, but I failed to
see whether ssb or b43 were causing the problem.

Does anyone have a machine with b43 in it that can suspend and supports
the RTC-trace feature so we can narrow it down? Even reproducing might
help to make sure it's not just something weird with my powerbook.

johannes

--=-y+mP7NIEwXijBAHAFsAS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASD/zuKVg1VMiehFYAQLcZhAAj+XbnRiTrixV5QXEbXdwmLo5nrsnlwNB
+JdzlDhn4SrU9Gh87H+pwJYso6GrNG3OAOKdfmx57WC9al9esDbhelqW+N6fV35j
ROW86eRNISoyDhY/DlyC2ScqrSAmJ29WGX5/KCOuvL6XUzYqoVqsUpnYYTKiXrK3
NYGqrFTKTtBF/Z24+cACDvYedhYoFDR0z4ND5Ssfh02kxL15JeZWdu0tuMydWwgb
J0iFLk05zeptT/EvWatFT/gTMiDM9sTf02Jwv1hmbJRxNLEa16Co3Cm3aj03SSp+
TxLTuFxUBPlJhfkgu7G/E70isrgDYYwDsKxe9Gj9v5zZfUFvlGYSixugHbDVwEPt
g9/20Ru5eMM/XQP+6OjoV3EwGT3tX1Oc+GZnqtYytXD0aiMWv5L5WVp7I8D7CMhI
hsNBjanWFbDjX5awjwMzs/PEhxpeRmmpFfs9kG9GisuE70SSR72N0FGmDrIPHARn
vXTvTzIkfvRLKBh8ZAQ7pGpZL4aOqRjCIvXN7mpw41WR8snjdLODfIxjUZfQKy1H
IxqyVQEGOVa79VcimLR1Xw/B0OJd5rxMdRmyGqCNnBmOCOsuXpm1RVhrmy3LvGub
7S+r+4OlJrD1Yc6JtC/MZ7hcncP9lBtjAOHMVORz1NH+kS2d0YNBdCEdZj/tgRmI
zgVNkw/A4EQ=
=NqEL
-----END PGP SIGNATURE-----

--=-y+mP7NIEwXijBAHAFsAS--

