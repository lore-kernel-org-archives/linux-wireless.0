Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:38337 "EHLO v3-1039.vlinux.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752218AbcIFHks (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Sep 2016 03:40:48 -0400
From: Sven Eckelmann <sven@narfation.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Simon Wunderlich <sw@simonwunderlich.de>,
        linux-wireless@vger.kernel.org,
        Pannirselvam Kanagaratnam <pannirk@gmail.com>
Subject: Re: Debugging RTL8192CU firmware loading on 3.12 powerpc
Date: Tue, 06 Sep 2016 09:40:41 +0200
Message-ID: <2747159.ja51ucCDFk@bentobox> (sfid-20160906_094053_498015_DA8049D3)
In-Reply-To: <d6f2b558-167b-cb48-e924-7bac815817b1@lwfinger.net>
References: <1586991.4QUcrJhXOm@prime> <d6f2b558-167b-cb48-e924-7bac815817b1@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1791668.jjbnYZ7q0s"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1791668.jjbnYZ7q0s
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Freitag, 2. September 2016 12:53:28 CEST Larry Finger wrote:
[...]
> The patch I included in my previous E-mail, and attached here,  does get the
> firmware loaded correctly. There is still a problem that prevents
> authentication. I'm still looking for that issue.

Thanks for the fast update. I am currently testing your patch. It looks like 
the initial error is now gone. The hostapd also starts but beaconing doesn't 
seem to work at all (no error from the kernel/hostapd but the device is not 
sending anything). I am currently checking how beaconing is supposed to work 
in your driver. Maybe I will spot something useful.

Kind regards,
	Sven
--nextPart1791668.jjbnYZ7q0s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJXznL5AAoJEF2HCgfBJntGCGUP/3mYV4uCFDxRXmGyh4PuXeLZ
/cirqA+7J8eCR91ZuGZfAcotrpipyB+977ZIncdcDLJYiJjGb0214uDAnOWknDwr
KGv3tbICdGR7QI67CVbQwRVGwQWSuzK4Z/7YfTqmOkfjO3a6Ctf5wWUpJTpN9j9v
e+mTSH2n1VBC9AhWFmcLkf0Dj0tU+Zh0gWjYzlRH91ixTmQvxyGn+W1pSGYWnxBC
YB3E/PSRibVlmoxI+KgtEoMrCiU1+VMLbKETby5i/6ZKQtrv2iU2avJSLwPUAhgv
4HFDavNoNPaqVWQvB34cZ9/Gy3c5BOdVNmvpCTbrlYl1y2si4EcLC0yRsbFZdkJh
fBfULZmFv0FQDOBJ9hQwM0EhUDZh1ZBiolHO87P+ES4R/doBhDveT9AikPHmJlDY
TPqNLSCpfsZIld/rAyU+NMPXlgpwYFDFQcUgSz6xfDAERYDGX5bO4E6FY5iXF3bN
US+hZj1veAA4oehuLORZamMzq6YMpq4YF6/GGeAd8SlUp7OT+DYlieVjb0FT5cwr
H5XB/Hl5ywmm6UMOD7AE03FhPtwuea5immoja7Npj45J/ou4U6AeZjjzi2h4tnfL
o8BY0gj8YdaoXs1tyyV6hDNuSpSX1+TN4oLkpYF/X63PXwEQpWHCHr9jw0m3oUQ7
cGqHBR5tbHJ5Z6YD3Euh
=9uJG
-----END PGP SIGNATURE-----

--nextPart1791668.jjbnYZ7q0s--
