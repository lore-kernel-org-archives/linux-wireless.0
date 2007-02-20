Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55096 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965234AbXBTIXr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Feb 2007 03:23:47 -0500
Subject: Re: Capture of unsuccessful ARP exchange
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: Jouni Malinen <j@w1.fi>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
In-Reply-To: <1171938483.10139.13.camel@dv>
References: <1171935085.8133.42.camel@dv>  <20070220015851.GE5279@jm.kir.nu>
	 <1171938483.10139.13.camel@dv>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-iX0xcU1TNJt78vL2ywTv"
Date: Tue, 20 Feb 2007 09:23:35 +0100
Message-Id: <1171959815.15489.75.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-iX0xcU1TNJt78vL2ywTv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-02-19 at 21:28 -0500, Pavel Roskin wrote:

> My first assumption was that the field QoS confuses it, but looking at
> the code, it's more likely a low-level problem. =20

bcm43xx firmware can definitely handle QoS.

> I'll try to see if the
> frame is even seen by the driver.

I would expect you to find that it is not, but just run a monitor
interface in addition.

> I agree.  The frames are either not received physically or thrown out.
> Which makes me wonder why the association happens so quickly.  Perhaps
> it's done at lower rates.

Could you start capturing earlier to confirm this?

> When ping finally starts working, all the data is transmitted at 1Mbps.
> And the QoS field is still there , so it's not a problem by itself.

Didn't you say that you're using mb's tree? You have a 4311 IIRC so I
wouldn't be surprised if there are problems with receive sensitivity
that go away after, say, two minutes (recalibration interval).

johannes

--=-iX0xcU1TNJt78vL2ywTv
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF2rAH/ETPhpq3jKURArZ7AJ0emlpE7DwWyzJC5+fFrp++zmlDFQCfSDaw
wjrDH0/Eo03JoRdWEucQimI=
=huoe
-----END PGP SIGNATURE-----

--=-iX0xcU1TNJt78vL2ywTv--

