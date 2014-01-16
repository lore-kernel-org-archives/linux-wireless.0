Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.neomailbox.net ([178.209.62.157]:6590 "EHLO
	s3.neomailbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbaAPMK4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jan 2014 07:10:56 -0500
Message-ID: <52D7CC0A.8080209@meshcoding.com> (sfid-20140116_131059_757880_C70D8036)
Date: Thu, 16 Jan 2014 13:09:46 +0100
From: Antonio Quartulli <antonio@meshcoding.com>
MIME-Version: 1.0
To: Oleksij Rempel <linux@rempel-privat.de>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: Re: [PATCH v2 1/5] ath: add common function ath_is_mybeacon
References: <1389803862-9078-1-git-send-email-linux@rempel-privat.de>
In-Reply-To: <1389803862-9078-1-git-send-email-linux@rempel-privat.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="A2MogG9cIR1Fi71N08PiCss6COJ6bDc9L"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--A2MogG9cIR1Fi71N08PiCss6COJ6bDc9L
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 15/01/14 17:37, Oleksij Rempel wrote:
> +bool ath_is_mybeacon(struct ath_common *common, struct ieee80211_hdr *=
hdr);
> =20

another late comment: wouldn't it be better is the function was called
is_my_beacon() instead of is_mybeacon() ?


Cheers,


--=20
Antonio Quartulli


--A2MogG9cIR1Fi71N08PiCss6COJ6bDc9L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS18wOAAoJEEKTMo6mOh1VX4wP/Aid7QODNOMkycaU42E+c3cM
oJ+Scshx3jInrEvC6h+5yFmVKoLwHAjTmtlfAdpPAorglUuWB22j+FFe1rkcEn0g
ZBea3jalviVnYDVmpcnuS0IBw/HX5I6siN3YTTicByjgcj6ImVd8H3SOhoKWtR/b
wC8/ShbMT83PRobNSrYNm4B+AKKn3wJ2pTWFv/Y+IY4kXbg7W4mIEOnDJNxypLqS
tSsqIQdmNYzhCsR/yceTcQ2KET59JxpM4ku1c4HmcHZsAlC9wgXpEQOjCOmYJiyG
ONEPIbJbGcAQcb+Tpv0XxnCLBQlZ/qKeErWhAw99EACTnV+UALl8cms9Zb9ejFtu
vTBKfQFJYG0BYnZ3vGCTUtDKvm+pWrTGI5cUSuDDJl9yKcr2z/aS9kWlnWNy3jEi
eFesmy/i9X9y5hMEeWlSr0bxGhU597PlbJYNGfALwSlpTn31LPvMHZbxriBcHLYp
DhMyXJDM890Axq+RqvxYFBOjLWRx/nGJ1kbtcXa0HodixX8btVzP880KQ+DKeSAr
JOPZq++3wzAIOML/Qf8D822HJgDbqz/JblgUyuxcRtn1uBvyRLYg0NnTvGxpPYLd
FCkMYNoycv8cEtE51Vo9O18pSnSyMpBbVGLpwTbhm0f5M/tR72r2PSyOFlOBrJDF
UezsAvZjgi5Aj9mNaNSn
=i9lu
-----END PGP SIGNATURE-----

--A2MogG9cIR1Fi71N08PiCss6COJ6bDc9L--
