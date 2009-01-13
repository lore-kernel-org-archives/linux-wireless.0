Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54599 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103AbZAMWra (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 17:47:30 -0500
Subject: Re: [PATCH 07/12] cfg80211: allow driver read access to
	cfg80211_regdomain
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1231876675-20518-8-git-send-email-lrodriguez@atheros.com>
References: <1231876675-20518-1-git-send-email-lrodriguez@atheros.com>
	 <1231876675-20518-2-git-send-email-lrodriguez@atheros.com>
	 <1231876675-20518-3-git-send-email-lrodriguez@atheros.com>
	 <1231876675-20518-4-git-send-email-lrodriguez@atheros.com>
	 <1231876675-20518-5-git-send-email-lrodriguez@atheros.com>
	 <1231876675-20518-6-git-send-email-lrodriguez@atheros.com>
	 <1231876675-20518-7-git-send-email-lrodriguez@atheros.com>
	 <1231876675-20518-8-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-rxgo2p6bXh8cTQXsOTFS"
Date: Tue, 13 Jan 2009 23:46:59 +0100
Message-Id: <1231886819.3728.2.camel@johannes> (sfid-20090113_234746_305134_2B36DB68)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-rxgo2p6bXh8cTQXsOTFS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-01-13 at 11:57 -0800, Luis R. Rodriguez wrote:
> A driver's reg_notfier() may want to inspect the currently set
> regulatory domain.

> +const struct ieee80211_regdomain *cfg80211_regdomain;
> +EXPORT_SYMBOL(cfg80211_regdomain);

Can't we just pass it to the notifier instead of exporting it?

johannes

--=-rxgo2p6bXh8cTQXsOTFS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJbRnhAAoJEKVg1VMiehFY0+wP/0FlfgDWoJ50qDbhLOSTxPXr
MB8n0dHJTO9nK4JTDjXLjOdUos/4qKTaYBW3jE7wsMy9ZGtgNVzocczs7+xykbnQ
u1xxpsnL1kH/A9Y4t2Tb5JQe0rJ1JRaeczuceRo2m5WJz9qrX7Rz5Ef4Mr9mj+zs
U9eyO85TteSj3MzoaLK5nZch+z3ksk/iuTxhky7z61Eo8G97uLLjgrIT/aoo7KXT
hD1hl55Aiyqg+S4+WblPTWDNfv72WFX2l+gfVL9Z9rkfZIPUh/qamYaexnvxTk0x
/mO8gnEMSkDrhIY/1wACj1GfwpECbveoJ/kI6f/Ct4f85sWELF6u7WM+O45JxiBy
wJQAmqjMZd79c3gQhsjhJT5P5r7wJRNr2AY7xe7xdEhng5pQOAGIzdpcZML+kQQq
ytwhW8VLQMEmHkNYlQbWBcRL6SAKPKFin/bhi2dgsyMk+VodyiGcAJMUILRQSGHI
y8ypBPQcGXbNEZ4+32o6DVHPlxmDf44koPtvbVObJtg1hXDvpgEWW7um/8v6kFCv
gtfm7zB5pg9UIEw8ZYb5PIDBtxUvfrNpHXLVBEuNZevLzHJsXsQ0wl5wpOc7kfSE
7lG/VK8pVxpRuxG5VM5c/o4s5l+iMhENIa65uVsd4IfG7+vspXU4EvTXRc+mVZ7/
A0+d4uqt7PtODTxSQ17r
=pmJ3
-----END PGP SIGNATURE-----

--=-rxgo2p6bXh8cTQXsOTFS--

