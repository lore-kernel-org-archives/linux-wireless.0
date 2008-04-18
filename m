Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:34292 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbYDRV5j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Apr 2008 17:57:39 -0400
Subject: RE:  RE:  RE: iwl3945 problem with 2.6.25-rc9
From: Johannes Berg <johannes@sipsolutions.net>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
Cc: Marcus Furlong <furlongm@hotmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <D936D925018D154694D8A362EEB089200438B6D6@orsmsx416.amr.corp.intel.com> (sfid-20080418_224627_648936_DECA7576)
References: <D936D925018D154694D8A362EEB08920043535A1@orsmsx416.amr.corp.intel.com>
	 <fu5iel$c45$1@ger.gmane.org> <fu5l5r$pm8$1@ger.gmane.org>
	 <1208376292.27708.3.camel@localhost.localdomain>
	 <D936D925018D154694D8A362EEB0892004353826@orsmsx416.amr.corp.intel.com>
	 <D936D925018D154694D8A362EEB08920043539AE@orsmsx416.amr.corp.intel.com>
	 A<fu931e$k1b$1@ger.gmane.org>
	 <D936D925018D154694D8A362EEB089200438B6D6@orsmsx416.amr.corp.intel.com>
	 (sfid-20080418_224627_648936_DECA7576)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-SFpBEkVfnKc+/EdYAA20"
Date: Fri, 18 Apr 2008 23:57:22 +0200
Message-Id: <1208555842.4848.56.camel@johannes.berg> (sfid-20080418_225744_096993_5359BB5C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-SFpBEkVfnKc+/EdYAA20
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > iwlist wlan0 scan showed the AP a few times, but mostly found nothing
> > at all. When it did find APs, it found at most 2-3 APs, whereas
> > the ipw driver
> > finds 10 or more APs on the same machine.
>=20
> I am seeing something very strange in this log and the logs you sent in
> your first message. It appears that your driver uses software scanning
> while hardware scanning is the default for this driver. This appears to
> be the cause of the ucode errors as the A band channels are configured
> as part of the scanning process.

Just jumping in here because I want to know if there are any mac80211
bugs (I don't have any 5 GHz hw except the iwl4965, no AP), would it
maybe help to explicitly enable sw scanning?

johannes

--=-SFpBEkVfnKc+/EdYAA20
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASAkZQaVg1VMiehFYAQJndA//Rv5Au9HEYPnMYkMNmwMDNQGoSzZjJ0yc
W8eusg9PAkyI/Hml9diS/Kc1EIXgcm2jhO8auPN28KmX30brTLF1UlEl+sU+QI+f
rYHMxqbe+xdMGwXQhLX2l8Abrwo9rwMbVi5WMyMwsG58oceh4i7MHVMTsrV5rtxZ
yqwS7AFdB2EShlDJfYTnfL5nizTK37kBWOQ7NhuV3m5RajeC5fRql+LwP8hgyJRS
AMFqfoMsvcR5o+bHwl3kDd85P2BNBnirHPFlWCDp0FRZdmjp9Ca1kT40amM+NB7K
yEPh8UeNNH5mvnNyQDUDl35XV6Y7P9B8RAZQkaKZdR1Qqb23Btx4f93pgtMx8+KU
z1jyyeetNr5dVCv8Va1X8iMpSOU6hsWFDmNEx6B9raU799hyHhkIR+JHPoaCaHM/
qaBB+R44EkNPySHlL3JO1oryVfj7ivsbvJTkytAoUNxEUYUsSWlpVLUYu3fFQXfz
AoPuQcD91D80/axB/s7GNYoe88yfpwTL/r0TnkZxZhKmQFJjN1YrkvM85/DN3se3
9qvrfwdZn4lAHCe5SwwLuYfeVVtxKqlSewRdxB+2KkiDpAT+r02vX7P+mwIs0nCr
kVeMtNq4uZL6nkWDr5ur6sElmPBjw681aRNdl6t6yQiOF7QeqswP5kgt1M/3qQ99
0REpS7u3mL0=
=fMlv
-----END PGP SIGNATURE-----

--=-SFpBEkVfnKc+/EdYAA20--

