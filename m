Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:46646 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbYCLO4v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Mar 2008 10:56:51 -0400
Subject: Re: [PATCH 2/5] tkip: remove unused function, other cleanups
From: Johannes Berg <johannes@sipsolutions.net>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1204968185.23455.38.camel@brick> (sfid-20080308_092340_520643_C35AE989)
References: <1204968185.23455.38.camel@brick>
	 (sfid-20080308_092340_520643_C35AE989)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-vk+BNO+rclGyYTL+SW2P"
Date: Wed, 12 Mar 2008 15:56:34 +0100
Message-Id: <1205333794.15910.12.camel@johannes.berg> (sfid-20080312_145700_808103_8DA61689)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-vk+BNO+rclGyYTL+SW2P
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Sat, 2008-03-08 at 01:23 -0800, Harvey Harrison wrote:
> tkip_S had an opencoded swab16
> make ieee80211_tkip_gen_rc4key() static
> remove the unused ieee80211_tkip_gen_phase1key()

This seems fine. Does it depend on 1/5?

johannes

--=-vk+BNO+rclGyYTL+SW2P
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR9fvIaVg1VMiehFYAQJVdRAAljaC0ASDKN+jjpuHPFSTJy7/36WCGDdv
DagzBtCNl+Sm37uAttgBLGWILyk1R2ow1ahSR5//6krS4Jc+SVndG2BmiUybWm92
gbTLy35eUA49EzyU2rW/yoIof7KjR7D642L6xO74M0gVWFc+is8tWLZn6y1acwfz
BOY8Fck1TTXjT0e/AOf2rAGmo0gsj5FQTHEbeZr8p8wrD45csaZVDEFKpGK2kd0M
mSMywDI+3E4wZReZlavqDRvYrpCgoUOcekoo0MGGcaXeYGnjoNz+NW+D0zUainSq
bKPXDvs+vhAQqAs2qaCC44Fp7RL43TfBayPeUHC49K8ZhwhOAKQ1asZX2ISuqxin
TO/Bf5bfgxu/SHeex5K8paiPF2917tY24rTa5k0SkH3/oMeIfB+SGjQkzMoMp1dQ
PLN/PgaydpGHjRtN2uj6AwynI2lzP+BnYkFEhY2irzeuD9jcWPNExFxufqTJURFH
w9zOaCLcOnfHmL01RcgAb3GuxlhVS+RI+5an3nFyZmP4JUZimf/dOojKl/awRqd+
mUe19fqH4mK28S6P8GW7pjKHaW8YbxfN0kq8+iUXJt+lKjUXwXMVmA/RmRlG/1ya
8tiIDF7Poqs3ujhA85Aq7QtFAhWuH8HEP1tsfGtsoR4Coj/apoAk5U4VXF2xoQ5X
lqrYhTfAzTY=
=2OTR
-----END PGP SIGNATURE-----

--=-vk+BNO+rclGyYTL+SW2P--

