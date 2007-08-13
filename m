Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:57718 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S968462AbXHMIAo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2007 04:00:44 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Hans de Goede <j.w.r.degoede@hhs.nl>
Subject: Re: Recent linux-wireless git changes have broken my prism54pci card
Date: Mon, 13 Aug 2007 00:58:47 -0700
Cc: Andy Green <andy@warmcat.com>, linux-wireless@vger.kernel.org
References: <46BFF10B.1090307@hhs.nl> <46BFFE4F.802@warmcat.com> <46C00D1E.3000807@hhs.nl>
In-Reply-To: <46C00D1E.3000807@hhs.nl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2477204.s6XiBmEhne";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200708130058.47778.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2477204.s6XiBmEhne
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 13 August 2007 00:49, Hans de Goede wrote:
> I already found that one, but there is no drivers/net/wireless/mac80211 d=
ir
> there. What am I missing?
>
John Linville recently collapsed that directory into driver/net/wireless.

If you can just find the title of the patches/commits or describe them, tha=
t's=20
probably enough for me to find them.

=2DMichael Wu

--nextPart2477204.s6XiBmEhne
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGwA83T3Oqt9AH4aERAiNAAJ42iexGnm9PSWZefcEz7pLBMOdOnQCglKtY
p8U0kOPOU5c2CJJDqyGT81k=
=qvM5
-----END PGP SIGNATURE-----

--nextPart2477204.s6XiBmEhne--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
