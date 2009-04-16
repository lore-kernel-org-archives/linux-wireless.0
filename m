Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60644 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495AbZDPTAI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 15:00:08 -0400
Subject: Re: [Proposal]TX flags
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: radiotap@radiotap.org,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <69e28c910904161147h5a68d3b5nd054b043d6ad2719@mail.gmail.com> (sfid-20090416_204759_216782_A2928C12)
References: <69e28c910904141733m72ce521ap8f1865bec991fff7@mail.gmail.com>
	 <1239902910.26575.14.camel@johannes.local>
	 <69e28c910904161147h5a68d3b5nd054b043d6ad2719@mail.gmail.com>
	 (sfid-20090416_204759_216782_A2928C12)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-WPhN+K+9zcBh68tF3De1"
Date: Thu, 16 Apr 2009 20:59:34 +0200
Message-Id: <1239908374.26575.20.camel@johannes.local> (sfid-20090416_210012_488863_CE5ABD58)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-WPhN+K+9zcBh68tF3De1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-04-16 at 20:47 +0200, G=C3=A1bor Stefanik wrote:

> Alternatively, the meanings of the {0,0} and {1,1} cases could be
> switched around (making the {0,0} case more logical, at the expense of
> the {1,1} one):
>=20
> TX Flags absent: Use RTS & CTS as needed.
> TX Flags present: {
> RTS=3D0, CTS=3D0: Use RTS & CTS as needed.
> RTS=3D0, CTS=3D1: Use CTS-to-self.
> RTS=3D1, CTS=3D0: Use RTS/CTS-handshake.
> RTS=3D1, CTS=3D1: Use neither RTS nor CTS.
> }
>=20
> (By reading the second proposal again, I find it more and more
> sympathetic... but let the discussion decide.)

That _works_, but is impossible to describe in any feature discovery.

johannes

--=-WPhN+K+9zcBh68tF3De1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ54AUAAoJEKVg1VMiehFYgeEP/2CirixgZ3BMWSeFRvRfSnl5
Qw2KnEBk9mjHE/AommNHDekFVtuthoVKEif12gb57OKjvkbaOV21KdS9qUOKfJEp
F8GjxFzc27aULdWvdg8XnUVsB2Kl6SFRuZBTjFmlxvcAUqVdNYaE2zOqsIJEP/V3
/jjjXo867k0DEfKnNeXyxvlXr5d2/O4KtI5u03Nw9CoHMrVB5StyuoIKVgdokTj3
i0J1topiEX/JFse7Db4Jp3/mbWKXc0h45Nh9v4xayqEqes05QgBairijHMuGWZ21
gL/UNQizPP6963OXDempE6z+B9A1gZuNCAr546x1DsV7fH5RKHpXTRmjw30gP+IP
Q+2XETi+Uqxh+RpDblscxw2OROdGWN6JqcIPpiagHclBX7P5gonZwGLaGFDznCd2
+obpQDB6sljzcofis72bahntr7Uy2winzDcJmWg4dEMjph6qaUGtzlsfMUlu2CSv
ZR7ZvU3OMIjaYYg/YDYiZBpxyEY5kt0yaJGyYZ6czFekSBrL8Zw2Hid02tRPT+Ms
tkXVRtoz9y5qlSdeKZZaaqp/X8NRBjk3r9r4ZnEer8MBlfJxACuE76nsmWrH79rM
m6b6y13ucFE/C/Pn62M9nrK2I1Ubr5FJZGrkc5PF86QCgss9CT1VrAXm4mNseJLZ
wUYrjJmgrFl4ZnWBMX84
=Ez46
-----END PGP SIGNATURE-----

--=-WPhN+K+9zcBh68tF3De1--

