Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60890 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755260AbZHNVMN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 17:12:13 -0400
Subject: Re: [PATCH v4 31/34] wireless: update mac80211 kconfig entry
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Larry.Finger@lwfinger.net, Jouni Malinen <j@w1.fi>
In-Reply-To: <1250281559-13041-32-git-send-email-lrodriguez@atheros.com>
References: <1250281559-13041-1-git-send-email-lrodriguez@atheros.com>
	 <1250281559-13041-32-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-+lKreM4dZgLf7Mz4+8IT"
Date: Fri, 14 Aug 2009 23:12:10 +0200
Message-Id: <1250284330.4411.5.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+lKreM4dZgLf7Mz4+8IT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> -	  This option enables the hardware independent IEEE 802.11
> -	  networking stack.
> +	  This option enables support for a framework used by IEEE-802.11
> +	  SoftMAC devices. SoftMAC devices allow for a finer control of the
> +	  hardware, allowing for 802.11 frame management to be done in software
> +	  for them, for both parsing and generation of 802.11 wireless frames.
> +	  Most 802.11 devices today tend to be of this type.


> +	  mac8011 implements the cfg80211 callbacks for SoftMAC devices,

mac80211

> +	  mac80211 then depends on cfg80211 for both registration to the networ=
king
> +	  subsystem and for configuration. Configuration is handled by cfg80211=
 both
> +	  through nl80211 and wireless extensions.
> +
> +	  If you have new userspace utitlities which support nl80211 you do not

utilities

> +	  need wireless-extensions to support a mac80211 device.

And in any case I really don't see a need to explain the wireless
configuration stuff in a Kconfig entry.


IMHO the text should be short and to the point, your texts give too much
background information that doesn't help anyone except people who
already know about wireless stuff to make a choice.


> +	  For more information refer the the wireless wiki entry on mac80211:
> +
> +	  http://wireless.kernel.org/en/developers/Documentation/mac80211
> +
> +	  When built as a module mac80211 will be built as mac80211.ko, if not =
sure
> +	  you should build this as a module.

We do not include the '.ko' in the module name, just say "The module
will be named mac80211" or so.

johannes

--=-+lKreM4dZgLf7Mz4+8IT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKhdMnAAoJEODzc/N7+Qma714QAJpHTqaId9xXuIXb+Zjvys6U
7aZkzLUtspohokd1r3/rMQhgXx3cjqLVQpuDW9VckIomPFN+6vC/XTO7DyN37j4o
6fMHMlHbaC6lIhSKL7lfoLMTtSpzYdn88tUWhY9k6f1WcfBCEX7Y7a40k3NnpBvE
KV4rMN2HpoiV9w3cy62Q5SyMmaSCZxn4t236jSEvlH7nIs62y5mMelngfqWEbwLU
k0C46SvNB67elj2gMjhYxa5zvQvFwgG6Y0BlOu5iWIzRXUl0kG2t5iU3dPfYARtX
5gFjEg5rfk0C2BUzZ37dyPWzf9z+qPyha07ONVDaTu2Be1CNoVvJ58Ccgxo4ulMi
QfDYjmFediqZNA/xUsz8tkpCCK1rDxhOnGwAh34CBheMOCMWby8e7rSHb8xkhfSJ
PiRleY5CHEOryxj0JTkXU1bU0X07gk+ZNuAWUHx4OauPlzHmcj/yAJcnfe0RDCYi
PN2631F8u60qeyIoMcY3voxubGJ252SgKzPNhhTfmicZ/NyhVLVf0cgLi+KCuRiq
UxMJlIJydn/JftgNNYn0YtSLDk0kZ77lHj7X4wAAxOPqeIDf/oPZLzekY5Bt/XEG
Ay0AgTLUTJ+dsHLBTiPKJ161vpH/W/lTBHZGZquDOS+nbDLO1PMpQhlL6HvrPFEn
SC2jxJsnQJ2MsnrZVkPz
=fDqY
-----END PGP SIGNATURE-----

--=-+lKreM4dZgLf7Mz4+8IT--

