Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:52818 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761669AbXJQDcl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Oct 2007 23:32:41 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: Please pull 'fixes-davem' branch of wireless-2.6
Date: Tue, 16 Oct 2007 23:29:51 -0400
Cc: davem@davemloft.net, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
References: <20071017023145.GA2848@tuxdriver.com>
In-Reply-To: <20071017023145.GA2848@tuxdriver.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3776809.t8rrTqrduP";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200710162329.55966.flamingice@sourmilk.net> (sfid-20071017_043248_178489_6AE93622)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart3776809.t8rrTqrduP
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 16 October 2007 22:31:46 John W. Linville wrote:
> Bill Moss (1):
>       mac80211: honor IW_SCAN_THIS_ESSID in siwscan ioctl
>
Where did this patch come from? The original patch looked nothing like this=
,=20
and this patch changes the behavior of siwscan incorrectly. If the interfac=
e=20
is not STA, IBSS, or AP, scanning should not be permitted. This patch allow=
s=20
scanning on any interface if a SSID is specified. NACK.

=2DMichael Wu

--nextPart3776809.t8rrTqrduP
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBHFYGzT3Oqt9AH4aERAv4AAJ9DW+5YFUFvdWRWqYAQYquGZUutLACglEEs
mYLw0WP/fm2vNAWdTbmyuJo=
=g5W2
-----END PGP SIGNATURE-----

--nextPart3776809.t8rrTqrduP--
