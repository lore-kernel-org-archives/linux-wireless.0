Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56241 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbYHGRMK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2008 13:12:10 -0400
Subject: Re: mac80211/cfg80211: Add BSS configuration options for AP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni.malinen@atheros.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20080807170701.GA21060@jm.kir.nu>
References: <20080807170701.GA21060@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-rUjrvkW5QePz0d++IcoE"
Date: Thu, 07 Aug 2008 19:11:33 +0200
Message-Id: <1218129093.3630.15.camel@johannes.berg> (sfid-20080807_191214_726524_C8387ED1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-rUjrvkW5QePz0d++IcoE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-08-07 at 20:07 +0300, Jouni Malinen wrote:
> This change adds a new cfg80211 command, NL80211_CMD_SET_BSS, to allow
> AP mode BSS parameters to be changed from user space (e.g., hostapd).
> The drivers using mac80211 are expected to be modified with separate
> changes to use the new BSS info parameter for short slot time in the
> bss_info_changed() handler.
>=20
> Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> +	/*
> +	 * TODO: IEEE80211_CONF_SHORT_SLOT_TIME will be removed once drivers
> +	 * have been converted to use bss_info_changed() for slot time
> +	 * configuration
> +	 */

I guess we'll also need to make the mlme code actually use it, as it
stands it looks like we never enable short slot. Oh well, later.

johannes

--=-rUjrvkW5QePz0d++IcoE
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJImyzCAAoJEKVg1VMiehFYBVkP/j3PL0X/v/V3Xkg9EIFJVSsE
P39uxdamFmd7zuj0L3JJCv1ckEWGbcV6Q7Bh8XWSVQ6mnMAVRtrNEvZT5SZ8CxYw
rZfAIo0eqsPET0LOu7EdMRxw5/JDXFbUIHQkpBcbMY2KZOYwZ5lVXW1motUbYN1z
ur256NEiiV8UBw7qKrKlv5yxWA7/NnNgYm/Zx4WdR0AialRUWR/Lm8Bqhx44vQc3
3fdkrge+qH6BV3B3heLDYQPbz9QFuXxMXj99xpDqt+7b2WykX4jpKgDYm1PmiY+q
GewsAU/B4mBa3oS1ab9BwL38Nx/hIhdt+xcsZn1359ptGc1AGu7zM6IKMOf2AGf+
ofovUDwbW0msA8b5bLF2gqi6otjSqhTJbk5lLdl4YTmwy8ZmHNZ7pCEifPj09M/s
RpM2ai3GcuHMAzW+JXPrPKAMVnyuhA8DtsD1KcZBenEUbbtgvbIb+k9t36RK0inZ
GeAEjdJb3ZFdz2gbVgIhkOA57eloqJ1rcglJvm6TfakiV+E2KYfIcTIUxPbd8TXc
a05NpgvSVdpQGMj26To9KhN25wULmY39oG1hY2uizJvmjefjAzLCdJFeB+olRqbL
G2Yz+PXwRt6HkTd0aUYXsjV+HrgICKgGFc9AORaWTs1CuemxKpYYpXLHwtRdEW3M
GkT11JfIUdzmUEoD+1qW
=4h+Z
-----END PGP SIGNATURE-----

--=-rUjrvkW5QePz0d++IcoE--

