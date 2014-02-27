Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:44342 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbaB0Gxm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 01:53:42 -0500
Received: by mail-we0-f181.google.com with SMTP id q58so1138440wes.12
        for <linux-wireless@vger.kernel.org>; Wed, 26 Feb 2014 22:53:40 -0800 (PST)
Message-ID: <530EE0EA.5030105@gmail.com> (sfid-20140227_075404_564820_9694F57C)
Date: Thu, 27 Feb 2014 08:53:30 +0200
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, ilw@linux.intel.com
Subject: pull request: iwlwifi 2014-02-27
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="MG86hBBa0Vhtf4lMI9opF2ixRPgbwEtAT"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--MG86hBBa0Vhtf4lMI9opF2ixRPgbwEtAT
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi John,

I have two fixes for 3.14.
Johannes fixes a long standing bug in the AMPDU status reporting.
Max fixes the listen time which was way too long and causes trouble to se=
veral APs.

Please pull - thanks

  emmanuel

The following changes since commit ec6f678c74dbdb06a6a775bbb00f1d26c17c40=
4b:

  iwlwifi: dvm: clear IWL_STA_UCODE_INPROGRESS when assoc fails (2014-02-=
20 19:16:27 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git=
 master

for you to fetch changes up to d8105a24fce48b7b016e868923000871f4196e63:

  iwlwifi: mvm: fix TX status for aggregated packets (2014-02-27 08:50:32=
 +0200)

----------------------------------------------------------------
Johannes Berg (1):
      iwlwifi: mvm: fix TX status for aggregated packets

Max Stepanov (1):
      iwlmvm: change of listen interval from 70 to 10

 drivers/net/wireless/iwlwifi/dvm/tx.c  | 14 +++++++++-----
 drivers/net/wireless/iwlwifi/mvm/mvm.h |  2 +-
 drivers/net/wireless/iwlwifi/mvm/tx.c  | 18 +++++++++---------
 3 files changed, 19 insertions(+), 15 deletions(-)


--MG86hBBa0Vhtf4lMI9opF2ixRPgbwEtAT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTDuDxAAoJEC0Llv5uNjIBEIgP/2PIakmJ5J9yuWGwWlqBhIS6
tsrQibM9joKEH4RguFCmut93JLoYJ8eX2QECOP1s79sW7GW3+T5Fa7F8yvDHbMCR
xrCW5wEeHVMLVbqxchJkGA4QMocFyHnq5oOIcxFRncn/HNwwV9uydAJOUZ6ZKXIT
oTLwNgST2R3YWfHIasjB/r/7XE0gslyKhU+0hKEB7DT6MY7fpfVLCaLWvclRvGHV
45S3gbY3p57aRrNo+Ap5FuiyZFvfkAgdGktM9ufsH5Q2bl7QzGuojpm2tnt0C2QG
wKnQMzYmKxqmZXdpuC+iD23IDwoOxqDj48suMTtOw3cOlpjSq3MqKwVYdRajgEKx
SOe0bCBcLImpmoq8n2I32Vb8MBNFBIegl4sp4xTNox6m4hL9l81pRvEwR2lX1/qz
1Wa/hZsBIZt7wgy4Cp8F0OSfkBodOCH7zarZkOQ6IXmB5ujDdL63UieFzyHk41Yj
E4TABx9HI4t8lBU+MFfP6VYTmPnKFeSZGmy7JkaHtMrpvhvyeaZSB6yRFdaRbemo
8QJYyFdpAAs7NmTrDXZOGIBOHXn01FDVWhMUWc9DH4uF5qyYmmhlHL+P8UW4a+7/
M42kPzPZY+tI/Y+995BNdH3t3882Xfh22ZKV8ZhCj4xRLMUmWeJVCC9bU+u5iXPE
VRQoYhVM5IV806XqK1Hg
=dJEL
-----END PGP SIGNATURE-----

--MG86hBBa0Vhtf4lMI9opF2ixRPgbwEtAT--
