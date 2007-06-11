Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:64494 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751036AbXFKRLz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2007 13:11:55 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Larry Finger <larry.finger@lwfinger.net>
Subject: Re: [PATCH V2] mac80211: Implementation of SIOCSIWRATE
Date: Mon, 11 Jun 2007 10:10:57 -0700
Cc: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
References: <4668a64b.VmU9f2GpA2itSuFx%Larry.Finger@lwfinger.net> <200706072012.56652.flamingice@sourmilk.net> <466D75FD.9090809@lwfinger.net>
In-Reply-To: <466D75FD.9090809@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart10553045.uJQ67iTA5M";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200706111011.01736.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart10553045.uJQ67iTA5M
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Monday 11 June 2007 09:19, Larry Finger wrote:
> Does sdata->bss need to be checked to verify that it is not NULL?
>
Yup.

-Michael Wu

--nextPart10553045.uJQ67iTA5M
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGbYIlT3Oqt9AH4aERAtJUAKCg0+8fWtIVpq/TsO98zAQZOdvbBACfYpfO
t9WCulEV+c9e6TY7wvQozQk=
=5lhW
-----END PGP SIGNATURE-----

--nextPart10553045.uJQ67iTA5M--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
