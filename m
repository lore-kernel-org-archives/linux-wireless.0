Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:35351 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825Ab3H1Rr2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Aug 2013 13:47:28 -0400
Date: Wed, 28 Aug 2013 19:47:23 +0200
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Marc Murphy <marcmltd@marcm.co.uk>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: 802.11p
Message-ID: <20130828174723.GA28214@pandem0nium> (sfid-20130828_194732_088154_93C59605)
References: <F690310232FDDF4AB457E8B3EF90DDE08D32184E@MARCM-SBS2011.marcmltd.local>
 <CA+icZUW4vbCfEq9-1ewe=O=fADq42y60T2P7YV4cgNBSntQ9gA@mail.gmail.com>
 <F690310232FDDF4AB457E8B3EF90DDE08D321AF2@MARCM-SBS2011.marcmltd.local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u3/rZRmxL6MmkK24"
In-Reply-To: <F690310232FDDF4AB457E8B3EF90DDE08D321AF2@MARCM-SBS2011.marcmltd.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 28, 2013 at 03:57:59PM +0000, Marc Murphy wrote:
> Yes I saw that post but no response, it was 6 weeks ago.
> I have had more success finding the source used for the GCDC and looking =
to see how different it is from the mainline kernel drivers.
>=20
> Next is to find an Atheros USB 802.11a stick to do some tests with.

If you want to use the GCDC patchset, use some Atheros Mini-PCI hardware. I=
'd doubt that these patches
will work with anything different from ath5k. :)

Cheers,
	Simon

--u3/rZRmxL6MmkK24
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlIeN6sACgkQrzg/fFk7axbO9gCfRiLYo7TL/6Ft45vVKZqyjij+
KEkAniZEJDhjQ1JmskAiw0hqLxXCaL2t
=XWl5
-----END PGP SIGNATURE-----

--u3/rZRmxL6MmkK24--
