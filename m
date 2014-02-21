Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:33438 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754612AbaBUBVi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Feb 2014 20:21:38 -0500
Date: Thu, 20 Feb 2014 19:20:14 -0600
From: Felipe Balbi <balbi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: "Mark A. Greer" <mgreer@animalcreek.com>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Felipe Balbi <balbi@ti.com>, Erick Macias <emacias@ti.com>,
	Thierry Escande <thierry.escande@linux.intel.com>,
	<linux-wireless@vger.kernel.org>, <linux-nfc@ml01.01.org>,
	<devicetree@vger.kernel.org>
Subject: Re: [PATCH 1/3] NFC: trf7970a: Add driver with ISO/IEC 14443 Type 2
 Tag Support
Message-ID: <20140221011955.GC19336@saruman.home> (sfid-20140221_022143_124171_715E883D)
Reply-To: <balbi@ti.com>
References: <1391206631-9862-1-git-send-email-mgreer@animalcreek.com>
 <1391206631-9862-2-git-send-email-mgreer@animalcreek.com>
 <20140221005059.GS18868@zurbaran>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="brEuL7wsLY8+TuWz"
In-Reply-To: <20140221005059.GS18868@zurbaran>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--brEuL7wsLY8+TuWz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Feb 21, 2014 at 01:50:59AM +0100, Samuel Ortiz wrote:
> > +#define TRF7970A_QUIRK_IRQ_STATUS_READ_ERRATA	BIT(0)
> Are there actually any TRF970 devices that do not need this quirk ?

in the oven ;-)

--=20
balbi

--brEuL7wsLY8+TuWz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTBqnOAAoJEIaOsuA1yqREDakP+gISIGOrOTXn/8FGkLmoMAic
NKYddiwynGB2eZRTR4LSBH0GzZ0LAV1xP4LF8qoFqYImcycqKX5P1hLWkb1mG45x
V715me8v7Bl6hTjyhA/VrUaTvm1n5JwfXhoS+vDHXSN8heMKKZpbS01B4BGOS9bE
Bdnp35RWNNap1c9mn4pyhYop1hZ10zrx8TXx/zdTRZcH4Y+HBbIXAtQnC0/chvx/
meGfJqEyP35/JViHfg1QVx4L4skQgccnV3KAxgYgyygiTTx1RtKApxJw6MjpCSxY
jkEGHnLfNGXNdt14Y0tEJ1YZObbzD17r4E0fTow6vLapL5app11rkUNQaHV4jhRW
fUjeiE2oviZ8oqdm8oBiyj+YSxQBi+AyyNUlL8y7wfrV5xtlF2A0SG13WFkqiE8h
Mdq97NBzsNthMg7DsHOoFdHsqnJ3BMLHcFv35CU2RcKRs4SkIunDzmY+g76+DXau
jtc8JnZ4L+jzw+QGQYaJlGX3Ozy4nrl9s8kzdYmtmm0YYt0VPCvX3jyP4E6avgqi
hpqqEnuRhb1/NO18ztzjCSeC9kn6myU99EmWbQ30NmUQ+w1glvxqQ+QNk6q/GEVQ
L6as8i/Rq9k/tK4thdz4SgKK3tFehLv2m2kl9yJuQdPI2K8Rrjmp+fNHXYkAZTSj
PlDlNuyw1+JLlyO/Pfn5
=pRcA
-----END PGP SIGNATURE-----

--brEuL7wsLY8+TuWz--
