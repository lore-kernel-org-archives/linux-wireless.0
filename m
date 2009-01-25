Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53556 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbZAYQ3V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2009 11:29:21 -0500
Subject: RE: [PATCH 1/2 v2.6.29] iwlwifi: fix rs_get_rate WARN_ON()
From: Johannes Berg <johannes@sipsolutions.net>
To: "Abbas, Mohamed" <mohamed.abbas@intel.com>
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <26E9B811E137AB4B95200FD4C950886B1C8F7AC9@orsmsx507.amr.corp.intel.com>
References: <> <1232564283-18008-1-git-send-email-reinette.chatre@intel.com>
	 <1232564283-18008-2-git-send-email-reinette.chatre@intel.com>
	 (sfid-20090121_195542_734853_62E08E0F) <1232621853.30174.19.camel@johannes.local>
	 <26E9B811E137AB4B95200FD4C950886B1C8F7AC9@orsmsx507.amr.corp.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-GPaompsiEzKSto/HLnDO"
Date: Sun, 25 Jan 2009 17:29:11 +0100
Message-Id: <1232900951.3952.12.camel@johannes.local> (sfid-20090125_172925_308530_5D8B56BF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-GPaompsiEzKSto/HLnDO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-01-22 at 08:51 -0800, Abbas, Mohamed wrote:

> Sounds like we should fix mac80211 to disassociate _before_ switching
> the channel? It won't help anyway if we're on another channel?

> [mabbas]=20
> I totally agree, all the disassociation frame will happen in the new chan=
nel that AP wont hear.

So any idea how to fix it? I'm not all that familiar with the MLME.

johannes

--=-GPaompsiEzKSto/HLnDO
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJfJNUAAoJEKVg1VMiehFYuvEQALrwVfMmq3W5ykwMsjGJclXe
dNW70SVDySZ6cZqq6KNtoi1vJR/y3aU5QZNGfpEL6636iZuXApPA8i2vupFjNnWe
/4v6thOjZ0b4mWe0pnaxFun4jAIUXBhNMkrSpVFquFKiJCnsPBf/U74l2wK3n8JE
WLrBgtz6oiuu6NHS/SHFKdens8QvMTBqutSYXgXK9lNPuYr0E8at98dpCU2499/V
0zakH1tk/xb2TZOFHo39bw2UzkqDD87GihUfZYxjIm2uBvOYX7YrSJHB0sSwpIFy
5AuYuuj5CXz6PLbq3eg5AkslQyBPLnoSve6xb0gPO0tz616MShJYAx4ZlV2xao1S
iXc8ogo0PXI+xQy/doyOxfxKNUx6K4JvGu2fxYuEgOPazoUxmiQ8cRdbsBtRwCx4
kpl5lfGRkgQhPdjoYiOBts6gynlU5x+9dq1QcxnKeIyU9l/9l/SSCO6Drhnuz+Dp
rDbAySXUnX+BUq5BSgYWzU57iFFEhmB3w1XAkkzA7ZNkYYbJXVDpKYNCY3svzOco
O/mIP5PjdYNvp74Gkoe7f3g16EDKCwK67l/ZPp+tfMMNKCdIsxQlgxl4ATRdw11v
APiLYae2HIaWcHEGJQDNSskD4jnz9mhGzzlN0BRPZ1PMUXklggNMqbpwcJM1NSrl
ImShYucDol/Jdfnf9Eby
=37Qq
-----END PGP SIGNATURE-----

--=-GPaompsiEzKSto/HLnDO--

