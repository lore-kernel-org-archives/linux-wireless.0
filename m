Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40421 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204AbZG3Trj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 15:47:39 -0400
Subject: Re: [PATCH] mac80211: use beacons for connection monitoring
From: Johannes Berg <johannes@sipsolutions.net>
To: reinette chatre <reinette.chatre@intel.com>
Cc: Ben Greear <greearb@candelatech.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1248975923.1216.1074.camel@rc-desk>
References: <1248903159-17024-1-git-send-email-reinette.chatre@intel.com>
	 <4A70C17B.6090309@candelatech.com>
	 <1248949853.29062.3.camel@johannes.local>
	 <1248975923.1216.1074.camel@rc-desk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-yIsFCxmXfjfGc2cP6Zhp"
Date: Thu, 30 Jul 2009 21:47:05 +0200
Message-Id: <1248983225.10971.5.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-yIsFCxmXfjfGc2cP6Zhp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-07-30 at 10:45 -0700, reinette chatre wrote:

> I captured the exchange when this problem occurs using a third system.
> The card does indeed try several times to send a probe request and they
> are making it out over the air. The AP never responds.=20
>=20
> Is there perhaps anything in this exchange that can help us understand
> what is going on?
>=20
> No.     Time        Source                Destination           Protocol =
Info
>  163883 401.891153  00:16:ea:XX:XX:XX     00:14:f2:XX:XX:XX     IEEE 802.=
11 Probe Request, SN=3D980, FN=3D0, Flags=3D........, SSID=3D"XXX"
>  163885 401.891482  00:14:f2:XX:XX:XX     00:16:ea:XX:XX:XX     IEEE 802.=
11 Probe Response, SN=3D3557, FN=3D0, Flags=3D........, BI=3D100, SSID=3D"X=
XX"

It's responding here,

>  165523 404.884405  00:16:ea:XX:XX:XX     00:14:f2:XX:XX:XX     IEEE 802.=
11 Probe Request, SN=3D981, FN=3D0, Flags=3D........, SSID=3D"XXX"
>  165525 404.885265  00:14:f2:XX:XX:XX     00:16:ea:XX:XX:XX     IEEE 802.=
11 Probe Response, SN=3D3827, FN=3D0, Flags=3D....R..., BI=3D100, SSID=3D"X=
XX"

and here,

>  166981 407.884161  00:16:ea:XX:XX:XX     00:14:f2:XX:XX:XX     IEEE 802.=
11 Probe Request, SN=3D982, FN=3D0, Flags=3D........, SSID=3D"XXX"
>  166983 407.884555  00:14:f2:XX:XX:XX     00:16:ea:XX:XX:XX     IEEE 802.=
11 Probe Response, SN=3D4034, FN=3D0, Flags=3D........, BI=3D100, SSID=3D"X=
XX"

and here,

>  168133 410.884167  00:16:ea:XX:XX:XX     00:14:f2:XX:XX:XX     IEEE 802.=
11 Probe Request, SN=3D983, FN=3D0, Flags=3D........, SSID=3D"XXX"
>  168134 410.884430  00:16:ea:XX:XX:XX     00:14:f2:XX:XX:XX     IEEE 802.=
11 Probe Request, SN=3D983, FN=3D0, Flags=3D....R..., SSID=3D"XXX"
>  168135 410.884643  00:16:ea:XX:XX:XX     00:14:f2:XX:XX:XX     IEEE 802.=
11 Probe Request, SN=3D983, FN=3D0, Flags=3D....R..., SSID=3D"XXX"
>  168136 410.884904  00:16:ea:XX:XX:XX     00:14:f2:XX:XX:XX     IEEE 802.=
11 Probe Request, SN=3D983, FN=3D0, Flags=3D....R..., SSID=3D"XXX"
>  168137 410.885073  00:16:ea:XX:XX:XX     00:14:f2:XX:XX:XX     IEEE 802.=
11 Probe Request, SN=3D983, FN=3D0, Flags=3D....R..., SSID=3D"XXX"
>  168138 410.885330  00:16:ea:XX:XX:XX     00:14:f2:XX:XX:XX     IEEE 802.=
11 Probe Request, SN=3D983, FN=3D0, Flags=3D....R..., SSID=3D"XXX"
>  168139 410.885580  00:16:ea:XX:XX:XX     00:14:f2:XX:XX:XX     IEEE 802.=
11 Probe Request, SN=3D983, FN=3D0, Flags=3D....R..., SSID=3D"XXX"
>  168140 410.885769  00:16:ea:XX:XX:XX     00:14:f2:XX:XX:XX     IEEE 802.=
11 Probe Request, SN=3D983, FN=3D0, Flags=3D....R..., SSID=3D"XXX"
>  168141 410.886618  00:16:ea:XX:XX:XX     00:14:f2:XX:XX:XX     IEEE 802.=
11 Probe Request, SN=3D983, FN=3D0, Flags=3D....R..., SSID=3D"XXX"
>  168142 410.887087  00:16:ea:XX:XX:XX     00:14:f2:XX:XX:XX     IEEE 802.=
11 Probe Request, SN=3D983, FN=3D0, Flags=3D....R..., SSID=3D"XXX"
>  168143 410.887308  00:16:ea:XX:XX:XX     00:14:f2:XX:XX:XX     IEEE 802.=
11 Probe Request, SN=3D983, FN=3D0, Flags=3D....R..., SSID=3D"XXX"
>  168144 410.887532  00:16:ea:XX:XX:XX     00:14:f2:XX:XX:XX     IEEE 802.=
11 Probe Request, SN=3D983, FN=3D0, Flags=3D....R..., SSID=3D"XXX"

but then it stops -- try to send that frame 12 times in quick
succession.

>  168191 411.084889  00:16:ea:XX:XX:XX     00:14:f2:XX:XX:XX     IEEE 802.=
11 Deauthentication, SN=3D984, FN=3D0, Flags=3D........

And then give up. Oddly, that frame is not retried?! I would expect that
to be retried too if the AP has gone south!?

johannes

--=-yIsFCxmXfjfGc2cP6Zhp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKcfixAAoJEODzc/N7+Qma7l0QAKotb2ZwuU5aXJD7Wm8rW57E
Pljpl7SKOz2JpHkZtnO9txpZWe+Jv6KzCVHHPewKYxVgzoPF6NsrX9KG0a0/C0zf
gcty/vCQmQGALFw0Kdbch0obn3LM3tpm0IFl9LAKP+0eWlUU6TsXP2R9QlYrDW6P
gJnS1BcalZBg4COW8YXJ+BEF74eyVzl7WAZprV83okFows67i6+TfzqafjUoJ/qp
6w38UYaNhYKyLBw16m4nXOBMxCxFfMwd7DdYcjqyPpr47e+v54jUa28YHT2Df+8D
QnpOc1d0/TzfbDVQA5DhGwqZLPFTw6YziAZH8+PiAra4T5HLNpbqUIBciWc5cy1A
1NmgJFzpMtLjp3nFzuzeWdo3Pdz83gHXncGhsX7WyQG3Jeh5zEE6FrQe6KYjZyei
hgnU//MI9sKSsO+rrQpyKjYz5hGh53NmY53SvrDXWH9rQp0fR9MCk6Mn3jtpBtNk
sq6bzTSunGgjL3rHHEmpvq1uzzQXeyTVrjGflzFKCrzTkvE0j2VXp45Dtj6U48Vf
/ZiCj4d4+ogm9lph2SKQSsck+iDCa6+ysoVhxYy1Bahf5NloHsWHIcCzgEUlCeCS
N2pcEAG1nn0QD3DdsJtbHizMSWm+ijmsdSDrQWDCBZtXtHMNQoyKRvOBd+d5PN8R
VU8+nP1wYcjES6KjTNyL
=EiDF
-----END PGP SIGNATURE-----

--=-yIsFCxmXfjfGc2cP6Zhp--

