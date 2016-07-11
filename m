Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:34356 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753296AbcGKLZc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jul 2016 07:25:32 -0400
Message-ID: <1468236322.25088.114.camel@coelho.fi> (sfid-20160711_132537_230474_15EE9005)
From: Luca Coelho <luca@coelho.fi>
To: kvalo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Date: Mon, 11 Jul 2016 14:25:22 +0300
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-ADNZBbNKAXvDKKqNExgH"
Mime-Version: 1.0
Subject: pull-request: iwlwifi-next 2016-07-11
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ADNZBbNKAXvDKKqNExgH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

I have one more patch intended for 4.8. =C2=A0I had forgotten to bump the F=
W
API version that our driver is now able to load. =C2=A0I hope there is stil=
l
time to get it included for 4.8.

Let me know if everything's fine (or not). :)

Luca.


The following changes since commit 6f482e37b75d4e56cdb9b56ae7057f3ce67097bc=
:

=C2=A0 iwlwifi: move iwl_drv to be shared across transports (2016-07-06 10:=
37:44 +0300)

are available in the git repository at:

=C2=A0 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.g=
it tags/iwlwifi-next-for-kalle-2016-07-11

for you to fetch changes up to ad38844b8e00c8d33eb1d1ffb49b945e6a985e13:

=C2=A0 iwlwifi: mvm: bump MAX firmware API for mvm devices (2016-07-11 14:1=
5:38 +0300)

----------------------------------------------------------------
* bump firmware version to load newer firmwares

----------------------------------------------------------------
Luciano Coelho (1):
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: mvm: bump MAX firmware API for=
 mvm devices

=C2=A0drivers/net/wireless/intel/iwlwifi/iwl-7000.c | 4 ++--
=C2=A0drivers/net/wireless/intel/iwlwifi/iwl-8000.c | 4 ++--
=C2=A0drivers/net/wireless/intel/iwlwifi/iwl-9000.c | 2 +-
=C2=A03 files changed, 5 insertions(+), 5 deletions(-)
--=-ADNZBbNKAXvDKKqNExgH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJXg4IiAAoJEKFHnKIaPMX6h88P/Axt0nfmHzyoNZSMp21qh8op
y4Cqa78fMqaePutb7gM5mcKbGkK72X3lgG8mALgdrX3ZWtHluwzmCHgQfpLM69Qs
N9NcITUkrB73fZkB6ugEzaHG5QYSk49ON0rf3Y/ZnTO0+IRmr2NGvzMUFChYB1Hk
KfovcPM6klOdeT+0484D9dJeUgC/LrMFt0CTS76g4Falfs1llT9cuSTnBDTCsNA0
pXnIE2H4YH0ry/FaUcVyqBBrSXac4rL2+6p03J77oO6dAhKHla4lMDHoqXLjyNlv
3vzfYSDpUXL5Ld23EERSYKevIy023xHzKU0/MkIY67L0JDt6uuhr6DcMplxp0Mfr
GTyS9c1Zo7ODnoTTm8NjjpaCQRNdZ6x66LyUZJbyIn9UMS8CMQPNInUnXntnX6Bi
I4yyzREopi9J2aXDB9fIw4Zh1X+4nLExpN/3QI6L7Jd/TnuYHznEXPX0UmKwON0N
Vp6GHckru71Y9mgN8WvjtsL3sPl0syhKLli5DBuZVKGvW8h9ZYaZUqyY2UatxwOt
c/xfjdeYtM0cDG4CfbE0HHzz4mnZAFry3SckUU1bZkwbR/M/biDfEv8pDSk4qbFk
cuEwYi5uu98EBR0lGJJEA1pR5pu1u0PvI4FATH1QaqboqKzAvv5kiqRPIaLvWCyw
/siGO13aMBc0nagMLH7P
=Aoak
-----END PGP SIGNATURE-----

--=-ADNZBbNKAXvDKKqNExgH--

