Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60145 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbZG1Qac (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2009 12:30:32 -0400
Subject: Re: [PATCH] orinoco: enable cfg80211 "set_channel" operation
From: Johannes Berg <johannes@sipsolutions.net>
To: Dave <kilroyd@googlemail.com>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org, Pavel Roskin <proski@gnu.org>,
	orinoco-devel@lists.sourceforge.net,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <4A6F270A.7030002@gmail.com>
References: <200907281634.26104.hs4233@mail.mn-solutions.de>
	 <4A6F270A.7030002@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-qG1G7nxXE9/deRs+HnPB"
Date: Tue, 28 Jul 2009 18:29:59 +0200
Message-Id: <1248798599.13742.2.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-qG1G7nxXE9/deRs+HnPB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-07-28 at 17:27 +0100, Dave wrote:

> Looks right for monitor mode (as you tested), but for ad-hoc the channel
> change would be delayed until the next SIOCSIWCOMMIT. Which for cfg80211
> is currently only on change_vif.

You won't be getting this call for ad-hoc mode, because then the channel
is contained in the ibss_join() parameters.

johannes

--=-qG1G7nxXE9/deRs+HnPB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKbyeDAAoJEODzc/N7+QmaqzYP/2qbfIiuQXp3Iea1reh7r7yi
zNU6kB41QKLEG4CwFMtCRzmd6kSGCYsrQCRWHKQYEApA1sD0wJMWe3XxqleLq1o0
IXf7pMX9zYFcupCBOkxPvzY4SF0lucnpa97jQdk1aFzxZtQ7nRTglK+dqHgeKX/E
ES81hlQzY+1T50ENuQzO2XtLKxGAv7krqt0xAnSvVRaAQm5Jl/sIrTK1d2XejDPf
DNpUoC9y4twFgTCOu5MYShG9LMKR2o/wbTmQEguGvWghKpZdjjjA422jjDVF1HTG
vP7nU/Fy3Kia1E1tOCAFsUNqAb76pgAce6zg2g6e+nnGts/SRdVIqpzXk89lYMS8
kki+jmAN0rumETqfid2KMRsLWumAelhKILqW3g2kMJa/RfG+woJxKHs0xfHVCgoE
u7gnl0KMFhN0O09VnE9Co4J41ovFuIyrVq+nuCw6bbgtnw3PqrIvlRxwAfpNi20+
ftSf7ckZbzkrfJUpWjluVG4f8i4vKNNXgbZlT3lhIIaHGGvGvDGBjeRmwo8YQiWL
qYJFlfdkpGVLDi8K6XrPhLkv1/WZ/JArys2zSHgmxzmpBw/VcLlS+PRXcZ+qbBN/
VxHUYxvxSaeJfRuGqmUGSU5fTrk4Oxefdc9qk39l6Pgrn+to2D3l2CLorzS/n1Bi
/x4kktwm4UE1JafvUeuw
=bxkG
-----END PGP SIGNATURE-----

--=-qG1G7nxXE9/deRs+HnPB--

