Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:40390 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756205Ab2KVV7T (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2012 16:59:19 -0500
From: Sven Eckelmann <sven@narfation.org>
To: Walter Robert Ditzler <ditwal001@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: ap
Date: Thu, 22 Nov 2012 22:59:13 +0100
Message-ID: <1519677.h6tbHHA5o0@sven-laptop.home.narfation.org> (sfid-20121122_225927_463956_AF11CE72)
In-Reply-To: <!&!AAAAAAAAAAAYAAAAAAAAAOJK0u4CH31Kl5v1RPAzyrZCgQAAEAAAAK0684NI5KVMj9apXTFW10wBAAAAAA==@gmail.com>
References: <!&!AAAAAAAAAAAYAAAAAAAAAOJK0u4CH31Kl5v1RPAzyrZCgQAAEAAAAK0684NI5KVMj9apXTFW10wBAAAAAA==@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart5643953.Hk0DpVTUi6"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--nextPart5643953.Hk0DpVTUi6
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Tuesday 20 November 2012 14:02:41 Walter Robert Ditzler wrote:
[..]
> 
> *** /etc/abbeoo/abo_cfghostapd24
> interface=wlan1
> bridge=br0
> driver=nl80211
> ssid=abbeoo_c
> hw_mode=g
> channel=10
> country_code=CH
> ***
> 
> *** /etc/abbeoo/abo_cfghostapd50
> interface=wlan1
> bridge=br0
> driver=nl80211
> country_code=CH
> ssid=abbeoo_cc
> hw_mode=a
> channel=48
> ***

How do you expect two instances of hostapd to manage wlan1 with different 
bands/channels?

Kind regards,
	Sven
--nextPart5643953.Hk0DpVTUi6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABCgAGBQJQrqAxAAoJEF2HCgfBJntGYUUQAM0SD1gshoniK+jI0dw/HuoC
n0hfxoj3woysIDq5MFnxLq6Ueem++gw6foA6xNJYf0HrxmdYfvxCE8iVaKOZGhA/
EK004GkkoY1uEFpMv13zaVbvF0m7KuI/pzzmANYbA47QBUCa20OyyJPSOpc1E3oE
U2/SC7ZSGbTcTzTvrCZ2LBdWdTNy159xDjVdDuNTaTHgwfsa/6LW85D3+0vycsrH
w1zKz664TcllW8HESY/EPeLjQ+ZTjfV18NauAgA0DaTTWSsxyMCw5LYmmAH+JhsN
h4kN9zLI9GrC6ygUrNz79dCgzn2XYy9P69D1buZRi3MqWWg9Zg6JlsknAkuZVg1y
EIY9oCqEqhcv63Qz7tNRRHEs9FKr6lB0K4eG6ycgsicOaYB28glGW1IiItYmjSVn
iVVaMhE4s3wsPyqooGBfC5yrjwv8eycSs/U5D4JXJ4sdJkCtWxEux5kOh5+/ZG1v
CrFpD0RLt5Tq/+vaoLHH56nFKUho0pGDUJbA0AV/vl3pYMiXnStonU9+8yY7ytpt
bmVXfjIpkqWbRvThYODxCjEJVhwrVQgG/nVjNz1uHDK+sX0pQDaf2vGRBhdrDDZ5
alFxc1J88Dy3s9N8ukq2HwXr4UgbfVRv5+PnIxtU4jpko6A8C7gBL7Ibe2XVssT4
wbmgI/BOdFBtGYrzTOQ3
=q7S1
-----END PGP SIGNATURE-----

--nextPart5643953.Hk0DpVTUi6--

