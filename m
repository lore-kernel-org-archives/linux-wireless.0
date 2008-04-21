Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:47453 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519AbYDUIYF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2008 04:24:05 -0400
Subject: Re: FYI: hostapd status
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <1208741320.2452.22.camel@debian.sh.intel.com>
References: <1208454990.4066.42.camel@johannes.berg>
	 <1208741320.2452.22.camel@debian.sh.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-OiYZUXljgIobvYjlDmQX"
Date: Mon, 21 Apr 2008 10:21:14 +0200
Message-Id: <1208766074.26186.32.camel@johannes.berg> (sfid-20080421_092410_645692_C4EB3C7D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-OiYZUXljgIobvYjlDmQX
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-04-21 at 09:28 +0800, Zhu Yi wrote:
> On Thu, 2008-04-17 at 19:56 +0200, Johannes Berg wrote:
> > Since we just talked about it on IRC and I made a list, here it is. Thi=
s
> > lists what we're missing in mac80211 and nl80211 for proper AP support.
> >=20
> > =EF=BB=BF * short slot        =20
> >  * short preamble
> >  * basic rate set=20
> >  * rts/cts
> >  * channel flag/regulatory domain
> >  * tx queue params (the plan is to make them qdisc settings after
> >    Ron's/my qos patch)
> >  * multi-bss support (no kernel changes, just hostapd keep track of
> >    BSSes)
> >  * internal bridge setting (separated STAs in AP, local->bridge_packets=
)
> >  * CTS-protect setting for AP
>=20
> These looks good for a basic AP. But I'd like to add more advanced
> features for example 11n, WMM AC and u-APSD support (which we have
> already done).

Well, yes, but these are the basic building blocks to get a basic AP
spec compliant. You can add all the advanced features that you want, if
the basic stuff isn't right we shouldn't really use that AP.

johannes

--=-OiYZUXljgIobvYjlDmQX
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASAxOeKVg1VMiehFYAQI1YRAArkVGNtUpU0He/2WSKxKDrdvRkOl1iHx9
vvTrLIGwQaZw0m0ZveY0IFKSGnkhvrFT02cAoYJucHWiY2O0lDomeGU9qklpjLN5
WbQ5DPCKM89qhKxKN3eAwtAwsUv2EU6tpnPe51aknkkvyN0JkYJWoUJPDgJyg0+T
5cP2K08O725FjOWR3yacBjx8pb3Xxf0986a7gNjrYA8hBemXKn0HL6EsDo01fLNj
YJ0GLziVgAHEL9NScrqefwKA6dMVZbJYBDJ80iY2doujLYnXdVHC8D+pPiYz8hAl
qoqXox6n4wlOjLCBVDtpCIbKaTdxtnxj/99fdo8vNHnlG40V6Is8Z3AEIYjp9f8+
dqa8AT6YLFjCTg4G9JnZDuvB898VSRuqp0QD0f7+o1WP6F97ue7VIcYahhI9m9IK
2n8OWY5k1cWTM5TmpWILL0eGepJ6Qv+jLhfjpGi9rX7lyj9mZu1vYW6w/o8UIUWD
esORrq9IlygtmUAbGhE2gWLqONnOlUeR2MXCg80JURY0PO3FqpV2+swOT6WREmoI
4dQnrjhkhU8J1AjR/vZneA1h2A9u7JLmJWSTVE1Gquv/WKJmS6DoABoRfK3NJcfM
Gg44mYjW5S2FlaUkWx6np6S4n6PQBFrwKzzjirPOF96tgT+YOC1RzgmN0QQry0bt
2B3KQ1Jmmgs=
=G2jX
-----END PGP SIGNATURE-----

--=-OiYZUXljgIobvYjlDmQX--

