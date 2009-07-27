Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37435 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755408AbZG0W3y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 18:29:54 -0400
Subject: Re: [PATCH 04/14] iwlwifi: Thermal Throttling Management - part 2
From: Johannes Berg <johannes@sipsolutions.net>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
In-Reply-To: <1248459194-10239-5-git-send-email-reinette.chatre@intel.com>
References: <1248459194-10239-1-git-send-email-reinette.chatre@intel.com>
	 <1248459194-10239-5-git-send-email-reinette.chatre@intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-JfPvVusWdb/N82GQu96+"
Date: Tue, 28 Jul 2009 00:29:20 +0200
Message-Id: <1248733760.7015.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-JfPvVusWdb/N82GQu96+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-07-24 at 11:13 -0700, Reinette Chatre wrote:

>  /**
> + * struct iwl_tt_restriction - Thermal Throttling restriction table used
> + *		by advance thermal throttling management
> + *		based on the current thermal throttling state, determine
> + *		number of tx/rx streams; and the status of HT operation
> + * @tx_stream: number of tx stream allowed
> + * @is_ht: ht enable/disable
> + * @rx_stream: number of rx stream allowed
> + */

This kernel-doc, and some others, are really botched btw -- the bit
after 'struct foo - ' really needs to be a single line only, you can put
longer descriptions after the parameters.

johannes

--=-JfPvVusWdb/N82GQu96+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKbio7AAoJEODzc/N7+Qma4igQAMFNkPCfmAeIZT7nzM72zIaA
1I6WjyGsihPA8KhKz/dnojPQGAxOylSm6JsnbiEZV1mw5XJA8TW84ueKkwFAFNFu
LojyWW7+z/totNQWi9sKaiXVhGQz6FTVeGpeXZZKI9zZ1Rw8w6CSKDbWm35Qcl/O
zhFhltz000ya8232KuDcKouBzHVE3+67KyG0QmlkrbWqSgpk3swJxe2bXfDLaCjC
VJ1DJfgNBBIJkk1YSp1L2N1/eKh35fbcoKxCP/21IeJb2G3F3N/5fSJ85XHndhLX
qH3XtnzwjfwEWuTOmbRIjneb4CPFwbzglx4rQlebbKuWkMmPFe9IbFtvIC/9/feD
b9AnVCqWAFpp/zodgrb1n4xmVNeQlLMLUOA8yq1TP3Vn6Hkd1NKnIsn2+fyQ5TBP
3AyfcbCPRXkb0XrCzuLUI1jDNAdTlNK1B1u1kL8wfHajimnkj8UObGMDqQQv6YTZ
Gds343sg8wKCz3qS+JmR3a2Q8U+QkOqBfE15/8qJC692wIolkZxcdAQzu2tgsvAk
H347akXwBoKxW0IPAQR5F0sd1jbPzIHqJtN2uYzSaNZGEoyoU5odBEiwOYnOSCC4
kauIRzt5w5E5rjrat5JC8d7341xZoL4zOvIcyYQkdA4i8OF/DFS97/HtD+8t9L3y
x+8qx6rSXXtbtylKeX1s
=SoxU
-----END PGP SIGNATURE-----

--=-JfPvVusWdb/N82GQu96+--

