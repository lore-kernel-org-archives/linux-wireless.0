Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:13893 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754702AbXDZE0z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2007 00:26:55 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Larry Finger <larry.finger@lwfinger.net>
Subject: Re: Wireless rates with mac80211
Date: Thu, 26 Apr 2007 00:22:44 -0400
Cc: wireless <linux-wireless@vger.kernel.org>
References: <462F9617.8010207@lwfinger.net> <200704251637.53683.flamingice@sourmilk.net> <463027A3.9040201@lwfinger.net>
In-Reply-To: <463027A3.9040201@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart14909341.lh2mCGQxbF";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200704260022.48747.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart14909341.lh2mCGQxbF
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 26 April 2007 00:16, Larry Finger wrote:
> The problem with that level of debug, the logs are flooded with many lines
> each scan cycle, which happens every 1 minute with NetworkManager. In
> addidtion, I was hoping for something I could look at without having to
> peruse my way through the complete log.
>
Patches welcome. The rate control API currently has no easy way to obtain t=
he=20
current rate which is part of why SIOCGIWRATE hasn't been implemented yet.

=2DMichael Wu

--nextPart14909341.lh2mCGQxbF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGMCkYT3Oqt9AH4aERAs75AJ0QX4/nLTD7ajetj6/6Wls9xnwbuACbBQ7F
SR6oxPGteDqWye7Za7Sj8UQ=
=xj/x
-----END PGP SIGNATURE-----

--nextPart14909341.lh2mCGQxbF--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
