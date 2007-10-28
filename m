Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:55806 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750792AbXJ1HfD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Oct 2007 03:35:03 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] mac80211: honor IW_SCAN_THIS_ESSID in siwscan ioctl
Date: Sun, 28 Oct 2007 03:31:34 -0400
Cc: stable@kernel.org, linux-wireless@vger.kernel.org,
	Bill Moss <bmoss@clemson.edu>,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>
References: <11934326793639-git-send-email-linville@tuxdriver.com> <11934326823646-git-send-email-linville@tuxdriver.com> <200710280329.40757.flamingice@sourmilk.net>
In-Reply-To: <200710280329.40757.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart10952858.x9b0Kab6u3";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200710280331.34515.flamingice@sourmilk.net> (sfid-20071028_073506_757618_72CE9827)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart10952858.x9b0Kab6u3
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sunday 28 October 2007 03:29:36 Michael Wu wrote:
> On Friday 26 October 2007 17:04:33 John W. Linville wrote:
> > From: Bill Moss <bmoss@clemson.edu>
> >
> > This patch fixes the problem of associating with wpa_secured hidden
> > AP.  Please try out.
> >
> > The original author of this patch is Bill Moss <bmoss@clemson.edu>
> >
> > Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
> > Signed-off-by: John W. Linville <linville@tuxdriver.com>
>
> Wrong patch.
>
Er, actually nevermind. However, I'd much prefer rolling the next patch you=
=20
have in this series up into this patch.

=2DMichael Wu



--nextPart10952858.x9b0Kab6u3
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBHJDrWT3Oqt9AH4aERAmzTAJ9PAz0a8nCa/9E6uw3x6R9U/vhvWgCdEJda
64fhgRgKdlBoconXqxRvTSM=
=oe2b
-----END PGP SIGNATURE-----

--nextPart10952858.x9b0Kab6u3--
