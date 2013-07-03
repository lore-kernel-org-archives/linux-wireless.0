Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:46654 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932988Ab3GCXGU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jul 2013 19:06:20 -0400
Message-ID: <1372892769.12249.259.camel@fourier> (sfid-20130704_010623_940041_6B89C3FB)
Subject: Re: [PATCH] brcmfmac: Turn off ARP offloading when configured for
 AP.
From: Kamal Mostafa <kamal@canonical.com>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	Arend van Spriel <arend@broadcom.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>
Date: Wed, 03 Jul 2013 16:06:09 -0700
In-Reply-To: <CACna6rzqjh0uC=qNThA=fsNmbLz+b0NUfkvFSLZ7GhRdGqOYug@mail.gmail.com>
References: <1370508957-12709-1-git-send-email-arend@broadcom.com>
	 <51C15D4D.6040009@broadcom.com> <20130619141920.GB7395@kroah.com>
	 <51C1D392.8060705@broadcom.com> <20130619165217.GC5419@kroah.com>
	 <51D33EC2.1090108@broadcom.com>
	 <CACna6rzqjh0uC=qNThA=fsNmbLz+b0NUfkvFSLZ7GhRdGqOYug@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-zy9dSOkRsHE7QC3CBzsr"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-zy9dSOkRsHE7QC3CBzsr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2013-07-03 at 06:54 +0200, Rafa=C5=82 Mi=C5=82ecki wrote:
> 2013/7/2 Arend van Spriel <arend@broadcom.com>:
> > Hi Greg,
> >
> > Forgot to ask, but it seems like Canonical is maintaining additional st=
able
> > kernel branches. I guess I should contact them for those kernel version=
s (if
> > I care), right?
>=20
> They track Greg's stables to pick up the patches. Know from my own
> experience, I didn't have to ping anyone :)
>=20

Yes, we're picking up cc: stable patches automatically when they apply
to the 3.8.y.z and 3.5.y.z "extended stable" branches[0], but we
certainly appreciate specific backports for those versions when they
don't apply cleanly.

 -Kamal

[0] https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable



--=-zy9dSOkRsHE7QC3CBzsr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABCAAGBQJR1K5iAAoJEHqwmdxYrXhZ2C4P+QHGOBvRa6FwmjzyLy8v0660
qMaHgPsLVSlsO+ZqD7/8BK/JgPtQIk1iZw71L/TW9//IJperW32Be9hqOFiQt0Xg
IYFaH2mrLDt62zfEVJAReeFsNKdH1NwsYSikCtCrNp7SdDoZsL/3wtc67g6agvhL
Mimo7NjMXpOZeIE5VL/Y2RfAOHJI5uQFuyt8Gbe7sAbiX7PV0tVnCj4OeizYxBRG
xmyUutuhwgbAV8qjXp2jtNtHUoQ3gjB9NzOK15LiQ+WKYC/2ASLE7Yihp9l5p4Jd
eoZCI19n7nbLYMm9RH9DG5tXPZAkQyHwcwSmg0fPVmApYdcudHA//+jBymtxRiLQ
ixvDu3Mw0ikRDntA4lFlGEiODNyzUZ0lCjg4lKU9EL7wjUVY0HClfOMm7zCaw6C/
9q76ITvoCuozqdTIikKmdtUU0vwVIe8ZJbx/GZfjtp5meEgTTf92OXz3nrh2puZu
5QPQEXAKCv8XB9OSLALfDFkt1Q348vTp4kEEHKCZfVQ2zbSWZDBt6gtqbcYcp0tr
ANAkdspobpC6ZF1W03hvsknJhVjm3l0OkVE3pe8g+B9qm/py4XQgqyR1i3ixTIQa
4xJaTr3a7d8EdAkIWzFSf/JhgygDzVB6eOVm2ly2DG11R317VDF4ASCO6LiIgV/L
Rt/jtUDRYLY0GRpkvdiZ
=6P0p
-----END PGP SIGNATURE-----

--=-zy9dSOkRsHE7QC3CBzsr--

