Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:32950 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbZDSQ5X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Apr 2009 12:57:23 -0400
Subject: Re: [RFC/RFT v2] cfg80211/nl80211: add IBSS API
From: Johannes Berg <johannes@sipsolutions.net>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20090419165443.158820@gmx.net> (sfid-20090419_185516_519795_36D34B9B)
References: <1240094996.21583.1.camel@johannes.local>
	 (sfid-20090419_005015_625875_1781AFCD) <1240097845.25826.1.camel@johannes.local>
	 <20090419125212.158800@gmx.net>
	 (sfid-20090419_145246_566920_BF082D12) <1240147050.25826.5.camel@johannes.local>
	 <20090419133544.158820@gmx.net>
	 (sfid-20090419_153615_967882_D1A9F951) <1240148519.898.3.camel@johannes.local>
	 <20090419140523.158830@gmx.net>
	 (sfid-20090419_160555_446977_A429511B) <1240150277.898.7.camel@johannes.local>
	 <20090419151629.158790@gmx.net>
	 (sfid-20090419_171702_263242_9A8C16F9) <1240154704.898.18.camel@johannes.local>
	 <20090419155319.158810@gmx.net>
	 (sfid-20090419_175352_161479_A88396A3) <1240156631.917.1.camel@johannes.local>
	 <20090419161316.158790@gmx.net>
	 (sfid-20090419_181324_681308_BAEAE072) <1240158381.917.21.camel@johannes.local>
	 <20090419165443.158820@gmx.net> (sfid-20090419_185516_519795_36D34B9B)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-FQqtpiv4kJpZ+13re/sL"
Date: Sun, 19 Apr 2009 18:57:21 +0200
Message-Id: <1240160241.28138.4.camel@johannes.local> (sfid-20090419_185725_960512_C926A9B4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-FQqtpiv4kJpZ+13re/sL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-04-19 at 18:54 +0200, Alina Friedrichsen wrote:
> > We might actually do that -- as part of the commands "connect" and
> > "disconnect" that do not exist yet and subsume auth and assoc into one
> > for hardware that doesn't support it.
>=20
> Why not use these commands as a high-level and mode independent
> version of assoc/join_ibss? And then simply call it from the wext
> handlers?
>=20
> "Zwei Fliegen mit einer Klappe"?!
> (Translation: "Kill two birds with one stone".)
>=20
> So you have a equivalent for:
> iwconfig wlan0 essid test
> iw dev wlan0 connect test

I still haven't understood why those extra commands are bothering you so
much. Anyhow, you don't _connect_ to an IBSS so that would simply be
_wrong_.


johannes

--=-FQqtpiv4kJpZ+13re/sL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ61ftAAoJEKVg1VMiehFYbPQQAJTcc/xMp6ElzU971ovCjy/F
FKEevw5ChVDqsncoWG4/igRYk8JyMM3+SYTjlR0SjEOWt7wbIpQA7YaQM0Rq41iP
TJ0+cySjOMuYRx1ZXJCW2xpnlQhmGFWfsBsJsK1x6712z3EhC+/d03+9Rs1+/nMX
8fBCeSkjSAiKBVDKtUpw6hKh9nqHgjodmSEqPC2R1PmE/bnoRBFnpZRvkQcksktS
Jc7PRm/yQJ87BCqZFgrhlZjeLXMw39BtBXX8+Q5AORhJNXy4LYPsC27ATLETNBZJ
J64J6F0Sa0CiX1bBcADYaAdYUZAQSy1JmTC9CvnZCgo7Mu/OeVnwIZcwjzrZQqA/
ygGjoBMc5zA1YfJSYVhG1poUmr/qm1bVsLJIrB2MIM6tcJb2sS0wICpZLlHKpx7f
AM/JyGYyPZh2Z9bYL3oPERnRpRcHypItK4cfZ2+C9yhlJs/iHYzQHMoOXCoZ8NBB
Yf71QRNXnUTfLoDxwcf0UqFVZ3G0N1LiyW3zNnEMgXgCYKPo4c6MYRqDSfst2wcm
gOoyxU+PISkay007kTxSD62Hlpp6oc6CpsVf5+nzSQ4J83HKh7xgFXATOI309eSd
K11Qm7L153CXth07TVulDVviiqk6WydwGcqUUTcmbdFotn1Tc2eA0wJne6jsqIxU
y3KUI04TZl9As0pmlIup
=btXf
-----END PGP SIGNATURE-----

--=-FQqtpiv4kJpZ+13re/sL--

