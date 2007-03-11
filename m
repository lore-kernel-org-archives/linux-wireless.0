Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:28215 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932744AbXCKVl7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Mar 2007 17:41:59 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Daniel Drake <dsd@gentoo.org>
Subject: Re: [PATCH RESEND] zd1211rw-mac80211: changed Kconfig
Date: Sun, 11 Mar 2007 17:41:46 -0400
Cc: linville@tuxdriver.com, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, kune@deine-taler.de,
	Michael Buesch <mb@bu3sch.de>
References: <20070311191931.752B67B409F@zog.reactivated.net>
In-Reply-To: <20070311191931.752B67B409F@zog.reactivated.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart24976746.hzOsMpKG4z";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200703111741.51440.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart24976746.hzOsMpKG4z
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sunday 11 March 2007 15:19, Daniel Drake wrote:
> Changed the reference to Devicescape stack to mac80211.
>
I referred to Devicescape originally because the only other driver that had=
=20
both softmac and devicescape versions was bcm43xx, so I copied "(DeviceScap=
e=20
stack)" in order to be consistent. I would prefer that there be one patch t=
o=20
replace both instances of "(DeviceScape stack)" with "(mac80211 stack)".

=2DMichael Wu

--nextPart24976746.hzOsMpKG4z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBF9HefT3Oqt9AH4aERAsjzAJ9AkCKeYMSAQSkiEMn4GeLJMc+UxgCdHQ2x
N7/zsoiSJJLhctATMSRJ5G8=
=PNgy
-----END PGP SIGNATURE-----

--nextPart24976746.hzOsMpKG4z--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
