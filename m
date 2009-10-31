Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48596 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429AbZJaF4n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Oct 2009 01:56:43 -0400
Subject: Re: [PATCH 08/15] iwlwifi: move iwl_[un]init_drv to iwlagn
From: Johannes Berg <johannes@sipsolutions.net>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1256938578-9638-9-git-send-email-reinette.chatre@intel.com>
References: <1256938578-9638-1-git-send-email-reinette.chatre@intel.com>
	 <1256938578-9638-9-git-send-email-reinette.chatre@intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-tpBT2mbaXe/ydiPEd0Sl"
Date: Sat, 31 Oct 2009 06:56:43 +0100
Message-ID: <1256968603.3555.79.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-tpBT2mbaXe/ydiPEd0Sl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-10-30 at 14:36 -0700, Reinette Chatre wrote:
> From: Reinette Chatre <reinette.chatre@intel.com>
>=20
> Since iwlagn is the only user of these functions, move it to this module.
> This results in a bit more code moving than just these functions since th=
e
> functions only used by them are also moved and we need to export the
> symbols previously available to them directly.

The last bit (export previously available symbols) doesn't seem to make
sense -- if they weren't exported before then surely 3945 doesn't use
them so they could be moved as well? Unless maybe they're used by other
functions that _are_ used by 3945?

johannes

--=-tpBT2mbaXe/ydiPEd0Sl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK69GXAAoJEODzc/N7+Qma6X4P/0J4tR4oqAHZYti+v2F5zP/Y
VBh1beFKVk6V9I1VsbAi5wgIsFRrPDd2XXyWtZtFXch7KlL99EfOryVvaXSY+kju
ae+WOA4/Oz82kQdKhTqsrw15b45ftQNCs0GU0r14KhiIDONDievv4s1OQjtqDnoK
AA03/dS2WsZkHOBFhzleDF4CARLr503WpIe7z+R9Szc4or5NA0if6Zs/iHrFZLyk
bYEgfuvji6FeHkxiibjvVHeH+q+pwjkFmhyP03bi0OLHff0j2VPYT5cA/vOUEHDG
fnVlMMcaqYrUmo6bNlGATVIhrpBjMG8sDl5b5bY/lYpF+JWOkSvkXR0b74qFVIgO
xB1GYICbpfffNYN30r3Cx8FR+wl31L75GW26Q/2r7ITYIsdkY/6oWsOvXfbLEtcZ
piA9bS4v11pNO1R3dFF/s3BN94zwItWRyM/ktFq9RZ0hlQgZV8ZhxXSFi8IA7txf
OaJ3OUU2yyZ+soA29nDZmKn43qPfIPG9no/1Rb21mOP+/vODWa3FrR6A7JVSDHJw
aI5Dy+YuiOTsZ6DtZasXeltGRwfUnIySomTIdWUzIlnzfnngCIBBHObD9lRY1hJ8
xthxmuvmUQpfipxOq3l7oF/U+yWxRSarwP8aswrRfVUZ1HpwrBYy87DT0m+4hW90
uYFMPraBN1uC3RHH2iuA
=RFnp
-----END PGP SIGNATURE-----

--=-tpBT2mbaXe/ydiPEd0Sl--

