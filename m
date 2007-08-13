Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:48604 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S968349AbXHMPqO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2007 11:46:14 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 3/3] mac80211: remove management interface
Date: Mon, 13 Aug 2007 08:44:23 -0700
Cc: linux-wireless@vger.kernel.org
References: <20070813074504.416717000@sipsolutions.net> <20070813074644.118092000@sipsolutions.net>
In-Reply-To: <20070813074644.118092000@sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart148381788.FE4bsUdXaX";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200708130844.27516.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart148381788.FE4bsUdXaX
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 13 August 2007 00:45, Johannes Berg wrote:
> Oh and somebody needs to fix zd1211rw-mac80211. It abused the
> MGMT interface constant that was explicitly mentioned to be
> not for drivers... I've "fixed" it for now but readers of the
> code may not be happy with it.
I've done this in all my drivers. It's perfectly fine. If you're going to d=
rop=20
the MGMT enum, please post a patch to s/IEEE80211_IF_TYPE_MGMT/-1/ for all=
=20
drivers.

=2DMichael Wu

--nextPart148381788.FE4bsUdXaX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGwHxbT3Oqt9AH4aERAkFoAKDC+yhW4DRrSWIhWGAIK6HJCZUTRACgwbIy
bIcyJvT1qztf6bUwio386MY=
=CIZM
-----END PGP SIGNATURE-----

--nextPart148381788.FE4bsUdXaX--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
