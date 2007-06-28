Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:15057 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759964AbXF1BkH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2007 21:40:07 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH] mac80211: Export short-preamble bit to drivers
Date: Wed, 27 Jun 2007 18:40:05 -0700
Cc: Jiri Benc <jbenc@suse.cz>, John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200706251628.00838.mb@bu3sch.de>
In-Reply-To: <200706251628.00838.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1974830.1Mui1nz4f7";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200706271840.09719.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1974830.1Mui1nz4f7
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 25 June 2007 07:28, Michael Buesch wrote:
> +#define IEEE80211_CONF_SHORT_PREAMBLE	(1<<3) /* use short preamble
> +						* with IEEE 802.11b */
Shouldn't this be more of a "short preamble allowed" bit rather than "use=20
short preamble"? After all, short preamble is usually configured per frame.

=2DMichael Wu

--nextPart1974830.1Mui1nz4f7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGgxF5T3Oqt9AH4aERAsWaAJ4owpgIg5bZPF+g8GnJG1AbJ6NK4wCfW6GA
bghDpEA8RGfKoSPa6JZ5JzE=
=VwEE
-----END PGP SIGNATURE-----

--nextPart1974830.1Mui1nz4f7--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
