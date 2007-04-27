Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:8473 "EHLO annwn14.rutgers.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755228AbXD0DiO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2007 23:38:14 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Larry Finger <larry.finger@lwfinger.net>
Subject: Re: Wireless rates with mac80211
Date: Thu, 26 Apr 2007 23:33:52 -0400
Cc: wireless <linux-wireless@vger.kernel.org>
References: <462F9617.8010207@lwfinger.net> <200704260022.48747.flamingice@sourmilk.net> <46303565.9040709@lwfinger.net>
In-Reply-To: <46303565.9040709@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3718468.1KCiHFEZ8B";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200704262333.59966.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart3718468.1KCiHFEZ8B
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 26 April 2007 01:15, Larry Finger wrote:
> What is in txrate in struct sta_info? Isn't it the rate to be used for the
> next transmission?
>
It is an index to the rate that could be used for the next transmission to=
=20
that sta. I was referring to the rate_control_ops not having a callback tha=
t=20
would return the current rate, but looking into sta_info should be fine.=20
Guess I overlooked that when I was looking to implement SIOCGIWRATE. Not su=
re=20
if doing this will be valid for other rate control algorithms in the future=
,=20
but that can be dealt with later.

=2DMichael Wu

--nextPart3718468.1KCiHFEZ8B
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGMW8nT3Oqt9AH4aERAhHmAJ9Tr1PvWxJipnU3uoFIbF3wpjX3IACggR/i
fvveW7u0n2woh7wPCyzqSNM=
=Sv+2
-----END PGP SIGNATURE-----

--nextPart3718468.1KCiHFEZ8B--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
