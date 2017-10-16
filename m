Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51233 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752007AbdJPMY6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Oct 2017 08:24:58 -0400
Date: Mon, 16 Oct 2017 14:24:56 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: rc2-next-20170929: wireless down, won't come up
Message-ID: <20171016122456.GA7351@amd> (sfid-20171016_142512_720496_10596A2A)
References: <20171016091830.GA21812@amd>
 <20171016102745.GA22525@amd>
 <20171016105154.GB3752@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="u3/rZRmxL6MmkK24"
In-Reply-To: <20171016105154.GB3752@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon 2017-10-16 12:51:55, Stanislaw Gruszka wrote:
> Hi
>=20
> Site note: Intel folks do not support iwlegacy, I removed them from CC.
>=20
> On Mon, Oct 16, 2017 at 12:27:45PM +0200, Pavel Machek wrote:
> > > In -next... after few days of usage with suspend and resume cycles,
> > > wifi failed on thinkpad x60. I have not seen this in years...
> <snip>
> > > Any ideas?
>=20
> We do not have any recent iwlegacy changes except cosmetic
> ones, so this problem most likely is mac80211, pci or other
> subsystem issue
>=20
> > Suspend+resume fixed the problem.
>=20
> It is not reproducible? If so, I think it will not be=20
> easy to identify the issue.

So far it happened once... so I don't know about reproducibility. And
I'm not even sure if I'm using iwlegacy driver. Am I?

									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--u3/rZRmxL6MmkK24
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlnkpRgACgkQMOfwapXb+vLZGgCgvSzcGAv7wLEfJZMAobiXWwip
zxsAoISA+/7bfm02mMVkTp+veLXQfFqu
=mEpn
-----END PGP SIGNATURE-----

--u3/rZRmxL6MmkK24--
