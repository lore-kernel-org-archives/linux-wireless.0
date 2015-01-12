Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:56804 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbbALHJo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2015 02:09:44 -0500
Received: by mail-pd0-f171.google.com with SMTP id y13so28987333pdi.2
        for <linux-wireless@vger.kernel.org>; Sun, 11 Jan 2015 23:09:43 -0800 (PST)
References: <1420968029-1222-1-git-send-email-hong@topbug.net> <20150112065445.GB29484@localhost>
From: Hong Xu <hong@topbug.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k_htc: Add a module parameter to disable blink
In-reply-to: <20150112065445.GB29484@localhost>
Date: Sun, 11 Jan 2015 23:09:36 -0800
Message-ID: <87a91oeaq7.fsf@home.hong.me> (sfid-20150112_080954_927207_63973D9F)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--=-=-=
Content-Type: text/plain


Bob Copeland <me@bobcopeland.com> writes:

> On Sun, Jan 11, 2015 at 01:20:29AM -0800, Hong Xu wrote:
>> Add an option "blink" to enable or disable the LED blink. The default
>> value is set to 1 so that existing users would not experience any
>> unexpected changes.
>
> Been a while since I looked, but isn't there a way to achieve same
> result by just echoing 'none' into the relevant LED's sysfs file
> (something like /sys/class/leds/phy0-led/trigger)?

It's a bit different. echo 'none' to the trigger would cause the LED
light to be dark, but if turn off the blink option here, the LED is
bright but without blinking.

Hong

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUs3MwAAoJECZsfTOCL4R4WgsQANkLCWoxawi84MtkNBagrEBv
UMwcfTiM4jAkU9TAbs5vk80VjcvTTdNGrycj4oiDu7u/iDGfJ9SetY/EuGRcM/z2
gAk9DBt5BXijmeOaSHFpdCgIG0TpKSzdhnOtepWs0vVGrMWcOPBf6mo+xcGK92qn
7WNSIYswHj4M/hmdloq5Pw0pvQMdorXz3p0riKjoZGzhjBsFos9BlgEP14t6I3ES
n6CPkpCwhbx40GBXwCyGbC1o2RYBR/gD5zH8VM6wIU8ImIH829NWVdrVJqXIA9Bi
lR1KlXHhJrbjA7YzSeVF8s+b8PLhsFpK8aN9gffFAMQ1XaipDSyaYokxdnD46aSm
Si50VCyOZWEAr76Wfz6tAKAFeuaogTR/22+NNPXcsVoY3N5/UdgBWmxUdeGUbZU3
3ccUuKINmWBKM6I+v1K+SXaz+QpF2QkxjTc6m4qjGcSvfaAylkpmT8UyATzJ4zaK
dJES6Csgag8lgble22PYwfgGE5FJ6pM3GIt3WU72rfZb9jjBsEpctQ+S90sCyKqd
HlJx5X+UN0EBK0SKUtMjcq+YBXSmYhdxH2gqfFoHd2bfoXkgYDmZta421N9QG0ZQ
gT03gFpdwgoD9XNFzKHu0UvwmF/eJeQ/b3zDdNEPc76uY1wAkzMmwPbXAQLVMXDh
of/4tLaKEbITiGq1ZqMP
=i6yB
-----END PGP SIGNATURE-----
--=-=-=--
