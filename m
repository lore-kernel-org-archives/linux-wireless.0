Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:62241 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802AbaFXTp2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2014 15:45:28 -0400
Received: by mail-wi0-f177.google.com with SMTP id r20so1237579wiv.4
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jun 2014 12:45:25 -0700 (PDT)
Message-ID: <53A9D551.6020007@gmail.com> (sfid-20140624_214531_432433_94C2AF5D)
Date: Tue, 24 Jun 2014 22:45:21 +0300
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	ilw@linux.intel.com
Subject: Re: pull request: iwlwifi 2014-06-24
References: <53A9D396.1020306@gmail.com>
In-Reply-To: <53A9D396.1020306@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="d0FXiOXFjA1XirLPKUXKp2VO3L3Us3WcX"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--d0FXiOXFjA1XirLPKUXKp2VO3L3Us3WcX
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable



On 06/24/2014 10:37 PM, Emmanuel Grumbach wrote:
> Hi John,
>=20
> I have been travelling so this comes a bit late. Nevertheless, it is re=
latively small.
>=20
> I have here a fix from Eliad for scheduled scan: it fixes a firmware as=
sertion. Arik reverts a patch I made that didn't take into account that 3=
160 doesn't have UAPSD and hence, we can't assume that all newer firmware=
s support the feature. Here too, the visible effect is a firmware asserti=
on. Along with that, we have a few fixes and additions to the device list=
=2E
>=20
> Please tell me if you have problems. Thanks!
>=20

I forgot to say that this is intended for 3.16.

> The following changes since commit 7171511eaec5bf23fb06078f59784a3a0626=
b38f:
>=20
>   Linux 3.16-rc1 (2014-06-15 17:45:28 -1000)
>=20
> are available in the git repository at:
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.g=
it for-john
>=20
> for you to fetch changes up to a42c9fcc4a88cdd246fab3bcf06c4487afee3d88=
:
>=20
>   Revert "iwlwifi: remove IWL_UCODE_TLV_FLAGS_UAPSD_SUPPORT flag" (2014=
-06-24 22:01:46 +0300)
>=20
> ----------------------------------------------------------------
> Arik Nemtsov (1):
>       Revert "iwlwifi: remove IWL_UCODE_TLV_FLAGS_UAPSD_SUPPORT flag"
>=20
> Eliad Peller (1):
>       iwlwifi: mvm: rework sched scan channel configuration
>=20
> Oren Givon (1):
>       iwlwifi: update the 7265 series HW IDs
>=20
>  drivers/net/wireless/iwlwifi/iwl-fw.h       |  1 +
>  drivers/net/wireless/iwlwifi/mvm/mac80211.c |  7 +++++++
>  drivers/net/wireless/iwlwifi/mvm/scan.c     | 65 +++++++++++++++++++--=
--------------------------------------------
>  drivers/net/wireless/iwlwifi/pcie/drv.c     |  3 ++-
>  4 files changed, 29 insertions(+), 47 deletions(-)
>=20


--d0FXiOXFjA1XirLPKUXKp2VO3L3Us3WcX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTqdVRAAoJEC0Llv5uNjIBzq0P/RVhU/vf0l331BvtMpIT5AHA
0O9wkKwOtBgwqk+hgS0MQ31CMU7U4d5ggIyN23TGAffx1ytKZJayYO9uQS0gB1Mz
WE789sDiJ70IfawNq5G+XE1QNB+cShu1M+0O1BabPGsYXR7qXRQIv++zMfeyvatb
mgxpe2nEaicliUZa5ezxyjEKXTuPua3HWHIWX8kxvS7Bl6+C0gHfnG2nvVA73UiV
txOmg8hKmfSw/+cMtPdAbsJ7TGlqILFGY+RoPwJCegMzQLI+hinAzgfaKHD4fKx5
VdVreT2BZoxykkWMiKaGe4mUxxN5IP350MdqukIkekkXAqACQcuvhUoj2DuUrolK
4HffNf1ERRPE1Yel3Y3H+AHrTG0lXEdhVo6Edlwkdi/z8jChrXzHNVvd38RHzqhC
ACi7GHg+Seci9iIdFRRqFZd1qTgAuPdNlWmEu3iehRRegh+L4QXr+d6NRCfGKWSo
bpUkbUSIQaKT8AARapesq1EfLglidNN1vbdyTc9wCTGNzblmUat5wXlj7dEz6WsV
KamaJHk6NC/JO83TfQP1Riji1X4r8eVMOpz42d6YkYLAx6Lt1hxiUqEH9vaCwD87
BeCeHOXbDqIf8Gpy5IyfGMYgQ9vjuNg0xZxNBjk3j+3YlI+oIrf01r46KuhBgyal
RC6yOZ1QwwPUgSqpz3qO
=GXQP
-----END PGP SIGNATURE-----

--d0FXiOXFjA1XirLPKUXKp2VO3L3Us3WcX--
