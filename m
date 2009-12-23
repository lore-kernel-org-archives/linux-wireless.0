Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from parez.praha12.net ([78.108.102.1]:58850 "EHLO parez.praha12.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135AbZLWNzA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2009 08:55:00 -0500
From: =?utf-8?q?Luk=C3=A1=C5=A1_Turek?= <8an@praha12.net>
Reply-To: 8an@praha12.net
To: =?utf-8?q?=E6=B5=B7=E8=97=BB=E6=95=AC=E4=B9=8B?=
	<tkaiso@thinktube.com>
Subject: Re: [ath5k-devel] [PATCH 4/5] ath5k: Reimplement clock rate to usec conversion
Date: Wed, 23 Dec 2009 14:54:51 +0100
Cc: johannes@sipsolutions.net, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org
References: <4B320265.7050807@thinktube.com>
In-Reply-To: <4B320265.7050807@thinktube.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2283688.UGnvGS8xQI";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200912231454.57507.8an@praha12.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2283688.UGnvGS8xQI
Content-Type: text/plain;
  charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On 23.12.2009 12:43 =1B$B3$At7IG7=1B(B wrote:
> 2. still not good and unstable throughput for 2.4Ghz
> thanks to your patch[3/5], [4/5], throughput was improved pretty much
> but still staying around 10~15Mbps(1hop), 1Mbps~6Mbps(2hops)
That's strange, those patches can't change anything... They modify a code t=
hat=20
cannot be used until patch[5/5] is applied, and even then you probably don'=
t=20
use it, because you didn't say you set the coverage class.

I think there's something wrong with your test methodology, because I don't=
=20
notice any difference, TCP throughput is always around 3MB/s. However I=20
haven't tried ath5k on both ends yet.

Have you tried setting a fixed rate (via iwconfig, it's not in iw yet)?
Or setting a fixed antenna (there's no UI yet, you have to hardcode it, see=
=20
function ath5k_hw_set_antenna_mode)?

Lukas Turek

--nextPart2283688.UGnvGS8xQI
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iQIcBAABAgAGBQJLMiExAAoJEEBjvk/UOfYw6EYP/jwLdzAkwsfut2I9YTS03dka
NFyDwwnpmr3k4dLu3elI+KHD5bIYeIIESM3RPhmGPSl50fl0NDEm0amu3jNW8pzA
Wmx1LWaZojzu8jC0l3AAjoOwtOWhxIEdqvOhEmumzC7Xf1nt2xff3/VBnf0GIv6j
obHKTFGsf4aF4LbFXh+DRWqLxjX14HtUUH0KmIx61B2zwEYxpaSSUiOh+5lPekle
bAHzG50aGoEy1AJ0VOnTDr/vItFKP41oR+dFA9Tk+sYhC4MIkU05//CVWnURL9aH
7S9fU/oOadXi+MsQmLGQYyjCyqyf2C9sTuR9Rvy8hVRELO/aTidjyZQxwGtSqhbS
TcZXv0NsOOc2CapMI8X2V6f04atUIx6CuX+O1xbHbHeVOACWGOvMYOvM3wUILuTA
ckK+nZiFjxvB1KxMxX3BGw/bybfKPRBwKXjzBAiuqjoqjJddk/+685u47xqWxTdW
Z2ssD3bficQgoirNyGtVgt1cLXB5/AvrCOmdt/O2Nr6VfIqm7Vo973RfsLUkO6sp
P0oE+u5c6KZf60rfW+ljCX/1L9KfCBcgJGZ1sPgsl7qI1ASq/KTdVT9VUQWBcOAc
DsQWCOkcBKHZLGWEuBZIlsTNAk2panfBScIRlDyKvFUAXi61LtVBrZr85jzaS5DB
uYiAdA+e4nRqKb6qiKhp
=ahOL
-----END PGP SIGNATURE-----

--nextPart2283688.UGnvGS8xQI--
