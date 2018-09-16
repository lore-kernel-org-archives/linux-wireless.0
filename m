Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34401 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726857AbeIPNoi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Sep 2018 09:44:38 -0400
Date: Sun, 16 Sep 2018 10:22:28 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        rdunlap@infradead.org
Cc: Johannes Berg <johannes.berg@intel.com>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        luciano.coelho@intel.com, linuxwifi@intel.com,
        linux-wireless@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: v4.19-rc3 on thinkpad x220: kernel BUG at
 kernel/dma/swiotlb.c:521 when enabling radios
Message-ID: <20180916082227.GA4602@amd> (sfid-20180916_102246_175363_6866D106)
References: <20180916064702.GA4180@amd>
 <20180916065703.GA4392@amd>
 <CAF7Mx6o1PV2xcgLp94=9OP1ZaxoxjebPE1_t93hQ65UkDLgKWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="k+w/mQv8wyuph6w0"
In-Reply-To: <CAF7Mx6o1PV2xcgLp94=9OP1ZaxoxjebPE1_t93hQ65UkDLgKWQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > I was running X220 with wireless disabled for long long time. Now I
> > > needed to enable it, and got...
> >
> > Tried with next-0913, and machine crashed with capslock LED blinking
> > when I toggled the switch...
> >
> > Any ideas?
>=20
> Replying using my phone. There has been such a report from Randy Dunlap on
> September 11 with subject "4.19-rc[23] iwlwifi: BUG in swiotlb".
>=20
> Did not quite follow that, just recall seeing it fly by. Maybe it helps.

Thanks for pointer.

Hi, Randy! We have same problem.

I switched back to v4.18, and it seems to be ok.

I'd prefer not to hear the b-word. Any other ideas?
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--k+w/mQv8wyuph6w0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlueEsMACgkQMOfwapXb+vK6igCgtQ23s8F5RGloD0DXZehRvtZH
j8gAnjhINpzzmzRaD5ICdCnIIHlRrksz
=HcVE
-----END PGP SIGNATURE-----

--k+w/mQv8wyuph6w0--
