Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54387 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbYJXJsD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2008 05:48:03 -0400
Subject: Re: [PATCH 07/10] iwlwifi: refactor tx byte count table usage
From: Johannes Berg <johannes@sipsolutions.net>
To: Reinette Chatre <reinette.chatre@linux.intel.com>
Cc: linville@tuxdriver.com,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <1224830938-1577-8-git-send-email-reinette.chatre@linux.intel.com>
References: <>
	 <1224830938-1577-1-git-send-email-reinette.chatre@linux.intel.com>
	 <1224830938-1577-2-git-send-email-reinette.chatre@linux.intel.com>
	 <1224830938-1577-3-git-send-email-reinette.chatre@linux.intel.com>
	 <1224830938-1577-4-git-send-email-reinette.chatre@linux.intel.com>
	 <1224830938-1577-5-git-send-email-reinette.chatre@linux.intel.com>
	 <1224830938-1577-6-git-send-email-reinette.chatre@linux.intel.com>
	 <1224830938-1577-7-git-send-email-reinette.chatre@linux.intel.com>
	 <1224830938-1577-8-git-send-email-reinette.chatre@linux.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-riuFNNLkFblCYi9ywKAt"
Date: Fri, 24 Oct 2008 10:27:53 +0200
Message-Id: <1224836873.6002.75.camel@johannes.berg> (sfid-20081024_114808_810258_F1C03238)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-riuFNNLkFblCYi9ywKAt
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-10-23 at 23:48 -0700, Reinette Chatre wrote:
> From: Tomas Winkler <tomas.winkler@intel.com>
>=20
> This patch drops unreadable usage of IWL_SET/GET_BITS16 in byte count
> tables handling
> This patch also cleans a bit the byte count table code and adds
> WARN_ON traps on invalid values
>=20
> This patch is pure cleanup, no functional changes.

Great, thanks!

johannes

--=-riuFNNLkFblCYi9ywKAt
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJAYcFAAoJEKVg1VMiehFYzM4P/Aod/VP51G+QkaCgDrR8y6Kt
akCh3rXqQVWGXTvwxxh7cqn30t3+KKWeaZ6Q4zOtXxKiecJ6lJQhNL/zM5Jmdk3Q
fbUvOe7J1Yn678IfBKuqz59kbu/GyUsc71m1kx25TD/XnE003a98CHTTPP7a3n58
9zxQJguPGBc5jFECBrecnL0Yf0HHmiUK4RbPabc9joiiqAygLR+DfHxgn1B8WaJ+
CVAG5cjSwQrp0dbNMFPnhjpFybLQTovqPgbbQWib71QVQP5NCstUW/9stqjCKbsC
itLzRTF7CL3JNNde5ttALfEEXvc7nmgU9rguxt7pWwxnJ7ccdM52rKXBfrGqm6do
VkKjN67Z87bMldINQsQXfouCkJmJPge4kIE/ODYCNx0rTAM4gosRbyg0Iuo0kw7y
S6JRz/HvryH+xK0HEdr/glki7Hl7zBcoB8/ORDtdyEIdQIz3q839dNs6cvUu17Yq
bzdt962iaSj/5a6TJgXUajZb+S2oF2iJjuXOo77ZncZfVN9M3uFUjt4/kc+lz28U
Q2oHRCeZqjatCd9yYzezRvs5+xzRDoiThu0DWFm2Vj62IGgJh6HZNGEem1ZD9hpc
0+WQO8i1xKLjN/ROC/aZVFdRLq4EPX9CQ2LGU52DUUO6Ui7sqOoIg/47AZZtFuv2
40d7n9GBaTR9H3XJUq4W
=xOUm
-----END PGP SIGNATURE-----

--=-riuFNNLkFblCYi9ywKAt--

