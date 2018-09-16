Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:32800 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726279AbeIPMTA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Sep 2018 08:19:00 -0400
Date: Sun, 16 Sep 2018 08:57:03 +0200
From: Pavel Machek <pavel@ucw.cz>
To: johannes.berg@intel.com, emmanuel.grumbach@intel.com,
        luciano.coelho@intel.com, linuxwifi@intel.com,
        linux-wireless@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: v4.19-rc3 on thinkpad x220: kernel BUG at
 kernel/dma/swiotlb.c:521 when enabling radios
Message-ID: <20180916065703.GA4392@amd> (sfid-20180916_085746_474682_FB248752)
References: <20180916064702.GA4180@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="fUYQa+Pmc3FrFX/N"
In-Reply-To: <20180916064702.GA4180@amd>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> I was running X220 with wireless disabled for long long time. Now I
> needed to enable it, and got...

Tried with next-0913, and machine crashed with capslock LED blinking
when I toggled the switch...

Any ideas?
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--fUYQa+Pmc3FrFX/N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlud/r8ACgkQMOfwapXb+vK1dwCgp5vqvnz6xhArH7xORoGQD68p
5a0AoLGVnkP4L2aOJCO3C4SON4Rl55Te
=Jl4N
-----END PGP SIGNATURE-----

--fUYQa+Pmc3FrFX/N--
