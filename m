Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59513 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946336AbXBQAJy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Feb 2007 19:09:54 -0500
Subject: Re: wireless-dev.git breaks wireless extensions
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1171670057.28539.5.camel@dv>
References: <1171670057.28539.5.camel@dv>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-RoXJFof8jCxl45fv4Hre"
Date: Sat, 17 Feb 2007 01:09:49 +0100
Message-Id: <1171670990.3575.50.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-RoXJFof8jCxl45fv4Hre
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-02-16 at 18:54 -0500, Pavel Roskin wrote:
> Hello!
>=20
> Today's wireless-dev.git breaks wireless extensions.  It forces
> CONFIG_CFG80211 to be enabled.
                        ^^^^^^^ ??????

>   I reported that it breaks legacy drivers
> back in December 2006.  It's still broken.  That's what I get for
> MadWifi:
>=20
> ath0      4=C2=BF3=C3=80=C3=98=C2=BD=C2=BF  ESSID:"" [51]  Nickname:""
>           Channel:-0  Access Point: 9F:DD:13:94:33:C0   Bit Rate=3D-57673=
3 kb/s  =20
>           Tx-Power=3Doff   Sensitivity=3D-576733388 dBm =20
>           Retry:off   RTS thr:off   Fragment thr:off
>           Power Management:off
>           Link Quality=3D0/94  Signal level=3D-96 dBm  Noise level=3D-96 =
dBm
>           Rx invalid nwid:2088  Rx invalid crypt:0  Rx invalid frag:0
>           Tx excessive retries:0  Invalid misc:0   Missed beacon:0
>=20
> I'll appreciate if things known be broken are not enabled by default,
> let alone unconditionally.
>=20

--=-RoXJFof8jCxl45fv4Hre
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF1kfN/ETPhpq3jKURAl6pAJ4qioTvFKdDsNDFYw6qFHmKfHFQmgCgqsmN
TJrwa374kmcW2TfC0ZCttrY=
=oBMF
-----END PGP SIGNATURE-----

--=-RoXJFof8jCxl45fv4Hre--

