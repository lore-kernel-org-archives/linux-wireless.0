Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50667 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbZJFPAV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2009 11:00:21 -0400
Subject: Re: [PATCH 08/13] iwlwifi: device tracing
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <20091006144801.GA3827@dhcp-lab-161.englab.brq.redhat.com>
References: <1254516247-4085-1-git-send-email-reinette.chatre@intel.com>
	 <1254516247-4085-9-git-send-email-reinette.chatre@intel.com>
	 <20091006144801.GA3827@dhcp-lab-161.englab.brq.redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-MHDW1oB7nbRxUxwLAJis"
Date: Tue, 06 Oct 2009 16:59:03 +0200
Message-Id: <1254841143.22426.25.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-MHDW1oB7nbRxUxwLAJis
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-10-06 at 16:48 +0200, Stanislaw Gruszka wrote:

> > The text format isn't all that useful, but the binary
> > format can also be obtained easily via debugfs and
> > then analysed on the fly or offline with debugging
> > tools.
>=20
> What particular tool is most useful here (Yes, I didn't read
> Documentation/trace yet) ?

None really yet. Maybe trace-cmd.

> Shouldn't we also remove or at least rewrite IWL_DEBUG_{IO,TX,RX}
> to simplify things and remove double functionality ?=20

Maybe. But right now people are probably still using the printk
debugging.
=20
> > +EXPORT_TRACEPOINT_SYMBOL(iwlwifi_dev_ioread32);
> > +EXPORT_TRACEPOINT_SYMBOL(iwlwifi_dev_iowrite32);
> > +EXPORT_TRACEPOINT_SYMBOL(iwlwifi_dev_rx);
>=20
> Missed EXPORT_TRACEPOINT_SYMBOL(iwlwif_dev_tx) ?

No.

> Beside, shouldn't we have two trace point - one when sending data to devi=
ce
> second when getting ACK in rx queue ?=20

Could be useful at some point, I guess. Besides, tracepoints can be
added at will.

johannes

--=-MHDW1oB7nbRxUxwLAJis
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKy1szAAoJEODzc/N7+Qmat2cP/37i58xzU8hkZCTC9nTB7ZDB
I56owWkSmSe5/az7w2l2aS7RLP5sDL2PpWGnsH4RacId25iXem+Xwvucgyyweafq
Q4w4udQWbjAX2do4FeCYk06niqL51O7oI9KiY0+41v+NuASSLFSnRt2Z4mM2P6Vm
Y4tsgLJiCi/d7024x2bg/l14r+SsPyvjTD23NJckWAL2HyhEyoEE5JgapBWL0Hat
ocJA8dhZCPRwSE+bEhvJKo+EL6i52Qy7c06TTlShFTHDdCz2J+/OQOLA2Vki+DNW
QxqVZiltlRyqij1U9BwDJcO0TMThg2Vk1hm2v8cGCqTijVc1t/XEXOMEJeQx4aR6
lahS9EUew6kg30C/w2tsjdzUpgZnmMMU7yg9vLYRhnPO/jcDvPNon8pMh0cTG3oY
TeO6xFqVkjmYKSbp9tNzfaRHE2eYmSQiteskzZ1AXhkiQQ6i94evZgQ4mFqS1m3Y
7ZhoXEXKBj/HjW7Zb5N311Twb5HC+fTx/I7KCCX7hWE7A5qxZqLZ0ULr+JqgMCwe
7FEFjEPn8aQoKDqgdXVI5GA/iNB30gsmIgUJVVfYQXOD2UN0bnYApI7t51fz7xW0
4C5/AWGub3G9d71K42Pgoi5F1hftTQAs649VROz0sOcTtvMuOqTRRVovVsDCypvN
Cv58vfOVnG29UUZBcF9C
=uef7
-----END PGP SIGNATURE-----

--=-MHDW1oB7nbRxUxwLAJis--

