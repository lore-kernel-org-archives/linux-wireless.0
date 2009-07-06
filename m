Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40544 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbZGFMxD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jul 2009 08:53:03 -0400
Subject: Re: Insist on cfg80211 for new drivers?
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Dave <kilroyd@googlemail.com>,
	Karl Relton <karllinuxtest.relton@ntlworld.com>,
	dwmw2@infradead.org, linux-wireless@vger.kernel.org
In-Reply-To: <20090701193657.GD3473@tuxdriver.com>
References: <1246388712.4949.52.camel@localhost>
	 <43e72e890906301217m2dec7bfaqea0472907531d21d@mail.gmail.com>
	 <1246396179.4949.76.camel@localhost>
	 <43e72e890906301458y197c5411yfb93ea0089ed49f3@mail.gmail.com>
	 <1246464991.4331.18.camel@localhost> <4A4BA21F.1070101@gmail.com>
	 <43e72e890907011112l220874bbu8db8808f666bbd4d@mail.gmail.com>
	 <1246473300.30522.10.camel@localhost.localdomain>
	 <20090701193657.GD3473@tuxdriver.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ABFZ9IAPKHmrHWp7SQeo"
Date: Mon, 06 Jul 2009 14:52:40 +0200
Message-Id: <1246884761.20908.11.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ABFZ9IAPKHmrHWp7SQeo
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-07-01 at 15:36 -0400, John W. Linville wrote:
> On Wed, Jul 01, 2009 at 02:35:00PM -0400, Dan Williams wrote:
>=20
> > That's really all I
> > care about, I don't want another WEXT-based driver accepted; I want all
> > the new ones using cfg80211.
>=20
> Now there is a discussion we should have had in Berlin...is it time
> to insist on cfg80211-based configuration for all new drivers?

Should we publish something like this:
http://wireless.kernel.org/wext-statement (don't want it indexed by
google yet so you need to log on to view it), for example on lwn? Just
so more application developers are also aware.

johannes

--=-ABFZ9IAPKHmrHWp7SQeo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKUfOVAAoJEODzc/N7+QmaxCIQAIojvjkN+lrHk5j3nS/rc+gI
SXmzV6o6O9BvjzP5WWdPgevtQET/OIEBZdyRuUaRcm36Mq2dMvq31voOyaEQAVBt
MDzk1rmVwWYPntOMgeCJMUUu0pb8ST4ltuevBfoAsIaAqiMLyNog5JLKU5AyPeLK
JvCCAwgRY6sgxxdYOREllWtNsvi1TKd8QOCoXElkQ6wCXrQ0EjL4d56nfkuHq/nd
cIvSdfLOW6z36xzAfBPFTuYmHQlSGFekrF5eLkwljhc86fuq6lxHhEOA+ZryZ49T
Pfe2paJaMaL7LUqnErxFhfZVFgJZTcmasGwG0D9pXSB8F6zyeA1q4xH/zAqtK47V
9RNJUxl5TATfXog3nJxBRYXG+qw1m3nYz03vP1ksthm0Wn5lPpAIsJNRe9PlpH1Q
FekY/MDdtHsaRpeuCYRGHFtOKFvnuxIK30QjlEJGNHPH60UxbBg62WdLCZx5Ip9X
MXd9T0SaWZ6R2WRCT4YQHfyXzoMTHbAuu2l4KSgs+YgEBekDrJVcevmrzujQWGzU
f4dPhWewGe7AHwt4fn2m+/H08O2THiiZjvYegtkY2dhkddP29Qh0uG0pgc+AyoQu
fJMmrKAR1ypoMxsLblKe6kKMlyT9of5e8c9giW65pguUIklEFspUQk+eIc0Kk2IP
VBOlo1vv52MdfEqc8djj
=JuIg
-----END PGP SIGNATURE-----

--=-ABFZ9IAPKHmrHWp7SQeo--

