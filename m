Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60988 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284AbXLQRrp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Dec 2007 12:47:45 -0500
Subject: Re: [patch 4/9] mac80211: Make PID rate control algorithm the
	default
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Mattias Nissler <mattias.nissler@gmx.de>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20071217144859.GB3121@tuxdriver.com>
References: <20071217001956.640555983@gmx.de>
	 <20071217002056.351743954@gmx.de> <1197852547.4885.1.camel@johannes.berg>
	 <20071217015004.2400ab33@morte> <1197852873.4885.2.camel@johannes.berg>
	 <20071217015748.5bb3f7fc@morte> <1197853758.4885.4.camel@johannes.berg>
	 <1197885374.7514.6.camel@localhost>  <20071217144859.GB3121@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-DekhIu0/yY0GBKl2xU6s"
Date: Mon, 17 Dec 2007 18:42:15 +0100
Message-Id: <1197913335.4885.53.camel@johannes.berg> (sfid-20071217_174747_775514_E61DE728)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-DekhIu0/yY0GBKl2xU6s
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> My "Spidey sense" tells me it would be good to keep the old one around
> for a little while... :-)
>=20
> Besides, as we have seen recently people often get quite upset when
> you remove a feature that they perceive to be working for them --
> no matter how much better the alternative may be.  It would be better
> to give them some warning.

Then we need to introduce a Kconfig option for making the simple one
default because we don't have run-time switching yet.

johannes

--=-DekhIu0/yY0GBKl2xU6s
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2a09qVg1VMiehFYAQLYHA//YIfJ77/YiXVs7qEaQHwk5tnixmtLi7f4
3MGpgLWIQQztva7oCwHp9gtRdUpg+oTwqlq6TdZlO0Ag5tFbOEzBYoHz1gii3RA+
PO4OT5BGh8vo7UXDWSPzgYW7Smcdym5PiyKYUD2Pim37N7D8862nhHU9mriThdEv
Re5aTwCvXNGV/Wh4kr1BbGS96dTWHs9F4h/ZefoLfI5hfCns+SeCUw5XC37IRmOH
k/dt3Gj2OOye6fqlscsY4FFTvbozLo7qZDYJrPYFQDgb4UPRPcxZb8dm6Ylvf6qT
QP01qURhvdoZvyYkE2iAXEkNXj4khd/R6UpqTPweLHOuTfIiPIq9CE0TX9IprOVm
eIQoVt4xNX1qP+Az/WAGIWHLcqt+nCuol8YF7do1us66EJPQk4TBOFdicAmcZgdO
GFeZYqLo/HC50c7W28bI+hiMSvVOgkfyd+7VKPIjG4LMVzOj94lddB67P+XHcuqQ
/0JJqjZiDWAZtojC7Hc3VQ8YbcrCEbO0OjZkvpaaFLfUGQY9lAb3RPoZTkVcPjzD
n+nGpzaeIvnE7+yLN0yyjZjVmezNh895ef/nU6nFxtRw5MEhZqA4lOE+7hajbimz
K5vL+PCV7fcfRpoynt9KTLYs1tdr1SJls+jl8JYs2pJh1AuZXWODi3WUo/AH+AfE
hogtfrbNcJQ=
=I2XI
-----END PGP SIGNATURE-----

--=-DekhIu0/yY0GBKl2xU6s--

