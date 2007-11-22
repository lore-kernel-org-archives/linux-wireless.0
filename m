Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50123 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468AbXKVM4z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2007 07:56:55 -0500
Subject: Re: wpa_supplicant/key deletion with all-zeroes mac (was: security
	question)
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: mabbas <mabbas@linux.intel.com>, linux-wireless@vger.kernel.org,
	Dan Williams <dcbw@redhat.com>, linville@tuxdriver.com
In-Reply-To: <20071122043722.GC8672@jm.kir.nu>
References: <4743E5DF.9040603@linux.intel.com>
	 <1195658254.12000.23.camel@johannes.berg> <20071122043722.GC8672@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-eKpdxuquPuSEMiy+t+CN"
Date: Thu, 22 Nov 2007 13:55:26 +0100
Message-Id: <1195736126.6323.86.camel@johannes.berg> (sfid-20071122_125702_986457_D7575CCC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-eKpdxuquPuSEMiy+t+CN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > > wpa_supplicant will=20
> > > receives this event then call mac80211 to remove any old security key=
,=20
> > > the problem it will pass 00:00:00:00:00:00 as station address.=20
>=20
> This sounds broken. wpa_supplicant should remove the key for the
> previous BSSID.


> > Interesting. I'd think this is a wpa_supplicant bug, Jouni, how is the
> > security wext stuff supposed to work here?
>=20
> Agreed, this sounds like a bug in wpa_supplicant. Unicast keys should be
> removed with their correct address. I think this used to work, but maybe
> some of the changes in BSSID processing in disassociation cases caused
> the old BSSID to be forgotten.

Can you look into it then please?

Thanks,
johannes

--=-eKpdxuquPuSEMiy+t+CN
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0V8PKVg1VMiehFYAQLetw//RRc8xup3St0qAibQAQJ5EshXJ5UJAnoq
jYU8WntQ6V2HshL0nzcjsPTWDbIMMyYyQkDOqT9MFSN/AX/jT1UzV22rwsHmEwE0
Zsk4HO9QoVyeuGpfPoqnSKpQj/45TqhWCdEvpbHLirYBPNPD3/+iv88Hd+zmo2YE
v5Yp3Xi2u/gjiiPw3zMJ391ESKgWddd/ILE3rCIvQOQFEmpreLva4QEfwyFN4/+e
mThRT+rS9vAe2XbbIrlY//5Y9vn5r1wSsWEjSPP3lV7hsSGWDths89m7ntb6xQ9e
cnlYhfZn7IrgNMq4n7XZdjeeH17CO0RXzEd5PcfyEkyUZaO9lnl215zKSfCJejxk
NRNHmBvjiSgW/6ZeNGaN3mELkAL0K5MaWDnCYQLIQh+SasNvS2aRJst2nsfRyVd2
8A+nAZVvakEZsZOIBPzkSQNHFidtcbln1jcfD1a1rvR8qKkF14zDbhx4VNdKtAUv
Mgk/scWCdsL8VW2LqwQ4NsLlbTWL+mXeu8xBhN9FcViK+u+gNXIG9SvnyO+EV+qJ
TfHXhuxgsS5oBTdg4E3L632puR2pUgU9KHAL5LHlGNucrV4SJMCpz20yE6scIFnW
2fqVU/CIbwoK+r5n3M/mj5vZXCLThcy2Pe9WQMYYlQ6Xg0kw48qHr4podNZVKe/s
VTNa/5Wy/IQ=
=zvjR
-----END PGP SIGNATURE-----

--=-eKpdxuquPuSEMiy+t+CN--

