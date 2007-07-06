Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55415 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbXGFNfn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2007 09:35:43 -0400
Subject: Re: Multiple interfaces in mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <9e4733910707060622h26926ce2mf13b36e3a539194a@mail.gmail.com>
References: <9e4733910707041723g6f7a535ap1a62dd4473484d40@mail.gmail.com>
	 <1ba2fa240707050530q2d165232raa73455397546c62@mail.gmail.com>
	 <9e4733910707050632m794944b5nb9ac9393b05dfa75@mail.gmail.com>
	 <200707052154.24976.flamingice@sourmilk.net>
	 <9e4733910707060533y3bd3b4a5v5f0441f0d6e76377@mail.gmail.com>
	 <1183725861.3779.0.camel@johannes.berg>
	 <9e4733910707060555s224b485ege5ed6024c7ca6b30@mail.gmail.com>
	 <1183726738.3779.2.camel@johannes.berg>
	 <9e4733910707060600x51f7b967p9ac6e1671f0713ef@mail.gmail.com>
	 <1183727663.3779.4.camel@johannes.berg>
	 <9e4733910707060622h26926ce2mf13b36e3a539194a@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jdfA2Wcfz5iWil3lEsPt"
Date: Fri, 06 Jul 2007 15:36:43 +0200
Message-Id: <1183729003.3779.6.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jdfA2Wcfz5iWil3lEsPt
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-07-06 at 09:22 -0400, Jon Smirl wrote:
> On 7/6/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Fri, 2007-07-06 at 09:00 -0400, Jon Smirl wrote:
> >
> > > > That's fishy. What hardware?
> > >
> > > Ralink rt2x00usb
> >
> > Oh. I never had good experience with that. Talk to Ivo?
>=20
> What is the most reliable hardware for monitor mode? I have PCI and
> USB on my desktop. I need something that I know works so that I can
> debug these other adapters that aren't working quite right.

I find that bcm43xx (I have a bcm4306) works quite reliably in monitor
mode and even gives you control packets and can also pass up frames with
broken CRC if required

johannes

--=-jdfA2Wcfz5iWil3lEsPt
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGjkVq/ETPhpq3jKURAm1+AJ4wy45cpY0Guv9qVrit1FNausHEYACgh/Yy
qR+Rq9OGEfep26ikE+XGqcw=
=+T/P
-----END PGP SIGNATURE-----

--=-jdfA2Wcfz5iWil3lEsPt--

