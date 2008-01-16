Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50795 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863AbYAPPqy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2008 10:46:54 -0500
Subject: Re: [RFC] mac80211: proper short-slot handling
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Michael Buesch <mb@bu3sch.de>,
	Michael Wu <flamingice@sourmilk.net>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	bruno randolf <br1@einfach.org>,
	Nick Kossifidis <mickflemm@gmail.com>,
	Yanbo Li <dreamfly281@gmail.com>,
	Tomas Winkler <tomasw@gmail.com>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Daniel Drake <dsd@gentoo.org>
In-Reply-To: <200801102000.44722.IvDoorn@gmail.com> (sfid-20080110_190054_053275_BB5AF055)
References: <1199974496.3861.80.camel@johannes.berg>
	 <200801102000.44722.IvDoorn@gmail.com>
	 (sfid-20080110_190054_053275_BB5AF055)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-FwajmL7MVCeDDt+79xkX"
Date: Wed, 16 Jan 2008 14:30:21 +0100
Message-Id: <1200490221.5887.170.camel@johannes.berg> (sfid-20080116_154711_491343_8D775630)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-FwajmL7MVCeDDt+79xkX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Ivo,

> > If you think it is the right approach, maybe try converting your driver
> > and see if that results in any problems, if not, send me the patch and
> > I'll integrate it.
>=20
> The convertion was very easy, and like I said cleaned up some hacks. :)

Thanks. What is this diffed on? I tried importing it into my current
patch but it failed, do I have to wait for John to pull in your recent
pull request?

johannes

--=-FwajmL7MVCeDDt+79xkX
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR44G66Vg1VMiehFYAQITDRAAu12jM0N5oWt5HFDCLXbcjfJ4YSCqbb2V
j7tvJU084zieeShzHqlBp5gj5mDV8H1zbx+MAfLA/yerBJMlsEQJj9cWVybwTPqo
uiHgMPcoIySoYu6S+GcajIgWociANQR1t66pWrBS5S2OBICdIdWdM6MDJJwIEc0X
6IMI0xucspJMGaKpA8zZYD+8Ja27uMBSf8wBPr1+dqaeRMJe220SXrLkr6bsZzto
e7qa6e4xxKC7p1gT7u/IiYcDZ+z/oQ+Nuym1UBuPmNoqGaYLHrS3rgYaqZCoMqsc
RPYIxKsyI1/Mvp4Xiva+LCwXsd2hOXwWat4f4vjfJ23ojx3eIzLFX/QiFLnwcmjU
lg16+fH67vn+wHGelOJxHlIA+Xpdf/wWcOfJ0oXSEYzHPH2QQIuXSqVwGyB5DfZJ
zR0b4YckYxV5inbNV9LnyouuDaj4qNPOEe5/z8Eqf24aJhAwOPthHXzq/ai1jxwn
7uW9PltNwUkCQJKnUAWu34aQFfd1yrCRQwOedHTDY+YQnn4f3kB0rLFe8S1rNY1n
z6oevj5JR8dNQGcYawCAN1ES2+2SIGofTXXB1cLMnKj5nMdZM/rpin7y3GfSKoYv
Hh5N7Jlw+t38XfU/n/1a5z1ZFj9sK20mx7RaxhRrFB/0RTNR/VOPZJIcgXVn/fsp
dpYKokpRzxQ=
=nLNl
-----END PGP SIGNATURE-----

--=-FwajmL7MVCeDDt+79xkX--

