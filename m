Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:35962 "EHLO v3-1039.vlinux.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964777AbeBMNPy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Feb 2018 08:15:54 -0500
From: Sven Eckelmann <sven@narfation.org>
To: Ali Abedi <a2abedi@uwaterloo.ca>
Cc: linux-wireless@vger.kernel.org
Subject: Re: 802.11ac devices that use Minstrel_HT
Date: Tue, 13 Feb 2018 14:15:48 +0100
Message-ID: <8037020.pGPiyahZAU@bentobox> (sfid-20180213_141558_564790_05A376AB)
In-Reply-To: <00665215-8a85-365d-dcfa-aa9b1aeedd1c@mailservices.uwaterloo.ca>
References: <769da6f9-bca3-48bd-32e6-009dd82f3c96@mailservices.uwaterloo.ca> <4674890.5ipQsmKAE1@bentobox> <00665215-8a85-365d-dcfa-aa9b1aeedd1c@mailservices.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1755978.5WPiQ6of1F"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1755978.5WPiQ6of1F
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Dienstag, 13. Februar 2018 07:56:29 CET Ali Abedi wrote:
> > So I would currently bet on hwsim (only useful when you only want to have some
> > simulations) or mt76. Afaik mt76 was also the one which was used to test the
> > VHT rate injection code for monitor interfaces and is therefore quite
> > flexible.
[...]
> Thank you Sven. I was actually wondering what hardware was used to test 
> the code.

It seems Lorenzo Bianconi used an D-Link DIR-860L rev B1 [1]

Kind regards,
	Sven

[1] https://patchwork.kernel.org/patch/8393091/

--nextPart1755978.5WPiQ6of1F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAlqC5QQACgkQXYcKB8Em
e0Yrjw//TMF+HLexnd8SKJuRnLjY3N48zm6Jb+eHXkUIsROEyaVNjLqIta17FefB
AvmYcCWwi84NxLkn75CBDhAvLMvQf4cAx/wYaBc4ArR+HFGg5si6XybdtL4GRuNr
/nIB6elwoxBMpZn1794g6WmdV4SLyljw9VOlWzLsg0ejc6o2SNZQwyedeuDyUZNj
HLSYbOl2qMfa800ofXmGTOjSEW8YsEc3hWVvuNRN6LX1P8nTuT/CWTmxxSNC/i3y
ZRtb+zMN3PNmFuR4mXik3A/iTqwD+zTew8jtJgwQw52xie8T1cZsvjXKLDDXOxpQ
8PTD+hGtd9hHqIaCGHFSEvxHoajn8mQk4eRTHoPGZu1eUcWa1zYiGcYMLHDjSNJp
a8KV7HcXyyCBYF5+Fuxm/fXLyPb94SSmc2hMMaHPmU/HI9nEXN62wEqw1nhPr5PL
xCVQapPFqtv52wye7HUusOdHwY75e89tg8EeSiixH5dbfGh4H8Bvc9USML2CUEBJ
d+aqUoP98/2PLhKkmhPCmTUNls2yrzbmAmEed30RyON7NChUTPj2Z06LN4xK/Mnq
a+As49rd12xWVtkiBblmANCb3W0n/bNpJY65/sq0u7qagTvB49JBYsMKEUGXrzBe
5GQU0ja/Lmvbmtdkc960qUzRlv3eQiDFVaV+u5BRrD11GIghkkw=
=/QWP
-----END PGP SIGNATURE-----

--nextPart1755978.5WPiQ6of1F--
