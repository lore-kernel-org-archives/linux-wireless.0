Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:56588 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932156AbcFJMhA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2016 08:37:00 -0400
Message-ID: <1465562195.29614.5.camel@coelho.fi> (sfid-20160610_143706_363909_84E4C3AC)
From: Luca Coelho <luca@coelho.fi>
To: kvalo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 10 Jun 2016 15:36:35 +0300
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-jtifOd/6u4CGKFSPtADv"
Mime-Version: 1.0
Subject: pull-request: iwlwifi 2016-06-10
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jtifOd/6u4CGKFSPtADv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

Here are some fixes intended for 4.7.  Nothing really big, just some
fixes for bugs introduced in recent patches and a long-standing bug
with IGTK keys, which apparently had never worked properly before. =C2=A0A
few more details in the tag message.

Let me know if everything's fine (or not). :)

Luca.


The following changes since commit 182fd9eecb287e696c82b30d06c6150d80a49c5b=
:

=C2=A0 MAINTAINERS: Add file patterns for wireless device tree bindings (20=
16-06-04 17:24:02 +0300)

are available in the git repository at:

=C2=A0 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.=
git tags/iwlwifi-for-kalle-2016-06-10

for you to fetch changes up to 280a3efa82fccc9532c968a77e5162cb9f0af497:

=C2=A0 iwlwifi: mvm: fix a few firmware capability checks (2016-06-10 14:20=
:08 +0300)

----------------------------------------------------------------
* fix the scan timeout for long scans
* fix an RCU splat caused when updating the TKIP key
* fix a potential NULL-derefence introduced recently
* fix a IGTK key bug that has existed since the MVM driver was introduced
* fix some fw capabilities checks that got accidentally inverted

----------------------------------------------------------------
Ayala Beker (1):
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: mvm: set the encryption type o=
f an IGTK key

Emmanuel Grumbach (1):
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: mvm: fix RCU splat in TKIP's u=
pdate_key

Johannes Berg (1):
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: mvm: fix a few firmware capabi=
lity checks

Luca Coelho (2):
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: mvm: increase scan timeout to =
20 seconds
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: mvm: fix potential NULL-derefe=
rence in iwl_mvm_reorder()

=C2=A0drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c |=C2=A0=C2=A08 ++++=
----
=C2=A0drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0|=C2=A0=C2=A04 +++-
=C2=A0drivers/net/wireless/intel/iwlwifi/mvm/scan.c=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0|=C2=A0=C2=A02 +-
=C2=A0drivers/net/wireless/intel/iwlwifi/mvm/sta.c=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0| 16 +++++++++++++++-
=C2=A04 files changed, 23 insertions(+), 7 deletions(-)
--=-jtifOd/6u4CGKFSPtADv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJXWrRTAAoJEKFHnKIaPMX6t/4P/2S3GPbU5g5H0WIVbjEPjtdt
8JyoXgJ5PihtI4w6gddV68PqX53ciZCdCGkxJrV5yPrOLiCbMaoN32/cVAkLhSVd
rDFUVz6ZNwEzvUYRZilhgjVay5WTEXobSn2ysUyfbaQOIP+86DEYqQFNhjqHzIex
tmMykzfRzfn74AVazK757jDVswfxKD9mEtdKJePsOOr6lxqe84Y1a87wMF/te6lL
eTmsnX9YlBTzftKZpbSsT6ZE8Jd4uS9qTUxwiT/zzK7RokJJKYCKcH/Unv5mDFsg
JpWocHAvfupe84WPVv/kUCvygvynnZpkZCfHRNpQq0yJXAu5HWf2GS4Hwk5vCNby
mxVBdPU5Rj52Or0vgw7pKI5m7k0DuDntUKpwliGT6PyeC1SLAeAH+HXwZr5MHSY6
EsDI0IdyeH2nSYa6G9nk9An9HThQTdIrVngJarOwp7927goB78Jq9sIXc3Y/Q/gK
2aUS+/JtygPAIq+pYyXPepZVwtge6RxKHI1EsAVweAw6mjJEHbocRVw00G0bfSUg
1LChHHw81Hhg/HQ4wmQnXGci9v7npLtMyIRV8x5p9ksSR7WDgJjFRWtRMvnF2Sns
RSpNHOiB/kCRIyEz9QEyeoYp4m1UwrxwkelpyQavVvh/lXbTcxQaNeNy4KC2kZlo
qPhfd4wTcoI7q02UVZjf
=rBXF
-----END PGP SIGNATURE-----

--=-jtifOd/6u4CGKFSPtADv--

