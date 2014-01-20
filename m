Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:32796 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752503AbaATC55 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jan 2014 21:57:57 -0500
Message-ID: <1390186665.3651.27.camel@deadeye.wl.decadent.org.uk> (sfid-20140120_035802_394433_4E289D4E)
Subject: Re: linux-firmware: pull-request Marvell mwifiex-firmware 2014-01-09
From: Ben Hutchings <ben@decadent.org.uk>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
	Frank Huang <frankh@marvell.com>
Date: Mon, 20 Jan 2014 02:57:45 +0000
In-Reply-To: <477F20668A386D41ADCC57781B1F70430F53691E15@SC-VEXCH1.marvell.com>
References: <1389325691-21371-1-git-send-email-bzhao@marvell.com>
	 <1390174797.3651.7.camel@deadeye.wl.decadent.org.uk>
	 <477F20668A386D41ADCC57781B1F70430F53691E15@SC-VEXCH1.marvell.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-RWSLA4TKYEPXMnhAoF7j"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-RWSLA4TKYEPXMnhAoF7j
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2014-01-19 at 18:10 -0800, Bing Zhao wrote:
> Hi Ben,
>=20
> > > @@ -730,10 +730,13 @@ File: mrvl/sd8797_uapsta.bin
> > >  Version: 14.66.11.p151
> > >
> > >  File: mrvl/sd8897_uapsta.bin
> > > -Version: 15.69.2.p11
> > > +Version: 15.68.201.p113
> > >
> > >  File: mrvl/usb8797_uapsta.bin
> > > -Version: 14.69.11.p179
> > > +Version: 14.68.29.p26
> > [...]
> >=20
> > Why are these updates rolling the version number backward?  Did the
> > later versions cause regressions?
>=20
> These images are newer firmware versions actually.
>=20
> The 2nd (69 or 68) and 3rd (11 or 29) numbers in the version string do
> not necessarily mean the version increasing or decreasing. Only when
> first 3 numbers are fixed, a smaller 4th number will mean that the
> version is rolling backward. For examples,

So what do you they mean and why are they in the version number?

> File: mrvl/sd8797_uapsta.bin
> -Version: 14.66.11.p100
> +Version: 14.66.11.p151
>=20
> The version is moving forward.
>=20
> But if we do,
>=20
> -Version: 14.66.11.p100
> +Version: 14.66.11.p99
>=20
> this will be rolling backward.
>=20
>=20
> Each firmware image contains a timestamp such as "2013/12/06, 21:28:31".
> If you think that is informative I can add the timestamps in commit
> logs and resend the pull request.

I don't think it is.

Ben.

--=20
Ben Hutchings
One of the nice things about standards is that there are so many of them.

--=-RWSLA4TKYEPXMnhAoF7j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUAUtyQqee/yOyVhhEJAQovMA//Wtkd7OxfTLUqvKwIW3C0rGgOrLmvy4X6
GDgG1ztbC0h5UAdsXEGmv2RQPhz1o/XfQP7AaDDi6wUO1hwTbhBiE6P9E1orbORZ
EfIL1Fs9Gto6rh1DlS5lDOg9g76SfCAy5OhvmSSBpgmYUSQZNH5Mo1CjwAt/Etv+
/GNN0egy48Kk43lJrgLD4/I/pX6vswUuiQjFcSzbalTHEY0JJbGSik4O4+vfWy1r
1KBsAr0UsB2N7UwgjofnOmdIvqYI0ZoEUVmU9gEsBUVO83U8SOeDbSraAqtLgI6q
U/SKXgTvOS8SklzTOKSvL+zlysV0OSdnq4RyWD5U7rV/fum22b7JUcCub7mqP49X
VrexVDGqwTpLWUXCxmtzg9iFxjw1S3tSVnQkVN7fQ7fWt/VrAt0IkeDQDrq7NPIM
xggDkMxcTn+eTeaO+FiES0cocjsoxWs5V9my2Cv35vdmzNMetIhdWGZYZpGrgh2y
PWu46ZbBACdXNIJTE5oc4atCTtdfjbJuthW3SB50Ry9JpRds9JV/OTZGvndpm5hQ
t/D5Eg/nuk/oIwSFiJ9dSgblOMwsHpPvL6CgYduD5Mmp/akH+q+F0JIgTxe9UAWA
V7cdYt4rZwlhWIiw0pAEJ01ZLnbzW2XJeeHC80kk+Vjdh3ROuVqUjzUxdu93e+XF
Ra7vI0OdsQA=
=Oqst
-----END PGP SIGNATURE-----

--=-RWSLA4TKYEPXMnhAoF7j--
