Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50749 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564AbZCUOj0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Mar 2009 10:39:26 -0400
Subject: Japan regulations
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-uDbDZsSNEsEd8nsrj4EJ"
Date: Sat, 21 Mar 2009 15:39:23 +0100
Message-Id: <1237646363.5100.209.camel@johannes.local> (sfid-20090321_153929_909353_98F35CDA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-uDbDZsSNEsEd8nsrj4EJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

The regulatory info for JP looks very odd
(http://wireless.kernel.org/en/developers/Regulatory/Database?alpha2=3DJP):

country JP:
        (2402.000 - 2472.000 @ 40.000), (N/A, 20.00)
        (2457.000 - 2482.000 @ 20.000), (N/A, 20.00)
        (2474.000 - 2494.000 @ 20.000), (N/A, 20.00), NO-OFDM

        (4910.000 - 4930.000 @ 10.000), (N/A, 23.00)
        (4910.000 - 4990.000 @ 40.000), (N/A, 23.00)

        (4930.000 - 4950.000 @ 10.000), (N/A, 23.00)

        (5030.000 - 5045.000 @ 10.000), (N/A, 23.00)
        (5030.000 - 5090.000 @ 40.000), (N/A, 23.00)
        (5050.000 - 5060.000 @ 10.000), (N/A, 23.00)

        (5170.000 - 5250.000 @ 40.000), (N/A, 20.00)

        (5250.000 - 5330.000 @ 40.000), (N/A, 20.00), DFS

        (5490.000 - 5710.000 @ 40.000), (N/A, 23.00), DFS

multiple of the ranges (blocked) overlap, especially the 4910 MHz part
is strange, seems like that first rule should be killed. Also, how
should the 2.4GHz part be interpreted?

Currently we are not interpreting overlapping ranges properly at all --
we really need to fix a set of interpretation rules.

johannes

--=-uDbDZsSNEsEd8nsrj4EJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJxPwYAAoJEKVg1VMiehFYFawQAJw53yjOxi9SE6Q+EQswBfzx
GKvkmMUWNqzDb2cheHVcFAz4BGFIzCRlEGr0sdtLsZC3HLMkqZnhU7Lua3bIRUVo
ub9CHiodmfFlqGfWOpY+4GKuYHYt4JOus+iSYosE0JUiuiZMq2QZGmV38xgoet4M
Tn8ikikuWj19H1PdRKnV5ES9WgKoKC3I+QgKc8qoSs0AisYKSXWenVmQJJe9ZxdH
Kp91pjktERtmBeqk9aXH8cbfUBr0KVHyNShjhUbW2V0+5IlskoLQ6sGtRlPIT1BW
qVKcwvUk7tU/jbnZikbK1MvJM3wnSnaFh3ATedM/JqUiY2fYzgaHq0ZhxA1yq1+Q
RsWEH61KKMDyPMhYN6kFsYB0fy5Huxy9Jrt5KEJPbo1yOQJ+E9PsV5MV8UCab9R3
5Nei6uDYUnZCpiGRjUevAIZagdqECno0H2A2kh/XiJYbp6ZGO2g8KvCIMfah9565
UIGJpBh0HpxQKqulClcbSy4SRR+EcgJkepulMg9t6Mlq+nIpFdkg1EoC9vM0uab6
dlOIdwf5dTSjkUJ58T5uO+im9y5q+XmJGfvKSzwVVZ55LErbmYQKjtyCK06U0F5f
aIMEMMB4kKwl+TpaIQVZ/Y23HAYCert8mbaNRKQ95o5f7aDypUvd2YCz+BdqC5zr
8JaGgegeJQ5K0U57H9uI
=glV6
-----END PGP SIGNATURE-----

--=-uDbDZsSNEsEd8nsrj4EJ--

