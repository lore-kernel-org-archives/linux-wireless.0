Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52628 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750955AbdHaS5V (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Aug 2017 14:57:21 -0400
Date: Thu, 31 Aug 2017 20:57:19 +0200
From: Pavel Machek <pavel@ucw.cz>
To: David Miller <davem@davemloft.net>
Cc: kvalo@codeaurora.org, torvalds@linux-foundation.org,
        xiyou.wangcong@gmail.com, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wl1251: add a missing spin_lock_init()
Message-ID: <20170831185718.GA31245@amd> (sfid-20170831_205738_216972_1B5665A5)
References: <20170831065204.GA17812@amd>
 <87y3q0q7ln.fsf@kamboji.qca.qualcomm.com>
 <20170831144743.GA21261@amd>
 <20170831.103305.1809212990680774811.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
In-Reply-To: <20170831.103305.1809212990680774811.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Pavel Machek <pavel@ucw.cz>
> Date: Thu, 31 Aug 2017 16:47:43 +0200
>=20
> > Dave, Linus -- can you still take the patch?
>=20
> Pavel, please do not bypass maintainers like this.
>=20
> It's really rude, and if you do things like that instead of
> trying to work properly with us, your relationship with
> these maintainers will suffer in the long term.

Do you mean I'm being rude to Kalle, or rude to you?

In the part you snipped, Kalle asked me to do just that:

# I'm not planning to submit pull requests to 4.13 anymore. If you think
# this is so important that it needs to be applied in the last minute (I
# don't) you could always try to convince Dave to take it directly.

=2E.and as I still believe patch should go in, that's what I did.

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlmoXA4ACgkQMOfwapXb+vLwzQCfUH/sTzIQGI368mHh7goYMqyr
Y0MAoJHYk44NU6GToYbDVRI7RU9aBN7S
=bFME
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
