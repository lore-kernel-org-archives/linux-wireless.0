Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from storm.alittletooquiet.net ([67.23.28.199]:39653 "EHLO
	storm.alittletooquiet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083Ab2L3Ov6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Dec 2012 09:51:58 -0500
Date: Sun, 30 Dec 2012 09:40:46 -0500
From: Forest Bond <forest@alittletooquiet.net>
To: Otavio Salvador <otavio@ossystems.com.br>
Cc: Malcolm Priestley <tvboxspy@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: vt6656 use
Message-ID: <20121230144046.GO18339@alittletooquiet.net> (sfid-20121230_155202_455351_C2062C24)
References: <CAP9ODKqv4iaZ+cWOKJRgdvs_MJOFTTKPa=G58tWixsN1Upq3Pw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pQhZXvAqiZgbeUkD"
In-Reply-To: <CAP9ODKqv4iaZ+cWOKJRgdvs_MJOFTTKPa=G58tWixsN1Upq3Pw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--pQhZXvAqiZgbeUkD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Otavio,

Sorry for the delayed response.

On Tue, Dec 18, 2012 at 05:53:00PM -0200, Otavio Salvador wrote:
> I've been trying to use the adapter without success; it seems to not
> scan the network for the available APs. I am using v3.4.22 kernel and
> I have include the vntconfigration.dat in /etc.
>=20
> The system seem right and I see no errors in dmesg. Do you have any clue?
>=20
> Thanks in advance by any help,

I have not used this driver in a few years now, so I don't think I can help.

Is this on a 64 bit system?  There are known issues with 64 bit.

Malcolm Priestley (CC'd) has been doing a lot of work on this driver lately=
=2E  I
believe he's resolved the 64 bit issues (thanks Malcolm!).  Maybe if he has=
 time
he can offer some help.

Otherwise, I suggest following up on the linux-wireless mailing list (also
Cc'd).  While the linux-wireless devs in general will not be interested in
supporting a staging driver, you might find other users that are having some
success with the driver and can offer some advice.

Hope this helps.

Thanks,
Forest
--=20
Forest Bond
http://www.alittletooquiet.net
http://www.rapidrollout.com

--pQhZXvAqiZgbeUkD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlDgUm4ACgkQRO4fQQdv5AyjcQCg1DrzNLVRrsPOM4YyqcA4sLer
1skAnR2z9hFpmnAbZ/qsEM2AMlK+u9px
=et1A
-----END PGP SIGNATURE-----

--pQhZXvAqiZgbeUkD--
