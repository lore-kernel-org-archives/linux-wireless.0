Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:44661 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbaATKrM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jan 2014 05:47:12 -0500
Received: by mail-wg0-f42.google.com with SMTP id l18so3804982wgh.5
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jan 2014 02:47:11 -0800 (PST)
Message-ID: <52DCFE87.9080103@gmail.com> (sfid-20140120_114715_500949_3C62CFAB)
Date: Mon, 20 Jan 2014 12:46:31 +0200
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
Subject: pull request: iwlwifi-next 2014-1-20
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="x4x7NkSplSkuWGQ9A0H0t49x1dNFUxmM9"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--x4x7NkSplSkuWGQ9A0H0t49x1dNFUxmM9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi John,

Well... I know... Not something to be proud of...

A critical bug has been reported on all NICs supported by iwldvm.
iwlwifi would simply panic upon interface up This patch fixes this. The
offending code is by me and is present in wireless-next.git and hence in
net-next.git.
I hope that this pull reuqest can reach 3.14-rc1 otherwise, all the
system with NICs supported by iwldvm will simply lock up.

Thanks!


The following changes since commit cf38e4f756d6396657c76f72ef42b6f47c523f=
97:

  iwlwifi: mvm: don't use highest rate in VHT MCS Set (2014-01-13
22:17:22 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git
for-john

for you to fetch changes up to 23e76d1a516eef416fb5c038791e943fc0916b67:

  iwlwifi: pcie: don't panic on host commands in iwldvm (2014-01-20
12:32:06 +0200)

----------------------------------------------------------------
Emmanuel Grumbach (1):
      iwlwifi: pcie: don't panic on host commands in iwldvm

 drivers/net/wireless/iwlwifi/pcie/tx.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


--x4x7NkSplSkuWGQ9A0H0t49x1dNFUxmM9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJS3P6hAAoJEC0Llv5uNjIBwIwP/RhI307vK2+3XOgfM0j5U83X
s00C45kiAA728RS0jbmtf/xiBEmevXOkyeQUAZEpnihRtVmAhYtnId8DgIKbWpxI
GbQZJ39GGTdbA5Fg6o/0DojY9dCbyGaJyFI50h7AMUhYx8k2CAmfTZO8sfRnsxyp
UmuSDEXxgqRLX0Cowb2AnpLFPVKEOW0vj8i0GoEWFQK3bbeGkntfk5LW62spjqUS
EbRewmplqNldbGv/onLTMiBcZpCc7Clmn70ITEsDKMz7Arldds/AHoej0SCDEy+m
c/k8lY62uOK/3UgE7D8ntJ51gDavmy+6ed3bpEGFLe2Xl8aSTZKXdphPHeAiurHr
lN1xcq6EPTLX5VRzRMwA65adFUYLEpNJNZj/UrFzQJnbw2B79EL5lKqwM2fUG/qz
PVvvey44KBpNhDVASPSRFuqCLIvu0xhPjNcJf0kzuHOxABl+1YlKcCVhmOFfqz6B
x8U9pXkem3/nTHDuvm9yGRaX0bA05XuzDqTk0OmUf06BZqFxk+y9FV7E9Pw/ZtId
OFZzzrbyMiQAe5qJp/XBte0mL6oFP4WPsq9Dw1oZ4P6guksOUKMBx0sLqrx5rTIV
+pYaZI/a8wkhWa77Oq6siTaX7QOGn66sEDrV4eHVesg8Q60TDIbMRZevSC7F42hU
1bfI9arljxKmbbDwYiJC
=tzKp
-----END PGP SIGNATURE-----

--x4x7NkSplSkuWGQ9A0H0t49x1dNFUxmM9--
