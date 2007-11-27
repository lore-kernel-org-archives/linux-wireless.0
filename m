Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:42040 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750793AbXK0FCz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2007 00:02:55 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mm snapshot broken-out-2007-11-20-01-45 Build Fail - net/wireless driver
Date: Tue, 27 Nov 2007 00:06:16 -0500
Cc: Tony Breeds <tony@bakeyournoodle.com>,
	Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200711200953.lAK9qxjO030444@imap1.linux-foundation.org> <200711262337.49178.flamingice@sourmilk.net> <20071126205559.dfaf1a56.akpm@linux-foundation.org>
In-Reply-To: <20071126205559.dfaf1a56.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1290261.VKdncilzpt";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200711270006.20431.flamingice@sourmilk.net> (sfid-20071127_050258_181019_299650C4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1290261.VKdncilzpt
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 26 November 2007 23:55:59 Andrew Morton wrote:
> On Mon, 26 Nov 2007 23:37:48 -0500 Michael Wu <flamingice@sourmilk.net>=20
wrote:
> > On Monday 26 November 2007 21:54:23 Andrew Morton wrote:
> > > Why not just rename one of them?
> >
> > Wait, why does renaming just one of them work?
>
> umm, well I assume that the failure is because we're trying to link two
> identically-named symbols together?
But there's more than one pair..

rtl8180_rtl8225.h:
void rtl8225_rf_init(struct ieee80211_hw *);
void rtl8225z2_rf_init(struct ieee80211_hw *);
void rtl8225_rf_stop(struct ieee80211_hw *);

rtl8187_rtl8225.h:
void rtl8225_rf_init(struct ieee80211_hw *);
void rtl8225z2_rf_init(struct ieee80211_hw *);
void rtl8225_rf_stop(struct ieee80211_hw *);

=2DMichael Wu

--nextPart1290261.VKdncilzpt
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBHS6XMT3Oqt9AH4aERAnskAJ98cmIi+/XhbTW51QQFDOF3f06d5gCgucIe
8KeKxLD1nSK5n+lXy/Gc2mU=
=Q/Bq
-----END PGP SIGNATURE-----

--nextPart1290261.VKdncilzpt--
