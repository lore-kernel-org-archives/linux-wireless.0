Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:33880 "EHLO v3-1039.vlinux.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932173AbcIBL0g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Sep 2016 07:26:36 -0400
From: Sven Eckelmann <sven@narfation.org>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: Simon Wunderlich <sw@simonwunderlich.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless@vger.kernel.org,
        Pannirselvam Kanagaratnam <pannirk@gmail.com>
Subject: Re: Debugging RTL8192CU firmware loading on 3.12 powerpc
Date: Fri, 02 Sep 2016 13:26:26 +0200
Message-ID: <6578938.N4SWO0a2Ic@bentobox> (sfid-20160902_132657_577642_121D8893)
In-Reply-To: <8cae6bb9-0465-9210-b543-61136836c263@broadcom.com>
References: <1586991.4QUcrJhXOm@prime> <8cae6bb9-0465-9210-b543-61136836c263@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart7295035.8hyijCJXRR"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart7295035.8hyijCJXRR
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Freitag, 2. September 2016 13:13:20 CEST Arend Van Spriel wrote:
[...]
> > Do you have any recommendations where the firmware loading problems could
> > come from, and where we could start to debug? Any pointers would be
> > appreciated.
> Hi Simon,
> 
> Could it be an endian issue?

Yes, it could be one (at least I've also guessed this - I could still be 
completely wrong). But the problem is now to find a good starting point for 
the debugging effort.

I've only looked at Simon's screen once while he gather USB dumps but didn't 
spot any obvious at that time. There was also the problem that the comparison 
dump looked already a lot different due to some timing differences.

I think Simon can give you later more details (when required).

Kind regards,
	Sven
--nextPart7295035.8hyijCJXRR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJXyWHiAAoJEF2HCgfBJntGvMgQAMBky8S+3zzEXGSSuK68st9F
jyLtE2Qjzyfq8+H8OXmfToUQGcQ69DMqEZbYvPEj6fdi1h6llRR43uoox8YrLOsc
jIXnnY5Md/866Ry5Q0x5Vim2xYCcx106fqjA6wefwps5YUoVTZUUg+UiM7YPazFJ
iAe10x27t/2EazRFlFfFxHueydwkO+KyT7H4HnKTymQsl0tQv2FuE+0fKY5pKoFv
g0Oa9MWpBMVgzSv7/RVshEQ+JtpAXZjQ/w3Ob1dvBOHvlktRyKYT50aa4mjJ4aAd
WD1sRE0lUPMVTfX0vwdFzn2hZINmsUY/IqW3Amqx9h4lvmWbaW5Wd4V1Jhcsa5by
1uYghCvufNE+EV7ziiRUgb9xUvXMPeZNVvM+9e5Qyl8F3ByH4q3GIQQrIuEYx8dB
cr7QJ2NMZoIpEX814GSBwoHPtwJdsiI7qTlUtzuypOdst7/yKEg8v0ZewPbky03E
25Tllo5Uw3gYHLspVzmlHSzTPY/Hm/qDy6CbtakvGdFFpaLJrtAoSAs4d8HqOX2U
soja0NRMRBfLpK7lsnBzAhTHMUUxhGQfwt4kvdNvAL3EzXHEGFpomTZ3d9sI9K2G
NRz6xYvK6Cmr22IO/8EYSHCBMwhzO8ds1YbVdUfnwqhhiHeAQxlcsteGfqri4sC0
xA3ERn2OjJEfErmUs3lZ
=r8Y4
-----END PGP SIGNATURE-----

--nextPart7295035.8hyijCJXRR--
