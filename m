Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:50736 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753478AbXG3DX2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Jul 2007 23:23:28 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Daniel Drake <dsd@gentoo.org>
Subject: Re: [PATCH] zd1211rw-mac80211: debug output for mac80211 ops
Date: Sun, 29 Jul 2007 20:21:31 -0700
Cc: linville@tuxdriver.com, kune@deine-taler.de,
	linux-wireless@vger.kernel.org
References: <20070730023128.99E927B409F@zog.reactivated.net>
In-Reply-To: <20070730023128.99E927B409F@zog.reactivated.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1695257.IELsu8n3za";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200707292021.37845.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1695257.IELsu8n3za
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sunday 29 July 2007 19:31, Daniel Drake wrote:
> This patch adds debug output to mac80211 operations. This is
> intended to sort out the issues with the interface semantics.
>
Ugh. I really hate enter/exit and especially these since they are open code=
d.=20
What do you need clarified about mac80211 interface semantics?

=2DMichael Wu

--nextPart1695257.IELsu8n3za
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGrVlBT3Oqt9AH4aERAnaoAJ0VWuXsCi3GhXDhxs4WoooA/TTaNwCfaAA2
+N/s0HMP1hnXfy5CoxYS+P4=
=8JRd
-----END PGP SIGNATURE-----

--nextPart1695257.IELsu8n3za--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
