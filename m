Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:65326 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755997AbXEOSxo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 May 2007 14:53:44 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: Panic in ieee_80211_ibss_add_sta when trying to join ad-hoc network (rt2500pci)
Date: Tue, 15 May 2007 14:52:26 -0400
Cc: David LAMPARTER <lists@diac24.net>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, Jiri Benc <jbenc@suse.cz>
References: <20070515152842.GA26481@charon.n2.diac24.net> <20070515171202.GD15105@tuxdriver.com>
In-Reply-To: <20070515171202.GD15105@tuxdriver.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3759009.mGGXOxUsHL";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200705151452.32246.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart3759009.mGGXOxUsHL
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tuesday 15 May 2007 13:12, John W. Linville wrote:\
> Patch below...does this work better?  Looks like upstream needs
> it too...
>
ACK. Looks like I forgot to set sdata after removing the code that set it.

Thanks,
-Michael Wu

--nextPart3759009.mGGXOxUsHL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGSgFwT3Oqt9AH4aERAmOPAJsE8aKfad8gta0HSkKfwaUIIJ1WigCg2WV/
9O0Tw/57c++wmrCMyg/FpXs=
=qC2G
-----END PGP SIGNATURE-----

--nextPart3759009.mGGXOxUsHL--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
