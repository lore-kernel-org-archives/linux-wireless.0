Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58892 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932107AbaGETcn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Jul 2014 15:32:43 -0400
Received: by mail-wg0-f44.google.com with SMTP id k14so2739198wgh.15
        for <linux-wireless@vger.kernel.org>; Sat, 05 Jul 2014 12:32:42 -0700 (PDT)
Message-ID: <53B852D4.5060109@gmail.com> (sfid-20140705_213247_108619_810B55FB)
Date: Sat, 05 Jul 2014 22:32:36 +0300
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: pull request: iwlwifi 2014-07-05
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="NRwPRr2Fuc0K3MjV4HePeMTDJxnWwhlL0"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--NRwPRr2Fuc0K3MjV4HePeMTDJxnWwhlL0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi John,

This pull request is intended for 3.a16.

I have here 2 patches that disable the usage of CTS to self. This keeps m=
aking trouble to the firmware and is not a really reliable protection any=
way. We may re-enable it in the future, but in rarer cases. Along with th=
is, I have a fix from Ilan that prevents a firmware assertion.

Please pull.

The following changes since commit a42c9fcc4a88cdd246fab3bcf06c4487afee3d=
88:

  Revert "iwlwifi: remove IWL_UCODE_TLV_FLAGS_UAPSD_SUPPORT flag" (2014-0=
6-24 22:01:46 +0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git=
 for-john

for you to fetch changes up to dc271ee0d04d12d6bfabacbec803289a7072fbd9:

  iwlwifi: mvm: disable CTS to Self (2014-07-03 20:55:18 +0300)

----------------------------------------------------------------
Emmanuel Grumbach (2):
      iwlwifi: dvm: don't enable CTS to self
      iwlwifi: mvm: disable CTS to Self

Ilan Peer (1):
      iwlwifi: mvm: Fix broadcast filtering

 drivers/net/wireless/iwlwifi/dvm/rxon.c     | 12 ------------
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c |  5 ++---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 12 ++++++------
 3 files changed, 8 insertions(+), 21 deletions(-)


--NRwPRr2Fuc0K3MjV4HePeMTDJxnWwhlL0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTuFLXAAoJEC0Llv5uNjIBzGAP/3zyV27059dLAXYynlI1JtAj
4AmmNUzlBlHh/zCMOnDQ5ySL3Rf08Cz1vyIq9giEz96mFEG1NYgX19fQYsnO5V7W
bSRaKXCoTz66S7DGEVMvEnMwzkZVXFNEZJwdqvkLTMCxRrAq+FdRknk+fVcYt9ZT
wPH7v1QQglUV5NS2QcOQAdEYx2ny49Bpwj2sJpfYbahOfHGdljlY0mxiz6qfqDbf
bYz+pKVCUpgnB6Remj2LifU4aczGJ1u9UxPR6fnSDizCSycWkWHaFm6tCqGmT3cv
Dx4tkdkw4iEIU2xzzAo9IpgM//kaTh5/XGEDozLjaCngIULz9WLWEAPPHgnrrktw
qem2s3ZKbcswJc8xxZsSa3/buwMxxJoq+Sb8suIyoUt20NZ6/QWWGtrJvB2OVQj0
LqBO4UqterFEqm3UJDJ9WRSnbY4ntvurQaJrEFsljcr7+J/z2uyCHhTxkjtHB+A8
Hq5Ds1AQduEpMBFJmH3R7UP95qKFDCoLqhc8SJpPSxCY7Yt2Eg6Wc6EqVCpQAajh
jejO5K+sGQZ+gwf8Rw89f5L4SxgTYGwm5BdHKWBMrFQS9/nOteCkR1gYTA9WXnTF
Z+mhyAHqF5i2YOmo7+DsZz3oCpXUddgDNVzVfeH2s+L9tZdym2isU24bvOL/citA
awvkZj4kL/5JO+JHzq6u
=J8AS
-----END PGP SIGNATURE-----

--NRwPRr2Fuc0K3MjV4HePeMTDJxnWwhlL0--
