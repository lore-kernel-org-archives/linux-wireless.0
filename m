Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:51680 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbaBLJIn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Feb 2014 04:08:43 -0500
Received: by mail-wi0-f182.google.com with SMTP id f8so6484511wiw.3
        for <linux-wireless@vger.kernel.org>; Wed, 12 Feb 2014 01:08:41 -0800 (PST)
Message-ID: <52FB39F0.9010102@gmail.com> (sfid-20140212_100856_833544_AF0ECF33)
Date: Wed, 12 Feb 2014 11:08:00 +0200
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
Subject: pull request: iwlwifi 2014-02-12 (FIXED)
References: <52FB360D.2060502@gmail.com>
In-Reply-To: <52FB360D.2060502@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="xGwNu17Wn1qcDSKHR4qcP8a9pQvVFCo6X"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xGwNu17Wn1qcDSKHR4qcP8a9pQvVFCo6X
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable



On 02/12/2014 10:51 AM, Emmanuel Grumbach wrote:
> Hi John,
>=20
> One single patch for this pull request for 3.14.
>=20
> As explicitly written in the commit message, we prefer to disable Tx
> AMPDU on NICs supported by iwldvm. This feature gives a big boost in Tx=

> performance, but the firmware is buggy and we can't rely on it.
> Our hope is that most of the users out there want wifi to surf on the
> web which means that they care more for Rx traffic than for Tx.
> People who want to enable it can do so with a simple Kconfig entry.
> Rx AMPDU is still enabled by default.
>=20
> Please pull - thanks.
>=20
> 	emmanuel
>=20
> The following changes since commit c512865446e6dd5b6e91e81187e75b734ad7=
cfc7:
>=20
>   iwlwifi: mvm: don't allow A band if SKU forbids it (2014-02-02
> 11:08:42 +0200)
>=20
> are available in the git repository at:
>=20
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git=

> for-john
>=20
> for you to fetch changes up to 930e106d90ca902c8ede0a8cb206cee1ef3c5cc0=
:
>=20

I had to edit the patch - 63f1809aa672dc439e7750b551ff9926a79312e0


--xGwNu17Wn1qcDSKHR4qcP8a9pQvVFCo6X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJS+zoDAAoJEC0Llv5uNjIBeJEQAIauq8DsRtvQxOmNloavbsfG
Oiu4j0f61PJe8IkQIai/KbeNaphuTz63UBDZA6NMZedyDtggvremPia/nXzweky9
eWZ4x1oKbuHfWgAySTEljfVY9bJmyhAV8mJjldBXplbK3K44/lpbeIN2Wf3I9zIm
4SeAvkzAfvWDhUWwYb6gHqxxkyAefOpHtW17f7P2ZVjS4JbnTAA/+gVrdS2/xkO3
UANq8UjRhLYu9hmRUqHAcm/WIc5bjxVFfuaLiapOXf1eUUW40hD8gi3G+Y6mNnzw
NmKtTMgUy3LEtXAg/mE1BCPem1By2vkaOKZ3BkuMu3DaTXze73cYArEMYDmCxsQL
DaX7h7xgNTV4U680jGE+cDQQjbZvmSEXoP+vj1ixA5WjiU2km3LuDZPDJLRbdZtG
ZLy3mM2cHhTYtetf2Tphafre3NM/oIbjNjnTA7BnO7dYhv4R/Ed11kHqNNdTvbJT
hRPaILo3eYXtdYDzLz5NM5UWfhjQk6q/AmZEysPrwKFgJhIPvBNYmdkcqZleMX9w
+TJlH2Te6tvEij9dmu7NZOkBlb097GjcH3fT9EM8lsEluoa7AQUM+y7oDJ+zF+Ks
5IHRThaF0ve4R0toWETZY3rBgIBcmUYmLGCxVGssApSKTNuK8Ot7/C/76ZKps+tU
opGZ/P3Xw4wg37G98oKQ
=ZaGC
-----END PGP SIGNATURE-----

--xGwNu17Wn1qcDSKHR4qcP8a9pQvVFCo6X--
