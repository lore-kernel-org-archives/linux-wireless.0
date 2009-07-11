Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47153 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754171AbZGKUwb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Jul 2009 16:52:31 -0400
Subject: Re: [PATCH v2] mac80211: cancel/restart all timers across
 suspend/resume
From: Johannes Berg <johannes@sipsolutions.net>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <m2ab3bkm2d.fsf@igel.home>
References: <1242391067.5799.53.camel@johannes.local>
	 <1242553242.10005.76.camel@johannes.local> <m2hbxjky1q.fsf@igel.home>
	 <1247334562.30647.111.camel@johannes.local>  <m2ab3bkm2d.fsf@igel.home>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-O1QKeAZc0ngHJuKYlHgF"
Date: Sat, 11 Jul 2009 22:52:28 +0200
Message-Id: <1247345548.30647.116.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-O1QKeAZc0ngHJuKYlHgF
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-07-11 at 22:21 +0200, Andreas Schwab wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
>=20
> > On Sat, 2009-07-11 at 18:02 +0200, Andreas Schwab wrote:
> >>=20
> >> Johannes Berg <johannes-cdvu00un1VgdHxzADdlk8Q@public.gmane.org> write=
s:
> >>=20
> >> > We forgot to cancel all timers in mac80211 when suspending.
> >> > In particular we forgot to deal with some things that can
> >> > cause hardware reconfiguration -- while it is down.
> >>=20
> >> This is breaking suspend on my iBook.
> >
> > Yeah, bug 13337,
>=20
> Thanks, I missed that one.
>=20
> > but the fix at
> > http://mid.gmane.org/8763dznnki.fsf@scholz.fias.uni-frankfurt.de works.
>=20
> With that patch suspend works here too, but resume hangs halfway
> through.

Odd, do you get console output before it hangs so you could add printks
to figure out where? Jan said that just fixed it for him.

johannes

--=-O1QKeAZc0ngHJuKYlHgF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKWPuIAAoJEODzc/N7+Qmay3QQAIMxIvBip7SrkAGAw+NHUA8t
NsJdGXa0QDhfmbM0SFHazirN1JxDs4r+c2sohci4YRM5AMFxpIH6Kx32QRCiXKp0
VL2tWm9YZ9FxiMqFL6ODtICMHKR8qiJxgkX++tj0zqyxcwtotPKsSIqzGMAsKbgz
uvV2q3eMA9lc3qeIX/Gzyv9ety9DEvxV22T8hFxumZaLt8cPVEH7pNb6ugMmmrku
WtSagk4LjIo6yuy8bz4JnnzyvfzXoQk4P1LEDFjvUKfqWpfcDJhjSFP23WoMrg1M
zELzf+GpOWq59hZAOp2sVSdJVJJSA4GSCPpuvI2t1FceEkQv1zanGRTdvtV/cKKO
I84wKHCU8lC1P6MyDNvHnECiagkz4ypnFLb3Dt54OBz7drdP0+h0EZ923mqNra8h
+tJgISJQ7V4IrZQsfcyWF9XX8kbjSdYZI78nrKfh1QACq5I9AvjW2kMyryBOpQDd
RB7OtQSVadue3YkktKoG2nc46yOr/2nJUhIp+tfbpBlHLV39llMCCv/WVvMYbuk0
dV0z3aMD4JFZQw1ZU2Sbe0VAY8pkXnBgdMidosktehwRvPEjof3v0e5Hi3dnIViC
Hjgks4v33R6S/ZNI5OlKneLawbwPlXJVlP86zEnz3gxeTOdeEAiST5u7m62AB5TL
EOkX+i165YQ2igZIg1IG
=I8xB
-----END PGP SIGNATURE-----

--=-O1QKeAZc0ngHJuKYlHgF--

