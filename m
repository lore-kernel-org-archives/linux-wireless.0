Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37133 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751774AbcKZRRe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 26 Nov 2016 12:17:34 -0500
Date: Sat, 26 Nov 2016 18:17:31 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Sebastian Reichel <sre@kernel.org>,
        Michal Kazior <michal.kazior@tieto.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: wl1251 & mac address & calibration data
Message-ID: <20161126171730.GA16318@amd> (sfid-20161126_181755_106598_FA4C5936)
References: <201611111820.52072@pali>
 <201611221805.13606@pali>
 <20161123222335.GA4788@amd>
 <201611232339.59411@pali>
 <20161124075104.GA26721@amd>
 <20161124083329.GB13735@pali>
 <20161124151317.34yoza3dzuh46oa4@earth>
 <20161124152045.GK13735@pali>
 <20161124184601.wo4al6nyzb6rmiqs@raspberrypi-2.musicnaut.iki.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
In-Reply-To: <20161124184601.wo4al6nyzb6rmiqs@raspberrypi-2.musicnaut.iki.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu 2016-11-24 20:46:01, Aaro Koskinen wrote:
> Hi,
>=20
> On Thu, Nov 24, 2016 at 04:20:45PM +0100, Pali Roh=E1r wrote:
> > Proprietary, signed and closed bootloader NOLO does not support DT. So
> > for booting you need to append DTS file to kernel image.
> >=20
> > U-Boot is optional and can be used as intermediate bootloader between
> > NOLO and kernel. But still it has problems with reading from nand, so
> > cannot read NVS data nor MAC address.
>=20
> You could use kexec to pass the fixed DT.

Yeah. You could also strap desktop PC to a USB GPRS card, and call it
phone. You could also make a pig fly.

But because you could does not mean you should. No, sorry, kexec is
not acceptable. Too hard to set up, slows boot too much.

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--5vNYLRcllDrimb99
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlg5w6oACgkQMOfwapXb+vJqqACgrtAWuiDJlQSlzJga7v8auBQx
iygAoJVSWOy57tYcdiEGo9zizsskhmD/
=9nSs
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--
