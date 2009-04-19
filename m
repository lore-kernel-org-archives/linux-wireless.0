Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35971 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805AbZDSSAu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Apr 2009 14:00:50 -0400
Subject: Re: [RFC/RFT] cfg80211/nl80211: add IBSS API
From: Johannes Berg <johannes@sipsolutions.net>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20090419174538.140620@gmx.net> (sfid-20090419_194610_734041_B2E7FCEC)
References: <1240094996.21583.1.camel@johannes.local>
	 (sfid-20090419_005015_625875_1781AFCD) <1240147370.898.0.camel@johannes.local>
	 <20090419143337.158810@gmx.net>  <20090419163204.158820@gmx.net>
	 (sfid-20090419_183237_340935_6640098A) <1240160041.28138.0.camel@johannes.local>
	 <20090419171546.158830@gmx.net>
	 (sfid-20090419_191552_279073_CA045D96) <1240161550.28138.6.camel@johannes.local>
	 <20090419174538.140620@gmx.net> (sfid-20090419_194610_734041_B2E7FCEC)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-331CmDPTo6GXZP44smRp"
Date: Sun, 19 Apr 2009 20:00:47 +0200
Message-Id: <1240164047.28138.9.camel@johannes.local> (sfid-20090419_200052_935873_60C3752D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-331CmDPTo6GXZP44smRp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-04-19 at 19:45 +0200, Alina Friedrichsen wrote:

> If you set a channel you want the IBSS on this this channel regardless
> if one already exist or not. If you don't, you never mind on the
> channel, even if the IBSS don't exist.

No, that's not true, you could well want to create your network on a
channel that isn't used that much or whatever.

I'm going to stop reading this thread now -- there's no value in it
unless you can actually come up with new arguments.

johannes

--=-331CmDPTo6GXZP44smRp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ62bMAAoJEKVg1VMiehFYwbsP/2uY5rla3S4rEt2SBTqsDAM8
EptyDBXmJ7Bndi5LeQTIUPTbagoXrZLOkpmfueCtxFprPAxe1FBIcji17OwEupxb
lBQv92gL1pvctclFENX3K7eDeEQg/CZDdDY7MPzk6t2NK9nH+jkWU5NnSy1tOBVU
EiVGszZDNEwbcbOgbW4cCLq2+JzOwK9O3tlc4Odog7YtrBGGVca7vVgO4y/T2pyK
ml/7UYtjn3kYb5QcassUHeUunKh2mrvUMkDVFLvj9ovGmJvtdd87Qez9aoC0vx72
DVv+kpb8mIgAkpVUBUFpf/yxB1szICpbrzHEbEWv029jyXkWmCkpliUNwGIZ+KP6
aSnHOyUBzFqohWf6fML8bvUmC3xq7bl5Do9/JVTOG7G7Z0Vs7fGVc8myuc/1XlPC
Q5oD0YUOIREK7SdqQH7z4atK0xyktgGFqZisP8w3RNCFuQ3hoXUld/uQxwsjqk2X
TKX+BKqcEmkT7KXkmTfdGCjgqvf3piYxSqgE1a6njDHFls2JN9pe3aqMEtuHj4Ws
HitpeQtP93xhGLgftlO5EmUcT2FetljcnztIq8IXHeWOqT3CTMFArycK76NPi+Go
0BMZEQs5jcCPsHqt1/Q8yss6sEGnVwnaUwCdRfYklbwCjFe8Rp6I7Fny5AWNI2XN
8FazhUcD+yEjKk/rQaDZ
=2Vbr
-----END PGP SIGNATURE-----

--=-331CmDPTo6GXZP44smRp--

