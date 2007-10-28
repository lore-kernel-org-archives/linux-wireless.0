Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:43036 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750795AbXJ1HdM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Oct 2007 03:33:12 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] mac80211: honor IW_SCAN_THIS_ESSID in siwscan ioctl
Date: Sun, 28 Oct 2007 03:29:36 -0400
Cc: stable@kernel.org, linux-wireless@vger.kernel.org,
	Bill Moss <bmoss@clemson.edu>,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>
References: <11934326793639-git-send-email-linville@tuxdriver.com> <11934326813245-git-send-email-linville@tuxdriver.com> <11934326823646-git-send-email-linville@tuxdriver.com>
In-Reply-To: <11934326823646-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2347701.AMDaTWUDfb";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200710280329.40757.flamingice@sourmilk.net> (sfid-20071028_073315_597239_835195CB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2347701.AMDaTWUDfb
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Friday 26 October 2007 17:04:33 John W. Linville wrote:
> From: Bill Moss <bmoss@clemson.edu>
>
> This patch fixes the problem of associating with wpa_secured hidden
> AP.  Please try out.
>
> The original author of this patch is Bill Moss <bmoss@clemson.edu>
>
> Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
Wrong patch.

-Michael Wu

--nextPart2347701.AMDaTWUDfb
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBHJDpkT3Oqt9AH4aERAkGZAKCoAkG1ZAFzDi9aEPddC4ZWSw09mwCgqkcd
Zd3TqTFwg7ovAlywGhMlV5k=
=/nlX
-----END PGP SIGNATURE-----

--nextPart2347701.AMDaTWUDfb--
