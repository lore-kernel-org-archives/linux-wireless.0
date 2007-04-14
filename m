Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:39564 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750844AbXDNVp6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Apr 2007 17:45:58 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Larry Finger <larry.finger@lwfinger.net>
Subject: Re: [PATCH 0/4] mac80211 and drivers: Improve wireless statistics
Date: Sat, 14 Apr 2007 17:42:48 -0400
Cc: Tomas Winkler <tomasw@gmail.com>,
	John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, bcm43xx-dev@berlios.de,
	wireless <linux-wireless@vger.kernel.org>
References: <46211955.4080006@lwfinger.net> <1ba2fa240704141300w2ec2beabm9cd1376c1b9ef2bb@mail.gmail.com> <46214155.20106@lwfinger.net>
In-Reply-To: <46214155.20106@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1402475.yjqoHy5KmQ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200704141742.49084.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1402475.yjqoHy5KmQ
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 14 April 2007 17:02, Larry Finger wrote:
> When I proposed a patch to fix mac80211, Michael Wu NACKed it and request=
ed
> the name changes I propose here. I don't care what names things get, but =
it
> needs to be fixed!
>
If you don't care what names things get, then my patch which swaps signal a=
nd=20
rssi assignment in bcm43xx-mac80211 is fine. If you don't like that, then y=
ou=20
do care.

I think "level" isn't very intuitive for a number that's either RSSI or dBm=
,=20
however. I recommended "signal" instead which seems to better suggest a=20
measure of signal strength/level, at least until we come up with a better=20
statistics reporting system in cfg80211.

=2DMichael Wu

--nextPart1402475.yjqoHy5KmQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGIUrZT3Oqt9AH4aERAk5FAKCKiDwt9UqGV+9pY3W0Kz7kUxYiogCeJl1F
iwhKNgdCM0IXkDqtaYFhRgg=
=hjkq
-----END PGP SIGNATURE-----

--nextPart1402475.yjqoHy5KmQ--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
