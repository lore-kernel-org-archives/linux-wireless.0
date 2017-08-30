Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:46224 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750835AbdH3Ji5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Aug 2017 05:38:57 -0400
Message-ID: <1504085929.31031.8.camel@coelho.fi> (sfid-20170830_113902_222068_45059A23)
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, linuxwifi@intel.com
Date: Wed, 30 Aug 2017 12:38:49 +0300
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-CPuygcCIKqBg037jpeb+"
Mime-Version: 1.0
Subject: pull-request: iwlwifi-next 2017-08-30
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-CPuygcCIKqBg037jpeb+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

Here's my fourth and final pull-request intended for v4.14.=C2=A0 It contai=
ns
just a couple of small fixes and a FW API number bump.=C2=A0=C2=A0More deta=
ils in
the tag description.

I have fixed the subject of one of the patches for the typo you reported
during review.

I have sent this out before, and kbuildbot reported success.

Please let me know if there are any issues.

Cheers,
Luca.


The following changes since commit d081a16db80ef7a260fb178aa1199e01f7432625=
:

  net: bcmgenet: Do not return from void function (2017-08-29 22:39:51 -070=
0)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git ta=
gs/iwlwifi-next-for-kalle-2017-08-30

for you to fetch changes up to d7a5b3e9e42ee95190742fef0d617bbde4f74d80:

  iwlwifi: mvm: bump API to 34 for 8000 and up (2017-08-30 12:30:56 +0300)

----------------------------------------------------------------
Last set of iwlwifi patches for 4.14

* Fix a queue hang problem due to 11w behavior
* Fix a warning caused by a too long debug print
* Bump API number to the latest version we support

----------------------------------------------------------------
David Spinadel (1):
      iwlwifi: mvm: Avoid deferring non bufferable frames

Emmanuel Grumbach (1):
      iwlwifi: mvm: bump API to 34 for 8000 and up

Liad Kaufman (1):
      iwlwifi: fix long debug print

 drivers/net/wireless/intel/iwlwifi/cfg/8000.c      | 4 ++--
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c      | 2 +-
 drivers/net/wireless/intel/iwlwifi/cfg/a000.c      | 2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c | 9 +++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  | 9 +++++----
 5 files changed, 16 insertions(+), 10 deletions(-)
--=-CPuygcCIKqBg037jpeb+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAlmmh6kACgkQoUecoho8
xfrZpRAAtyl5nlmVzgjy4Ufol86gCPNGx0YpyglME3c50zSD4AFihYILr5SqYzE7
U33U5x916iCgwwT/seM1H1XAZ8s5KNMcQB7+S+jpHk6k649DGPZNa0XbCCcvPaOd
7eEXaI6qpy5CN13MnlHbh7VresLosdlttwNtjl0HC6fNm+KuH3RHIsU90MIsXo1w
PRrVQVdPCdObLxu/2bzdbdpEFdc1cARET9kBikDJwjqKhPgNwvplZ3Ya6CHdXJt0
tYrl3v4b84ueThv6/rTjO+XlRIYuz0TQqgzbJdzh6rXOV7AvZTiYbtvnIB3yX2Y1
MMsIZQhTe2yGbb0ISKA4FdEDq8ge7fDVi/I9Tk/SY6OWdkOEhxMiiz5uNf1bmmpA
LaSTCtv86FhJ0UuqUpf/L4IVXyuttsX4hOXJbXUq5a3Nc7fqhOFifOvz0vvr3ohk
7tJm0TeX+osbrPAiYBT31bAEMu0iO/RUqBc6Bq/91V7MoB6AHOPH/DIS4atlZmAI
1457UJsO/cMGn5VneCK4BZGLDJJDYsvJKJWMNI807EI+ObSWV9i8yr6GNNiUOcAZ
5ewqlFUYglahsXSCUvbNOVUdm++PwEZ40viJPkEyV67b/3vL+jbWbpsb27QZkKj3
DdUFS5r+ImPR7GayfBUk+ToWvajqQGUgqQCzL7H8GRi1R0Q2yG8=
=O4ua
-----END PGP SIGNATURE-----

--=-CPuygcCIKqBg037jpeb+--
