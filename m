Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f176.google.com ([209.85.128.176]:34504 "EHLO
        mail-wr0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751830AbdCNOKc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Mar 2017 10:10:32 -0400
Received: by mail-wr0-f176.google.com with SMTP id l37so124993719wrc.1
        for <linux-wireless@vger.kernel.org>; Tue, 14 Mar 2017 07:10:31 -0700 (PDT)
From: Simon Wunderlich <simon.wunderlich@openmesh.com>
To: Sven Eckelmann <sven.eckelmann@openmesh.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org,
        Benjamin Berg <benjamin@sipsolutions.net>
Subject: Re: [PATCH] mac80211: Allow multiple listeners for management frames.
Date: Tue, 14 Mar 2017 15:10:24 +0100
Message-ID: <3029516.gVNlmVZjU3@prime> (sfid-20170314_151156_713684_E9529C94)
In-Reply-To: <33102038.DFbxuT1K2h@bentobox>
References: <20170310093454.27664-1-sven.eckelmann@openmesh.com> <1489499461.10872.4.camel@sipsolutions.net> <33102038.DFbxuT1K2h@bentobox>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1640690.KL97FvX8Qn"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1640690.KL97FvX8Qn
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

On Tuesday, March 14, 2017 3:06:35 PM CET Sven Eckelmann wrote:
> On Dienstag, 14. M=E4rz 2017 14:51:01 CET Johannes Berg wrote:
> [...]
>=20
> > I'm not sure I mentioned it to him, or even remembered it when we were
> > discussing it, but I don't think this patch is a good idea, at least
> > for action frames.
>=20
> [...]
>=20
> > If you restrict it to non-action I can live with it, but I don't know
> > what you really want to do with this.
>=20
> I think he required it only for probe requests.
>=20

The idea was to grab probe requests from userspace with a program running n=
ext=20
to hostapd.

Cheers,
      Simon
--nextPart1640690.KL97FvX8Qn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE1ilQI7G+y+fdhnrfoSvjmEKSnqEFAljH+dAACgkQoSvjmEKS
nqEkUhAAi3ER0u6K0rvcbkXKH4hXlYWHQH+Mx/x5AfhVWZTwLvHw4SFeUKwEOYYf
WVQv3GlqNCIK/0S5j7qBS9zuWkuydrQuHKKC7Gw26XLTXHEl57DlCdLxPwdiAhj1
kZ+WRp2lmT4F2rPQvwr50DqcddwrlvM7y7RYYix+VlveDWXknh9aJt1MA07s1N4T
V35AJZXGMDmQv5aGQhHVD2YGSNIQ5+Jq6apZJQZKRiFnp/bmCWaooNLPvMHJlBvF
WbR6YrRCSwP/F3npIk7v5n1wY6EoUKfCqFGvt6I3BPmHXzURkuMG1rFatBRY/xE3
fA29E1OiLtCFNrix55P38SP6YEjrIE8jawecaF6tNH6jJhfAtQlvLTMDcYaRYFal
C/at0SqXfj2quw6acQP+F6IX3obzXXpaQNo8WhZsAu/gA8xYWBlu02jizlYVtnjK
P12jMcG4aDtwqtwRRa9rCqC8XVJADyW1DNUj8twPuZchVz14NhGmMC8DU4SGvVhE
GVw08KI6vlqr3jGGY3ugRKdxAfZ/dSP7Lq7ooIXOOMOhKa9X2gRI7+IJl9TamWp3
OiHy4ArPYyHR5/2QhY75a/T7sIKxw61l1bfpCUm4HCWVfziGlblSAwF/9kMLKI3j
QqfY/y2SiO4Vp8n79RXI178PTjX9oDp+klj2bATS/ZgxWIzMMZE=
=pDQd
-----END PGP SIGNATURE-----

--nextPart1640690.KL97FvX8Qn--
