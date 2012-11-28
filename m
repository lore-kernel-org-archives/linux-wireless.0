Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:44037 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842Ab2K1KhS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 05:37:18 -0500
Date: Wed, 28 Nov 2012 11:37:10 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Jonathan Bither <jonbither@gmail.com>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC 0/3] Add spectral scan support for Atheros AR92xx/AR93xx
Message-ID: <20121128103710.GA5284@pandem0nium> (sfid-20121128_113723_035859_ADB8BDDE)
References: <1354042885-32688-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <loom.20121127T201036-82@post.gmane.org>
 <20121127194952.GA530@pandem0nium>
 <20121127203244.GA752@pandem0nium>
 <50B52A33.3060900@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J/dobhs11T7y2rNN"
In-Reply-To: <50B52A33.3060900@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Johnathan,

On Tue, Nov 27, 2012 at 04:01:39PM -0500, Jonathan Bither wrote:
> Hi Simon,
>=20
> On 11/27/2012 03:32 PM, Simon Wunderlich wrote:
> >On Tue, Nov 27, 2012 at 08:49:52PM +0100, Simon Wunderlich wrote:
> >>[...]
> >>
> >>The goal of this was to create the spectral scan feature based on public
> >>information, so the results are probably not optimal yet, but I hope th=
at
> >>this will help to move Qualcomm/Atheros disclosing some information (th=
is seems
> >>to be planned anyway[2]). Otherwise, maybe other people can help
> >>reverse-engineering this. :)
> >Just to clarify: I don't mean anyone should disassemble proprietary obje=
ct files
> >or use proprietary source code and re-use these findings without permiss=
ion to
> >create this feature - this would probably be illegal anyway.
> >
> >By reverse-engineering, I mean we can already dump data spectral scan da=
ta with
> >this patchset, but the hard part is to interpret this data correctly - a=
s you'll
> >find in the patches, there are a lot of bits which we don't know what th=
ey
> >mean, and maybe there is even more info hidden in these bits. I've uploa=
ded
> >some samples taken on my hardware to the github repo, so anyone can use =
my
> >program, matlab, or just stare at these heaps of bytes to find some patt=
erns and
> >try to interpret it. Actually I was just staring at the bytes myself and=
 wrote
> >this visualizer to get a better idea what they could mean.
> >
> >Of course, if we can some docs or support from QCA officially, this woul=
d be even
> >better. :)
> >
> >Cheers,
> >	Simon
> A search brought me to their patent application. The Drawings on
> their patent application contain some more information on the signal
> classifications. Hopefully this will be able to help you or someone
> else.
>=20
> http://www.google.com/patents/US7929508
>=20

thanks for pointing that out! This doc gives a pretty good general idea
how things are working, although it isn't too helpful in details. It also
describes some pattern matching related things.

If you anyone is interested in the pattern matching things, also the
airshark paper is definitely worth to be read:

http://pages.cs.wisc.edu/~suman/pubs/airshark.pdf
(some AR9280 details are to be found at section 3.1)

Cheers,
	Simon

--J/dobhs11T7y2rNN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlC16VYACgkQrzg/fFk7axY0pACdFVkJojzeA/pvbi0yU1CIaOZS
KlAAn3RBeoQR1j+HjXBmqFORXguoUt34
=eO8V
-----END PGP SIGNATURE-----

--J/dobhs11T7y2rNN--
