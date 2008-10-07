Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44978 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423AbYJGSB5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2008 14:01:57 -0400
Subject: Re: [PATCH 2/4] mac80211: add multi-rate retry support
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Derek Smithies <derek@indranet.co.nz>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <48EBA2BE.9070705@openwrt.org>
References: <48E8E48E.5090300@openwrt.org> <48E8E528.7060501@openwrt.org>
	 <48E8E588.30001@openwrt.org> <1223329786.3778.38.camel@johannes.berg>
	 <48EB98A6.4050406@openwrt.org> <1223400436.7328.54.camel@johannes.berg>
	 <48EBA2BE.9070705@openwrt.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-j+hPL59sBe2uadHBl3WC"
Date: Tue, 07 Oct 2008 20:01:56 +0200
Message-Id: <1223402516.7328.65.camel@johannes.berg> (sfid-20081007_200206_850530_3146C671)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-j+hPL59sBe2uadHBl3WC
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-10-07 at 19:56 +0200, Felix Fietkau wrote:

> >> The IEEE80211_TX_CTL_RATE_CTRL_PROBE flag is used to tell the tx_statu=
s
> >> function that there is a sampling rate in the second MRR stage, so tha=
t
> >> it can update the sampling counter accordingly, in case the sampling r=
ate
> >> actually got used.
> > So if I read that correctly you're saying it's not part of the driver
> > API but just something to be preserved from tx to tx-status. Can you
> > document that in the header file too please?
> Will send a new patch updating the docs soon. Should that hint apply to
> only this particular flag or the whole flags struct member?

Well that's just for this flag, the TX_CTL_NO_ACK for example surely is
something drivers need to check :)

Thanks,
johannes

--=-j+hPL59sBe2uadHBl3WC
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI66QPAAoJEKVg1VMiehFYTusQAI23DzSWfESN6Dn4QseAbQr6
T60csnIDsIY0ihE61/PrDzonYMPB8cirFwXudp01O3/5+4BJGXuGJl62G3EcsMDF
bu6/OC8ua5Z8393a+8kptqyMZgeuZvrMo54FzVlbVWmDZPPa/+DKUAeG9tbGQwBL
LnmGOhMJDUWf2vrW8WZrY9+A+fThPYYgE6JMEhPjmbDcAoBTjsBn57pwV7xdVxc7
0Qo9fmmRx0MSi5/pAgrNDaFkbRDc1HK4iImla+LGURiQIrJ1a+OZfZbHE8t5WwQB
NIX7LAWdVCyxI2V/omPiXpDdS9U6HM80jwZYw8MLWqy1Twnno7qee+G0tL7xW1mL
KPVAo+DcIzLnQGdTFgT/dXg+br0EyG2DBaNDp+9M1tpTNQ9kkPa2anSZadx8hQ8q
jx3jq+hseG4d6kNeG0sd6os1SwxbbEUjD88KI3r4ShCy7RYSCBTJuVEgVp3h7tGJ
bLHGcIhCsB9UXGrXe+K/luRq1e2EaIRyOoqA95tOt1uKSeOKn4Ta9F12ASUU8Ee7
qwFWS39CUHAGPZn0pT/LC18o25HbWlaJHZ3XT2cMduk/DrnnQnONl/UoTwFr6mbY
UVzhJpO+Y2IOlmZPoFTNEYK5SKYBKrRid2XOrQzaRrD+HfPd61cWtl97Dh9273Lh
M2K0xgAhbCP/T1R6fOrR
=0Fo2
-----END PGP SIGNATURE-----

--=-j+hPL59sBe2uadHBl3WC--

