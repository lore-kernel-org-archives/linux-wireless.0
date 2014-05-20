Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:53760 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766AbaETKgT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2014 06:36:19 -0400
Received: by mail-we0-f180.google.com with SMTP id t61so298593wes.11
        for <linux-wireless@vger.kernel.org>; Tue, 20 May 2014 03:36:18 -0700 (PDT)
Message-ID: <537B2FF7.5070908@gmail.com> (sfid-20140520_123632_193908_B7D2DE9E)
Date: Tue, 20 May 2014 13:35:35 +0300
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: pull request: iwlwifi 2014-05-20
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="hc4BmoNGJB64sX3v6Hsdj9BAQvX2fdepf"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--hc4BmoNGJB64sX3v6Hsdj9BAQvX2fdepf
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi John,

Here is another pull request for 3.15.

Avri fixes a disconnection issue in the power area. In certain cases, we =
can get the beacon only after association, and in these cases, we would b=
egin to filter beacons out (to save power) too early. When that happened,=
 we would disconnect.

Please pull, thanks.

The following changes since commit b538b8ce76f69f7fa225bc0817bbb361b877ea=
23:

  iwlwifi: mvm: prevent sched scan while not idle (2014-05-13 15:05:32 +0=
300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git=
 for-john

for you to fetch changes up to 7340564bfacddd9cc974c714a5844e49216af190:

  iwlwifi: mvm: don't filter out the first beacon (2014-05-20 13:33:29 +0=
300)

----------------------------------------------------------------
Avri Altman (1):
      iwlwifi: mvm: don't filter out the first beacon

 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 13 +++++++------
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |  5 -----
 drivers/net/wireless/iwlwifi/mvm/power.c    | 63 ++++++++++++++++++++---=
----------------------------------------
 3 files changed, 27 insertions(+), 54 deletions(-)


--hc4BmoNGJB64sX3v6Hsdj9BAQvX2fdepf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTezARAAoJEC0Llv5uNjIBM0YP/24q/hECorBHKytNx8131vdr
EvOThkNL9vPazZWIgbduHyLBu1YkDMPUkSK+DUvHVDwdEXLR64eJD2VmGo5UOumh
sWt5m4Ey7IUZtLNxwnrapz+UWcpO+bjjY7wEmbOWEbAml5GydE9j1JaqhWiDLhzc
VeD+zYdqefnKgZKoRvpN8qC1QeRYkEoQyELm0dMWaw2f102yxgmqOTy372euVpzT
YgJMVwTQBU7OsoLi14TSyJTBxnHQoR2L+/Qdi0maMU3pUGB8nNliNk57D9plzkUr
mwf58XqboC+VPk0GRMUHrvy9tSa3nzHiifUtyh/0jjLeVVGUq7k1Il7Or83mX6Li
l62XZPDWAiBgkI5KDhriARh84p2Ch6i/OXIHI2Dc8JCtjfiPdKhSwJP9LmW6u5LG
3jzkFtMojkj8G2TevTPMoKJzhuePH9+Ehnofa9129CEWeIHtkvcuBY1ByHpjPVHk
HXRxWeootsPius3Zjk+7n2RgJLOA8xEa3/zH+qUvpOsIoxS+TqYwTm/oAOPbBwNd
uFwzXAxUR1TnxUAoQN1lnBZ8yngWBtgObuM6mtt46zqRX2KaqW1euQ38BfwULeWX
9hEjX8m0YF1jxZ/I4YGLJR+u+LP5x7Iww/6+/M6ZvPBjcSuQWBzyrLLHyXwYK4/O
YEmJjNK+OCwyC/WBOIv7
=MB+l
-----END PGP SIGNATURE-----

--hc4BmoNGJB64sX3v6Hsdj9BAQvX2fdepf--
