Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33393 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760937AbYHBTex (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2008 15:34:53 -0400
Subject: Re: wireless USB adapters recommendations?
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>,
	linux-wireless@vger.kernel.org
In-Reply-To: <4894B518.1000207@wpkg.org> (sfid-20080802_212726_665120_66BC7C97)
References: <4894AC77.5060801@wpkg.org> <g72be3$gpf$1@ger.gmane.org>
	 <4894B518.1000207@wpkg.org> (sfid-20080802_212726_665120_66BC7C97)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-xd67TIfIX5ne/btolJ9a"
Date: Sat, 02 Aug 2008 21:34:46 +0200
Message-Id: <1217705687.8621.56.camel@johannes.berg> (sfid-20080802_213516_066729_4A77B849)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xd67TIfIX5ne/btolJ9a
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-08-02 at 21:27 +0200, Tomasz Chmielewski wrote:

> So, there is no wireless USB adapter working with Linux supports access=20
> point mode now, because some parts of nl80211 are not ready yet?
>=20
> I see nl80211 is in vanilla kernel now; what features still lack to=20
> provide access point functionality (to wireless USB adapters)? Any time=20
> frames (2.6.28? later?)?

I'd expect .28, but cannot say for sure. It actually works right now,
but has some non-standards-compliant behaviour wrt. basic rates and
slot/rts/cts configuration, which is why you need a small patch to
enable it.

johannes

--=-xd67TIfIX5ne/btolJ9a
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIlLbTAAoJEKVg1VMiehFYvWMP/3SqBFnYW5FwX8wutTAgHwnj
vNQTrYlumsOZkC9nZS0qL/XOJW7Q7zeHz95HFFV/ZpkI2z4uf7J2n/tuXteg/+5p
QPUDxpN0sJBreeD0uvepXgxuSKaNi7w1PU08F6XYPlvnI8Zg3rRcU9KtzHMsdeTS
rCp3TKRqblPWIsJWejDa7sWzZYlnKEYw/mRHVyWmhTMezG89m2d/ArXU/lN32U6a
aOEYBkaXz8k5Q15FH/eYnxzxqoJrJmfERwP5ob0752RLrykmhrFgn+3vd+n4gW8V
2nSRVA6u3L0J3w4tbUemmL/Rd7NtXC6DqfdFcGlNddHD6GpqmaDS5GVuhCBw31+F
fybMxB12egG1LF2/VHOXxq7dDc2IgPvA+IieLZ/z76sJkUMK8VacWdsf+MXn3KbD
Hw28paetkaQZJeIedZuDteQg0zKmacbZLUE/hFxN/2DO9FALzbhWwehujOrlp1Ks
0EFCqbfvZIElJoWl491kzvNasazNo4AXHoMwa6TjeoMIgPV5OJrKqjqZQfw1yAr4
KFJ3PTsozf/fOCH3U/hQs0IhrHFO/8KQGS/Wxrsv2LoSY/3CnRJstaEfRlbt8icI
0Njc4ZsUw24rteUnAOLekaUoSA1MN3L2z3UXsLgByWpeobFg6lyEn3cMxx0W5BgP
JEd3NXzvuAgCkzII3nhT
=TYkj
-----END PGP SIGNATURE-----

--=-xd67TIfIX5ne/btolJ9a--

