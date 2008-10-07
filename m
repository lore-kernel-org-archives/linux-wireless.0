Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42786 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764AbYJGSQC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2008 14:16:02 -0400
Subject: wpa supplicant interface up delay
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Jouni Malinen <j@w1.fi>, Dan Williams <dcbw@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Eg2gCKTLNSp1CvrMoaMG"
Date: Tue, 07 Oct 2008 20:16:01 +0200
Message-Id: <1223403361.7328.71.camel@johannes.berg> (sfid-20081007_201608_134402_34146830)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Eg2gCKTLNSp1CvrMoaMG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

                         * Wait some time to allow driver to initialize bef=
ore
                         * starting configuring the driver. This seems to b=
e =20
                         * needed at least some drivers that load firmware =
etc.
                         * when the interface is set up.

which drivers are those, and why can't we fix the drivers instead? This
seems like a bug in the drivers that they return from their open
callback prematurely.

johannes

--=-Eg2gCKTLNSp1CvrMoaMG
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI66deAAoJEKVg1VMiehFYVJ0P/1YvvDS8SjNel/eF38tTvUk9
1BBZURNY/EQ1d/uZ6d7WoSjU/ylto4vXCVOvTVGL2yDJrYTWzrLesa2Ce2EHHMMM
+GFyOmzAtptBR8Rz57HdZS0Xt6IhyoYOdJBJnBcIjkNtkLrj9FuxivBanRR7EpGX
ZKp7/K1W36kMeTAZLD7ei417b2lvB6sWaGgZLf0TGeH0v5icAaq1NeoSY+HYgzap
PCMn7J7CU1kuilOxOkhDyDJXPiGnOD5jJcSA1+MqfBNkxUo1gCCi88oJ605fBhgm
/GdqV1yA6Lld5AvnJhdyTdl3XDa6QelW5865pRdcxTX93nRha4pujdWjF2h+xxoQ
sJKl1ry54sRmHoSiomCiUwZvkRABE6fBivR4Od+QXHcy0hrpuvf4APYwYTiMUYha
QoWRntWQLllCZNQT0xCfQyobHfKDxN4dUydWQ6nP3omS/vsW8iSduPfoStiJAEt6
GU5liNPVsZZfJa58TBT9VUa9LVsOeVCdvlZHsDIC6J30PRUE4JuV+hwaog2gLjn1
P+b3xRL3rdGgH5E43rzC5d5LVBIJR0fDFLGn2mwsmQjKU31k4XO42K9Op2/vsqKQ
FXklORZP3aY0JcnFS320hCsKFSFc4Wx/tcVKUM8U+PC3WNFxJDN2ueqAnqjjHMSd
VP8vn6iWEDoTWxup2W7E
=YCoK
-----END PGP SIGNATURE-----

--=-Eg2gCKTLNSp1CvrMoaMG--

