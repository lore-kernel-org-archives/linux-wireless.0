Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from libra.uberspace.de ([95.143.172.171]:49017 "EHLO
        libra.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760897AbcHaTdR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Aug 2016 15:33:17 -0400
Date: Wed, 31 Aug 2016 21:32:56 +0200
From: Matthias Beyer <mail@beyermatthias.de>
To: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: Jes.Sorensen@redhat.com, Larry.Finger@lwfinger.net,
        amitoj1606@gmail.com, bhaktipriya96@gmail.com, bhumirks@gmail.com,
        ksenija.stanojevic@gmail.com, meleodr@gmail.com,
        shivanib134@gmail.com
Subject: Re: [PATCH] drivers: staging: rtl823au: hal: Remove pointless test
Message-ID: <20160831193256.GA20648@lucy> (sfid-20160831_213354_098408_24C80596)
Reply-To: Matthias Beyer <mail@beyermatthias.de>
References: <CAMzoamY0HSt4af8EeJpt73FD++q1MZ7iHJFa4NDBtzzQrNMjbg@mail.gmail.com>
 <20160823194417.30531-1-mail@beyermatthias.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="dDRMvlgZJXvWKvBx"
In-Reply-To: <20160823194417.30531-1-mail@beyermatthias.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Pinging here as nobody responded yet.

Maybe this was overlooked.

On 23-08-2016 21:44:16, Matthias Beyer wrote:
> As reported by David Binderman, this test is useless as of
>=20
>     if (a < 3) {
>         /* ... */
>     } else if (a >=3D 3) {
>         /* ... */
>     }
>=20
> so this patch removes the second check.
>=20
> Matthias Beyer (1):
>   drivers: staging: rtl8723au: hal: Remove pointless test
>=20
>  drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> --=20
> 2.9.2
>=20

--=20
Mit freundlichen Gr=FC=DFen,
Kind regards,
Matthias Beyer

Proudly sent with mutt.
Happily signed with gnupg.

--dDRMvlgZJXvWKvBx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJXxzDlAAoJEM6vG2R+1WslFM8P/3VsbWBJZ2YZ0TQStwxhLECc
88oSWpnMbL2Z8HC/tc+O70LVFZDrhTjRviyYlAI1vyEsgoSpPzzJquKgkXwm08rg
ECS58hL8RfHgoYHWibo9iqQfz6vOMfkanmEwysDNJ0xsbxDKQtgwbb/D/Cay+vUI
PoyolnacW/TSbvaXshNqSwLxN/HB2pthM7oSHZ/eyCbAEMaBiPjnUGWLM834D7RA
qEESZ80NFuGbZAAxhl+p/yDydDtiAKSxL0m2LZNPxNTLVdvjl2hKlHjhwe3NrOd0
zdgifgOFP5gH9/0SvgMyACdtqGUi4C4FPdnCHBBdsCvJV4fPWjjp1tEBJHuCWp7V
rAOJMEsQEfECQdZnHM8PEv40TaTKVKVLio43oI42oU8guNbQNUKMLdtdbKjwwPRu
6QZuYPDUzOcTVDdFdDiSabv/APfK0X88xMMSPBa8Ax4aMxMQb+mk6gln+bgHfdFX
KPMCcTOSluqK+Chav9hoyFH8ZtgSftazfq6ZzDIa7n54Zs14FLhKbmR2gafvWLbS
2JyHtUMkhz+6ZF4tvTdfJd/2i9SPuWA44PvETUtA9W30RnsN+rsJwozd0MGAq1EJ
fQ/haf9FizOOsv0S9jHETVXpYvwnOTODe/qUijf6d6yA4VMvv7bt6uypDkgcrga9
KSypJedJ6z12+rnLZRG1
=G771
-----END PGP SIGNATURE-----

--dDRMvlgZJXvWKvBx--
