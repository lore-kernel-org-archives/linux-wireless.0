Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:50078 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745AbaETITM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2014 04:19:12 -0400
Date: Tue, 20 May 2014 10:18:25 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Antonio Quartulli <antonio@meshcoding.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>
Subject: Re: [PATCH] b43: xmit: set 5 GHz bit depending on current band
Message-ID: <20140520101825.3d928446@wiggum> (sfid-20140520_101917_308849_FAB30641)
In-Reply-To: <CACna6ryTSKim3ckZsJnE_1zrXW-JFabZSaJrLrOFL+JgXzLLjQ@mail.gmail.com>
References: <1400568385-26182-1-git-send-email-zajec5@gmail.com>
	<537AFAA0.3070401@meshcoding.com>
	<CACna6rwa6zKX=ngSQhmWTrZcy_W7fjMrTmQ-A8XURZCVMX1nrA@mail.gmail.com>
	<537AFFEB.1040707@meshcoding.com>
	<CACna6ryTSKim3ckZsJnE_1zrXW-JFabZSaJrLrOFL+JgXzLLjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/A=SEVQ6.fyOYIKK3UdXH9C1"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/A=SEVQ6.fyOYIKK3UdXH9C1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 20 May 2014 09:23:28 +0200
Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wrote:

> You're probably right. It's just a bit historical, it matches bcm47xx
> specs, Broadcom's public code, Broadcom headers and probably their
> internal specs. That's why I didn't decide to really touch it, to
> avoid confusion when comparing specs with the code.


The thing is that the actual hardware bit is called GMODE.
I guess we could rename that variable and add a comment, if it's really an =
issue.
But not the #define for the hardware bit.


--=20
Michael.

----
Please use PGP/GPG encryption.
Key-ID: F532BE1D908D8B0E
--------

--Sig_/A=SEVQ6.fyOYIKK3UdXH9C1
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTew/VAAoJEPUyvh2QjYsOHCgQANeSAke/cFI5Z9fM8rHaYcSD
xVcUs0p21d/J3Lcr724DMZGZGzbU4qkjK/ezQbvSEfoe2wsdbUruMo/UxnxHkKcJ
AgqZF55CgdLcdSDTAat8whQdzMuodaGma4KDKRDxzEBp5tr4PL8RMjC6ALvqjQKL
Ij0J1D4qJPpI78WCU94otlt/8MDvuKplXOFLQ4hDP11JoTaiCWb0S0N+hy7Gw/v3
Yh5Cg++QA/QLiQCz8/i1hS3lboy9AxwR5e5+Uyg1HumnYPVO3ex+t+xVknNITvsw
3NJRrpuMCx91tkEizTkjFFzC//SZajHDjIARixo5ogLxxKjL/DDxRltN++GnJWp+
dDIWJPOD3KCUv526bXXrFx0F5B1I/0VDiNTqKPUvFgCtbfuYIWtC3wTjsf3RJNKu
sEgNP1dR8x1eIlAxI/f0vMmyDMkIV6khMPjBf4iKj2EB0XiozUgpXoBGJs29nVIy
bapMj2xm4LT841V9Qg094sulNv8I6iwM7l+x0T2xryYrS/byYSaHD+7qBslJgPcD
Ezre7qk6RjccTz1d+AYQCca9qNqKCX2cR5Hz98K9byH9tlpwQJfUYeYiM3G+b1An
+EJoUn7HOhwfJ2PKtHplHNMsrVTz+IzgAcdspxq4e+LEPp9dm6Yddib3RpTBfNEI
S56JGPmi8Y8HPsexkP14
=xqW0
-----END PGP SIGNATURE-----

--Sig_/A=SEVQ6.fyOYIKK3UdXH9C1--
