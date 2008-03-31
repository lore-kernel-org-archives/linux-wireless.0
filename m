Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42562 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403AbYCaMGq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2008 08:06:46 -0400
Subject: Re: [PATCH] b43: Add PIO support for PCMCIA devices
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200803311116.47928.hs4233@mail.mn-solutions.de> (sfid-20080331_101947_283793_A475F480)
References: <200803292101.16696.mb@bu3sch.de>
	 <200803311116.47928.hs4233@mail.mn-solutions.de>
	 (sfid-20080331_101947_283793_A475F480)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-s5thH2S/Y9uCp7DhFBfe"
Date: Mon, 31 Mar 2008 14:06:42 +0200
Message-Id: <1206965202.5468.20.camel@johannes.berg> (sfid-20080331_130650_171070_6A0395A6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-s5thH2S/Y9uCp7DhFBfe
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


On Mon, 2008-03-31 at 11:16 +0200, Holger Schurig wrote:
> > PIO is needed for 16bit PCMCIA devices, as we really don't
> > want to poke with the braindead DMA mechanisms on PCMCIA
> > sockets. Additionally, not all PCMCIA sockets do actually
> > support DMA in 16bit mode (mine doesn't).
>=20
> Does this mean there are b43 based compact flash cards available?

Yes, for example this one which we have a few
of: =EF=BB=BFhttp://www.summitdatacom.com/specifications.htm#SDC-CF10G_802.=
11g_Compact_Flash_Module_with_Antenna_Connectors

johannes

--=-s5thH2S/Y9uCp7DhFBfe
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/DT0aVg1VMiehFYAQKM8A//b71fPDHrVCDBDYQc7urq2lR4oRk0uova
gnQQJss2dWltp+borzhIUNh3hmXI6LPR2CmwGsOwRok3CZ1Ptp62Dx97K3ND2x2C
dneT68VHxVaZxDHl77QaY7puX/n4/maNit1r10z83d3FfhmPC3nORp36j/sa0Qjx
bnIeP9bH2LfIA1cwxpMX6pmbAO6s0wSMORQuzkOgH+N4hMatteqetPtPk5Zshb0Q
wq8WzoceoWDtb9CfmAlL92lABnrYozkqnrh4MN6xJx8RJt2aBGcku9DIP0q409Nj
uvjwiDfL7aVxWS0715vAASZ+2MgEE/fzUc4d+71c04WLJYP6nzuonBPpmkp0a17E
4TBr2KNBkwV3OiYI7UiEuW/Pwd45O++/KFGshASS3ARrEYeu/nzw4DSILdT94o/l
ORvVyYxOP+7cs/Kjyjh/L/uiI3cwuxsO4hkMbc2ygZKq2nZXhjA2Fe25TL+v0Kee
ClGERRHIiW8kK/0mdIPoL2jNH2uWI4WPpDr7EqMpQPAeUoOiWuOZBDEkZuHAkxWS
zntp4nPrAp7cx/pQWlf2BtbFw2/7FGi5QmT5jvmG5nJlfnfC639y9Zhq+2AgFfLz
OBFLmSGENd0GLdFij/uwqWWUviqSaR3zkHn39XJ5jjYtpMBIl6Xg3MbJmr/7x+ey
gSwCB9wxx+g=
=NNCQ
-----END PGP SIGNATURE-----

--=-s5thH2S/Y9uCp7DhFBfe--

