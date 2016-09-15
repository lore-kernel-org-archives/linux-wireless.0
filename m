Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54598 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751085AbcIOQKl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Sep 2016 12:10:41 -0400
Message-ID: <1473955833.5664.38.camel@coelho.fi> (sfid-20160915_181045_696699_EAC6CFF1)
From: Luca Coelho <luca@coelho.fi>
To: kvalo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        linuxwifi <linuxwifi@intel.com>
Date: Thu, 15 Sep 2016 19:10:33 +0300
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-Vxto5FyfWAqqe4MnA1mT"
Mime-Version: 1.0
Subject: pull-request: iwlwifi 2016-09-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Vxto5FyfWAqqe4MnA1mT
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

Here is one more patch intended for 4.8. =C2=A0It's small and low risk, jus=
t
moving some lines of code around, to prevent a firmware crash in
certain situations.

Let me know if everything's fine (or not). :)

Luca.


The following changes since commit a904a08b5fee5317ff0f7b8212aa5d0776795a52=
:

=C2=A0 iwlwifi: mvm: Advertise support for AP channel width change (2016-08=
-29 22:29:06 +0300)

are available in the git repository at:

=C2=A0 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.=
git tags/iwlwifi-for-kalle-2016-09-15

for you to fetch changes up to 54c5ef2e93ea002dc5dd63349298b2778fe59edb:

=C2=A0 iwlwifi: mvm: update TX queue before making a copy of the skb (2016-=
09-15 18:35:20 +0300)

----------------------------------------------------------------
* fix to prevent firmware crash when sending off-channel frames

----------------------------------------------------------------
Beni Lev (1):
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: mvm: update TX queue before ma=
king a copy of the skb

=C2=A0drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 19 +++++++++----------
=C2=A01 file changed, 9 insertions(+), 10 deletions(-)
--=-Vxto5FyfWAqqe4MnA1mT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJX2sf5AAoJEKFHnKIaPMX6l6sQAKS1uNpRawC1yU74vB1+HG/1
8dvID4wLJVrQq1sjbvW/PMLSnIQ3mPaSXHGlI7KoQ+qNBiKznXnuhRfTjV4Q1vs9
Rwrc+Fk4T5uzkXYQjIbHJTuSXP+49t9ANJzo6PKMJkS4s3Sv41tBa5adINviim8I
lyr2DPvAh1rsFbaf44sILSgYh4C4FmnIQjUEzXqmDmtDcSEpPbcBFCtLsyeKfqFB
we1tga/yyMdrF3NS4pkxVSnwKCl+ZoWSD1HXQvr+6M/oIFJ9UTLSYkO2+PXOba8v
M0QdcLc01aWy/k8iFL6ImCL4pDCH9dqGgv3QDAFJzbSfhFgLN//0EBZOOQXTajSJ
aJKx2uGbYZ53Ooet8ZxK7/frU8fiYlkau+eSWQcyoMB1WhrbWDnrwk+hkJ3j/DCb
svNRxqqsfOU8qhQIaVpIdPuYrtwXf9VNY7gsPJDE6SjEeecYbFolgrUmqJPg6HGV
v6BEN9cOh7Hv4Arb985f1A6FSYsxTxQAIkPQEyQenbe732AzVVh89CbDONdOaEQl
5Bp3b0BTq5UBvnG3zCE5IXEDLCaiQSmQhKCrEFChP2KjXtmnqMJt/nAHcacfvcvU
5CJNL2UiEvbeggxRknfnsUwLtQM8tS4UZOBf0dAPIOTOI/Gda6+jxaiyffucwODn
fS0C0Tm1BrZvkC4ejus6
=IO7J
-----END PGP SIGNATURE-----

--=-Vxto5FyfWAqqe4MnA1mT--
