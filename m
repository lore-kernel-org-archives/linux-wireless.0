Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37322 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757AbYJIJwd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2008 05:52:33 -0400
Subject: Re: [PATCH] iwlwifi: get rid of IWL_{GET,SET}_BITS crap
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Christoph Hellwig <hch@infradead.org>,
	Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
In-Reply-To: <1ba2fa240810080538i864b901kc8e6e694004dbade@mail.gmail.com> (sfid-20081008_143818_988617_8BC13653)
References: <1223311803.15196.36.camel@johannes.berg>
	 <1ba2fa240810070703j471faa30mce3678febf3c20e8@mail.gmail.com>
	 <1223398724.7328.45.camel@johannes.berg>
	 <1ba2fa240810071228m52a60861r5558529426b9b487@mail.gmail.com>
	 <1223408085.3618.2.camel@johannes.berg>
	 <1223408342.3618.7.camel@johannes.berg>
	 <1ba2fa240810071306sb282e06h9d29ea2c36f5c3d5@mail.gmail.com>
	 <1223410226.3618.13.camel@johannes.berg>
	 <1ba2fa240810071346n506b8f1clffaebb7f1f72a10f@mail.gmail.com>
	 <1223452923.3618.25.camel@johannes.berg>
	 <1ba2fa240810080538i864b901kc8e6e694004dbade@mail.gmail.com>
	 (sfid-20081008_143818_988617_8BC13653)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-o4uPLoN4bqiX3ODkpy1+"
Date: Thu, 09 Oct 2008 11:52:29 +0200
Message-Id: <1223545949.22490.26.camel@johannes.berg> (sfid-20081009_115237_222690_DEF328A0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-o4uPLoN4bqiX3ODkpy1+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-10-08 at 14:38 +0200, Tomas Winkler wrote:

> >> > Also, keep in mind that address 2 is _never_ used at all anyway
> >
> >> This is not correct we always use first 2 pointers. First for tx comma=
nd
> >> second for the actual packet.
> >
> > Ok so you use two.
>=20
> My only point is just to make sure that you understand that __never__
> is not correct

Right, sorry, I really should have checked.

> > Writing three words in total. I strongly suggest that
> > you have WAY more trouble in iwlwifi than an imagined performance issue
> > coming from a corrected and understandable struct layout.
>=20
> You are rally trying breaking into open doors Currently I'm more
> concern with correctness then performance so I wanted to rise
> hopefully all issues.
> I'm testing your layout it's work so far in my home setup. I'm on
> holidays till EOW so I will be able to give it some more stress in Lab
> only next week.

Sure, that's fine, I can't really see what can go wrong but testing is
always good. It just seemed to me that for some reason you preferred
keeping the pair-layout and complicating the code?

johannes

--=-o4uPLoN4bqiX3ODkpy1+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI7dRZAAoJEKVg1VMiehFYafQQAKZzPOkTRvAhP+R/t93jqbGP
vhtA+S1iR84pcf01KprEkyIoWrUV1FsuCzV7aojqkwL43q4nPqWh5fTh7AalypLP
jazrNlr2zlJTiQn0LuhObWEAe57aoRHl8+6TjrT3KMmzUubG3b7CP1/zM4cvpMOL
FINAno1/8+vjCB107VYktzj+1Lx43+z6QT1diDmuyATzUTWloryARO15/ONrJrHk
cTwo9gkCELQzN2WBK+4DiAcWg88AlXs5W+0W9PYwaEXzPiK9pNZPX+lHunZgGJDp
1qax6ru1p3uCVHlsPw7Un2QsukEhpoFhzjNVJKYxfPa2okhOl0IMEx3wEab4gewL
gB0p2v9HuPeNOU5LuRRySjdyFP/zI6sdxfjPr0ky2OErxcagJvuw4gXOZf78Y780
t6qNVJLqqjioFaK/W4VXl7AYAmNQlzNG2J/YNBAOsuZdJsz1ww36BT+Nybp9ya6t
aRaHSCghHwj9+YEUdNLlD3MBcXQkqCiBv616U3UaxptOWQ7GUTZWyBD5A92PDwRh
OHSTIUsPhlD+REGqe3z/3VgIatV5j11GXB+XzzS2AMwZry70YtghZqYFfAV8l0J/
J2lKSUzHTXJeS3GQmvkeO1X8V2ae41SbzGThETwcEp7u1NpWsC2MI6DsyAPhTcER
iHFgoWgxHUBfqGVBQD0a
=ZV1+
-----END PGP SIGNATURE-----

--=-o4uPLoN4bqiX3ODkpy1+--

