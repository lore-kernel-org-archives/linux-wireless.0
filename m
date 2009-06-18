Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44943 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759191AbZFRWxM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2009 18:53:12 -0400
Subject: Re: [PATCH 00/23] orinoco: initiate cfg80211 conversion
From: Johannes Berg <johannes@sipsolutions.net>
To: David Kilroy <kilroyd@googlemail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1245363695-8289-1-git-send-email-kilroyd@googlemail.com>
References: <1245363695-8289-1-git-send-email-kilroyd@googlemail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-6+WLBMjsqeOX89y+wrDr"
Date: Fri, 19 Jun 2009 00:52:44 +0200
Message-Id: <1245365564.16399.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-6+WLBMjsqeOX89y+wrDr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


>  drivers/net/wireless/orinoco/Kconfig          |    1 +
>  drivers/net/wireless/orinoco/Makefile         |    2 +-
>  drivers/net/wireless/orinoco/airport.c        |   98 +--
>  drivers/net/wireless/orinoco/cfg.c            |  162 ++++
>  drivers/net/wireless/orinoco/cfg.h            |   15 +
>  drivers/net/wireless/orinoco/fw.c             |   41 +-
>  drivers/net/wireless/orinoco/hermes.h         |    2 +-
>  drivers/net/wireless/orinoco/hermes_dld.c     |   50 +-
>  drivers/net/wireless/orinoco/hw.c             |  668 +++++++++++++++-
>  drivers/net/wireless/orinoco/hw.h             |   11 +-
>  drivers/net/wireless/orinoco/main.c           | 1133 +++++++++----------=
------
>  drivers/net/wireless/orinoco/main.h           |    3 +-
>  drivers/net/wireless/orinoco/orinoco.h        |   49 +-
>  drivers/net/wireless/orinoco/orinoco_cs.c     |   96 +--
>  drivers/net/wireless/orinoco/orinoco_nortel.c |   38 +-
>  drivers/net/wireless/orinoco/orinoco_pci.c    |   38 +-
>  drivers/net/wireless/orinoco/orinoco_pci.h    |   57 +--
>  drivers/net/wireless/orinoco/orinoco_plx.c    |   38 +-
>  drivers/net/wireless/orinoco/orinoco_tmd.c    |   38 +-
>  drivers/net/wireless/orinoco/scan.c           |  285 +++----
>  drivers/net/wireless/orinoco/scan.h           |   21 +-
>  drivers/net/wireless/orinoco/spectrum_cs.c    |   96 +--
>  drivers/net/wireless/orinoco/wext.c           |  878 ++-----------------=
-
>  include/net/cfg80211.h                        |   11 +
>  net/wireless/core.c                           |    3 -
>  net/wireless/wext-compat.c                    |   31 +-
>  26 files changed, 1748 insertions(+), 2117 deletions(-)
>  create mode 100644 drivers/net/wireless/orinoco/cfg.c
>  create mode 100644 drivers/net/wireless/orinoco/cfg.h

Amazing. Very cool!

johannes

--=-6+WLBMjsqeOX89y+wrDr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKOsU5AAoJEODzc/N7+Qma8xcQAIdWvDK8TsxNw11kKdscHKEK
VTiLhOBrtQX17yFk69LVnY/DviPtX5hmDyF+XUn0npc+KttFK4mMwQMHGz2CT0gH
Xln5HO7mJWlbooD/BIkqgLFdQX51AavjTWjwW1qbZoZ0cArgbJ5EXHatLIWwBWxy
u/hUuVXe8qUfYib+RDeNMb2ojcZfJgPE+Yvtvy4bnsQ790jXWFOKy8GeGniSGzwl
C8HIcY/vJovC7qQEvCS3aATp+G5wzgSxwoQuQ6v+bcrMzo7yuWW0DBAKOQN6uOBr
e9fxaodJN0V6EiQcwz9Un9X3zYpQZ+CLoFD+zpbPzSXJ+1QMGZdAjsXpPsiqjXjs
V4XK3O9NeUEAjyjKN8wnEVtypFrH45GR+zk7D9t4r30POqCVQF8fKcvynnuLlED9
WbefqSUAZie+k2AeToF9Ra7sogSzCPwxjXd0CNJym+i19n+I9QwE50YxZ+aE27Xs
yhhZDZkUvn1ftplETzERgy1+s+QAP+YFufhKtjO/kLb7pW9MGpbxEwhXLaszO96V
anIfT900RB+joE2xEfBUn91QTc5oiSOyXzZw3s6h1KnaI6FFxiamJbXanpplAyJ8
k4j85Bq2TfA1He9bubUHgnvUpGvbRLCVpfJcXzm+eAFyS1dzapKtvuk7d8tIMz7q
HEi6d6j2NsWEztFf0NUn
=sTN3
-----END PGP SIGNATURE-----

--=-6+WLBMjsqeOX89y+wrDr--

