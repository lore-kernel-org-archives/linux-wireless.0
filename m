Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:32835 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbXJCGrd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Oct 2007 02:47:33 -0400
Subject: Re: [PATCH] hostapd: don't try setting the generic IE to the kernel
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20071003030150.GG933@jm.kir.nu> (sfid-20071003_040255_295721_C594139D)
References: <1190811258.4204.7.camel@johannes.berg>
	 <20071003030150.GG933@jm.kir.nu> (sfid-20071003_040255_295721_C594139D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Y4HgIE7T9Sf9fxM88N92"
Date: Wed, 03 Oct 2007 08:47:34 +0200
Message-Id: <1191394054.4178.2.camel@johannes.berg> (sfid-20071003_074742_294902_8C32AEF2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Y4HgIE7T9Sf9fxM88N92
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-10-02 at 20:01 -0700, Jouni Malinen wrote:

> hostapd_set_generic_elem() wrapper for this driver wrapper function
> should return 0 if the wrapper is not implemented (function pointer is
> NULL).. Did I miss something or shouldn't we just remove
> i802_set_generic_elem() function completely instead of leaving the empty
> "return 0" version in?

Oh no you're right, somehow I was under the impression that the wrapper
function returned an error if it wasn't implemented. Want a new patch?

johannes

--=-Y4HgIE7T9Sf9fxM88N92
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARwM7BaVg1VMiehFYAQIdJQ/9EWYHEV6GFRAupMBcfCnIE4EBbkYx//75
OK/WJWAFchRMFPWZspuZHyZSwD5BaEhfbviu2Jth+9lfDJ8neIWcAt05SUxVzqLs
66rvpqv0TTwOppSWgGBeQQgJfHLdnNqYE5PtdwDlomdiVlS6rwYfbLQXJFspRGhJ
GVkhaIEb3OTyNpD6dXny2ekFkjQR8rHDfIf/RuJlCb2DeTIs1BUimjN2seMYqboG
liHEVR8mi5yt2mCDOyr8/Ags3yHlaaZ1NaQsh/Z+jXf3V1xjdZLOpbGlhIrHJYnN
8F8c7gjs60U4c7F969URog4Mr67QTT3/RmoFbEMKUAM2T98A/80PsCxCfQvhsuyx
7+lIWUZF8ODgw/1975++vF6ovpkCd+rCxsvvEI6/svfoxvRJo2PQ4cvVYHxhZuSH
7mW8BwbD2mkPP2alAuOu7DvBXUpGhvjPRj1LVU/007sLRpnR8OupXf+gcoFnoOyq
LOZjhgYVs6lkDp6X5Pd8uBSDnEXNldLahGLWmu5qrHH3F30QKyKRqZ764DDlzzUU
zsXKugYgyTJzDS8ulcRQKgHQG/L4DdzWbaWc7VVLNjmCmF70TKL40JNWoik5kzH3
Z2SaOp6Yf5NvOv6guF+WiHr12vfaPDZlASt9eZWEegsbtLcgdX6AIu2/GIYoWqfI
orle1BiuwJU=
=QDPM
-----END PGP SIGNATURE-----

--=-Y4HgIE7T9Sf9fxM88N92--

