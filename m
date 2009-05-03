Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57805 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754941AbZECSHo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 May 2009 14:07:44 -0400
Subject: Re: [BUG] scans can still hang with -EBUSY on iwl3945
From: Johannes Berg <johannes@sipsolutions.net>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: reinette chatre <reinette.chatre@intel.com>,
	iwlwifi maling list <ipw3945-devel@lists.sourceforge.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1241227946.5192.3.camel@maxim-laptop>
References: <1241179203.8086.3.camel@maxim-laptop>
	 <1241193513.10498.97.camel@rc-desk> <1241208792.7082.47.camel@maxim-laptop>
	 <1241227946.5192.3.camel@maxim-laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-/YDY9sX7BIEUNia43T9f"
Date: Sun, 03 May 2009 20:07:40 +0200
Message-Id: <1241374060.13562.37.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/YDY9sX7BIEUNia43T9f
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-05-02 at 04:32 +0300, Maxim Levitsky wrote:

> > * iwlwifi.git - very close to current head, yesterday HEAD
> > * disable_hw_scan=3D1 - this bug is present regardless of this setting,
> > yet this rules out firmware interactions during rfkill.

Are you absolutely sure this also happens with disable_hw_scan=3D1? That
seems rather strange. Can you please also put a printk into
net/wireless/scan.c:cfg80211_scan_done, and provide separate logs w/ and
w/o disable_hw_scan=3D1.

johannes

--=-/YDY9sX7BIEUNia43T9f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ/d1pAAoJEKVg1VMiehFYruIQAKZ6GfVPCSYnNBLJYsnRzF6y
DjEfhjnLo6XxnS3TiMbopE41u8TxcAJ9GJxsPVI/RQWSccvW16dTPOKRA2nufyB0
SkH/J8GWmHd7kqa43CSP/ctChOwBymfv9lHpCGoscfsYE3mJeR+dWDu+wbxPThwP
dFyNbJb4UP6dgRkO69LNHi1Zygrt+XY9P4gX/05/ywRti+lArM4+x2bIUruD/g+R
j01uA5geaYTm6ses2kqWIf7K+ZAc4DGCvm8K7Lbph50xr6GbmF4RNJUO2h45SPjC
1Cgm2FF63wh9JMWbyESiKwiW58r/QCFl4Beq89Bd4aYmzhDP644GIkUXvuzydTc3
iV4g9fhV3FhlQuqL4LTwXiDbTbJYQa5WLAcMAMzdsSKryslbbfruhRP9gHJZwkfJ
UfT6I2I39IBezN2MTy7r9bh+jl58xo7MVWgdYZMVhZw0vkiNAd2rHz1YOtegm3ZZ
bQYH1/sIDWt2KIbR+EZSKx0AzWetAFljA8F5sgfqPf6sVpQkeYiExRVK1JgvN++I
FshBIsuYZdTh72Jrf6+4oj2rgqtUvEiGPsdFbZw749xer9BC3SRH9teMUGPCjl1f
R+mjbl2Sis49DEiGbCj81SQ0t8vLvEaBh0yJyhKsE1YZYOmkN/6H0hLHIQYAdIlw
OF7s+erQtK7/R8hathaN
=Vufx
-----END PGP SIGNATURE-----

--=-/YDY9sX7BIEUNia43T9f--

