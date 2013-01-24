Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55408 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919Ab3AXQfP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2013 11:35:15 -0500
Message-ID: <1359045335.21908.8.camel@jlt4.sipsolutions.net> (sfid-20130124_173519_018541_DD15DB86)
Subject: pull-request: iwlwifi 2013-01-24
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 24 Jan 2013 17:35:35 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-50aaPQQAMaznlkAZqPIc"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-50aaPQQAMaznlkAZqPIc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Also for iwlwifi, I have one fix from Emmanuel reverting a previous fix
that caused more trouble than it's worth.

Please pull. Thanks,
johannes

The following changes since commit c3e5d7181afb66657393066bccce0956fab09ab3=
:

  iwlwifi: audit single frames from AGG queue in RS (2013-01-16 14:20:20 +0=
100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git f=
or-john

for you to fetch changes up to ae023b2795d36f0f077e157428eb7eafa29ee412:

  Revert "iwlwifi: fix the reclaimed packet tracking upon flush queue" (201=
3-01-24 12:54:24 +0100)

----------------------------------------------------------------
Emmanuel Grumbach (1):
      Revert "iwlwifi: fix the reclaimed packet tracking upon flush queue"

 drivers/net/wireless/iwlwifi/dvm/tx.c | 24 +++++++-----------------
 1 file changed, 7 insertions(+), 17 deletions(-)


--=-50aaPQQAMaznlkAZqPIc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJRAWLYAAoJEDBSmw7B7bqrv58P/1UODJcdkcVawrpSZ02m10ve
OHkWAzaptc63K6dNVTkEG6sDXozk8m4NppQx4Dok8mBcaUuLqlXuPebsVwT3URxG
OXx7ouu+GuR/5T/XhXvgoMxhyc9h7yhy3jnD9jxX0HICLjS5wxaa6Lzze0zK11cf
8bzucgkGY5p4b001KiXnXYu1n8KzVRO99U445f74syhJkdHTOHDwQwd4wFgpMO1L
BMxLVmGSEYIvQ8cS8C2ZjWf6TJOjlfbPay9sevR8/d8aQ8SVkxNyfbq/cynKuGAg
CxDhCPyB89fnJJR5vBO+ZLl+cf3aPnu6A/XOJoESNu89I1gpEDs9hcHi1KpFmRlw
82+VC/gshaOCc3av5AGwpVLsiUBBTKSu0fbsyYdglkIwnNbE8ks/1VtHYxg5k7MB
K9/1v93hd3K7b6tXsEzU+uPQrrOr+kFIo7tNv8szYpL7rTigDM5ThXvsbQQdkI5t
akajv6B9VdVMuxg1tYTnaUegw8pBbY0Z4T+D52MAVLGdUYh4eDK+ewoAUtquujMQ
iA8m0CDoxD5LJZXChte+obAV3WbSSSePczVr7atxxq5i8jgSbLS+VLE/O2yeWouK
bn/Y13Md4mRfyrVpRNv1rVKs3gpcxgR89qrns1qcg78hBkjrzbYT61Ji0x4Mgvoq
QQx4Z24mLG9kj5++qy7d
=TOCN
-----END PGP SIGNATURE-----

--=-50aaPQQAMaznlkAZqPIc--

