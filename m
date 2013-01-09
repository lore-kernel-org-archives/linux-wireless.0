Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:44777 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757436Ab3AIN1S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2013 08:27:18 -0500
Date: Wed, 9 Jan 2013 14:27:11 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Adrian Chadd <adrian@freebsd.org>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org,
	Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: Re: [PATCH] ath9k: add spectral scan feature
Message-ID: <20130109132711.GB22836@pandem0nium> (sfid-20130109_142731_328044_196C1F33)
References: <1357652938-18836-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <CAJ-VmomJiw8cZqiPRCa8iDrTJdhwtWTTVQwMcHnnyft+DquR1Q@mail.gmail.com>
 <CAJ-Vmom8XFaPwOamGwqcG1sZaDyjodUbhgPFNHONBAYnr1eEBA@mail.gmail.com>
 <CAJ-Vmomz-iqz5h-rdzd9Z-0DQdMrWBq2cdXq+DHvNUrVWmS0Gw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hQiwHBbRI9kgIhsi"
In-Reply-To: <CAJ-Vmomz-iqz5h-rdzd9Z-0DQdMrWBq2cdXq+DHvNUrVWmS0Gw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--hQiwHBbRI9kgIhsi
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Adrian,


On Tue, Jan 08, 2013 at 02:17:40PM -0800, Adrian Chadd wrote:
> .. my turn to impress :-)
>=20
> I've peverted your code in the worst possible way and made it work on
> a live data stream.
>=20
> http://people.freebsd.org/~adrian/ath/fft_snapshot_5ghz.png
>=20
> :-)

Cool, that's actually pretty nice!

Wanna share your code? The original program was just a simple proof of
concept, but we can integrate code there. live data was on my wishlist
as well. :)

BTW, what happened to your QT visualizer?

>=20
> I have FreeBSD's ath driver now enabling and triggering spectral scan
> (if configured this way) on each channel reset/change, so I can gather
> spectral samples during a scan.

That's similar to what is included in the Linux patch.

>=20
> I'll tinker with this a little more, but I'm honestly at the point
> where I think you and I should just agree on a javascript-friendly
> encoding scheme and write a HTTP server app that just reads in a live
> or recorded data stream, then feeds it serialised out HTTP. That way
> people can just write HTML5 renderers (which leverage all the
> GL/accelaration they want) and we can benefit from having a shared
> visualisation tool. :-)
>=20
> What do you think?

Putting all together into one "standard output" is a great idea!

Actually I'm not much of a webdeveloper and have no idea of HTML5 etc, or h=
ow to
design such a "java-script friendly HTTP server app" - implementing yet ano=
ther
HTTP server is probably not a good idea? But any proposals is welcome
- maybe something which can run on OpenWRT as well so these guys can enjoy
the spectral features on their WRT and TP-Link routers. :)

Cheers,
	Simon

--hQiwHBbRI9kgIhsi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlDtcC8ACgkQrzg/fFk7axb37wCg0aIwmwtjas0UMufZMxnnd3Vu
imQAoJ8D7k+Lc33/RM7k98kUP+Ttr3FV
=xezx
-----END PGP SIGNATURE-----

--hQiwHBbRI9kgIhsi--
