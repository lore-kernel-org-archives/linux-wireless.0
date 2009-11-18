Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39154 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932329AbZKRS0y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2009 13:26:54 -0500
Subject: Re: [PATCH] mac80211: use a structure to hold the mesh config
 information element
From: Johannes Berg <johannes@sipsolutions.net>
To: Rui Paulo <rpaulo@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1258568579-21900-1-git-send-email-rpaulo@gmail.com>
References: <1258568579-21900-1-git-send-email-rpaulo@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-mUP/oC+z/O5VOOy5gNLJ"
Date: Wed, 18 Nov 2009 19:26:29 +0100
Message-ID: <1258568789.30511.52.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mUP/oC+z/O5VOOy5gNLJ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Cool, thanks.

>                 case WLAN_EID_MESH_CONFIG:
>                         elems->mesh_config =3D pos;
> -                       elems->mesh_config_len =3D elen;
>                         break;

Should there be a length check here?

johannes

--=-mUP/oC+z/O5VOOy5gNLJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLBDxSAAoJEODzc/N7+QmaAzAQALX3N2gcPSo8+vlHYGTGkZgh
KF48V2+1Rxhlx+nrVOWAl4CHa8Or1ZxAHaIezgF3objNmcINLjUaymokzPOAMDva
G3nqzQv3HkCHQ8BVdui9pS4zh1eAJPzPgsFmzVk1bWBlhsw7LH3vGQDx7JRVFu7d
9FZklOgQa8U3hsE1474mlXK9ZjIZpeq/r3/JqCRzcfni2doxBtbNO/TvehCuG/zU
vXbhIy8Zqzmu1jzuwKZYE5AbqUXcnAD2DE/HYwjVUlaTiJux905YEmLiW0H6+rQk
bkrAf9ZxMSPuG/MCMLmWJmU+tkMCgzXWPN3HbMQbwSC75c+NSR3gH/QiNAvQL5SY
JpeKug1aZb3ZWb38gw2dpOiQlzocsUZI+2OXy7lociPk/5cbJoMcKi+SOKfSPvp3
s4b2TZ+YFb87UYh00FksAkVxEA2u1IUy6bVr3IfIfP1VpFQrxiWcFmV+C64nYsMM
KUkWuruqBTgp9+7wvOmtTph0g1I1xi6F5/0t4yLuWcbntQkaSuJeSVas1dxFl4AW
T3EUhmo/mVbY1/PFR2qFETks41aiIUZfwn2NkrCMczdlIOWH4w3+08hPgUAGCYSg
9ONTESB7R6H2vxFMksfMAk4y1BNw//xv3O6bzXv3MeHqAoIRVlV39KUABPtNGhNW
N3G3Eoplp0JL56Nj9i9E
=kIpV
-----END PGP SIGNATURE-----

--=-mUP/oC+z/O5VOOy5gNLJ--

