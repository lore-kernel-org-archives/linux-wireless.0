Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:38624 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759752AbYB2QAM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Feb 2008 11:00:12 -0500
Subject: Re: ath5k on ARM
From: Johannes Berg <johannes@sipsolutions.net>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>, linux-wireless@vger.kernel.org
In-Reply-To: <40f31dec0802290511i694755ecoed3ac2e38c030c7d@mail.gmail.com> (sfid-20080229_131130_826786_AA26B02E)
References: <m3hcfum53k.fsf@maximus.localdomain>
	 <40f31dec0802290511i694755ecoed3ac2e38c030c7d@mail.gmail.com>
	 (sfid-20080229_131130_826786_AA26B02E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-6hr8eu/rlgJnvdSl6eZj"
Date: Fri, 29 Feb 2008 16:59:58 +0100
Message-Id: <1204300798.3938.30.camel@johannes.berg> (sfid-20080229_160017_177091_6813BB9D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-6hr8eu/rlgJnvdSl6eZj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Fri, 2008-02-29 at 15:11 +0200, Nick Kossifidis wrote:
> 2008/2/28, Krzysztof Halasa <khc@pm.waw.pl>:
> > Hi,
> >
> >  Another thing:
> >  ath5k uses udelay(2300). ARM has (include/asm-arm/delay.h):
> >  #define MAX_UDELAY_MS 2
> >
> >  It ends up in __bad_udelay.
> >
> >  Solution?

> Hmm, i'll see if it can work with smaller delay and let you know...

Maybe use mdelay instead of udelay?

johannes

--=-6hr8eu/rlgJnvdSl6eZj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR8gr/aVg1VMiehFYAQLRYQ/+KtOS01+2Vzc3EadJN/WSoRhQylyoZLLg
ojbtIyXJ5icGwf9bL8NrRwuny1Twp4NaFLqp8vPJ4HLG7d/zl0gE6QSS/CIeayl3
RIPMF2YI4xkZEdstvAN2dV2KuqC42/QhcNcTjSMImHI14NTAtvhwCcCqfCbq8HrF
REn0++Kssfm7jbikrveYxyMNND8cnUyng2anrR4npahwR/Tqozq4aC9i6eGj7Ps9
sc1/IMwX2jvuTx4E7EB7mJ9rnrnjxrDxdH6u8zNkKNcyd92oCi7uK581qOTvewzS
L1fh1Jb6+G+jznAdJ4R3t9J+MpFNIlcMc8BC2YybkA3gIyBaGC3FmMfAKkFlFF7k
V97gfqCOY0gDPHzalBasgslZnRUmSdWCz8GRwSmFIosAsOibQtFogFWKPiv3e0PX
k0ac2vSOKlrniAnvuZCnL6VecyPCn5TJeAqY1cz8TELpud0ysxdNH+D7FmKdVlgE
i9sVXZmffardd2rJ0a84jPZOFE8IwA15pQB2+gPO1Sv0nkDS2icuSO5WEH0U285d
1/my5y8i/yW4wztEqMZOnzegrpPTIJ7apCcp68TYEeDdu6Lodl+JjO5WVGpEGVb1
8zHWt0+hQzIiC6/G3AIK0SLDTA4ab/bFOvqvMqPwcO9DC5ixQXfWV4ylJzg0S1xc
UgZAISX4/JQ=
=uKBh
-----END PGP SIGNATURE-----

--=-6hr8eu/rlgJnvdSl6eZj--

