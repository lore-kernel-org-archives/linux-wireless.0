Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40048 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbZALI7a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2009 03:59:30 -0500
Subject: Re: [RFC PATCH v1 2/2] mac80211: use ps-poll to request frames in
	power save mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Vivek Natarajan <vivek.natraj@gmail.com>
Cc: Kalle Valo <kalle.valo@iki.fi>, linux-wireless@vger.kernel.org
In-Reply-To: <8e92b4100901120057n4cea722fo1a78bcbc45341d00@mail.gmail.com> (sfid-20090112_095751_397885_6849C4EB)
References: <20090111070148.3849.10799.stgit@tikku>
	 <20090111070353.3849.5303.stgit@tikku>
	 <8e92b4100901120057n4cea722fo1a78bcbc45341d00@mail.gmail.com>
	 (sfid-20090112_095751_397885_6849C4EB)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-gbKgUISfP4GYdQGuBPwz"
Date: Mon, 12 Jan 2009 09:59:27 +0100
Message-Id: <1231750767.4809.7.camel@johannes> (sfid-20090112_095934_094755_B1B85F6E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gbKgUISfP4GYdQGuBPwz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-01-12 at 14:27 +0530, Vivek Natarajan wrote:
> On Sun, Jan 11, 2009 at 12:33 PM, Kalle Valo <kalle.valo@iki.fi> wrote:
> > When a directed tim bit is set, mac80211 currently disables power save
> > and sends a null frame to the AP. But if dynamic power save is
> > disabled, mac80211 will not enable power save again.
>=20
> The patch I had sent earlier, 'mac80211: Reset the power save timer
> from master_start_xmit' (44378a8e64b9399...) addresses this issue.
> This enables mac80211 to start the dynamic ps timer after sending a
> null data frame. Hence when the specified time lapses, power save is
> enabled again.

Except when dynamic PS is disabled.

johannes

--=-gbKgUISfP4GYdQGuBPwz
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJawZnAAoJEKVg1VMiehFYSp8P/ibjgD04IxheEI5aUN4FHLfT
1+k5Lssn3GUfpp85evseC7ucgZrH6f+IhwtZavUCYZk7BUgU+vVjMBjri7amrPHQ
zj7+AXg7jiDf78bRLN79eUxigJN1V+FySpfqXTtulVAs2neAVzKtqaIzBOWkcH6j
4sF7MJs4eo89A3vzb3Tnk9HCQgT51Dyd+P6U8OlXZR7Ks7jGn0lD8TquVvWcdiXr
VhSvJWQ8M6KOYOqsmy38ST17Uw+xG8kUUoki0h6vfTy6vmbJcdg6w5RCdd7O9oI/
XlNL+M6nbDMyisltsYZDF8xru9YC6Glc2bDp8MstyRLBDWfEspqg9/AqTTtIPI3d
9cqhjbrxeXt5pLck7q2IZ/n9jMzMMhssnvQLXNr66WDUFYsCMG2xnAkFgrgoeqPg
psmaa351oqGi8Cpbq6cLC3/B31AzuAYwN3voq7DXXHBWUaVhePouJw8339hvSfxA
MCkX/iZtHJQoDOthOJ0+RH3auJUMmU7f//OXaZeO9kFpmzSgWjscX6/XdquAJ0Mp
/RJtREgxUjI0uY0GFRqiuE/cuSKg6MhxD6V0nax5tI+MMV6jtLVCPMIApmzKpDZb
g3E7TQ5TVRmiGxvkSDs6KzS3iiBUSQSh/LiCojW1OTflwwQYy8xQ/eLxY8XCjQ1i
ukOZhiPUrQt9NBPx8fqj
=u8NA
-----END PGP SIGNATURE-----

--=-gbKgUISfP4GYdQGuBPwz--

