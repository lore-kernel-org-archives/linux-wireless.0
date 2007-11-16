Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:46039 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934343AbXKPU4S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2007 15:56:18 -0500
Subject: Re: [PATCH] ath5k: consistent info and error logging
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <Kalle.Valo@nokia.com>
Cc: Bruno Randolf <bruno@thinktube.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
In-Reply-To: <87mytez5vs.fsf@nokia.com>
References: <1195200656-25847-1-git-send-email-bruno@thinktube.com>
	 <1195214563.8147.118.camel@johannes.berg>  <87mytez5vs.fsf@nokia.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-JUXai8cJmA+QhwI/PaPG"
Date: Fri, 16 Nov 2007 16:53:58 +0100
Message-Id: <1195228438.8147.146.camel@johannes.berg> (sfid-20071116_205643_026239_FDC04CB4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-JUXai8cJmA+QhwI/PaPG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Fri, 2007-11-16 at 15:17 +0200, Kalle Valo wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
>=20
> >> +#define AR5K_INFO(_sc, _fmt, ...)	\
> >> +	printk(KERN_INFO "ath5k %s: " _fmt, wiphy_name((_sc)->hw->wiphy), ##=
__VA_ARGS__)
> >
> > Eww. Can't you make them static inlines?
>=20
> Wasn't it so that a inline function with va_args is not possible?=20

Hmm. That might be true. How about just using dev_dbg? Not that I really
ever need to look into ath5k (hopefully!), but the code just struck me
as not very nice.

johannes

--=-JUXai8cJmA+QhwI/PaPG
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARz29FaVg1VMiehFYAQI3Gw/8CBpjYG+qu1ypyQBkN4wUINCum+en8DZv
qDnRXR+lsQH70iAnx7HLwd07TDhASrxQeFQDv60zwNtv2DtwPjdMTTuESYn1NpbR
TWnGkuqnBryo1CVlqdw3gktLfR+UVhWxmsbTNMtJIjEDcU1C2OAGpEKquW7pnd64
Fk7NLlDKWvTnrqJifsq2I+oFfeZR7uAfwDOK9dpMs45aRcAPGnpNva7aAUdpSyIU
lFLIJvnxwaYemrvCzAKjqKeRxifGnf34J9uFiiz/kGs95WBnlB5LYHBcjHl5O0ZF
Sk/2t9IFoPyDETUc6tYYu4VmMCY16bEXknAkkDjrEEwww/Ct6tENy9WEuh8WsKn4
CwQwSkGJrtrlNo/aab22yA5YVQZiztUdL8TN3EUBjraOLnqWi03MGOdWRjGlQumq
mqwSsdqWH+WPmR7Oi7hQhhULrQGZYez5JjZZiI+Lgdi8/NvePZccswApFG0Jz02p
d7w2j3Xu/Qll4+rhWpcw5JZ4tG6VfZ/W0mm0LzEzeK8HszPTFOJvSkCFcMBt1ebQ
C0vtRx0e3FDeK1HNaeqRQMotF1tyTlMCNnpYkxPpArB06jMKfiSw/7vwjha43Omp
esDQrCx7EP2uN+G4g4ELe/Dl7i0bp/Huppk2dO4EQqT/CbFHUeAjCMudpTyZ4OVo
OfwdiGyGeGY=
=qikt
-----END PGP SIGNATURE-----

--=-JUXai8cJmA+QhwI/PaPG--

