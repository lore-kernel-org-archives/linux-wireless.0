Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38783 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158AbZAVKQK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 05:16:10 -0500
Subject: Re: [PATCH v2] mac80211: Add documentation bits for
	mac80211_rate_control_flags
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <18807.59500.605111.97993@gargle.gargle.HOWL>
References: <18807.59500.605111.97993@gargle.gargle.HOWL>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-3BCjsvRRn/G0eec03/fn"
Date: Thu, 22 Jan 2009 11:14:55 +0100
Message-Id: <1232619295.30174.0.camel@johannes.local> (sfid-20090122_111614_981440_F1DC16C5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-3BCjsvRRn/G0eec03/fn
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-01-22 at 09:00 +0530, Sujith wrote:
> Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>

Thanks.
Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
> v2:
> --
> Replace 'can' with 'should'.
>=20
>  include/net/mac80211.h |   20 ++++++++++++++++++++
>  1 files changed, 20 insertions(+), 0 deletions(-)
>=20
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 9a5869e..2e72a12 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -262,6 +262,26 @@ enum mac80211_tx_control_flags {
>  	IEEE80211_TX_CTL_RATE_CTRL_PROBE	=3D BIT(12),
>  };
> =20
> +/**
> + * enum mac80211_rate_control_flags - per-rate flags set by the
> + *	Rate Control algorithm.
> + *
> + * These flags are set by the Rate control algorithm for each rate durin=
g tx,
> + * in the @flags member of struct ieee80211_tx_rate.
> + *
> + * @IEEE80211_TX_RC_USE_RTS_CTS: Use RTS/CTS exchange for this rate.
> + * @IEEE80211_TX_RC_USE_CTS_PROTECT: CTS-to-self protection is required.
> + *	This is set if the current BSS requires ERP protection.
> + * @IEEE80211_TX_RC_USE_SHORT_PREAMBLE: Use short preamble.
> + * @IEEE80211_TX_RC_MCS: HT rate.
> + * @IEEE80211_TX_RC_GREEN_FIELD: Indicates whether this rate should be u=
sed in
> + *	Greenfield mode.
> + * @IEEE80211_TX_RC_40_MHZ_WIDTH: Indicates if the Channel Width should =
be 40 MHz.
> + * @IEEE80211_TX_RC_DUP_DATA: The frame should be transmitted on both of=
 the
> + *	adjacent 20 MHz channels, if the current channel type is
> + *	NL80211_CHAN_HT40MINUS or NL80211_CHAN_HT40PLUS.
> + * @IEEE80211_TX_RC_SHORT_GI: Short Guard interval should be used for th=
is rate.
> + */
>  enum mac80211_rate_control_flags {
>  	IEEE80211_TX_RC_USE_RTS_CTS		=3D BIT(0),
>  	IEEE80211_TX_RC_USE_CTS_PROTECT		=3D BIT(1),

--=-3BCjsvRRn/G0eec03/fn
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJeEcbAAoJEKVg1VMiehFYhOsQAKvYYnQGrFdh2Vtn6rS2PvNa
fZteJXUIP3J58ixl/bfKxDihBgsV097K0yPW3GTv3FIOUNpKPLROnTLeN1j4P3V2
CS10Kx35ek6IEhNW6Weh0Y0AHaxmdeviCuyHYrl9R6QPtp7VLzVkaLD4Ra68Vabl
CWuqUhD6DyFxryx0HNhA97lIfBqwlzINuAOPEmwTjtu5tTKp4R4cYHoKIgSOpMDK
JYuzZssbGmY+HD1o6QZH7KXWKZh1xkDTUN4qlhFVt5zZvi64ePypNb+2STR4x3i6
5N3fK13q598wgLY8WCsZj6kDlfTjtRCOpjkeCO2uJenPyRLPOHGRn5gaPTvkjI96
8IWL+qjgzJVDAuGZS0ngRNPXX8bcdBqvmDFZSwyETybxJyGLnL4Z+B8pXlqfoyvH
j852f4hJu2sRxFq5AM5v9aj9EfuQGzUyAnFKxwZBisshzxZeQT6U3ZpeTG8vTF/L
v8Bpod6Ms7wLxDuGzDQTKDSt+CkbKEzB8DV3GblVevDqkaxi6vU/O+ZbN7ujGXCv
TLveISp1gObi8kws0MFhieB9uqNXdYX1B0sJ1etPP8+WVK2PjIAn2cey1rFrrqyV
AucO4FMd8NGpBkYpTfkm4gbTCi+VR/F/KXX5HvIecirHe1arMseopzBLShCTTUGK
OOPhmF7+ACoCUsFrkGSS
=mmJh
-----END PGP SIGNATURE-----

--=-3BCjsvRRn/G0eec03/fn--

