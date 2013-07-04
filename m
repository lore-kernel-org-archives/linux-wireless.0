Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60347 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932206Ab3GDC3Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jul 2013 22:29:24 -0400
Message-ID: <1372904956.22888.51.camel@deadeye.wl.decadent.org.uk> (sfid-20130704_042927_423343_EE1BA0CD)
Subject: Re: [PATCH] iwlwifi: add firmware for 7260 / 3160 devices
From: Ben Hutchings <ben@decadent.org.uk>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, Bjorn Mork <bjorn@mork.no>,
	Johannes Berg <johannes.berg@intel.com>,
	David Woodhouse <dwmw2@infradead.org>
Date: Thu, 04 Jul 2013 03:29:16 +0100
In-Reply-To: <1372075552-3253-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1372075552-3253-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-MX5sFWXMeq/un93mnC9j"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-MX5sFWXMeq/un93mnC9j
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-06-24 at 15:05 +0300, Emmanuel Grumbach wrote:
> Add new firmware for new devices: 7260 and 3160
> version:
> 22.0.7.0
>=20
> Cc: Johannes Berg <johannes.berg@intel.com>
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> ---
>  LICENCE.iwlwifi_firmware |    2 +-
>  WHENCE                   |    6 ++++++
>  iwlwifi-3160-7.ucode     |  Bin 0 -> 670172 bytes
>  iwlwifi-7260-7.ucode     |  Bin 0 -> 682892 bytes
>  4 files changed, 7 insertions(+), 1 deletion(-)
>  create mode 100644 iwlwifi-3160-7.ucode
>  create mode 100644 iwlwifi-7260-7.ucode
[...]

Applied, thanks.

Ben.

--=20
Ben Hutchings
Tomorrow will be cancelled due to lack of interest.

--=-MX5sFWXMeq/un93mnC9j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUdTd/Oe/yOyVhhEJAQovAw//SJLt7EyMSh/Eap2QzwnYv7UEoL5l5crx
uf3n++0SdtnWxjpN4PKd2EEu3p4oSJ/ISMfGqi8MOjXaoxfrdCCdWeTzjQ72MMFB
pjugtnKd56XmONof1Ez8EiIg0faV+JOXqGmJFTzn7zVxSrtKWK7TnogU5pOkfxFk
GRvCGCDDAmf6lmHLp+kiI1HrfcyHpNS6YLWbaW6xgeUZowBNNjhlZeulL+Sao8ya
6oJ5G/C4SUdDUpUkyOcQUrGqm7rLg3LDt0R/L7Lp6t4mwAEUp0MzSNKwjr6O2Yv8
6mPj5fBBdyMy4GPAclNLdpL4cNv0DpuziLYR28gtnD29fH28kzqnviSE+gG2j91+
YLIFHOCUdYUE0METZBX21rai+420K92TWCP7Xs/Tpb+/r/wwNEKgUCbJwEqe8QWP
YXqLXuk81kM/z65xAY2XhbWRcqEpue2+2EOzYVhfGyHETQjXhDWgc/CtBJTjIkz/
RqZKNTaDBjGT39R2qEw1FN+ZvTdp2lBEFo45rFS3A3+V6j3i/pHBy+6/ZmL+A5az
Vi2EshZP0YgL+Y+264yP8UI/us20ZT2rJZ1ocggS2Ifs9tc0NXHK/FPp8x2fM1U2
o9DzZLzZdiU6TtSz3nYxkP0XJWcH0PC6pk/mhB1V0V+vQuP4c64ujC5Ep7cGj5/x
+glTIKiNQXk=
=dGtv
-----END PGP SIGNATURE-----

--=-MX5sFWXMeq/un93mnC9j--
