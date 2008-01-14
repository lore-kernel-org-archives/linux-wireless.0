Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43372 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754672AbYANKfk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jan 2008 05:35:40 -0500
Subject: Re: [RFC PATCH 03/10] mac80211: A-MPDU Tx adding basic
	functionality
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <rindjon@googlemail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <c85cb4470801140126g3e32cfebjacfe4c7d3ef22032@mail.gmail.com> (sfid-20080114_092608_303300_4AB6CAEF)
References: <11999857423156-git-send-email-ron.rindjunsky@intel.com>
	 <11999857493027-git-send-email-ron.rindjunsky@intel.com>
	 <1200070308.3861.203.camel@johannes.berg>
	 <c85cb4470801130718x8069c4fi2eff95a21a11a2f3@mail.gmail.com>
	 <1200261102.5887.19.camel@johannes.berg>
	 <c85cb4470801140126g3e32cfebjacfe4c7d3ef22032@mail.gmail.com>
	 (sfid-20080114_092608_303300_4AB6CAEF)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-o1BU9E8IRoPcfU8ba7O8"
Date: Mon, 14 Jan 2008 11:35:12 +0100
Message-Id: <1200306912.5887.40.camel@johannes.berg> (sfid-20080114_103545_100425_D64E71F6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-o1BU9E8IRoPcfU8ba7O8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> to go into A-MPDU active state we need 3 conditions:
> - addBA request was sent (HT_ADDBA_REQUESTED_MSK)
> - addBA response arrived (HT_ADDBA_RECEIVED_MSK)
> - all legacy frames drained up to ssn (HT_ADDBA_DRV_READY_MSK)
>=20
> their combination gives us HT_AGG_STATE_OPERATIONAL. so when we go to
> HT_AGG_STATE_IDLE automatically we reset all the above.

Ah, I see, sorry. I was looking for a flag unsetting.

johannes

--=-o1BU9E8IRoPcfU8ba7O8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR4s636Vg1VMiehFYAQJJQhAAwyuSeKP2vBzzE6wzF8cZYMN69oHFRv2Q
UTx5RaPQKXwIoZmFNwwmo+rDD+4PFIjNXBun6qmzGOW/QW68XKOKz0n1J+d92kXj
RkKErwdu8ma7ziwXbLgALq4KaIhpENG9acX2iXauQj9CNzgNrpeaXfo8IPgdcMfa
AfKPAEuY2WOFPSvQFa1JVZaiTLfe/2GOCUjkxejzULTCTcpsF/uZkmvbFlTjBog0
DCYGa87L88/vo94wZM7kbjjI4TcloQ7DUKRlz3naDUfRoxfUatC/zhd1GdNMY/T4
fpWTbH5/rph/ctrEIZE5fKbamLt69BjjNxuQ9DV9pu+qdu22Rrbsm/nbufa1pMQD
IF77WnNK+DxLJ/8Z9gXlSd6PME33+kjuMcdsDlVSjNaqQdzE3mxk2sNEfITbSCtA
E4CKrc47elXksx6rU7uBvSa6tnOsA+pwvS/c8ruoFArqqgckN68SxkExpD/M30HE
lpKW4I9QIngGOpvNsjOCHhj4uX8nT+Esz3N/jpkMi39HT8uXcsVfGxyUI+ksQHT3
U5aRoc/efFl4HdcFZ355gpJ1toiyT0YNlrd6lc/8+4tmQmGUBIduZrAvrs7kZGLu
h49Py+cZwlRk5OWNvURRdy3w1Ky8Q280yucz34MJ1//zcKKGAZDVEPKYdfZ2HM5d
e5+dgvWnd5w=
=4Qeq
-----END PGP SIGNATURE-----

--=-o1BU9E8IRoPcfU8ba7O8--

