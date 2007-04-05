Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:53718 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1767240AbXDETSA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Apr 2007 15:18:00 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Hauke Mehrtens <linux-wireless@hauke-m.de>
Subject: Re: no reassociateing with rtl8187 driver
Date: Thu, 5 Apr 2007 15:15:44 -0400
Cc: linux-wireless@vger.kernel.org
References: <46140CD0.3010205@hauke-m.de>
In-Reply-To: <46140CD0.3010205@hauke-m.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1304159.yykWSaVPxV";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200704051515.49161.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1304159.yykWSaVPxV
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 04 April 2007 16:38, Hauke Mehrtens wrote:
> I am using the rtl8187 driver based on the mac80211 stack and it is
> working pretty well except it can't reassociate to the access point with
> WEP encryption enabled (I haven't tested without) of which he lost the
> connection.
>
mac80211 doesn't handle reassociation when a connection is lost. It is=20
recommended to configure mac80211 with either wpa_supplicant or=20
NetworkManager (which in turn uses wpa_supplicant). However, since we're=20
trying to have a reasonable level of compatibility with userspace that use=
=20
wireless tools directly to connect, some reassociation is probably=20
appropriate to implement.

=2DMichael Wu

--nextPart1304159.yykWSaVPxV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGFUrlT3Oqt9AH4aERAutZAKDNzan7TBDaaHscNCHp+z/y84KqhwCeNaUC
civ/y1wEXgo6Y1kNPowOYow=
=PmXh
-----END PGP SIGNATURE-----

--nextPart1304159.yykWSaVPxV--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
