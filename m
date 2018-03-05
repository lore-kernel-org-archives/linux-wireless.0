Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:43132 "EHLO v3-1039.vlinux.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932723AbeCEHmz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Mar 2018 02:42:55 -0500
From: Sven Eckelmann <sven@narfation.org>
To: Anilkumar Kolli <akolli@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Sathishkumar Muruganandam <murugana@codeaurora.org>
Subject: Re: [PATCH 2/2] ath10k: add debugfs support to configure fwtest parameters
Date: Mon, 05 Mar 2018 08:42:53 +0100
Message-ID: <1974303.3lPsqGCgIZ@bentobox> (sfid-20180305_084300_022191_ED55700A)
In-Reply-To: <1520233148-26050-3-git-send-email-akolli@codeaurora.org>
References: <1520233148-26050-1-git-send-email-akolli@codeaurora.org> <1520233148-26050-3-git-send-email-akolli@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2180520.GZCWctjGSx"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2180520.GZCWctjGSx
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

On Montag, 5. M=E4rz 2018 12:29:08 CET Anilkumar Kolli wrote:
> @@ -496,6 +497,8 @@ struct ath10k_debug {
>         u32 reg_addr;
>         u32 nf_cal_period;
>         void *cal_data;
> +       u32 fw_test_param_id;
> +       u32 fw_test_param_value;
>  };

Why is it necessary to have these two values in ath10k_debug? They seem to =
be=20
used only in the context of ath10k_write_fw_test().

Where can we find the documentation of the possible param_id and param_valu=
es?

Kind regards,
	Sven
--nextPart2180520.GZCWctjGSx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAlqc9P0ACgkQXYcKB8Em
e0ZJWRAAuw8DpbZQ5RRZL46kjbk5cL5Ej/+A0fOl6e5KG97YrbyHp40grRR0EmbW
Fj8wfLzeE4zUG4y+42hPArnXjIhHLF18VMwGMix/U7wfiQlHou/8kFGulqwovNXy
qhA5K/DYcHYuOegBXfYeSxGIQqSULo9H2bIIobWlYYHpQHdYzO5ndjfojeJ/apna
eLgZGlSzJ0fHh30qMr8pdPmsMg9+LAC8M3TKbBvRm9rMG5vyyP3lRqhXoCjR1NVH
NSbcaaLx//kChoJJxm7H4PN52NcbmEr+0TMGgOriM2YCf+sePejHFmFvsUmVcbw0
grYrv6XqNz7SY/quRZBQ9bfVcHjMZLhCkDQhCqt0Icn3xlQK90mIROTS1qAP2sPP
leqHiI9HmqqP/wA3/n5y1v299ndltE7Qb/ZEWOZmBPiYhCcJr9824Cy0jiWYucK0
gwYfKl1R7DVCajHs+yKWn64Sx3tWJv8DjO5yNVcaWDJ3hMHG7WT30WNsC1OFPBE1
ka6z7QdhK5DP7QUf/W/GQHjiFPW3bi4H76gkyOiVxfTKzULMrciU+jSDaPxy37Ys
rjbeCgTbplO4Ze9TxnR5botbXIFuw+o6mlHzqNix/BRnagSAU/J6NCBLlHbQy634
qq4jMhVc3Trk9P6tQs6EIPxYq0AA2f453paeCHDwnxEMYa40io4=
=ku7e
-----END PGP SIGNATURE-----

--nextPart2180520.GZCWctjGSx--
