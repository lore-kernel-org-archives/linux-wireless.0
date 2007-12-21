Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33481 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821AbXLUQgg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Dec 2007 11:36:36 -0500
Subject: Re: [PATCH] mac80211: remove useless sdata variable
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Andreas Schwab <schwab@suse.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <20071221141557.GC19874@tuxdriver.com>
References: <1198195385.16241.68.camel@johannes.berg>
	 <je63ysp7ua.fsf@sykes.suse.de> <1198240471.16241.70.camel@johannes.berg>
	 <je1w9gp5ll.fsf@sykes.suse.de>  <20071221141557.GC19874@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-LadfsfHyRt4gCnoedOKK"
Date: Fri, 21 Dec 2007 17:35:48 +0100
Message-Id: <1198254948.16241.78.camel@johannes.berg> (sfid-20071221_163643_736553_26BA2BA5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-LadfsfHyRt4gCnoedOKK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > >> > --- everything.orig/net/mac80211/ieee80211_sta.c	2007-12-21 01:02:=
11.253160428 +0100
> > >> > +++ everything/net/mac80211/ieee80211_sta.c	2007-12-21 01:02:32.11=
3165907 +0100
> > >> > @@ -458,12 +458,10 @@ static void ieee80211_set_associated(str
> > >> >  		return;
> > >> > =20
> > >> >  	if (assoc) {
> > >> > -		struct ieee80211_sub_if_data *sdata;
> > >
> > > Too little context. There's another one in the surrounding scope that=
 is
> > > already initialised exactly the same.
> >=20
> > Sorry, but I can't find it.  Was it added in an unmerged patch?
>=20
> I think I'm with Andreas here...?

Hmm. I guess it was then.

johannes

--=-LadfsfHyRt4gCnoedOKK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2vrY6Vg1VMiehFYAQJsPA//V50f+7FbqQwEJxDZw4jbSxiFLBnxPYm1
/kT65wQWVgETCdEaDLllpBWsc7tifGUQSWBFKRzYzw1AOt1mamxeqcyLC2zaCO9M
wsRdxMMt0F6bTH5aLlgRBCjPiGvZaGX/HPrDJulC+zgVioqK1oGMEKb6+H4puCQd
U0mNvipvcKBZNPP5s2v45R3TZIJqfnhK1u2hHwU9e+f4ApBFMa5QJ5ou8fL5g6o6
GMeyd8u2CiYFz22ulRMAcLUsUWdaKRSoB0j92oaTciclUfA9C08Tw5mJfe4NDppv
HwRrXpDkcdOjyqNONjKYzVXlfbrLKeYZMaojafvy+wShESH5eaN0fb9AGdiBScCn
a5mF9A5unuw+IXwXl3RLCQ+ZuvH+leSwB6OGrJUp2vOAtObSmrWBMslLf3sh/1DQ
fFShohqLydp+7w+OQMj6DOMiXfw7cA74WLkb0Pv5OoeHEGzBRtEplXcUoba9Y09r
2i5RicxRaQN6l3CWF8gGi0sZ3FUNvIK0oB4ijlnS0/MZ6M+ThcqY8/UrVDTJKV0b
ssULl83zj7qPCNeiuu2zGq35f+4L82CZS6pz4MTRvqBbhjrOmhTr/OiX2lTxGc8f
Js8qJgTOFhTHasoLK6RDreblwJjaX+Ikw/p2XEzbPb1uAunnww/VqQ/B33qiSaVD
Lm1SlW22wmA=
=Rhy8
-----END PGP SIGNATURE-----

--=-LadfsfHyRt4gCnoedOKK--

