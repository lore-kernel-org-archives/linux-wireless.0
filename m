Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:33497 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932174Ab2ICOef (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Sep 2012 10:34:35 -0400
From: Sven Eckelmann <sven@narfation.org>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	openwrt-devel@lists.openwrt.org,
	Marek Lindner <lindner_marek@yahoo.de>,
	Gabor Juhos <juhosg@openwrt.org>,
	Adrian Chadd <adrian.chadd@gmail.com>
Subject: Re: AR9330 hornet board stops beaconing after a few days (0xdeadbeef)
Date: Mon, 03 Sep 2012 16:34:30 +0200
Message-ID: <2968585.KZWUHnqH8O@bentobox> (sfid-20120903_163439_045582_2C98D185)
In-Reply-To: <CAD2nsn2wGCsYV2NW9VSVnvmQhnEk0EXW1vn6eaTYg_4-1w8ecQ@mail.gmail.com>
References: <20120813165340.GA10044@pandem0nium> <20120902200102.GA28313@pandem0nium> <CAD2nsn2wGCsYV2NW9VSVnvmQhnEk0EXW1vn6eaTYg_4-1w8ecQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1409415.C9LQapUH8N"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--nextPart1409415.C9LQapUH8N
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Monday 03 September 2012 19:23:26 Mohammed Shafi wrote:
> > # dmesg
> > [...]
> > [900132.160000] ath: phy0: NF calibrated [ext] [chain 0] is -104
> > [900162.160000] ath: phy0: NF calibrated [ctl] [chain 0] is -104
> > [900162.160000] ath: phy0: NF calibrated [ext] [chain 0] is -104
> > [900192.160000] ath: phy0: NF calibrated [ctl] [chain 0] is -104
> > [900192.160000] ath: phy0: NF calibrated [ext] [chain 0] is -104
> > [900197.470000] ath: phy0: missed 1 consecutive beacons
> > [900197.560000] ath: phy0: resume beacon xmit after 1 misses
> > [900222.160000] ath: phy0: NF calibrated [ctl] [chain 0] is -104
> > [900222.160000] ath: phy0: NF calibrated [ext] [chain 0] is -104
> > [900252.160000] ath: phy0: NF calibrated [ctl] [chain 0] is -104
> > [900252.160000] ath: phy0: NF calibrated [ext] [chain 0] is -104
> > [900275.910000] ath: phy0: missed 1 consecutive beacons
> 
> seems we are getting beacon stuck, though its not sufficient for triggering
> chip reset (or) atleast start noise floor calibration. Is this is in a
> congested environment ? we can dump cycle counters . I think we need to
> have a WAR of chip reset if the cycle counters (busy is too high) inspite
> the MAC hang signature . let me try too to figure out that WAR is already
> available (or) we got to enable it.

The test environment is not really "congested". It is not in a city and you 
don't have many access points in range. Only 2/3 clients are using these two 
test access points. I don't know whether there are other things using the 
channel range also used by the access points.

Kind regards,
	Sven
--nextPart1409415.C9LQapUH8N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABCgAGBQJQRL/2AAoJEF2HCgfBJntGXHMP/j0yoG0FhFrMBHNZDrs4q3VC
qme7a56FSIPPtfdRxK8Z2HESl3w3g561BHcNOfBIvPTw1dASdmiKPhUJ3jsiNQB7
JrPxxK2YR0FrcaLuJ4MLCEAI8pBN+Tpen6zcmmxqTRMoEUco48BkD9UuuRIDoQex
uYvkFpcs5tbU2Pif4BMIZBHXfeVGxVO3O63XdsNkEbJymupajGzFc6g7sUhcwjb6
C9rmIhpQxgQcDQ6AOmUBMq96b8Uv0WxR0kj2WWKjlBRzmqQl2TbPpMD5ragHt7UW
yB/lDH5yur52/dvsTwOUmBu7Z9FlYOuTfanfQD0nUwKHpnA/5C6YrLic3cyb+H1X
qNerUr42RjxrE1Pxjr1p3Rva354jZMOVXb9a6+wCTlG9XwJlNY6201hJwRhdOGfS
J2HnMa+4b7adKoZ2j+9zvaH6vRveKi/wgvQ/4CNvsdviHsP6DCzjS8QzLggibbvN
0pAF7f6YZePtOna2S/McFv5I31hmUpDoS6T9SbUMwkT8mIv8orjnC3/Sc+77M+ot
UAgO2zCmaRm/IbPaTjeXnonxoQOOga7FzLbPV2wr671gKunfQzKJUfv1VsYov+bd
/2JBPaOxsr5gnBwFaPZAxC7rqUrrVCpgDMV1sfXxNvValuurcrMz420ftDj94LBq
fKcR5iD6EeBrokKy0Ee7
=tlS0
-----END PGP SIGNATURE-----

--nextPart1409415.C9LQapUH8N--

