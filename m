Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:10393 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761983AbXHWWTP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Aug 2007 18:19:15 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 26/27] mac80211: refactor event sending
Date: Thu, 23 Aug 2007 18:16:55 -0400
Cc: John Linville <linville@tuxdriver.com>, Jiri Benc <jbenc@suse.cz>,
	linux-wireless@vger.kernel.org
References: <20070821145905.689978000@sipsolutions.net> <20070821150052.127733000@sipsolutions.net>
In-Reply-To: <20070821150052.127733000@sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1441795.TaTg08fMGt";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200708231817.04416.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1441795.TaTg08fMGt
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 21 August 2007 10:59, Johannes Berg wrote:
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ wireless-dev/net/mac80211/event.c	2007-08-21 16:00:34.715923881 +0200
> @@ -0,0 +1,36 @@
> +/*
> + * mac80211 - events
> + */
> +
Should probably make this look a bit more like other files in the directory=
=20
and add the usual copyright/license boilerplate.

=2DMichael Wu

--nextPart1441795.TaTg08fMGt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGzgdgT3Oqt9AH4aERAvrMAJ46Fgd77ZBbX/45XzsrDuleN6W7XgCgqTXf
L5kH5hvX01+ziErhVU/k/yk=
=JtQd
-----END PGP SIGNATURE-----

--nextPart1441795.TaTg08fMGt--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
