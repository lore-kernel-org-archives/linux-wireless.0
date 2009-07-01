Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44940 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500AbZGATyC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2009 15:54:02 -0400
Subject: Re: Insist on cfg80211 for new drivers?
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Dave <kilroyd@googlemail.com>,
	Karl Relton <karllinuxtest.relton@ntlworld.com>,
	dwmw2@infradead.org, linux-wireless@vger.kernel.org
In-Reply-To: <20090701193657.GD3473@tuxdriver.com>
References: <1246388712.4949.52.camel@localhost>
	 <43e72e890906301217m2dec7bfaqea0472907531d21d@mail.gmail.com>
	 <1246396179.4949.76.camel@localhost>
	 <43e72e890906301458y197c5411yfb93ea0089ed49f3@mail.gmail.com>
	 <1246464991.4331.18.camel@localhost> <4A4BA21F.1070101@gmail.com>
	 <43e72e890907011112l220874bbu8db8808f666bbd4d@mail.gmail.com>
	 <1246473300.30522.10.camel@localhost.localdomain>
	 <20090701193657.GD3473@tuxdriver.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-RrhZg9HeGiX7FtHCoQfV"
Date: Wed, 01 Jul 2009 21:53:39 +0200
Message-Id: <1246478019.8154.10.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-RrhZg9HeGiX7FtHCoQfV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-07-01 at 15:36 -0400, John W. Linville wrote:
> On Wed, Jul 01, 2009 at 02:35:00PM -0400, Dan Williams wrote:
>=20
> > That's really all I
> > care about, I don't want another WEXT-based driver accepted; I want all
> > the new ones using cfg80211.
>=20
> Now there is a discussion we should have had in Berlin...is it time
> to insist on cfg80211-based configuration for all new drivers?

Can't imagine there would have been much discussion on that with the
crowd that was there -- I think we should. In fact, on the notes was
"publish a wext deprecation statement" or something like that.

Just like we insist that nobody adds an entirely new wireless stack, we
should insist that nobody add a new way of interpreting wext commands.

johannes

--=-RrhZg9HeGiX7FtHCoQfV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKS76+AAoJEODzc/N7+QmacOwP/14AtPL6M309evNKLeAFlp/d
pCxv/0a+KdADriI0G6E7pRetThTSkKhMIFG+bBp7By06cbEDORHDe64X+nO0B80B
6pvNZuFAQTc4j0zd6JaGOhf+mwkk/TAguWxovavHo081Me3e7U02S1jWsRUwsdUl
P5XTzEvHh0vNUyAVtWQmFxyb1JD2m5s9z646FoePrdMSdhs5oIAVKeQxFU+fkYnw
PkGAVYgTsxufrguGf42vuwCa3Kw0PVSikrGftMbojkN3AjD6o2d+GdrAufZw8SRA
WwNkj9kLCnoviYqeYU8nY5eSWc4civTIjOQMT6SJVArGiWaz+JMvtscNXUP2DYJQ
OIg8/jxwne8VT1pf+XLnpumgPDIehap1ROTaW+BStSBOY1u3T8bq3m9H36yqVTv+
sonXN4sLbM5opky05FvT3dvP20mznsEsj2tZk3YbrzxztScXPcg/3uuYMfwLo5nB
Pisc4eh5JcQIxDDf3rPQM8kZ9yNdf8YKYsETMiGUai/xmNNs55kTBElArkRawayF
q7n3EJXFxIApkvjBuQKjBGOgdZfY1hCAuyZNx/Mb8daVvCvFI+vjb0KveiGPPPtN
poHjt0kTsx20YyglgQKcHZK04arzRcF06ok/VU5rdW7pCeNo7gGJvgYWWIWB1s7Q
mpPb5ZGGE5lytHjU+63P
=Rs4y
-----END PGP SIGNATURE-----

--=-RrhZg9HeGiX7FtHCoQfV--

