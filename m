Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50086 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332AbYDSNvr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Apr 2008 09:51:47 -0400
Subject: Re: RE: iwl3945 problem with 2.6.25-rc9
From: Johannes Berg <johannes@sipsolutions.net>
To: Vincent C Jones <v.jones@networkingunlimited.com>
Cc: Tomas Winkler <tomasw@gmail.com>,
	Brian Morrison <bdm@fenrir.org.uk>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>
In-Reply-To: <1208612902.26186.23.camel@johannes.berg> (sfid-20080419_144855_272045_BB1CE2BE)
References: <D936D925018D154694D8A362EEB08920043535A1@orsmsx416.amr.corp.intel.com>
	 <D936D925018D154694D8A362EEB0892004353826@orsmsx416.amr.corp.intel.com>
	 <D936D925018D154694D8A362EEB08920043539AE@orsmsx416.amr.corp.intel.com>
	 <fu931e$k1b$1@ger.gmane.org>
	 <D936D925018D154694D8A362EEB089200438B6D6@orsmsx416.amr.corp.intel.com>
	 <1208555842.4848.56.camel@johannes.berg>
	 <D936D925018D154694D8A362EEB089200438B728@orsmsx416.amr.corp.intel.com>
	 <20080418232358.000fbdf7@peterson.fenrir.org.uk>
	 <1208558255.4848.60.camel@johannes.berg>
	 <1208558382.4848.63.camel@johannes.berg>
	 <1ba2fa240804181728u7a3440cajbba7dcc696d02909@mail.gmail.com>
	 <1208593973.26186.2.camel@johannes.berg>
	 <1208608786.3980.7.camel@X61.NetworkingUnlimited.com>
	 <1208610565.26186.17.camel@johannes.berg>
	 <1208612641.3980.31.camel@X61.NetworkingUnlimited.com>
	 <1208612902.26186.23.camel@johannes.berg>
	 (sfid-20080419_144855_272045_BB1CE2BE)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-idqIGLylCYjbZZeyOcli"
Date: Sat, 19 Apr 2008 15:51:31 +0200
Message-Id: <1208613091.26186.26.camel@johannes.berg> (sfid-20080419_145158_595407_A63CFFA9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-idqIGLylCYjbZZeyOcli
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > I'll leave it up to you (collective you, not necessarily a personal
> > you), how to best deal with associating with APs which are not
> > broadcasting their SSIDs. I agree with you (personal you this time) tha=
t
> > roaming around the country broadcasting those SSIDs does not seem
> > particularly desirable. So how should the ability to connect to non SSI=
D
> > broadcasting APs be implemented?=20
>=20
> I would probably list, in network-manager, "I found (a) hidden
> network(s)" and ask the user for an SSID to scan for actively at that
> particular time, rather than trying to scan for all previously known
> SSIDs even if those networks weren't hidden, as windows laptops (at
> least those with Intel hardware but I haven't seen many others) seem to
> do.

Or it could remember the BSSID and when it encounters the BSSID again
scan it actively to see if it still has the same (albeit hidden) SSID.

My N810 behaves that way too, incidentally, it seems to first scan
broadcast but if you then don't select a network quickly it starts
scanning all networks directedly that it has previously saved.

johannes

--=-idqIGLylCYjbZZeyOcli
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASAn44qVg1VMiehFYAQKRVxAAlav+hl8E//Wh4go822eVkwiKjC6FfA1X
bphGt4368jVmpnW8+9wmj14/YQaG5xv48w8/GUHl2qFfMPQwq/TovVLZwoPnAUs9
VUVVL8DIrMFNMvibtpNA4ySMQSe29uohi5l2RQk9Qd7t+RQgCuN+arFAgVi+cFjJ
zkISpaYDxjR2cnZYfcNBax+e+tw9mh4BxiCh4QDPyySP5dW84p/vq6t4I1Uio4Se
X84uRFBEou1Pg8k3NQdoW7cZzK3W4pr57+D6hWfZT73YyKWFQKwlmhNSbyJgiWfB
zBNPe5/Kc2DRIES9TD4lgU70LMoNEvTzTZP5NumQze/pQGGBso6TJ/2VDO5Kmcfu
GYzPtYgiQkwXstkLo4l3xuPnRbwTxR0DZ+aiPnJCIwerwg7lDGl+KXLAKrJ+igw9
clYcGnhIsQN5tz7/s8PgDK/A22CZJijZLqAlJfIP5v3D8TDS6UZ95IFaaDKGvtl9
FepNP7evb6Fnad9l9rumD2zlfn5X9yNYfT28D/j0KfL7ibjPvU7V9KmjJ4Uviffh
ZOykeEjDUD23D7HJhteKM2s/Zvnh7UkESZewvmRNxDEtEip0MaucAt0z+kcwC1xd
dwzWAk1iLwMGr14Tvr6Y3JF00dfSyX2fbJQ1yCnm8uMmDJsTQzmaIy7N1RYX4QBM
6Dyq3DkIx3s=
=N1Tk
-----END PGP SIGNATURE-----

--=-idqIGLylCYjbZZeyOcli--

