Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:58969 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755968AbZEZMTi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2009 08:19:38 -0400
Received: by qw-out-2122.google.com with SMTP id 5so2393661qwd.37
        for <linux-wireless@vger.kernel.org>; Tue, 26 May 2009 05:19:39 -0700 (PDT)
Message-ID: <4A1BDE51.7020009@gmail.com>
Date: Tue, 26 May 2009 08:19:29 -0400
From: Will Keaney <keaneyw@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v11] rfkill: rewrite
References: <1242942720.4212.19.camel@johannes.local> <1243068246.4606.45.camel@johannes.local>
In-Reply-To: <1243068246.4606.45.camel@johannes.local>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig5033585128021BDCEAD8761A"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig5033585128021BDCEAD8761A
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Johannes Berg wrote:
> This patch completely rewrites the rfkill core to address
> the following deficiencies:
>  =20
I applied this to a fresh pull of wireless-testing this morning, and
haven't had any problems from it.  It looks like the soft lockup I
reported earlier has been fixed.

Thanks,

Will Keaney



--------------enig5033585128021BDCEAD8761A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkob3lUACgkQjfayWCA8dDHPzACeKbzcqJ7nQ13Cn/EX2su5Rbsm
+WkAn0kRXhXYESVcqLqIQUJvILBkyuOR
=SNE2
-----END PGP SIGNATURE-----

--------------enig5033585128021BDCEAD8761A--
