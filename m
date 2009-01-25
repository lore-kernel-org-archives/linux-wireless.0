Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pD9E7F3AF.dip.t-dialin.net ([217.231.243.175]:59703 "EHLO
	apo2k4.ath.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753993AbZAYOqe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2009 09:46:34 -0500
Received: from lucien (unknown [10.8.1.2])
	by apo2k4.ath.cx (Postfix) with ESMTPA id 1B012150076
	for <linux-wireless@vger.kernel.org>; Sun, 25 Jan 2009 15:38:32 +0100 (CET)
Date: Sun, 25 Jan 2009 15:38:27 +0100
From: Valentin <apo@apo2k4.ath.cx>
To: linux-wireless@vger.kernel.org
Subject: Re: [linux-wireless] Re: p54 + ISL3887 + master mode?
Message-ID: <20090125153827.4650afbe@lucien> (sfid-20090125_154638_853948_89D0B252)
In-Reply-To: <497C4273.7050101@gmail.com>
References: <20090125020727.544a6819@lucien>
	<497C4273.7050101@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/seKU/GH8fXx6IxjmeLAmXwb";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/seKU/GH8fXx6IxjmeLAmXwb
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 25 Jan 2009 11:44:03 +0100
Artur Skawina <art.08.09@gmail.com> wrote:

> Two things:
>=20
> You may need a recent hostapd.
hostapd is already from git, that shouldn't be the problem.
>=20
> 2.6.28 doesn't have a lot of fixes to p54, which are only in the
> wireless-testing tree right now, so you may want to try that, or
> wait until ~2.6.30, i guess.
Right now I'm using .29-rc2, but I'm gonna try getting that.
>=20
> fwiw i have a net2280 based p54usb device, that one works using
> hostap from git and current wireless-testing kernels.
>=20
> artur
>=20

Thanks,

--Valentin

--Sig_/seKU/GH8fXx6IxjmeLAmXwb
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEUEARECAAYFAkl8eWMACgkQ22z6WcGtDs8nPgCXfnCpGnmfz3bBlfM08Ex6RRUe
yQCgrLJgRw/3wHQ3KVJgjP5siu3zlpM=
=2VHC
-----END PGP SIGNATURE-----

--Sig_/seKU/GH8fXx6IxjmeLAmXwb--
