Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vms173007pub.verizon.net ([206.46.173.7]:44191 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759202Ab3BXCbW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Feb 2013 21:31:22 -0500
Received: from odin.tremily.us ([unknown] [72.68.84.219])
 by vms173007.mailsrvcs.net
 (Sun Java(tm) System Messaging Server 7u2-7.02 32bit (built Apr 16 2009))
 with ESMTPA id <0MIP00M1YDNKY230@vms173007.mailsrvcs.net> for
 linux-wireless@vger.kernel.org; Sat, 23 Feb 2013 20:31:03 -0600 (CST)
Date: Sat, 23 Feb 2013 21:30:56 -0500
From: "W. Trevor King" <wking@tremily.us>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: arend@broadcom.com, linux-wireless@vger.kernel.org,
	brcm80211-dev-list@broadcom.com
Subject: Re: [RFC 13/13] brcmsmac: activate AP support
Message-id: <20130224023056.GH1361@odin.tremily.us> (sfid-20130224_033135_290806_03FF3670)
References: <1361667972-22909-1-git-send-email-hauke@hauke-m.de>
 <1361667972-22909-14-git-send-email-hauke@hauke-m.de>
MIME-version: 1.0
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="4C6bbPZ6c/S1npyF"
In-reply-to: <1361667972-22909-14-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--4C6bbPZ6c/S1npyF
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 24, 2013 at 02:06:11AM +0100, Hauke Mehrtens wrote:
> This activates the AP mode support.
> =E2=80=A6
>  	/* Just STA for now */
> -	if (vif->type !=3D NL80211_IFTYPE_STATION) {
> +	if (vif->type !=3D NL80211_IFTYPE_STATION &&
> +	    vif->type !=3D NL80211_IFTYPE_AP) {

The "Just STA" comment can probably go too ;).

Cheers,
Trevor

--=20
This email may be signed or encrypted with GnuPG (http://www.gnupg.org).
For more information, see http://en.wikipedia.org/wiki/Pretty_Good_Privacy

--4C6bbPZ6c/S1npyF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRKXtfAAoJEEUbTsx0l5OMm8oQALTXXDHPNB494Xo9cgo7lYMG
KC8cQOBowEbM2aWCCrrL//14nYmnIl6R8SaWuTRIkJnWHThW0PTCijLNJCPSbh/X
g2nsoGs32hFtCJwj1rVW5u7Rxia1sfqPGMNznpY/T9FVxqsERdJI8ees3JiYqRry
VL3XmERE1pNaZtduYXQOR0p/GFgS8KG1c1Fem7w3b3nXz5VMAtrWIC3KIF28ALNq
YbKUzUDCnGIcrXynZTQvyW7p3p2kGYYIaHTZz9whTuBdFw/qC+sRYLXJFmogL6QN
shC8lpJGt4+Psq6F7Zu40YProUzo0mKnx56f7Zcd7VFezpnR8hWd0Wd/tQCRfRNn
Kl3ApA+KLhARGqdbr7nEu1bnYDM5RzxQgMTtWYdLI4FpSjV8ZhLSnjbJ49jhQuIH
NUr4vR9Ad6+9irFM8WWMWdhWu3gZ1pTAy4p9dFKSbEfzUYkbL9wk6r03W5SMxc3N
u9fOC7uUcBiB9qEik7f+qIlQDwE5h7U5B+BKA4DWGa8qDZC5zyRXyx95qU2IrqaK
mP1GMTkTIIpwcACLbaI3COG3fU3GiRnqT04Vzs+Em/WxxW5AVexA1WoHwRvO6WwA
cxm+xiRRv+Bg8Nqdo5iP+QMowp1mEc0n5diJ77XGDtwWMHN4s5yQGJWVQqNc5Tkh
CVTlmoEJ054K7/zv8qeI
=9N08
-----END PGP SIGNATURE-----

--4C6bbPZ6c/S1npyF--
