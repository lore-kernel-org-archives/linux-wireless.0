Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:60854 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764608AbXFGWlX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2007 18:41:23 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: jketreno <jketreno@linux.intel.com>
Subject: Re: IEEE802.11e/WMM TS management and DLS support
Date: Thu, 7 Jun 2007 15:40:36 -0700
Cc: Jiri Benc <jbenc@suse.cz>,
	"John W. Linville" <linville@tuxdriver.com>, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
References: <20070606082152.GA28639@mail.intel.com> <200706071412.54918.flamingice@sourmilk.net> <4668DE0F.7060302@linux.intel.com>
In-Reply-To: <4668DE0F.7060302@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2919834.eb3Sm0tSCJ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200706071540.41665.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2919834.eb3Sm0tSCJ
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 07 June 2007 21:41, jketreno wrote:
> Nothing is perfect the first time--and nothing will ever get done so long
> as an aggressive and offensive position is held in regard to outside
> contribution.
>
Sure. But frankly, this code sucks. The original patch that I reviewed had=
=20
problems that indicated a total lack of testing.. and that was just for a=20
subset of the patch series that I actually reviewed in detail. Even the=20
design of the entire patch series is questionable even if we weren't trying=
=20
to move to a userspace MLME (and we need to, because kernel space MLME is a=
=20
*dead end*). The patch series also introduced sparse errors.

Do I need to go on? Make the code suck less and we won't have to go through=
=20
this again. It's that simple. It's not about being aggressive or offensive.=
=20
It's about having some standards.

Now of course, this also happened because Linville didn't see much and assu=
med=20
it was okay. If a patch needs review (and a patch series of this size *need=
s*=20
review), go ahead and ask for a review (or remind me I need to do one!). I=
=20
don't have much time this summer for writing code, but I will make sure I=20
have time to review code, especially if Jiri Benc is not around.

=2DMichael Wu

--nextPart2919834.eb3Sm0tSCJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGaIlpT3Oqt9AH4aERAn5BAKCISZT+89Jl4xwagstvlaFVMDoFHgCgrI15
YJpbqYnwAkA43BdtCgtJ4B4=
=hpW6
-----END PGP SIGNATURE-----

--nextPart2919834.eb3Sm0tSCJ--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
