Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40790 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751965AbcH2Thz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Aug 2016 15:37:55 -0400
Message-ID: <1472499451.27868.31.camel@coelho.fi> (sfid-20160829_213758_789432_75F69E66)
From: Luca Coelho <luca@coelho.fi>
To: kvalo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        linuxwifi <linuxwifi@intel.com>
Date: Mon, 29 Aug 2016 22:37:31 +0300
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-e1pDD3FSpZyZCp9BJffA"
Mime-Version: 1.0
Subject: pull-request: iwlwifi 2016-08-29
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-e1pDD3FSpZyZCp9BJffA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

Here are 4 patches intended for 4.8. =C2=A0They are all very small and low
risk, but fix some actual issues. =C2=A0More details in the tag description=
.

Let me know if everything's fine (or not). :)

Luca.


The following changes since commit bb87f02b7e4ccdb614a83cbf840524de81e9b321=
:

=C2=A0 Merge ath-current from ath.git (2016-08-29 21:39:04 +0300)

are available in the git repository at:

=C2=A0 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.=
git tags/iwlwifi-for-kalle-2016-08-29

for you to fetch changes up to a904a08b5fee5317ff0f7b8212aa5d0776795a52:

=C2=A0 iwlwifi: mvm: Advertise support for AP channel width change (2016-08=
-29 22:29:06 +0300)

----------------------------------------------------------------
* Fix P2P dump trigger
* Prevent a potential null dereference in iwlmvm
* Prevent an uninitialized value from being returned in iwlmvm
* Advertise support for channel width change in AP mode

----------------------------------------------------------------
Emmanuel Grumbach (2):
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: mvm: consider P2p device type =
for firmware dump triggers
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: mvm: don't use ret when not in=
itialised

Peer, Ilan (1):
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: mvm: Advertise support for AP =
channel width change

Sharon Dvir (1):
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: mvm: check if vif is NULL befo=
re using it

=C2=A0drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c=C2=A0=C2=A0=C2=A0| 3 =
++-
=C2=A0drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.h=C2=A0=C2=A0=C2=A0| 3 =
++-
=C2=A0drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 1 +
=C2=A0drivers/net/wireless/intel/iwlwifi/mvm/mvm.h=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0| 2 ++
=C2=A04 files changed, 7 insertions(+), 2 deletions(-)
--=-e1pDD3FSpZyZCp9BJffA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJXxI77AAoJEKFHnKIaPMX6OaoP/0sjh0EoNMm3VLYtkfeXp07a
orkZt2EX7NmZGBRDe9KG/UrOnnfArjTLcXbptTGA2qh6U7uZYaooD/LC8PyZwzqh
iVwTYreTRcTCQVP3dfiBPEPLQsdabm3av/1Sbo2C3aW0Xfoj3L3/b8cfJnBqK3Ak
lVjpwvaXv5cAlZv1E2wBojNxhtGco7aetoUvDszcyhyHOV1LzlckFy1/074Sfghq
2sOTSj+9+GXEAmO7/b182D6glU3QbOXJvSBGUawnrFQEdQ1vfTdcWMlBkugTkpHa
lnSNmdy+hpqTZQQctp71Ox+DFeChmH6IhhEyrKGpOw0BFeOZdJFrBa0/+wiFJXic
stARAhu1oe7PnWb4Sh4rDb3rwKHqZ8GUw9QW5uPy9i3GGGT4RZuma1KItAVF/S6Q
3/96XqqVCljMQq9SMmjLoBLn7AboxQeCikJI/ij306qnnUmavZZxkrkZ993vUnfU
z1Ovg02rWj3zs8difoPumOTlfsM1qoKGkSMUaVu9RcyFKDaofWPGcrOET0hcdFoY
V04iEU+e2h3ZQabOweOBi6lDMklJl+G6rEYOKf9PojqP4QDXNIQwiCG1lHZ6sun4
nqDXN/Umeg7iv6mXVKyI5evCTQ+s7r/zJXxUotTksBMLHvyTpPPLzf2n/pabnULr
i0P09GsnMTOvjZUWdL7g
=8dJe
-----END PGP SIGNATURE-----

--=-e1pDD3FSpZyZCp9BJffA--
