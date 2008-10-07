Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42861 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbYJGSST (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2008 14:18:19 -0400
Subject: Re: wpa supplicant interface up delay
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Jouni Malinen <j@w1.fi>, Dan Williams <dcbw@redhat.com>
In-Reply-To: <1223403361.7328.71.camel@johannes.berg> (sfid-20081007_201608_134402_34146830)
References: <1223403361.7328.71.camel@johannes.berg>
	 (sfid-20081007_201608_134402_34146830)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-nmH6A/qu1xojA0v6lQnm"
Date: Tue, 07 Oct 2008 20:18:18 +0200
Message-Id: <1223403498.7328.73.camel@johannes.berg> (sfid-20081007_201821_469015_0DD8273B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-nmH6A/qu1xojA0v6lQnm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-10-07 at 20:16 +0200, Johannes Berg wrote:
> * Wait some time to allow driver to initialize before
>                          * starting configuring the driver. This seems to=
 be =20
>                          * needed at least some drivers that load firmwar=
e etc.
>                          * when the interface is set up.
>=20
> which drivers are those, and why can't we fix the drivers instead? This
> seems like a bug in the drivers that they return from their open
> callback prematurely.

In any case, this delay should certainly be removed from the nl80211
driver; when porting drivers to the new APIs we can make sure this is
done correctly.

johannes

--=-nmH6A/qu1xojA0v6lQnm
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI66fnAAoJEKVg1VMiehFYFt0P/1Y4Bz5/w4KUc6a8dwKu4A1u
0RkrWlJliU+Ps0LZT+Q1EyVKhWjrhQHn0RfqmBfVgDiJr86a48H0U4c/jVeESwvl
88y4RB+2gzWAWKLuMRz1CvR/8lJuwGKXBQS3dC0fkhQLzzKn4zKZhYEz649x+CXM
u7hxAejjPx3M3Z264j78XX+9cvSb+yocq75IxEA7IkvUA3ZSCBBHICKon6fdTQ2m
pTO4GOelVt01HbKZyO+axn5CIL5aFfIVAXcyciZ1pLIFYlAj5U1SrOMB03xQXl2u
vYGPrBGGirIrG+IlpQYVVJ6BzQjbsS3rT44a0iNjnZYV2MTh0U5pAKaqgZn16Bga
1uyysPpqOpUQa2je9TJZeTbvuh2UCYjECBuuJHpIXxHLL5IvtqvdpX6QcPLjnVmH
CZg2dOtX+6hfbh3qZkf4isAGiQ5D+LKoW8zqJ1l+ocGWgCfBWCxYlss/+zMfDmNN
b4C3+/69HFj7RYtF6i1AkaFx+Nzc66lvD6J2wRGCPZiiXFAK67dyTfoXAH06QeZr
sbTJV3wbxHtOz3QM2Mbb/ZAhfsSSJy3lz+8C7HyXVqVs/JB+39X+2vlR06oBvLBI
A8MpKWXJbFhcWqI5fliHpC+XUNXkD10o6g1NSyYK48KbvsDyvOg5plcn05MC/osf
j66Yisl5oWSum63CdZzl
=4F58
-----END PGP SIGNATURE-----

--=-nmH6A/qu1xojA0v6lQnm--

