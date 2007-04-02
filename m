Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:35399 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753271AbXDBF2L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Apr 2007 01:28:11 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Larry Finger <larry.finger@lwfinger.net>
Subject: Re: WPA does not connect to bcm43xx-mac80211 when using NetworkManager
Date: Mon, 2 Apr 2007 01:26:15 -0400
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org
References: <460E2B8C.4030002@gmail.com> <1175388624.10282.0.camel@localhost.localdomain> <46107D79.3060706@lwfinger.net>
In-Reply-To: <46107D79.3060706@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4309188.bmrun96NSu";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200704020126.19572.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart4309188.bmrun96NSu
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sunday 01 April 2007 23:50, Larry Finger wrote:
> I'm using Michael Buesch's "mb" tree with the "mac80211: use IWEVGENIE" a=
nd
> "mac80211: set enc_capa" patches by Michael Wu. My distro is openSUSE 10.2
> on an x86_64 system.
>
I had a similar (probably same) issue but it doesn't seem to happen as much=
=20
now. If you're using the tree from=20
http://bu3sch.de/gitweb?p=3Dwireless-dev.git;a=3Dsummary - that does not co=
ntain=20
a number of very useful patches from Jiri's tree which are currently in=20
Linville's wireless-dev. Please try with the patches from Linville's tree.

If it continues to occur, try unloading the module (bcm43xx_mac80211) and=20
loading it again as a workaround. If that works, we most likely are seeing=
=20
the same issue. I also recommend updating wpa_supplicant (SuSE 10.2 ships=20
with 0.4.9 IIRC, I test with 0.5.7) but that probably doesn't matter much.

=2DMichael Wu

--nextPart4309188.bmrun96NSu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGEJP7T3Oqt9AH4aERAjluAJ0bMSg1MEGK0klEaR7ClNhWlcT/1QCfQVT0
CchMG0IP66ZK+AZRrFQmC6k=
=Bw31
-----END PGP SIGNATURE-----

--nextPart4309188.bmrun96NSu--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
