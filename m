Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:34344 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030392AbcGKKph (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jul 2016 06:45:37 -0400
Message-ID: <1468233921.25088.107.camel@coelho.fi> (sfid-20160711_124541_361212_D3DD2454)
From: Luca Coelho <luca@coelho.fi>
To: kvalo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	torvalds@linux-foundation.org,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	linuxwifi <linuxwifi@intel.com>
Date: Mon, 11 Jul 2016 13:45:21 +0300
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-+CLRCx86fNrw47kIrkze"
Mime-Version: 1.0
Subject: pull-request: iwlwifi 2016-07-11
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+CLRCx86fNrw47kIrkze
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

This is a fix for a warning that was spotted by Linus. =C2=A0We already hav=
e
this patch queued in -next, but it should have gone to -fixes. =C2=A0I hope
it is still possible to send it for 4.7. =C2=A0And it shouldn't be a proble=
m
to have it in both, right? I guess git merge would take care of that.

Let me know if everything's fine (or not). :)

Luca.


The following changes since commit 280a3efa82fccc9532c968a77e5162cb9f0af497=
:

=C2=A0 iwlwifi: mvm: fix a few firmware capability checks (2016-06-10 14:20=
:08 +0300)

are available in the git repository at:

=C2=A0 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.=
git tags/iwlwifi-for-kalle-2016-07-11

for you to fetch changes up to 7f5ac3b1294569624fc5d8b8eb9efcd73eb49b1b:

=C2=A0 iwlwifi: mvm: fix txq aggregation bug (2016-07-11 13:23:02 +0300)

----------------------------------------------------------------
* fix a warning splat and potentially a SYSASSERT in some aggregation scena=
rios

----------------------------------------------------------------
Oren Givon (1):
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: mvm: fix txq aggregation bug

=C2=A0drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 10 +++++++++-
=C2=A01 file changed, 9 insertions(+), 1 deletion(-)
--=-+CLRCx86fNrw47kIrkze
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJXg3jBAAoJEKFHnKIaPMX6/4MP/0zGbzUV2DCmB+HU3EmU02Qt
Dbf3YJFF4TrLWWoQEnaSx4zPYvCqgR8/MBMzbDNuzUM4FCIq0CxQw+BE9rCpPSNT
gQAZLHYyctcC5UQRnhKa7yY1KhtuzIQYrTBVNqJQRusxke6r5hzWFvYIzWJNcLif
RbK9cv00/FDshOyK8xFfxM9BYIH0ggDYKUF1Xqyxs7vZzpozT0AYetX90CIiOSjQ
yjykTSD55A0xBmSEjqgyJOditG2VaGPA0OIHxfc1bS0OSnEDakyRFmlEXj2j6r8f
ot9qGPcPGWbN+qKaPSP/6Y2htdV4hLpgXoHnEHYA0cwmCVT7k2NZfr46ILWhUD9X
ReOnpOBTIXx5i2DLluv/LypqUT1ca2rxqrPDsRhdDv9fbBg1DBY0EflpIEMtD5la
Y9Q4wRQQ+3vZ1uo8oLZdrJKQy7GCkEhsbWcuVHrkn2iIMtOeEijvAzFzORg3HeTZ
IcW0aUFwYM8JvNerBDTyAp6/H77OxNL19AocIV5mF6Eh+nTq/d2GS1kCeHVRM4Jd
Vz0JeGQrjPk+5kzZcJ6cjqSfRUoYve/1D7dSFQySK2l+6K1l0DeJOIiE4hbuDm6o
bKukvXoPsjIP1TjtROdNv1k5/+yVhOK5XPE+3ZQOs0C9731r6g/Yh8WqQGtXpBRK
peZkLAuFWqeEpCAjoQSI
=MhqB
-----END PGP SIGNATURE-----

--=-+CLRCx86fNrw47kIrkze--

