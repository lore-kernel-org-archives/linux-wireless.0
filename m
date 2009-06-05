Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35665 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbZFEG2K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2009 02:28:10 -0400
Subject: Re: [PATCH 14/15] mac80211: move management / no-ack frame rate
 decision to mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	ipw3945-devel@lists.sourceforge.net,
	Gabor Juhos <juhosg@openwrt.org>,
	Felix Fietkau <nbd@openwrt.org>,
	Derek Smithies <derek@indranet.co.nz>,
	Chittajit Mitra <Chittajit.Mitra@Atheros.com>
In-Reply-To: <1244180502-4323-15-git-send-email-lrodriguez@atheros.com>
References: <1244180502-4323-1-git-send-email-lrodriguez@atheros.com>
	 <1244180502-4323-15-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-n0t9yNFQHqZj4Te/pIzp"
Date: Fri, 05 Jun 2009 08:28:08 +0200
Message-Id: <1244183288.22576.93.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-n0t9yNFQHqZj4Te/pIzp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-06-05 at 01:41 -0400, Luis R. Rodriguez wrote:
> All rate control algorithms agree to send management and no-ack
> frames at the lowest rate. They also agree to do this when sta
> and the private rate control data is NULL. We move this to mac80211
> and simplify the rate control algorithm code.

We previously thought this would constrain our rate control algorithms
more than we would like for future experimentation with higher multicast
rates. Has that changed?

johannes

--=-n0t9yNFQHqZj4Te/pIzp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKKLryAAoJEODzc/N7+QmaPTMQAJ50APIEP8eojKqwzU4WAUWz
cQpGatuE6WmyBgA8Om5N0376OUd7awjh4aVg4kC4FGxPsnxD47AC+Pl0RkxpphCy
V7tRkEVrHKFFyE8Al5PEhPD5IKJD+94oAlxIYzzehx9PyC1ZSRHh4JeJeyOPRhsN
cnNBGAp5KuerA9Lgd7ElF3KdkoVX+3S9PM/CFhlUNK6IPBT1bAzxVpSBrvCAH8Pz
X4mk43k8EVKug5aaMiWlEUplfSidezvBwW87mzP7VxxA3FhlSKt0yUaXAWoFes+X
oP/Z0nDwbfIuGYx5kTRFcL1H19ia2xWELNUh2BVkxnwTmKKBH7M+ScVI+jcl+x8n
Xi89D9xcFFp/RvIXifOpsAPN40s777+tt4NzH6UecpdBtZxR27kI4ypIwfohHFwY
XmRxde16U7EAHPpRRWh8aNvu3KhSShchR9+LhgAITt0jjkHHhUfN2ivY2MFrtMN8
UjwdfsMdoUXXQYMdommqMi8G5/Lwr+0+smry+X0xW0phQ7Znr7efxqa6bpjQKmpX
0ZLLvvwne6csNyj+8LwGLllu+6N/gTeh+YuKHwecJfz8FnTMAjBUhITgnJBtAhrX
bCYS8z97cHDAblAGDzVjGaZ7hbFYBTnJzEfdsF2FfiJMhpCST8ceQ6Ux3ull3eCN
JqKYZZLeN4HuSTVj+OxT
=opo4
-----END PGP SIGNATURE-----

--=-n0t9yNFQHqZj4Te/pIzp--

