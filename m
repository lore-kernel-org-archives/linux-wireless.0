Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59828 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbYJTIpk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2008 04:45:40 -0400
Subject: Re: [RFC] mac80211: Re-enable aggregation
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Sujith <Sujith.Manoharan@atheros.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, Luis.Rodriguez@atheros.com,
	tomasw@gmail.com
In-Reply-To: <43e72e890810200135o1581c904i456a35298f8a56a9@mail.gmail.com> (sfid-20081020_103626_380313_66145BB4)
References: <18684.16351.638713.791015@gargle.gargle.HOWL>
	 <1224491480.18024.32.camel@johannes.berg>
	 <43e72e890810200135o1581c904i456a35298f8a56a9@mail.gmail.com>
	 (sfid-20081020_103626_380313_66145BB4)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-U2XoZ+L6WBkWw6QjmXGA"
Date: Mon, 20 Oct 2008 10:45:35 +0200
Message-Id: <1224492335.18024.34.camel@johannes.berg> (sfid-20081020_104544_006322_8B79C2FF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-U2XoZ+L6WBkWw6QjmXGA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-20 at 01:35 -0700, Luis R. Rodriguez wrote:

> >> + *   @is_part_ampdu: set to indicate that the wireless core should sh=
ould
> >> + *           treat this frame as part of an AMPDU
> >
> > I thought we said we could keep the flag instead of moving to the skb
> > here?
>=20
> That was just because the changes required to add this was too much
> for 2.6.27 but since we don't care about this fix in 2.6.27 we can do
> whatever is needed to fix this properly.

Right, but adding random stuff into skb isn't really "properly" imho.
And we don't really need this afaict.

johannes

--=-U2XoZ+L6WBkWw6QjmXGA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI/EUrAAoJEKVg1VMiehFY70oQAIlQaM77/KU5kIjHLwqJjTGz
oOBg+2m4QogrzxKemzQ4ZUZdg5CGPrajZBXInoffP6sq/SfZjvDrh79OwkpupJZE
pNhD3EOZtGtxwqJE0wDFfy7I9ZO2Em8DztiVf+JZgTuJxop6EZRjYA2Ggjka+gY7
WYy0f1JfSGEPqCnor7PlhyD4g1afXrzVH91v+hPS2FWv0f++bT0FTrMhYGXcsflx
sQjbzaQMMbgrfIeGHSutpCTaSx13oNwSlYohMzbUKS1Y9neBQ9vnUDvfA7lufOMb
pfGwgogHWossdR5N8Y0DupkxTlBIejf9DhoJ3tSufVmVQsFn0j1OXThdGBxw1c1f
HjfsEcOfWk4MmfzNDVhzO3a8LjxFzVMKeYfSpy88Vurm+NaVUXLSZoUmEUOR21Wx
RdiTzGkKfxk4I2VWgo+ylXBEYpwfXtfZEcVezlEH3CwEpQDmTSY4vFyUnc5OUjXJ
nN7hJHrCHuKN8eN6p8KJNo4U+u4/3Io0Oc4ZPPFFVTtpObBK7Pb9oLnIRY69tnGJ
qmcecnHVjifv7MxJZ3uKoy5jJ0dT1UrgPZxgpiAIO8hS7tiqXHzYifvHjEWd2Blo
KuWnqexeCCExXguVtZXDcH5XasmxBbKy3TJb7lWcNH4WuzteK/BIyvZ1NrqKOSkM
5DAVO0ZBqeG1BkJGdAsR
=WtYJ
-----END PGP SIGNATURE-----

--=-U2XoZ+L6WBkWw6QjmXGA--

