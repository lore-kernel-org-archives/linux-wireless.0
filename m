Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59882 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755762AbZDWIQx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Apr 2009 04:16:53 -0400
Subject: Re: [PATCH] mac80211: calculate maximum sleep interval
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: John Linville <linville@tuxdriver.com>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <874owfdctm.fsf@litku.valot.fi> (sfid-20090423_095534_138805_55F8E4DE)
References: <1240418677.30082.3.camel@johannes.local>
	 <874owfdctm.fsf@litku.valot.fi> (sfid-20090423_095534_138805_55F8E4DE)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-AAbRo/uupmrmRW/24Kae"
Date: Thu, 23 Apr 2009 10:16:14 +0200
Message-Id: <1240474574.30082.171.camel@johannes.local> (sfid-20090423_101721_740850_11ADF2B1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-AAbRo/uupmrmRW/24Kae
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-04-23 at 10:55 +0300, Kalle Valo wrote:

> > + * @max_sleep_interval: the maximum number of beacon intervals to slee=
p for
> > + *	before checking the beacon for a TIM bit (managed mode only); this
> > + *	value will be only achievable between DTIM frames, the hardware
> > + *	needs to check for the multicast traffic bit in DTIM beacons.
> > + *	This variable is valid only when the CONF_PS flag is set.
>=20
> I would prefer to call it max_sleep_period. Or maybe even wakeup period,
> because it's about waking up here.
>=20
> For me interval, for example beacon interval, means that the unit is TU.
> But this might be just me.

Good argument. I'll post a follow-up patch to rename it (to make it
easier).

johannes

--=-AAbRo/uupmrmRW/24Kae
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ8CPLAAoJEKVg1VMiehFYgQcP+wRaT0Mb1ZztjzqhjbZYaBU5
2247N+Z43qDlRlAGkg1okudh9Md4/Lc6MSpJQAd+JlWpRhvx1dL9cjrKsSRM3kk+
jnyXrX+1cwYeElQFR7wGXHYr82Wcp02Y4T1RDD8NDMhvlY1xsyK+s1Cw6Xl8dnhf
6D5K/LVuWhP2rWcZOpiRAqNLJ9nToD9FlaiV6au/qnVZ530DCRnZqVSuLvTBZadS
meY4T8rBib14EwIMTDIsqFCJZH6tAoIgPkOnrgxjDoolQMI8XAD8wxGvaIV31yzM
xhxZMlr+6g2YzZgIaDGz8zbeylRv3ugZUUaxaYODBsVW0Mm3mo4rSYNYE+TxjFMz
83MW6+rcR1vjWJYe3vIHOsC0X646iT5IFBuJDzvSziNGJfxT2RNNNW2JR7wVKcss
ZBVbbfFvHt8CQ4X7KpMzjD45l28OejBZ2HfXtnxkkNrgtkzyV8M7fCDgPtR+X2s2
mwXHHsI4AFOF2WwKBuyT7RSxXaV43Gy1MBfprOru7IZsFFctJH1nXU+afL+4GuJi
O0ouZvbweGPI2F+/6rQ3vSGx1btOcCp27vExkTKxXLi9Kl47iBH9RL3ZJE9jOiBK
Qv5GRIDJXEJO/XzsnAbBnB+0cN00HGQUFh74bo2Sx8ZbZW03qlowepNcJKHx8Boc
oAgH0ZefnG1zEyeOvzt+
=2uAB
-----END PGP SIGNATURE-----

--=-AAbRo/uupmrmRW/24Kae--

