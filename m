Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:44795 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751223AbeDUIYt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 21 Apr 2018 04:24:49 -0400
Date: Fri, 20 Apr 2018 22:24:44 -1000
From: Joey Pabalinas <joeypabalinas@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Kees Cook <keescook@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        luciano.coelho@intel.com, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: New sparse warning from min_t(): expression using sizeof(void)
Message-ID: <20180421082444.i4eyw2zxl6tipt6i@gmail.com> (sfid-20180421_102510_913596_B4BAF2CB)
References: <87a7txf15w.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mn2mculu7u6ifheg"
In-Reply-To: <87a7txf15w.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--mn2mculu7u6ifheg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 21, 2018 at 10:50:51AM +0300, Kalle Valo wrote:
> Is there any way to fix it? With ath10k I use sparse a lot and because
> of these warnings sparse is now very annoying to use.

I submitted a sparse patch [1] for this not too long ago, but in the
meantime you can still curl the patch [2] and apply it directly to
the v0.5.2 release to suppress the deluge of warnings (-Wpointer-arith
is off by defaultl so no need to change any of you configurations).

[1] https://lkml.org/lkml/2018/4/10/923
[2] https://patchwork.kernel.org/patch/10334353/raw/

--=20
Cheers,
Joey Pabalinas

--mn2mculu7u6ifheg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEKlZXrihdNOcUPZTNruvLfWhyVBkFAlra9UwACgkQruvLfWhy
VBla9w/9Eg2FL9Pe3W4Lub378queMq4m0wcO9elSFFRDLYI1TCkxC0eDFerZaPOl
dllZu/hbw8vBWu7XjGECQrboGzykeCyoqpFYsNtz7A5FvbKKRY0bP3rO2Ntj0qi6
CH88xINF9lp2CYhLGBsHKWnbfAy+vVAv2//rwxo71Nn/kcc++ViRgbbFEKKMEaSm
GIfb7pyRkZEOaSnm15NtNzJpQ9DRQTxAczKRTCsCCnAdw+/CgQzUbT/YYwIIHGBz
d1SDaUFTe4liugnxQXxMBC6HlxUKv7g6Pc9jQ0gqSWqnADHOggcHC9GcsDnEbO+n
B8aJUJmwjyDL6VU5AXmOyspm2+zq8PSeTwox4myTP50SNdiG3ta+rEcSzeOiLgWU
nE1oL7jlmW4x4WZMCoQMi68OtgF8ZxHlLbh9xt999rO1gS+mYHocATTwaVGAyABS
hLb/KhbaV6vPVh3An3XpkZl9PyfpkZ0cRJaPCwybvBiY6paB18bwYIwKC+Jzr0ck
A18FtwfpqPbyFeOqtjfeIttpql0XH8z/wr+Ggf9rhMNen4TaJI+F+7/a10gDr5eX
X+1h8x0jgQspjP4m2ZygRT9bSyenxCque2rNV+R1Oiz7iLS6+dH6XbSdRRaFKHdL
5IhTcriF6Ac85MOs6TR6ohMLnXSzez7xXcjZk7E2nnziZ/WDnAU=
=Qo91
-----END PGP SIGNATURE-----

--mn2mculu7u6ifheg--
