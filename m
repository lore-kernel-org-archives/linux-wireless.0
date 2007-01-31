Return-path: <wireless-bounces@tuxdriver.com>
Received: from annwn14.rutgers.edu (smtp.rutgers.edu [128.6.72.243])
	by ra.tuxdriver.com (8.13.7/8.13.7) with ESMTP id l0V0HeIS032353	for
 <wireless@lists.tuxdriver.org>; Tue, 30 Jan 2007 19:18:06 -0500
Date: Tue, 30 Jan 2007 19:16:52 -0500
From: Michael Wu <flamingice@sourmilk.net>
Subject: Re: Getting dscape running
In-reply-to: <1170197696.11455.18.camel@dv>
Sender: wireless-bounces@tuxdriver.com
To: Pavel Roskin <proski@gnu.org>
Cc: wireless@lists.tuxdriver.org
Errors-to: wireless-bounces@tuxdriver.com
Message-id: <200701301916.58291.flamingice@sourmilk.net>
MIME-version: 1.0
Content-type: multipart/mixed; boundary="===============1171907200=="
References: <9e4733910701301415p2ce1042aqcd833c732bc761cb@mail.gmail.com>
 <9e4733910701301436m2bdb903cpb2089a1c395b489c@mail.gmail.com>
 <1170197696.11455.18.camel@dv>
List-Post: <mailto:wireless@lists.tuxdriver.org>
List-Subscribe: <http://lists.tuxdriver.org/mailman/listinfo/wireless>,
	<mailto:wireless-request@lists.tuxdriver.org?subject=subscribe>
List-Unsubscribe: <http://lists.tuxdriver.org/mailman/listinfo/wireless>,
	<mailto:wireless-request@lists.tuxdriver.org?subject=unsubscribe>
List-Archive: <http://lists.tuxdriver.org/pipermail/wireless>
List-Help: <mailto:wireless-request@lists.tuxdriver.org?subject=help>
List-Id: Linux wireless networking development <wireless.lists.tuxdriver.org>

--===============1171907200==
Content-Type: multipart/signed; boundary="nextPart1578235.Hhyii9Tds6";
	protocol="application/pgp-signature"; micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1578235.Hhyii9Tds6
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tuesday 30 January 2007 17:54, Pavel Roskin wrote:
> Just in case, please make sure your .config enables CONFIG_CRYPTO_ECB
> and CONFIG_CRYPTO_ARC4.
d80211 selects ARC4. ECB is selected too if you have Linville's last update.

-Michael Wu

--nextPart1578235.Hhyii9Tds6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQBFv9/6T3Oqt9AH4aERAszkAKDasU12KKlExk26kAbqYSAt/M/hngCffEa8
FyQuGtTinWvlym6aPX9BNI4=
=BGZj
-----END PGP SIGNATURE-----

--nextPart1578235.Hhyii9Tds6--

--===============1171907200==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
wireless mailing list
wireless@lists.tuxdriver.org
http://lists.tuxdriver.org/mailman/listinfo/wireless

--===============1171907200==--
