Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53054 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbYJORqG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Oct 2008 13:46:06 -0400
Subject: Re: New Regulatory Domain Api.
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Marcel Holtmann <holtmann@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Zhu Yi <yi.zhu@intel.com>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890810151039s34ad8d79nd2744847dd254b4e@mail.gmail.com> (sfid-20081015_193938_934932_4EB690B0)
References: <B27EBC40D200ED48A3F4CC2EBEABAE0B16C892F2@orsmsx501.amr.corp.intel.com>
	 <1223969808.2570.153.camel@debian.sh.intel.com>
	 <43e72e890810140204ne135e72kefe379dd3d26f7bc@mail.gmail.com>
	 <20081014203510.GD3349@tuxdriver.com>
	 <1224018957.3027.9.camel@johannes.berg>
	 <20081014211912.GF3349@tuxdriver.com>
	 <1224019662.3027.13.camel@johannes.berg>
	 <1224085609.4764.18.camel@californication>
	 <1224086374.735.4.camel@johannes.berg>
	 <1224091577.28173.9.camel@californication>
	 <43e72e890810151039s34ad8d79nd2744847dd254b4e@mail.gmail.com>
	 (sfid-20081015_193938_934932_4EB690B0)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-oC9k9gb3sKcfYD6HCAvi"
Date: Wed, 15 Oct 2008 19:45:23 +0200
Message-Id: <1224092724.735.21.camel@johannes.berg> (sfid-20081015_194614_582523_4CDD919C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-oC9k9gb3sKcfYD6HCAvi
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-10-15 at 10:39 -0700, Luis R. Rodriguez wrote:

> We decided on our discussions to respect the built-in card first. For
> more cards we can take the intersection if we want to keep being more
> restrictive. Its what makes sense if you think about it.

I'm not really too sure the intersection makes most sense, we mostly
used the first hint because it's likely to be from the built-in card,
ergo announcing a region for which the whole product was certified. If
you add a card, we basically don't trust it currently.

> My suggestion is to add a default minimal 5 GHz regulatory domain
> definition to your driver on single band cards to deal with this. When
> a dual band card is present then all of the full card's capabilities
> will be used.

Unfortunately, there's no such thing as a default minimal 5 GHz
regulatory domain. This might work with systems built purely out of
Intel cards, but to be honest, I wouldn't want to see this because it
would mean that if you add a dual-band prism54 USB then it'll start
sending on those 5 GHz channels regardless of where you are and what
you're allowed to do.

johannes

--=-oC9k9gb3sKcfYD6HCAvi
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI9iwtAAoJEKVg1VMiehFYuNEQAIWNREasnzmAlGQu1Gh0FvOY
i4RqtLojFtDkJ578G6Z3jrzdx4LyDkdmcXbBoTBWJSPVwqzRIPrE7ggu0NBtjdse
ld4L4MmIxdZqZhoHxtAlSChiShsN9UEdH9NFNbmcv3qED1aNkJqAooLgrgF64B8u
yRQ6oXzqpNglPBPPwBssfUVOM5RYYmGI76hFARyz5aRyd4hDHyztL46mmPRiwMhG
IWLDoKEWOQy25NzT2LMCvvZ74F3gjxxcGMdLbsE01etbk6PhpLoxoNgHrilZATEA
7HlfAlw62lcVLzxDubPk+9vwsUhzk0lvBaB65yF4qODwuIniUALwLc45wpdCmApX
RSKBtrb97aqCiRSbjvUuDGFteUSIM1QruD1FonOnivftXvzXV7+1a3wu2T7DjAbK
iSO783Q3bVKXSZJZFwM11in/6ilXOBvoGRv5TNMJ3LzXgt9n4HRJahu+SGFJ83n+
WQPHwNgW5ymfca7aAMM0ym0PObIa4Jymiz72ejUsxU+iIFipvOzAD6An+kNhve8r
U85av4Z+REFTQ4oCTCsbsF+IiNUY6wYA7muUDDFcKeVVO+eUPCOj706M5ihThNHu
5M0ZNn6r3YBwofk4QUvMpmSgBB7GznAPgb02nuFHX/0paVbZ8dg+MUl2HSsp9bSP
JTEVX7caiaY6ebU3WblY
=Ibh7
-----END PGP SIGNATURE-----

--=-oC9k9gb3sKcfYD6HCAvi--

