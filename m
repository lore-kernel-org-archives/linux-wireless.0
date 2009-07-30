Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56188 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332AbZG3T1Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 15:27:24 -0400
Subject: Re: [PATCH] iwlwifi: don't export symbols not needed in other
 modules
From: Johannes Berg <johannes@sipsolutions.net>
To: reinette chatre <reinette.chatre@intel.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1248979665.1216.1094.camel@rc-desk>
References: <1248947897.8925.13.camel@johannes.local>
	 <1248978482.1216.1087.camel@rc-desk>
	 <1248979011.23496.4.camel@johannes.local>
	 <1248979665.1216.1094.camel@rc-desk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-svMsTgofCY/Q5OE06BfD"
Date: Thu, 30 Jul 2009 21:26:49 +0200
Message-Id: <1248982009.23496.5.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-svMsTgofCY/Q5OE06BfD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-07-30 at 11:47 -0700, reinette chatre wrote:

> No. If this is what you want then I think you also need to remove
> iwl_rx_ant_restriction.

Hm, I missed that, I actually have removed as part of my powersave
patch.

johannes

--=-svMsTgofCY/Q5OE06BfD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKcfP2AAoJEODzc/N7+QmayBsP/0RZnKGRCAgu2yrED+0C09xh
6Q0VNAsugyjRRg6E5ZGIwRDAwz/d2clN+kSBHVvrBaqCIokIGlE5b4WqNVMfa41P
IA4TMNvuYL9vkN3dO1uX/PmzLptIoVDb2oWnET4VQYaQtRb3H+419NT60vzcdM4F
sDmIMW+U+e9DaZlpxlyKfEgUbsP0nU3Jg9jHvt9UWkQfUjUzr1fm2IgS1hI1wZos
lcbnlEmgDrqYakuWibVdqn/b4vtqnYmE9DsiOF1crwIbbPdv1/WB82HE/lQ5a5Ok
cpubuWtUtyMW8r7cwLFfEtsX+PEzG3STUb7/hT1KMrVefxGhIWFixaZLX2Taxsgb
3j0Ykho6QuQpmHPbOfPlESdHXfVHIh9pJmsvJzeEi1cPbMmZMhYiiyPDc+XnnvIQ
uZxI2rqHo2JJ9lPv3C2A+EM253TZqyb/TawpA5kAygoCly3y9fT2t5m4+Wwuno6s
y8aZMpDOxsp9wUF9Pt5CEwWK6ds5kR/VmtDghH6OOtPvC/LBlgX5lHxxcwZ4zF8H
96Sls+J1niXWR6W0Z/h5p/gPoXDjEnIbXfA+v3NcTO6/kqaLCtimGOKOtQsd+gzc
jNZ/aU5OhrtZ7VZ/yoSkV1TL4/5cfBA3AxNyhTHm9ETn13bss/gm8PF+VCmne04P
k7ZbnHsnEJqdJiSSfWJ/
=/P/N
-----END PGP SIGNATURE-----

--=-svMsTgofCY/Q5OE06BfD--

