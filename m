Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751398AbeAZRpX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Jan 2018 12:45:23 -0500
Date: Fri, 26 Jan 2018 17:45:18 +0000
From: James Hogan <jhogan@kernel.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Sven Joachim <svenjoac@gmx.de>, Michael Buesch <m@bues.ch>,
        linux-wireless@vger.kernel.org, linux-mips@linux-mips.org,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        Matt Redfearn <matt.redfearn@imgtec.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH] ssb: Do not disable PCI host on non-Mips
Message-ID: <20180126174517.GA7637@saruman> (sfid-20180126_184527_591623_D08C5F8E)
References: <87vafpq7t2.fsf@turtle.gmx.de>
 <20180126100902.GN5446@saruman>
 <87fu6su1mv.fsf@kamboji.qca.qualcomm.com>
 <87tvv8r1tu.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="DocE+STaALJfprDB"
In-Reply-To: <87tvv8r1tu.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--DocE+STaALJfprDB
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 26, 2018 at 07:01:49PM +0200, Kalle Valo wrote:
> Kalle Valo <kvalo@codeaurora.org> writes:
>=20
> > James Hogan <jhogan@kernel.org> writes:
> >
> >> On Fri, Jan 26, 2018 at 10:38:01AM +0100, Sven Joachim wrote:
> >>> After upgrading an old laptop to 4.15-rc9, I found that the eth0 and
> >>> wlan0 interfaces had disappeared.  It turns out that the b43 and b44
> >>> drivers require SSB_PCIHOST_POSSIBLE which depends on
> >>> PCI_DRIVERS_LEGACY, a config option that only exists on Mips.
> >>>=20
> >>> Fixes: 58eae1416b80 ("ssb: Disable PCI host for PCI_DRIVERS_GENERIC")
> >>> Cc: stable@vger.org
> >>> Signed-off-by: Sven Joachim <svenjoac@gmx.de>
> >>
> >> Whoops, thats a very good point. I hadn't twigged that
> >> PCI_DRIVERS_LEGACY was MIPS specific (one of the disadvantages of using
> >> "tig grep" I suppose!).
> >>
> >> Reviewed-by: James Hogan <jhogan@kernel.org>
> >>
> >> I think this is obviously correct, so it'd be great to squeeze it into
> >> 4.15 final.
> >
> > I'm not sure if I'm able to get it to 4.15 as it has go via the net
> > tree, and we have only two days before the (likely) final release, but
> > I'll try.
>=20
> Too late, Dave already sent his last pull request for 4.15. This will be
> in 4.16.

Okay, thanks anyway (and sorry again!).

Cheers
James

--DocE+STaALJfprDB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEd80NauSabkiESfLYbAtpk944dnoFAlpraQwACgkQbAtpk944
dnpSLQ/9Gg3MY7IqQYTE9ZHANZ6fyDd3B890rU4BNFoqtiAnckGlRonyWc7mhfaf
0/L3N9LDzJchxY+h8WLdzWEXm4l2tZkmnHExK8H4cfM7Ge3GGf+NUqHb8cYC4bN7
Obx7/rxJhhdQFHNOlKq4ZVyLARZ4fIn9nrCU0/qOZvCeIj1Yf2lR7Jwfa19MnVuQ
ewPt6DY1iYxeAVYOVNAetCkvOBAsQepa9LTFNY/7WQcD1MlHU3TDeH3+/nmGHDX9
CrRlezScTP2nK9dBA+NuYlJMzzsevkg29tUW2N328lS2gLF3WzoEXkDJW5/9ZeV6
WGZlVkpTThqp8/XT3yVCKwUPegQFHDtx52dxDWapedq+elvdP+c+k3yBfIq6nMsP
HfZ2xJMDKNoKAsCykcANeJC3tFm3LDEwaoq1lScmV75WfSX+cFAHitiuopa0taZ+
5C//vGuTFbug505UxgGm8tmAReL7i15fPwYr2fTLSGakop66uMuKxa7LnYNrJT9d
R9Y9EE5wONMByu/Ga9429IqlsO6+D2VQccW0FchebIqeAVnC8JsSnnCXCUiUJQPS
KsIBeavuOHOkba2w869+OWFjNEO6MKOhkCWHGVChg9/nVMpGfGxAsjJ65FKn2Wo/
8oxSrzovGxdclJCcrLr6jP2Dn7FNmobkOTUpncuc/57c+sJ0Kmc=
=+Osn
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--
