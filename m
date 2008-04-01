Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35373 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755690AbYDAME7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 08:04:59 -0400
Subject: RE: "Try to stop Tx aggregation on non active TID" messages
From: Johannes Berg <johannes@sipsolutions.net>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
Cc: "Rindjunsky, Ron" <ron.rindjunsky@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Tomas Winkler <tomasw@gmail.com>
In-Reply-To: <D936D925018D154694D8A362EEB08920040FA21F@orsmsx416.amr.corp.intel.com>
References: <1206568750.22530.8.camel@johannes.berg>
	 <c85cb4470803280145j42bcf1b5kfcfd220b5b6cf76a@mail.gmail.com>
	 <c85cb4470803300456y75ced072ue89ea3f2dbbdce8b@mail.gmail.com>
	 (sfid-20080330_125632_683065_10482C70) <1206964750.5468.9.camel@johannes.berg>
	 <D936D925018D154694D8A362EEB08920040FA21F@orsmsx416.amr.corp.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-B4tP0yqKk5N+/tpsUvTX"
Date: Tue, 01 Apr 2008 14:04:55 +0200
Message-Id: <1207051495.5143.60.camel@johannes.berg> (sfid-20080401_130503_892192_8494B46D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-B4tP0yqKk5N+/tpsUvTX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Mon, 2008-03-31 at 14:00 -0700, Chatre, Reinette wrote:
> On , Johannes Berg  wrote:
>=20
> > [1] as, incidentally, you can see in the current wireless tree from a
> > few days ago, iwlwifi with debugging doesn't even compile!
>=20
> Could you please send the errors you see? The debug flags recently
> changed, so the following is needed:
> CONFIG_IWLWIFI_DEBUG=3Dy
> CONFIG_IWL3945_DEBUG=3Dy

I'll double check and send if anything still occurs, I realised (after
sending that mail of course...) that the error was from the machine that
has the card in it on which I might have forgotten to update the kernel
sources.

johannes

--=-B4tP0yqKk5N+/tpsUvTX
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/Ik5qVg1VMiehFYAQJeKhAAkV7YRR5xctj3pqCAe8iADruflzZZEM+M
gfJrL6DNHqcg/Y+wFSUY71TCqzeZYDIfezmzFfxmio5aEAWdLnLrqVm5/HsVL1Bq
P3VTkWowEqfE8n+GhT2reiZG2Ujustqb4iSf0XQzBMIl0qaDQtOiolDzgBmo14fD
tf/d8Pv994c/LmK9qBgsPU8VXio8Yrr2HhJtufyOyitRTC8/kBv/k4AkMlfE7Dfz
+KOsgzCCpVRl+h7rA7+zL4t6lWW15QUOu4r38qSAh0bOcr+fZXiu1hy6vq+x5hVk
YeL/tiBUPTQncn/D1k0OpVuFw/XwssMuDUGgBznwrp2tq0RFpNxlwACqlVibVcOn
Kst3HJo1noRPG5AMaSr4b6Lg4j/al+SU4lov2z016zg2+HMVAo7kCls37G1bD/Zg
Nb5snJGyepgVEJK/grVkTMm1A2YsqqJwGOi0Kls0Ty8czDNqyiAz5DIdmt2yxPhP
lciSRkVl7FioKS6WcEYmx+amMDyKKq3dgQo8GT5QBr5Qt5Pb9J/n0lMPIvzNpPcE
DQRdBF+9eJdlYHKi1IrWpYpRCm6J1YHtxI1WqFlHdTF/sqp3TUt6u0MWb1GUtT0U
LjdyL/xScVFyt6JjmvS6Vm3Bq/J9qPY1vTuhZc6cVu8MHSCMEZvbHnufdIw5sju6
nSxGMFHgpUs=
=mhJz
-----END PGP SIGNATURE-----

--=-B4tP0yqKk5N+/tpsUvTX--

