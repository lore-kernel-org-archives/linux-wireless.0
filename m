Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42258 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097AbYJORh1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Oct 2008 13:37:27 -0400
Subject: Re: New Regulatory Domain Api.
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <holtmann@linux.intel.com>
Cc: Zhu Yi <yi.zhu@intel.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1224091740.28173.13.camel@californication>
References: <B27EBC40D200ED48A3F4CC2EBEABAE0B16C892F2@orsmsx501.amr.corp.intel.com>
	 <20081009154547.GB13349@tesla>
	 <1223608949.2510.1061.camel@debian.sh.intel.com>
	 (sfid-20081010_052512_883760_F373F92C)  <1223975972.10113.20.camel@johannes.berg>
	 <1224034856.24677.9.camel@debian.sh.intel.com>
	 <1224085845.4764.23.camel@californication>
	 <1224086490.735.8.camel@johannes.berg>
	 <1224091740.28173.13.camel@californication>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-El1beGQyp2Jw55J2bqF3"
Date: Wed, 15 Oct 2008 19:36:45 +0200
Message-Id: <1224092205.735.12.camel@johannes.berg> (sfid-20081015_193741_322160_0561E0DA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-El1beGQyp2Jw55J2bqF3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-10-15 at 19:29 +0200, Marcel Holtmann wrote:

> I think it is fine to do so. Since plugging in an USB wireless card is
> expected to work and if we limit it, lets give the user at least some
> way to figure out why it is limited.
>=20
> Especially when your internal one is a BG-card and you external one is
> an A-card only (or combo). And you put it in to just access an
> A-network.

Good point. I've never really considered that since we only added this
feature after understanding you at OLS :)

johannes

--=-El1beGQyp2Jw55J2bqF3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI9iopAAoJEKVg1VMiehFYO0IP/03te+vwpYVHETtrD+/judHI
ed9JsykIBFRt8fDYjAp3iS5rZyM3H+7Hn8VrV1Oq5lpA+dvT62WwBseS3W59fH9h
YyZZMYTfUiFTLBk+l9DaurbOJZ3vhYnnUKWDARj2zvZAtqlrk+vMXBYNQ8vnJEoh
EVxGRNc28t5tKQLuwVitbgZRHQDOd6dEhJL1CuSosIZPXmi0a4NPqGk27jlCMAPE
HZwmSRcHIS5x/QOMx0soaHrIjGU6yM5cr9jq+wD2ZClkxcuZGrzM18E9coQr7D69
eXLIdrDIDD9iKYKTbFINAySKHZoOPc6uRgZ7k01VqGprckhexXVpbI9BRjrZcMxO
FNIaa7UytrWfg+DADSDU3THIIr8Hm5kt2EuQ+4R/eHR+mqqsfW7BPUZhA66qVLCM
rqTDW5KKr78hEQFIqp0pNd7E83fFmQjbplmvqvVBEbdvb7EYYWQvS1wGS4B+ppqE
FrMF3KDitM/fRmqvmFAJq0a7yjQTObNtvos5P9SDxbO35wAnNLthOPXfKKscOEAK
FgwyD19LURGlrJCNKy9pGxnczs1CXzQbbh0+zxjRgrLgbzOUl2/xEcD7SItVZ7gv
++m2SORv2nU+q4C7S96/wfMwMFCOpnJN6r0ExklfbqbZbZ32TL+cH44xoBNKldIC
fJatSdThUuLDs0X9HNCz
=1c05
-----END PGP SIGNATURE-----

--=-El1beGQyp2Jw55J2bqF3--

