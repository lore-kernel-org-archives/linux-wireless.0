Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailguard.fgan.de ([128.7.3.5]:53205 "EHLO mailguard.fgan.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753AbZJUKGU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Oct 2009 06:06:20 -0400
From: Henning Rogge <henning.rogge@fkie.fraunhofer.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] cfg80211: allow driver to signal noise level
Date: Wed, 21 Oct 2009 11:24:34 +0200
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	John Linville <linville@tuxdriver.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <200910201413.29734.hs4233@mail.mn-solutions.de> <1256080691.4475.8.camel@johannes.local>
In-Reply-To: <1256080691.4475.8.camel@johannes.local>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1806118.XaqVUgGzfB";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200910211124.41067.henning.rogge@fkie.fraunhofer.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1806118.XaqVUgGzfB
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Wed October 21 2009 01:18:11 schrieb Johannes Berg:
> On Tue, 2009-10-20 at 14:13 +0200, Holger Schurig wrote:
> > Allows a WLAN driver to signal current noise level:
> >
> > # iw eth1 link
> > Connected to 00:13:19:80:da:30 (on eth1)
> >         SSID: SSID
> >         freq: 2437
> >         RX: 424 bytes (5 packets)
> >         TX: 0 bytes (0 packets)
> >         signal: -49 dBm
> >         noise: -93 dBm
> >         tx bitrate: 11.0 MBit/s
> >
> > Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
>
> NACKed-by: Johannes Berg <johannes@sipsolutions.net>
>
> As discussed previously, noise is not a property of a station.
Noise it not a property of a link between two stations, but a property of t=
he=20
local station alone (the point where the noise was measured).

Do we have a netlink part to put in properties like this ?

Henning Rogge

=2D-=20
Diplom-Informatiker Henning Rogge , Fraunhofer-Institut f=C3=BCr
Kommunikation, Informationsverarbeitung und Ergonomie FKIE
Kommunikationssysteme (KOM)
Neuenahrer Stra=C3=9Fe 20, 53343 Wachtberg, Germany
Telefon +49 228 9435-263,   Fax +49 228 9435 685
mailto:henning.rogge@fkie.fraunhofer.de http://www.fkie.fraunhofer.de
GPG: E1C6 0914 490B 3909 D944 F80D 4487 C67C 55EC CFE0


--nextPart1806118.XaqVUgGzfB
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkre01MACgkQRIfGfFXsz+DhFACdEm+q1zVSSiyvnabz7gXDuGQx
3M4An3/Fn5GfZrxRnNb4nqUSA6EnV1r4
=6tRT
-----END PGP SIGNATURE-----

--nextPart1806118.XaqVUgGzfB--
