Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55322 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760471AbYJJVDA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2008 17:03:00 -0400
Subject: Re: ath9k rate control API abuse
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <48EF128C.6070800@atheros.com>
References: <1223629834.3930.67.camel@johannes.berg>
	 <48EF128C.6070800@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-HCHcDuwwgj1N+3ryzBs+"
Date: Fri, 10 Oct 2008 23:02:57 +0200
Message-Id: <1223672577.3748.40.camel@johannes.berg> (sfid-20081010_230305_355542_237E83A6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-HCHcDuwwgj1N+3ryzBs+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-10-10 at 14:00 +0530, Vasanthakumar Thiagarajan wrote:

> Thanks for the bug report and comments.  This private structure was
> mainly introduced for
> multirate support. Since now tx_info has most of the information that we
> need for
> rate control this private structure can be nuked. I will clean this up.

Wait a minute. We're about to post patches that revamp it again and that
will be much easier for you too.

johannes

--=-HCHcDuwwgj1N+3ryzBs+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI78L+AAoJEKVg1VMiehFYppoP/iWZf+NXK5BBVyc/btYWZ65S
gMew6lj+kGKdnpvO5Dm3c6JKr/w9/wVbs/b/tX17hOdkKeFUFAXUtr6V64B7l9/h
vGETVZMON7VeqdeB6FkuI3OiQJKLA1Z3IWighsWvxc9eVaI8gt8E6I8JLZIYam8b
2Q8VBwFm25/zutBFoa6w5ZqxuDNp30i+fL87E9VFd/Xj/xk5ZVjWJWbyx9WAVb+D
y7uHT48iLxEGukGFTFfh+Yko2cwSxeVqYa3/luxMlvUcGU4OPubLJAAL191c65VY
oPOzSZd/RN9QVk2GJIHuzeAxmlYg+NrIMGyFWJsNPPBO+MwmV/R21Sybl41pt+N3
RZxbVUPMy265QpPxs1xTug7MOmmrTfw3Af5kLQEra9Js7zny28la0CFWifDMrVdh
RZXHYQ7jgNnO3RsILXq4i+LjjH8q2R6SGRyAFjrxfaWafS1tscScfghkxOWO5ulj
lfBppgszssife5ylWfo9wedzNhSp9QhMx5fK7SISO1C2e0xo8VNHjjFoy0baVFAK
U8jzKkdcwOqyT7nFOdY6idPOh0oI58Pr7CgibyH9i9GyU8e46ExUp6XcXv9Jqkf9
z+EdmER1qN+mQXzBmDYswTuCYKTt+tP7X51WX45vTWiZejCWKb8h3GCNAp7BGchx
29YjsXwMU7ktqLikVAKR
=Z0ev
-----END PGP SIGNATURE-----

--=-HCHcDuwwgj1N+3ryzBs+--

