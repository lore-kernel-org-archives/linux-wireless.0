Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:54591 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932573AbcBCRO5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 12:14:57 -0500
From: Sven Eckelmann <sven@narfation.org>
To: b.a.t.m.a.n@lists.open-mesh.org
Cc: Josh Boyer <jwboyer@fedoraproject.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Kalle Valo <kvalo@codeaurora.org>,
	Marek Lindner <mareklindner@neomailbox.ch>,
	Simon Wunderlich <sw@simonwunderlich.de>,
	netdev <netdev@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [B.A.T.M.A.N.] ibss.c backtrace when batman-adv adds wireless interface
Date: Wed, 03 Feb 2016 18:14:55 +0100
Message-ID: <5257267.1LZJPcyIcQ@bentobox> (sfid-20160203_181506_346905_1CC90011)
In-Reply-To: <CA+5PVA4HVjsEw+j+HMDzO0gnQb4xTRwbAu4H2do3MU41QWvOvw@mail.gmail.com>
References: <CA+5PVA4HVjsEw+j+HMDzO0gnQb4xTRwbAu4H2do3MU41QWvOvw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2329807.jhdNh6WYTb"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2329807.jhdNh6WYTb
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Wednesday 03 February 2016 10:24:43 Josh Boyer wrote:
> Hi All,
> 
> We've had a user report the backtrace below when loading batman-adv on
> his machine.  It looks like the cfg80211 layer is complaining about a
> null bss returned, but I cannot tell if the rtlwifi driver or
> batman-adv is in error here.
> 
> Thoughts?

About the attachment "batman-adv oopses with kernel-4.3.4-300+debug". Sorry,
this was my fault and caused by an copy+paster error while adding some
lockdep_asserts. This caused too many lockdep reports. It was fixed a while
ago upstream in 008a37448707 ("batman-adv: Fix lockdep annotation of
batadv_tlv_container_remove").

Kind regards,
	Sven
--nextPart2329807.jhdNh6WYTb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJWsjWPAAoJEF2HCgfBJntGXngP/1AnZSxN9oDkZmkDbanuHvdL
7JUaza7ghgK8Eofs6Hp5vIfJGTODpZeIQ7uvfZwj3/LWIxsil5PIrDSIfuwthJLA
FyU8JKLHezcZ0SPsK7oABtWREHdARTpe/EYngru6KWVpPTdK2Jscf1YEVGleqx7Q
UEHoKo09mYBrIL+9O+ekavLFC/O9PbsMuu2nF2W+0MKyXVB6TTE/4wF8ZBlS2BHp
VwFBilXmJAPtbs1Mo6M7gC9kCjoqWOHVT5S3ZHDqB839Y2XAiSLMJD28ck60n9zb
RbkxhQYwGGUxQ95OkGgzFtTbkG6NC3WWTckNUuoipn04ls7V2yJ9ZNIaxsQIcu3l
0w5M2ITBYF6Pvo2KUvOwy3xT+CNAXvzXh3ZeOQfMgYWfRP65qw5qjOxGc5DdFm+U
hOvmu6B01v27+vr9+KFEqjFUOYNgA4dY2fok6B8d3UmKmQwaDvuWk3880cO03Y5Z
spiIIqrutKpsziPnM98/F52E+aYssQuvBSHT5TatP1WWVOiCuOgHORJhejGCZHaN
4UmKYe00Eg1fAtemR33yHF+5VdJnohY2adAcMUU2dZ6uID39w60dIs1lb2DeEHdF
LRTWsnIYAJWv4UVOLEqMn1g+d/YuowgzmGrYUdvIPrydBlAeOJbEPmxdR15ZLdal
xBYGHhyjp43Vre/EiSVC
=66Fg
-----END PGP SIGNATURE-----

--nextPart2329807.jhdNh6WYTb--

