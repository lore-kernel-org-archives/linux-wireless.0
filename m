Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:37157 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756529Ab3FDOP1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jun 2013 10:15:27 -0400
Date: Tue, 4 Jun 2013 16:15:22 +0200
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: "C.B. Wang" <wtwangcb@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: carl9170:5/10 MHz Channel Support on carl9170
Message-ID: <20130604141522.GA13816@pandem0nium> (sfid-20130604_161533_937872_4D1DA089)
References: <CAB-Tk70nqYw8a57suVZdLcfJ+cUPSkYMXw3q1kqaO=r8jv7_hA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vtzGhvizbBRQ85DL"
In-Reply-To: <CAB-Tk70nqYw8a57suVZdLcfJ+cUPSkYMXw3q1kqaO=r8jv7_hA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Tue, Jun 04, 2013 at 09:13:27PM +0800, C.B. Wang wrote:
> I want to know if the ar9170 chip support 5/10 mhz channels.The
> datasheet says it supports
> 802.11j,but the carl9170 driver does not provide support.

I don't know if the carl9170 or the chip really supports that. Mac80211
currently does not support 5/10 MHz, but there is currently a patchset
pending to add this feature. If you want, you can apply that and play
with it.

It would still require to patch the carl9170 driver, the patchset
currently only adds support for ath5k/ath9k. Also the "super" channels
would have to be added.

Cheers,
	Simon

--vtzGhvizbBRQ85DL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlGt9noACgkQrzg/fFk7axarfQCgiqOau6ScCjnupTWp1sYOVJsE
UxcAoJtx+TmMbqA3SN6vlMAOMtY7pEst
=w7aA
-----END PGP SIGNATURE-----

--vtzGhvizbBRQ85DL--
