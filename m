Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58324 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750959Ab0CGXUA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Mar 2010 18:20:00 -0500
Received: from deadeye.i.decadent.org.uk ([192.168.4.185] helo=localhost)
	by shadbolt.decadent.org.uk with esmtps (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <ben@decadent.org.uk>)
	id 1NoPlN-0006Gi-OW
	for linux-wireless@vger.kernel.org; Sun, 07 Mar 2010 23:19:58 +0000
Received: from womble by localhost with local (Exim 4.71)
	(envelope-from <ben@decadent.org.uk>)
	id 1NoPlM-0001wF-Hj
	for linux-wireless@vger.kernel.org; Sun, 07 Mar 2010 23:19:56 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1267932373.2819.393.camel@localhost>
References: <20100305155155.3578.80301.reportbug@celtic.nixsys.be>
	 <1267932373.2819.393.camel@localhost>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-PyfxhLO2Ts4KoNsdsUUn"
Date: Sun, 07 Mar 2010 23:19:55 +0000
Message-ID: <1268003996.2819.528.camel@localhost>
Mime-Version: 1.0
Subject: Re: iwlagn driver is no longer able to manage Intel 5100 AGN
 wireless controller
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-PyfxhLO2Ts4KoNsdsUUn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2010-03-07 at 03:26 +0000, Ben Hutchings wrote:
> On Fri, 2010-03-05 at 16:51 +0100, Wouter Verhelst wrote:
> > Package: linux-2.6
> > Version: 2.6.32-8
> > Severity: important
> >=20
> > Hi,
> >=20
> > Since about a month or so, I can not bring my wireless network interfac=
e
> > up anymore. At first I thought it was a hardware issue, but that's not
> > the case; under "that other" OS, everything seems to work fine.
> >=20
> > When I try to bring it up, the following ensues:
> >=20
> > wouter@celtic:~$ sudo ip link set wlan0 up
> > RTNETLINK answers: Unknown error 132
> >=20
> > Ben Hutchings told me on IRC that error 132 meant ERFKILL, i.e., that
> > the RF kill button would be engaged. But that is not the case; and
> > toggling it does not seem to change anything.
>=20
> Is this a known bug?  Otherwise, can anyone help Wouter to debug it?
[...]

Wouter subsequently reported that the BIOS battery recently ran down,
and that reflashing the BIOS has fixed this problem.  It sounds like the
BIOS state was somehow corrupted and that this resulted in incorrect
reporting of the hardware rfkill state.  Something to be aware of in
case anyone else reports similar symptoms.

Ben.

--=20
Ben Hutchings
The most exhausting thing in life is being insincere. - Anne Morrow Lindber=
g

--=-PyfxhLO2Ts4KoNsdsUUn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUAS5Q0h+e/yOyVhhEJAQIHUQ/8CeJQ4p1ev6ndrKzFEQcS2bxmJBDD7xL9
zUShrEW6rB/NO8Iqr8uNNtL4YLy96YtOIplTgKszpjyeOZ/t1QXvjhaSfSL/o2U3
5GA8pPzhL56bnXBNZrWBA9/do85+GICvVQgNkzdZjZ2lr3Uy+sJuZq3F6epIMW2V
M24bW17E32JA5gkJ2FqtUi/7BRBFDCTGUpnbC9g0Bezw2LW1gcsIldS631Axn4U9
ASPGGPWq/e0ipzLcs2K3s9H+hNrtazQAld0yCQFo2L0WM7B5ZR+7tM2VPZ/gEXYq
LYXWRDUYQND4Xs335ht1ZkM7u6TiV/hkRY567yKq7l7R4Ea24fFY3vb/nbKt59hT
rSaTvLijCFGIpzb8C4AqjCeqWalRVlZsq5EBM99sfRmidWDdP1K7e8Q3dQC4tvzR
SRR7yBxaT9x+zbxyJ+ZOW5r+KFBqePcXUqZ04+8aWMEtxS6wOeF737Gqx8jZBPoP
CbXaYQyTzL0w+Ip31yl3uqSM9/dy0VkffNKrtMxKDwb09zYCNMgzVhI7Dul+CCAj
wddZGPzZExnKcsbL0HLddZOg3g6iuuH9F7vwKljl4fWaXvWepAdJwIbdz4WgNzMk
TtXT32AtAuuqHsDLHAUO6gu1bq8eBXvRLCkL7g8N01kdM93QCMhIec3V07TKS4pk
cyvuj+pNaRc=
=3VGv
-----END PGP SIGNATURE-----

--=-PyfxhLO2Ts4KoNsdsUUn--
