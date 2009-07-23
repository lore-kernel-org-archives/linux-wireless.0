Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57275 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030AbZGWKit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 06:38:49 -0400
Subject: Re: [PATCH 4/7] mac80211: Replace {sw, hw}_scanning variables with
 a bitfield
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <20090723101403.5147.55273.stgit@localhost.localdomain>
References: <20090723100732.5147.73989.stgit@localhost.localdomain>
	 <20090723101403.5147.55273.stgit@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-uPx5c/UC+E42Ga8A8GZK"
Date: Thu, 23 Jul 2009 12:38:17 +0200
Message-Id: <1248345497.19121.22.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-uPx5c/UC+E42Ga8A8GZK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-07-23 at 12:14 +0200, Helmut Schaa wrote:
> Use a bitfield to store the current scan mode instead of two boolean
> variables {sw,hw}_scanning. This patch does not introduce functional
> changes but allows us to enhance the scan flags later (for example
> for background scanning).

> +			if (test_bit(SCAN_SW_SCANNING, &local->scanning))

Do we actually need atomic bitops?

johannes

--=-uPx5c/UC+E42Ga8A8GZK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKaD2WAAoJEODzc/N7+Qma+N8QAL+UfshrBdTreR5syYoUvdT0
NrDcdHCXkudd3SbwvNTjdv4Ar6JfqNe8Fy6dcr95LmpvHh6745tih+c/EBoApVKo
DHGpnHVYf1UCT6O3b4qiBLnpettGlW//PZNflYaY0mMPEF4pkaiAPxmpbcLfcY0i
HZK3vTXB28oq0283J4/MmrSzac2tpmZD7lHpiBJqZtkxQ4Hy9ibSfQhT+kRxG3Jk
0VSNAiH4O2YQdYrQB0rSDsBYmNHzIRaNMCZ5Cjm4o8SCi3JYgiO0xQj59JQHOrV0
43JCdNMefG4weH/x4V0DMvV7gMMzZGplrVCoLtdy2fMjsfUjELdJJkxxYRYUCvrw
epOTvl7wf6llwCAFuqUnUuxd7rgucQrem1JBDNz/Z+uxjOLztT1/glDms6vX0GtI
w/4tDV66pyQMMAkGstP/FX4fg6ws8qYYdMULHm5X6gq/uEWZE/hpXGkp6xdSk5uR
ct0BAly4aW3T9Yfm10z6SkYVYsSwLUFZSne0YlWxnReHjclo+e1j2ISs6JaaAD8w
W1lvW/rvmU9BON41BAEJxv0YcxMHl+dZbdHU6vLY/CkkBiWXnY5cADnve7uuW853
t8Sqvty1aNSeWx7FAAqY3fix54khrPYIY1o8il51NkespyerKz+l12d05S4Lr/LV
+EUdLbGS500THHoCFN50
=YUbr
-----END PGP SIGNATURE-----

--=-uPx5c/UC+E42Ga8A8GZK--

