Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47984 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757252AbZKRPwH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2009 10:52:07 -0500
Subject: Re: [PATCH 1/2] rfkill: Add missing description for RFKILL_TYPE_GPS
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1258559281-20935-1-git-send-email-marcel@holtmann.org>
References: <1258559281-20935-1-git-send-email-marcel@holtmann.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-LIF6qZmi4xiiCIwhv/o8"
Date: Wed, 18 Nov 2009 16:51:42 +0100
Message-ID: <1258559502.30511.24.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-LIF6qZmi4xiiCIwhv/o8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Both look good, thanks for short-circuiting the repost cycle :)

Acked-by: Johannes Berg <johannes@sipsolutions.net>

Not that I fully understand the need for either GPS or FM rfkill, but
hey, whatever.

johannes

On Wed, 2009-11-18 at 16:48 +0100, Marcel Holtmann wrote:
> Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
> ---
>  include/linux/rfkill.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>=20
> diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
> index 3392c59..a75e9e5 100644
> --- a/include/linux/rfkill.h
> +++ b/include/linux/rfkill.h
> @@ -35,6 +35,7 @@
>   * @RFKILL_TYPE_UWB: switch is on a ultra wideband device.
>   * @RFKILL_TYPE_WIMAX: switch is on a WiMAX device.
>   * @RFKILL_TYPE_WWAN: switch is on a wireless WAN device.
> + * @RFKILL_TYPE_GPS: switch is on a GPS device.
>   * @NUM_RFKILL_TYPES: number of defined rfkill types
>   */
>  enum rfkill_type {


--=-LIF6qZmi4xiiCIwhv/o8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLBBgLAAoJEODzc/N7+QmapxQP/jB9jpRTRWyLO/DFar9ZSKZw
y7dkefvBu/hCArlfvvCkrm4yO45J1NdytpO/rhOaSiWuzmh2rZ5M59m0kToGASAe
iSQXw4RAWlYmwQ33nmNwU1lZSiHyIUzR+n/59A4R+9BsgQuQYM0xpeJJpVoFT4bd
IlpKiLH86erj1Z0T2D9J2Y9sbwcUYCNlu80KasYkiLJsGIou35vhPptj0+HFVSsz
1xRn6naHFit5L5viy31vNYGmhbcPZo6SpvaaD1U8RXis4vT22tUSJgxRY8dMd7VM
v1ahQSyoLIyBa96Bg1rix9pVvpfOsAcrhzR4B9JWiWhQWxkkM6iTf27r/tSyF8Md
sldxvPkexLzKksLlqCVUFISfh46X2EUyEO1OFKk46BiohoVq5KEY2YoMY6To6Wkj
tCRPfvKTX9BfFJteetSHFRyvoYgdXsQbE3unQyzPCgW7+TZLqehBeY0OE2YaTvok
I2MMOg7LsgbxEgSxTrORZumqtuU4XEH9MoNZYJspfFL6ziR8VppHcQ3THKGeIYGO
4M0032zRdA+XisAC1cE7sYxTgxC4Qlc/fo0RtV0aMEAMkFcSY/a3V0Gns1w1BrSX
yfeBPrhwtpzW98miBIF0bJFR0Ymi7CNhAZ/AZsu6NAoUsj3Slg45Te6OzPK3YrBN
cn44STQ3vP2oU86azm2+
=7uu+
-----END PGP SIGNATURE-----

--=-LIF6qZmi4xiiCIwhv/o8--

