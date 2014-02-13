Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:40283 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098AbaBMNdl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Feb 2014 08:33:41 -0500
Received: by mail-ea0-f174.google.com with SMTP id z10so1808528ead.19
        for <linux-wireless@vger.kernel.org>; Thu, 13 Feb 2014 05:33:37 -0800 (PST)
Message-ID: <52FCC95D.4090609@gmail.com> (sfid-20140213_143347_594703_8890690C)
Date: Thu, 13 Feb 2014 15:32:13 +0200
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
Subject: pull request: iwlwifi 2014-02-13
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="kt3J88t8xfUU6QwqxqbKrjsNEi5UlcpaN"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--kt3J88t8xfUU6QwqxqbKrjsNEi5UlcpaN
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi John,

One single patch for this pull request for 3.14.

As explicitly written in the commit message, we prefer to disable Tx
AMPDU on NICs supported by iwldvm. This feature gives a big boost in Tx
performance, but the firmware is buggy and we can't rely on it.
Our hope is that most of the users out there want wifi to surf on the
web which means that they care more for Rx traffic than for Tx.
People who want to enable it can do so with the help of a module paramete=
r.

Please pull - thanks.

	emmanuel


The following changes since commit c512865446e6dd5b6e91e81187e75b734ad7cf=
c7:

  iwlwifi: mvm: don't allow A band if SKU forbids it (2014-02-02
11:08:42 +0200)

are available in the git repository at:


git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git
master

for you to fetch changes up to 205e2210daa975d92ace485a65a31ccc4077fe1a:

  iwlwifi: disable TX AMPDU by default for iwldvm (2014-02-13 15:24:35
+0200)

----------------------------------------------------------------
Emmanuel Grumbach (1):
      iwlwifi: disable TX AMPDU by default for iwldvm

 drivers/net/wireless/iwlwifi/dvm/mac80211.c  |   22 ++++++++++++++++++++=
--
 drivers/net/wireless/iwlwifi/iwl-drv.c       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-modparams.h |   11 +++++++----
 drivers/net/wireless/iwlwifi/mvm/mac80211.c  |   22 ++++++++++++++++++++=
--
 4 files changed, 48 insertions(+), 9 deletions(-)


--kt3J88t8xfUU6QwqxqbKrjsNEi5UlcpaN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJS/MmeAAoJEC0Llv5uNjIBf2cQAJKAtPS947cZeqWXOmt5sleO
0q/1Pm2KZp+XFBjovfzwl6mt9dv5MiGFvDCqSGBTJW1w9Qkq4srQYLskENxHscvN
ddbk5PmbGirQN/bL4jHRPhdiISoukKo1diN8uohIK0j+38l/dLP/r+UCpsEjZRR3
h6s0a25gzVbZNnnYh5t8zYGdIt/5Voj7KlzU97UrbphHNy2enGwnrbPtIwtGhupv
Le/q+vagsaMry/gdrln99bk8DN7OFQHw9DWIjje0rY04GthrcLT34fzYCn21G5zx
z1v6aNG+9L6SCtdnDTmLzV0Ih/I3aCSS34M9dvtEU23d/5sEaiDfQ1jLTZLpXoPv
cbtz20e3Au7utS9VPwg3OKeWciC8hdNnspDNAuksvBI2fEvIkLMGouXHGGZ9JY8q
c6ly8FSatsh/CfcB6YCi4c7PAknoNBKBO1+p1dAYMxRhos1IK417k6LcJ2hwD44D
oMJiFZd5uNcFrQ/6gwo+DJUklXwW6K0qGixVwESnKC+rnUqhSGT46GePyOYeVoKn
y5+SRU4RStgQ96qzhyO/06mvcNt9AlIrXOe4Gjzby2Auuq6VxrhfHfaqWydZdBBu
XDKL9S/fvh0s75hgvi6fsddXwwAvNnA8XWsOElI57MBUpNNUBx0djzqxSS7uypW1
6PJ51LODXm7sP7DZsuFz
=TCDT
-----END PGP SIGNATURE-----

--kt3J88t8xfUU6QwqxqbKrjsNEi5UlcpaN--
