Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:36799 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752783AbXEZTCX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 May 2007 15:02:23 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH V6] mac80211: Add support for SIOCGIWRATE ioctl to provide rate information
Date: Sat, 26 May 2007 12:00:21 -0700
Cc: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
References: <4653b189.dPwlgw4JKvpc7kFq%Larry.Finger@lwfinger.net>
In-Reply-To: <4653b189.dPwlgw4JKvpc7kFq%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3445730.esMPEJW4EW";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200705261200.26762.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart3445730.esMPEJW4EW
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tuesday 22 May 2007 20:14, Larry Finger wrote:
> At present, transmission rate information for mac80211 is available only
> if verbose debugging is turned on, and then only in the logs. This patch
> implements the SIOCGIWRATE ioctl, which adds the current transmission rate
> to the output of iwconfig.
>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>
ACK.

Thanks,
-Michael Wu

--nextPart3445730.esMPEJW4EW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGWIPKT3Oqt9AH4aERAiAJAKCAqXtETFGHQTcg58vLeNhdFRyhzgCdHVkp
TLM16Hbw7GamLfe2xkQSzNs=
=uOa6
-----END PGP SIGNATURE-----

--nextPart3445730.esMPEJW4EW--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
