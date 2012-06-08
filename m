Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:41529 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394Ab2FHSLE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2012 14:11:04 -0400
Date: Fri, 8 Jun 2012 20:10:53 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Andre Heider <a.heider@gmail.com>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Subject: Re: chip id 4318 regression: WARN_ON_ONCE(sdata->vif.hw_queue[i] >=
 n_queues))
Message-ID: <20120608201053.48548a11@milhouse> (sfid-20120608_201109_060165_AE57EF9C)
In-Reply-To: <4FD239AA.9090708@lwfinger.net>
References: <CAHsu+b_wQOuhbBkx25CZ2cai5VVos7zK3s=EiPBy_+OnXWiWaA@mail.gmail.com>
	<1339167160.4901.0.camel@jlt3.sipsolutions.net>
	<CAHsu+b-p1aTUG8L=5SCNB8Gqzwsm7_VA53Qf-ENPHmM5Z5C8hg@mail.gmail.com>
	<1339168452.5748.0.camel@jlt3.sipsolutions.net>
	<1339168600.5748.2.camel@jlt3.sipsolutions.net>
	<CAHsu+b_Dp-A_kC-MSofJko3hr4dYxreYQ7rrq7wzsJXVoY_5yw@mail.gmail.com>
	<4FD21C6B.5000402@lwfinger.net>
	<1339170182.5748.7.camel@jlt3.sipsolutions.net>
	<1339170287.5748.8.camel@jlt3.sipsolutions.net>
	<1339170510.5748.9.camel@jlt3.sipsolutions.net>
	<1339170742.5748.10.camel@jlt3.sipsolutions.net>
	<CAHsu+b8ZGPN3iQNGH1mdzMO6kH+F1n+qZ5cT4KMcx8bh_BP1qg@mail.gmail.com>
	<1339171159.5748.11.camel@jlt3.sipsolutions.net>
	<CAHsu+b9EgAfq6_G8xqRzf0qHkmyQnvs7j=g4wWcSVJXstAz4mw@mail.gmail.com>
	<4FD22727.7000500@lwfinger.net>
	<1339172904.5748.18.camel@jlt3.sipsolutions.net>
	<20120608183339.78a7fcbd@milhouse>
	<4FD239AA.9090708@lwfinger.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/qAyNSOqaNa/e8XW=XkvrLQ6"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/qAyNSOqaNa/e8XW=XkvrLQ6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 08 Jun 2012 12:43:06 -0500
Larry Finger <Larry.Finger@lwfinger.net> wrote:

> On 06/08/2012 11:33 AM, Michael B=C3=BCsch wrote:
> >
> > Larry, did you check with PIO?
>=20
> No, I only used DMA. With the latest patch, compilation is Ok, and DMA wo=
rks for=20
> both kinds of firmware, while PIO fails for both.

Does PIO even work without that patch and with prop-firmware?

--=20
Greetings, Michael.

PGP encryption is encouraged / 908D8B0E

--Sig_/qAyNSOqaNa/e8XW=XkvrLQ6
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP0kAtAAoJEPUyvh2QjYsOOi0QAKESew1hzKEX/s/enemCRvYT
Z/dSZVvbaW42X8SKpxZQPKNAC8OMsBZ7srgLSSFZaFLA+SK+uvqxSClT68gHmROU
gESfmVxAGbch2YpAGJ+5ts07BeXhYI0C+EVlIOw4a77Y2sCY/whv/qdVNBnKqCY2
GKe8DxoHm+rQCehemHQ3jB8nPU3N4a2PIgy8VwdBRMCgXNnWo44OQdC/97bua0T0
t17hGr9JLn1cAXcRkv4Gcvlw6nb5BoxQNKYTXStt3mRGemDb49TioRiHywxUbsd7
XdqXVIHabAcWIZaBiWN2SLbuCr/sVccT62x79jKWaxAeJssJFVLuTI857BdooRYX
T5QkAwnDXYC4xVkZ+MJqg3m+p1WjSpI/L1gXalTjKR/lw+m7iuHGkuo4TDe4163X
pxJ368jkfEDWJ8xEQQQN7AGwXAtAiYwBep3GM1qyLp+NmZQjLNiPKUeAIiul79mQ
y14kari2ydeD8feX0qNDph6jmYfIdHbs0H9A5v9hT5rSdAfndKJsm5v8q8yop9hi
KC6NiYrAN+A8NJWdi2KTS+S9vmjcQrtvB2gET7vJe7s+PMkVuPcaTyf/mVjiTMqi
Syomq0JfvH63jjO9SHqF4uLys0mHzxgHZjz28/HAGpI8Yl1CzOk0yoqaCXtIlsQq
hsxwP9IxKIqZRLR8PfQV
=bMzH
-----END PGP SIGNATURE-----

--Sig_/qAyNSOqaNa/e8XW=XkvrLQ6--
