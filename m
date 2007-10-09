Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51102 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755806AbXJIRkL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Oct 2007 13:40:11 -0400
Subject: Re: [Rt2400-devel] Mode selection in mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: rt2400-devel@lists.sourceforge.net,
	Adam Baker <linux@baker-net.org.uk>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200710091954.03727.IvDoorn@gmail.com> (sfid-20071009_183751_027972_F8EC7689)
References: <200710052319.10600.linux@baker-net.org.uk>
	 <200710091932.45235.IvDoorn@gmail.com>
	 <1191950973.4013.45.camel@johannes.berg>
	 <200710091954.03727.IvDoorn@gmail.com>
	 (sfid-20071009_183751_027972_F8EC7689)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-POK4cDNa5ybj4K5uKFKE"
Date: Tue, 09 Oct 2007 19:40:52 +0200
Message-Id: <1191951652.4013.48.camel@johannes.berg> (sfid-20071009_184036_217304_45A6D1CA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-POK4cDNa5ybj4K5uKFKE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-10-09 at 19:54 +0200, Ivo van Doorn wrote:

> > Well, it's not too strange that it has two places since there's the SIF=
S
> > too which is needed for ACK/CTS timing, these packets aren't sent from
> > the host so you can't have those timings in a per-packet descriptor.
>=20
> You mean things like ACK_TIMEOUT, those are all seperate registers in the=
 Ralink hardware.

No, I'm not talking about the ack timeout, I'm thinking of the short
interframe space (SIFS) which you wait after receiving a packet before
sending the ACK.

> ButI think I should be more clearer on this, rt2500pci and rt2500usb are
> basically the same chipset but only the bus type is different.
> What is notable is that _only_ rt2500usb has this IFS register, none of t=
he
> other Ralink chipsets (including rt2500pci) have it.

That is indeed strange.

> True, but in G mode you are compatible with B. The legacy driver doesn't
> switch back to B mode when the AP is in B mode. This means that it will
> be using the G timing values.

That sounds wrong.

johannes

--=-POK4cDNa5ybj4K5uKFKE
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARwu9IqVg1VMiehFYAQLwxw/7BfQPftsCcJ9d5OS27hmO6YTEKEAUwdbb
E3/2dllowOFePWoK/T0sNxyw67kW3UGc8UIDdwAFZzj53ao4YEPrHzU3EdHWHbB/
zikNLPiC/Vg+JsgqAZBysQ91ZN9E4DNqk0MuYuHDfsmGj33hcxpBV7ktEq4jvgIs
m5T4bx9ESYpv8iH8kXWtNMznJ8xqCUBCfLKPv1vEF6p4fg0ndZk4AgmcJtuYEfCE
B2cv6v91awc5zInFUxV7k2Cx1Q7d3jG+N/myPeV6D8ku705/PLNs3JGc72oHTF+5
3FSNXm9+0L5ls88+tunitpj0M7I0nWEZSKcBwXf5t8MW+S/FAtB7HvxxBttrx936
iRZdTtvfrubTqxuhKOvlEPBJ9uIUmvvFPnsnaS8cAvK6I27hhNvbUHMlhbBngDQU
KUGemBFCjcLpb5jdAWgwtpF0Y1FSM1r2eOtQuDH3Zd0E4W3pra7/x4SyUe+wjtQn
ehFP87D9ch6yHdlhLUxJJ7+1stwnrFescQJMaxBvVpNxx80Du11KwVkhOd11Ui8X
zd/qO56S8Ftfwk2ZaWW52cezNS5q5ahhDaXr3rqBh9RDTmgg+KeHX2ytPwu5CmWB
aTjk87TkDM2lH00Tn6KeM+NFVb/O21xRw0s0gYnEnCj4d6mzwVvBe47ic+1akY81
k84wI6jsrT8=
=NFlH
-----END PGP SIGNATURE-----

--=-POK4cDNa5ybj4K5uKFKE--

