Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58749 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933576AbZKXRmD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2009 12:42:03 -0500
Subject: Re: [PATCH 2/2] mac80211: minstrel try all rates
From: Johannes Berg <johannes@sipsolutions.net>
To: Adam Wozniak <awozniak@irobot.com>
Cc: Derek Smithies <derek@indranet.co.nz>,
	Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
In-Reply-To: <4B0C1527.60305@irobot.com>
References: <4AF0D54D.4090303@irobot.com>
	 <alpine.DEB.2.00.0911111508391.6214@kauri.acheron.indranet.co.nz>
	 <4AFC655A.5020706@irobot.com> <200911122103.27455.chunkeey@googlemail.com>
	 <4AFC8E4F.5090307@irobot.com>  <4AFC8F0D.5020700@irobot.com>
	 <1258097352.3899.75.camel@johannes.local>  <4AFDDF19.8060202@irobot.com>
	 <1258191039.6167.40.camel@johannes.local>  <4B018B26.2070008@irobot.com>
	 <1258392453.32159.28.camel@johannes.local> <4B0192A6.9050808@irobot.com>
	 <alpine.DEB.2.00.0911170938380.3829@kauri.acheron.indranet.co.nz>
	 <4B01D4A5.7060204@irobot.com>
	 <alpine.DEB.2.00.0911171156210.3829@kauri.acheron.indranet.co.nz>
	 <4B01E298.3030602@irobot.com>
	 <alpine.DEB.2.00.0911171314470.3829@kauri.acheron.indranet.co.nz>
	 <1258443484.1375.8.camel@johannes.local> <4B02DFE3.9040602@irobot.com>
	 <4B0AEEE3.2050808@irobot.com> <1259018866.7094.189.camel@johannes.local>
	 <4B0B2F6E.7050907@irobot.com> <1259025067.7094.208.camel@johannes.local>
	 <4B0C1527.60305@irobot.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Lg+eStEiNOjvr4S8Gcjn"
Date: Tue, 24 Nov 2009 18:41:33 +0100
Message-ID: <1259084493.3491.21.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Lg+eStEiNOjvr4S8Gcjn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-11-24 at 09:17 -0800, Adam Wozniak wrote:

> I do not believe 1/2 was a hack.  It really was possible to get to the=20
> end of that function and use that variable without it being assigned the=20
> correct value.  Also, it is important to reinitialize the rate control=20
> layer when the list of usable rates changes.

Ah, indeed. But I still don't think the rate control _init() function
should be called again.

johannes

--=-Lg+eStEiNOjvr4S8Gcjn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLDBrJAAoJEODzc/N7+QmatW0QAMjk9ktGHJEgHjbtIT3gJGZg
7wu8UKJ3NWkD+e4MHpCoPP0fHgVwBa9twj3pSbRVQaCWDpMUFMWsZI77rb2LpW6Q
O97Ugeax1vXV/CL2TbMpNfxWqBAW4xf/t3wVd+zVjY51B5TbK0uuv8tQ4BZielby
8Uyp8PursyJOCsu+q/GHWmaQoiQBRGd7d8xzwMA8EzwpHnXOX1LmYUBWtKmc84yB
VuaRsbx6PFn19Kvbz3YihtUkvmwbVIOAMbHdglImIdwYlwb30uSMYARh6HJqshsH
lepd5PiapP8c3SMmW+Z04jpEQjPN48FP5p7KK13QUriJijF4pTongSzTg7INbtkF
EtU12lvB6FQduxsZj6G8melZI3Xi2TPpMAm+uLu4BLUaLiyKtqpiGMhyAE4RHnGM
sbaud7PaOUf6pikGvymO2YgvemjXqa/02Fz7NcRk++ZuP0SC+V1ZuOF6EFEGDxxN
J8GSH/WfuJjB6XeFB8/upvOuKqYT4jyjlhlnE+8LcwjN9rEULpbT+E3V4JUtEXL4
DyesRUKhzoWgC8pF/uAq0wvZInnpAuHCd9YdC2MRYemSWBPR7fQm/FUs1iDj4neI
Ye0PXW2SrtK4JiKjquD4bZnageMf8NqTMTJ6KMDqJ7QoWVU++WWIYOdDrppsScPU
fs4x8I3nElUWiT+kIocz
=FbC2
-----END PGP SIGNATURE-----

--=-Lg+eStEiNOjvr4S8Gcjn--

