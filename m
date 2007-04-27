Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:34476 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757232AbXD0UvH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Apr 2007 16:51:07 -0400
Subject: Re: Wireless rates with mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: Jiri Benc <jbenc@suse.cz>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <46325F58.5070808@lwfinger.net>
References: <462F9617.8010207@lwfinger.net>
	 <20070427221153.7ecc04de@griffin.suse.cz>	<46325B51.7090506@lwfinger.net>
	 <20070427222932.548519eb@griffin.suse.cz>  <46325F58.5070808@lwfinger.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9hpItHD/ZjD/ez06bvnr"
Date: Fri, 27 Apr 2007 22:51:08 +0200
Message-Id: <1177707068.3565.61.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9hpItHD/ZjD/ez06bvnr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-04-27 at 15:38 -0500, Larry Finger wrote:

> No, the simple rate algorithm is fine. Once I make the connection, it is =
changing the rates up and=20
> down as I would have expected. The main problem was that I never got on, =
and without communication=20
> there was no basis on which to adjust the rate.

Hah, I had the same problem and always thought the dhcp server was
somehow a bit buggy because re-doing dhcp fixed it (it sends a bunch of
packets and then the rate gets adjusted down). Of course, I don't have
any problems to associate since my university still runs 40-bit WEP.

johannes

--=-9hpItHD/ZjD/ez06bvnr
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGMmI8/ETPhpq3jKURAjA+AJ9qGVGF50qQtGfZT3aq3wlR6MKyHACgiju9
wd6tcAvg/dHfDipDN92IEtE=
=YgpK
-----END PGP SIGNATURE-----

--=-9hpItHD/ZjD/ez06bvnr--

