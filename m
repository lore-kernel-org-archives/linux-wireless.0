Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:38567 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041AbYBYLgs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 06:36:48 -0500
Subject: Re: mac80211 locking: tasklet vs. non-tasklet
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	bruno randolf <br1@einfach.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <1ba2fa240802250333p1d0a4ebqd37ff4f837aa556f@mail.gmail.com> (sfid-20080225_113326_228690_F3FD5D96)
References: <1203676145.26341.39.camel@johannes.berg>
	 <1ba2fa240802240829s7c650ad1yd47c6b25e466a50@mail.gmail.com>
	 <1203933096.13162.54.camel@johannes.berg>
	 <1ba2fa240802250252x753796f7ob071c12c72aec172@mail.gmail.com>
	 <1203937042.13162.81.camel@johannes.berg>
	 <1203937235.13162.83.camel@johannes.berg>
	 <1ba2fa240802250333p1d0a4ebqd37ff4f837aa556f@mail.gmail.com>
	 (sfid-20080225_113326_228690_F3FD5D96)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mKkbSz7QTIAQDWzhDzVN"
Date: Mon, 25 Feb 2008 12:36:41 +0100
Message-Id: <1203939401.13162.96.camel@johannes.berg> (sfid-20080225_113651_776869_74426C49)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mKkbSz7QTIAQDWzhDzVN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> I would notify mac only if driver cannot deal with reset and also
> mac80211 configuration have to be reapplied such as start association
> process again in STA mode.   It would be probably security problem if
> we put just station into associated mode without proper association
> process.

Hm, guess it could be. I think this will require quite some work to
completely put the mac80211 state into the hardware again, but this
would also be great for suspend/hibernate since that really is a similar
case.

johannes

--=-mKkbSz7QTIAQDWzhDzVN
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR8KoSKVg1VMiehFYAQKmyBAAnN+c2jK1hxMc4OGeSkgj8IqkGwcpfLMi
CQ1L0oWcwq2VtB7pGZcoqPL0XDsVCuSMCC3PovTXEefvAomSle11Pq/Nv+7gIifC
BnwbfqfVb8pWD49RNmhPAank8+LP90zhjZs3EJl8sElmDA9GYj+0VFNAf3wL1alH
bFZVZC8Ss9hKxta2p28xCwcRKbFFGFr/6NoHKV7dov+kQ+gVeGi1uTpF1GaljAjp
H2CsiTczoQ+slf6EOvPNt3lloGjiXT/iX9croq6/Ohrrw/ZHKsRVBnORloJy2Pde
kBg5OyMRyC19Xc/LvZRfPJdyb/aJVTT5vPgeEZ22KVGVUFplsiMhPYqBUyEkqcwT
nKhNOUAJIju2yrFkLOx1gPsdLe9zQniTmzWzpBV3Sl/F9vX4IqMSsD+pxQfUEYGI
R+O03TdT19r0Ilk2WychBk2QhigecwSORI1dz1ye/ahKKXTrv30KGmQVlIcCnr97
WdxuadPxo0tsvv11bVn78KFk7FfdPQI8on7IuD6R92WITThqrWv79EQpxfQkvXyq
/RCTRZfvyFd6eks8j8eQlG+Cuk5Wr32anjQesJes4NHSn2K5YXeRACe3Ga6Mjq7L
fHsn5BiZ88iCOOWsAyzzIxwsgxgIjxITBtaFEeAONDNCIRXlwb9qOiBLlmXbiTAJ
17DepC73kPQ=
=yemt
-----END PGP SIGNATURE-----

--=-mKkbSz7QTIAQDWzhDzVN--

