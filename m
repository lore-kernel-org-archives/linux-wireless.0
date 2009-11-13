Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41165 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbZKMH3O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2009 02:29:14 -0500
Subject: Re: compat-wireless and minstrel
From: Johannes Berg <johannes@sipsolutions.net>
To: Adam Wozniak <awozniak@irobot.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	Derek Smithies <derek@indranet.co.nz>,
	linux-wireless@vger.kernel.org, nbd@openwrt.org
In-Reply-To: <4AFC8F0D.5020700@irobot.com>
References: <4AF0D54D.4090303@irobot.com>
	 <alpine.DEB.2.00.0911111508391.6214@kauri.acheron.indranet.co.nz>
	 <4AFC655A.5020706@irobot.com> <200911122103.27455.chunkeey@googlemail.com>
	 <4AFC8E4F.5090307@irobot.com>  <4AFC8F0D.5020700@irobot.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-yKFPs4ILo8diYzfBBSoK"
Date: Fri, 13 Nov 2009 08:29:12 +0100
Message-ID: <1258097352.3899.75.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-yKFPs4ILo8diYzfBBSoK
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-11-12 at 14:41 -0800, Adam Wozniak wrote:
> Whoops, patch was slightly incorrect.  This is better:
>=20
> *** compat-wireless-2009-11-09/net/mac80211/ibss.c    2009-11-08=20
> 21:15:06.000000000 -0800
> --- compat-wireless-2009-11-09b/net/mac80211/ibss.c    2009-11-12=20
> 14:39:12.391545084 -0800
> ***************
> *** 246,254 ****

[snip]

it would help if you used diff -u

johannes

--=-yKFPs4ILo8diYzfBBSoK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK/QrDAAoJEODzc/N7+QmaP40QAI05kytYttzncbBfnDRCJVYT
mPSZHWwT09evxbU5MbOPdTAleKc8+iZ9MlHAWBuxR83it/kXxxi6nwQ2HAjV8AKW
hDE80usrY3Hc3mKia5kIZmSoqduDqiFzGmvgYVdYuEzGrp6YwEkiMBiUYtstXbnQ
znzjKb8Bu3eAeuSu2q95itGP6wMxJ8GZxvRdtDWD36yqKZeO6YX+vUzb8aH63PcL
bq1iPi14zsZaRedKRZNUsKB9gg+ksGjkD15fnny0XvELYapiMZX8xzoces9iSrLl
is8Ar2tuw81EhkuQq29PzWGoLTsECsI0eZBKsWz/MuWT53RxrQ2brL1z5wd+ju2l
ZD3jMtZAotUWF3hZsZXHrvBTeOKpsjw1oKQJ+i5QmBgO+LmHE5V24Z4ksL+g2eu+
iobglqd/xffRkIwv1xaO0KGg9pTPbNYR9vjZ8ocb7f/Cnq4jprz0Sqv7tTuLorFp
sld0qzqrTzLkCQzfjurDjLFsc6AMNcvzDHCrobW2hZk03HmCFWr4iylw/oW+nj1v
T8z/Dnf7iczimjk26C9GJAIBc56gIfBv09498ItSVtp8yhvSXse4EdqG4ti3Qkis
GHZWw9rcbSnORmMe2muQKsmmbC1Novg6YDmNHz7WObdcXrv6qIRcqCYw5zky61qW
3sKYwImrE9Er7RIxVODb
=u0fk
-----END PGP SIGNATURE-----

--=-yKFPs4ILo8diYzfBBSoK--

