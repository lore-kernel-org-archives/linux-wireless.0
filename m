Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gold.linx.net ([195.66.232.40]:53276 "EHLO gold.linx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752445AbZBISYF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2009 13:24:05 -0500
Subject: Re: IWL5300, 2.6.29-rc4, CRDA 1.0.1: Missing out 802.11A frequency
  ranges
From: Tony Vroon <tony@linx.net>
Reply-To: tony@linx.net
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	reinette chatre <reinette.chatre@intel.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
In-Reply-To: <43e72e890902091020p65235e3ds833560974c785318@mail.gmail.com>
References: <1234202993.21570.18.camel@localhost>
	 <43e72e890902091020p65235e3ds833560974c785318@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-rAzYpYYCsV5TamhTyZsW"
Date: Mon, 09 Feb 2009 18:23:31 +0000
Message-Id: <1234203811.21570.19.camel@localhost> (sfid-20090209_192410_821929_66022C96)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-rAzYpYYCsV5TamhTyZsW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-02-09 at 10:20 -0800, Luis R. Rodriguez wrote:
> Your AP did not provide 5 GHz frequencies in its country information
> element. Because of this the intersection between what CRDA has for GB
> and what your AP provides does not include any channels in 5 GHz. This
> has been fixed in wireless-testing though, if your AP country IE does
> not have information for a separate band we lave that band to trust
> CRDA information instead.
>=20
> This should have been propagated down to 29 already, maybe it'll be in
> rc5?

John, will this make it into 2.6.29 final please?
>=20
Regards,
Tony V.

--=-rAzYpYYCsV5TamhTyZsW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkmQdKMACgkQp5vW4rUFj5p0fgCdF6iXlmDc7BZMznXQTTAN86YC
Nu8AoIwMOputlpVwR507C9uxXPR4xGJo
=eBb5
-----END PGP SIGNATURE-----

--=-rAzYpYYCsV5TamhTyZsW--

