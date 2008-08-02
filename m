Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45984 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355AbYHBTCM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2008 15:02:12 -0400
Subject: Re: [PATCH 8/8] rfkill: add support for wake-on-wireless-packet
From: Johannes Berg <johannes@sipsolutions.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
In-Reply-To: <1217700664-20792-9-git-send-email-hmh@hmh.eng.br> (sfid-20080802_201122_064360_071330B0)
References: <1217700664-20792-1-git-send-email-hmh@hmh.eng.br>
	 <1217700664-20792-9-git-send-email-hmh@hmh.eng.br>
	 (sfid-20080802_201122_064360_071330B0)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-J8HP+PhwPlqjWCJiVFeB"
Date: Sat, 02 Aug 2008 21:02:03 +0200
Message-Id: <1217703723.8621.50.camel@johannes.berg> (sfid-20080802_210215_767836_A455F2A1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-J8HP+PhwPlqjWCJiVFeB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-08-02 at 15:11 -0300, Henrique de Moraes Holschuh wrote:
> Currently, rfkill would stand in the way of properly supporting wireless
> devices that are capable of waking the system up from sleep or hibernatio=
n
> when they receive a special wireless message.
>=20
> Since rfkill attempts to soft-block any transmitters during class suspend=
,

why does it interfere with suspend anyway?

johannes

--=-J8HP+PhwPlqjWCJiVFeB
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIlK8mAAoJEKVg1VMiehFYVUwP/1yOTvKT7zE8Ok2NSIgVr958
K+pvloZc9T+CirqSBaiYu1Text6c8pYU/k4tdgrP8aoedFtZ79gouXhJbbghS9qq
pJDKf9FQwyS3MlTILLREpw1F3Yi8kCPLtyKk660T8t7u9yvL5HI+TRxPXt4P/tWj
GhpoGMP90MbCZ4EetQy2e1+Hl1DfblKvQT1WFgI0tFppnmRSmFlwfr4aZAJdo9+F
9gdmyicX4/rHePccHdnLwP5Zd1AoBp6NZjOWxkn+TojrW/OQNgkeMnrIs+T1Qp2C
F4EM2bHaCKbud++PUf1MeQ3tIfti9Xs9O/6j8tGoj+A16QAYa7Omkf1dO6m6GugL
uFxujqD7aYNZflVtvyXOdDnHfSR7cDv36t6WII6GVLMYExUOqm/qvTpbuiZnMQUz
zeEAUCvqPvqQPd1sFW2NY68VFuC8XAkllkgBxFZgF1rXgk34tl/n3Otlg0/PROC+
+3qqf4rt1rkuJ9w71Umn1GXMt4pRWe08Sm4IIc0XTdEmRlypDPzclMvLvAvyw9IL
tCF10Mbt23oAgGfOPP99PAAWfVTO+og5014fGJHHv19A3wJf36QVW+TthWqqCB8F
mvauWmVBK2I/u8R4xhGqUU8F5Na0lOPyJqxgklPrgouPnqy3b32ASCYFgof6me9N
1JRzbiHK86fMcrLj6PEb
=jdeo
-----END PGP SIGNATURE-----

--=-J8HP+PhwPlqjWCJiVFeB--

