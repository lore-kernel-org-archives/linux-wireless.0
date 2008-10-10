Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36197 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757651AbYJJPa5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2008 11:30:57 -0400
Subject: Re: splitting out the 3945 RC algorithm from the driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Zhu Yi <yi.zhu@intel.com>
In-Reply-To: <1ba2fa240810100801i7886be3cq7376881951fdec36@mail.gmail.com> (sfid-20081010_170154_636889_D3FCC4B2)
References: <1223631856.17594.4.camel@johannes.berg>
	 <1ba2fa240810100801i7886be3cq7376881951fdec36@mail.gmail.com>
	 (sfid-20081010_170154_636889_D3FCC4B2)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-qrDvE4ptrCF8Ct55RD+B"
Date: Fri, 10 Oct 2008 17:30:52 +0200
Message-Id: <1223652652.3748.21.camel@johannes.berg> (sfid-20081010_173101_713805_5604ED42)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-qrDvE4ptrCF8Ct55RD+B
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > There are a few difficulties:

> >  * the RC algorithm is responsible for adding IBSS stations to the
> >   firmware, this is pure design stupidity and must be fixed anyway

> First please again stop this language, you are not telling us
> something that we don't know.
> There is history how things are developed and there is time for
> everything to change.  It wasn't stupid when it was develped mac80211
> then what it is now.

See, that's where we clearly disagree. It _was_ stupid even back when it
was initially written. We discussed this back then and you wrote a
trivial patch to have mac80211 do the sta_notify call as required. But
then you already has this code and didn't bother cleaning it up when it
was possible.

This is a development process issue, and partially comes from you doing
so much "invisible" development in-house, and partially from John being
way to lenient with you and accepting such hacks, in the hope you'll
clean them up. Well guess what, it's now well over a year later and you
haven't. If you don't live up to such promises, how can we take your
development process seriously?

The normal process that we make everybody else go through would be to
post "oh, there's some API missing that we need", then you post that API
and get it in, and _then_ you do the stuff that relies on it.

You need to get that.

johannes

--=-qrDvE4ptrCF8Ct55RD+B
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI73UpAAoJEKVg1VMiehFYkq8QALMhjOfPMNI0ibtAZShahgL1
kUeTYvQkAdsTdtxD3yU5slsBYYwWqOzKRg7wxxl19ULEouvW84QDiab5TQUpGlsc
sRDTMwE1KMauproAk9+Q+3tzOKYg5toTuWessH+hayfvwtwyU3SQcDfFoB+4Za44
p/Q0u0fyJODt9XGmA19h/wU/dMcICJ6r/py58ePVIm+uFBZXidwKK/kQkwP8N/bi
CyaMd1Rgv6kwp+gHY5HmKwYWUH9OHofkPgprqWmiPnGmkEVzdWjXyujDY0hyTj4n
g1jEQHj1ioFe2thAfrgxMC5VG1MgHbrnzcMfwO+RNvYLn3zSBtzIocBH0eEolxxd
0AOiwJE54PlhmhJZ9INt3cjagA+LaXlpEnR/moI6FDKJvPh3YAS28ZEyS02Itzow
P42cvSnGLhRrcGMjw729m0dRRqDReckNBk2zKqEKo+AS5WAkXdMKGyzDaxhZNJ5C
q49QiNy17xwioVJFYYduMINysgJY6LRPlZvZnfF2zDC/iqamNb+K+MTEGS9hMmtv
RlMKpKUTgcfpOc+8geIe6DspqH+JQZeIafkGhwResNPc6pH4Eq5G2zzecawjlTTB
aauOPS8DPlq5OvK76Q1c0v72nrWIihutCUlyWdoGEvSC04IcDJXzI3YIsP6pxW5+
TiHtLoAzRITSXlmlkpcq
=C9ES
-----END PGP SIGNATURE-----

--=-qrDvE4ptrCF8Ct55RD+B--

