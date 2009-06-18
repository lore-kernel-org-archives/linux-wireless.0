Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34948 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477AbZFRWHN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2009 18:07:13 -0400
Subject: Re: wireless netns work
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>,
	Georgy Berdyshev <codingmaster@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Netdev <netdev@vger.kernel.org>
In-Reply-To: <43e72e890906181504i3b48b1fbj88fe485890e5f1a0@mail.gmail.com>
References: <1245328543.13790.31.camel@johannes.local>
	 <1245329713.13790.37.camel@johannes.local>
	 <40f31dec0906181016nffa031flac8f464c929f1bc9@mail.gmail.com>
	 <43e72e890906181443g54269d1bm7ce24dcb46e7e921@mail.gmail.com>
	 <1245361694.6495.2.camel@johannes.local>
	 <43e72e890906181504i3b48b1fbj88fe485890e5f1a0@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-dX2T67YB3VTASrUbQuOP"
Date: Fri, 19 Jun 2009 00:06:45 +0200
Message-Id: <1245362805.6495.3.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dX2T67YB3VTASrUbQuOP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-06-18 at 15:04 -0700, Luis R. Rodriguez wrote:
> On Thu, Jun 18, 2009 at 2:48 PM, Johannes Berg<johannes@sipsolutions.net>=
 wrote:
> > On Thu, 2009-06-18 at 14:43 -0700, Luis R. Rodriguez wrote:
> >
> >> For example, I see you used mac80211_hwsim and was able to use two
> >> wlan interfaces to talk to each other. This seems great for testing
> >> purposes but it remains unclear to me the advantage of testing with
> >> separate namespaces vs creating two wlan interfaces on one namespace
> >> with mac80211_hwsim.
> >
> > You cannot ping within one namespace and have the packets actually flow
> > over the virtual 'air'.
>=20
> I see, thanks! How does using a separate namespace fix this limitation?

Well that's the magic ;) Think of it as having one copy of the
networking stack per netns.

johannes

--=-dX2T67YB3VTASrUbQuOP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKOrpyAAoJEODzc/N7+QmaAxMP/0+jJFlOJyAtcMeLwtQNFLEq
FPzM9tjf/rfOLZEr73wEY2KIvQHf9ApbzHcXmPZ6Z92TFQXZIRRoqy0fjxN17oZy
d5fKWEkG/Jb7Z7rRenQ1BsQzgnj98lQn8Hrp8+8rKbSDfm1ijVHXoY9l2vtbXJ4R
zdtxAwJvReySaPkt0TbufFJsIXK5RyTaJWyEs1QZQ14Cwt6KgMUhqRD2p9VYQT2f
fCUrAlW7xjbbedOvptVITeo+m2vtWpy09l9jjkzkqegWBW4C8LzLooXgxk9AQZS+
r5CSqdqqbCuMBP0EhiAS2DJNwAR1b+RgDWgjmUFTJ0jnADxdsgSFgLysDjCJQr13
lgh2cArlYEaW19xHOzzwT1zS/ui7KSl3lVyyYxVjf1K7lmd6WRkCKRwjwfqL8WSn
292Q22JjfJ5BavljADYaP/AWzRQhD7vbvl3s9b+MXizULO18LGKmaTie6WEeRmHn
p5K/MmifhzH3JwSrJlyxNl6Y4CiwNsQ3fvp7a65ciKp3oc8SX9D6OL3vVUp5wWKs
TKTuWktkz8bB2SkThXuphhQ0+oEJVcqNhhJwb/0hVT2TeJCwbdjS1ruJL8XpF6ii
pxET/LQil8D5S2kM5gKBamYlAPpuxut2CszgkA7HBCsD/N3yRkqMEBmcz5QPx/iP
EHiOOhpTFpePZc2xYdIF
=BNIX
-----END PGP SIGNATURE-----

--=-dX2T67YB3VTASrUbQuOP--

