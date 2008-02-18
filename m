Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59817 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757625AbYBRLQH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2008 06:16:07 -0500
Subject: Re: [PATCH] mac80211: enable IBSS merging
From: Johannes Berg <johannes@sipsolutions.net>
To: bruno randolf <bruno@thinktube.com>
Cc: ath5k-devel@lists.ath5k.org, mcgrof@gmail.com, jirislaby@gmail.com,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, flamingice@sourmilk.net, jbenc@suse.cz
In-Reply-To: <200802181042.44428.bruno@thinktube.com>
References: <1203088151.8931.197.camel@johannes.berg>
	 <20080216022918.18775.59888.stgit@one>
	 <1203239503.12783.22.camel@johannes.berg>
	 <200802181042.44428.bruno@thinktube.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-3RAVMVMgBpxSt1i0xxnS"
Date: Mon, 18 Feb 2008 12:15:54 +0100
Message-Id: <1203333354.12783.33.camel@johannes.berg> (sfid-20080218_111612_705937_6623C4CD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-3RAVMVMgBpxSt1i0xxnS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > which I think refers to the last hunk of your patch. However, hardware
> > also has such filters, so I think we also should set the
> > FIF_BCN_PRBRESP_PROMISC filter flag when IBSS is enabled, we don't want
> > to force drivers to do this implicitly when IBSS interfaces are added.
>=20
> hmm, i don't know about that and i don't seem to need that for ath5k, so =
can=20
> we do that in a follow up patch, please?

Yeah sure, we can do that.

johannes

--=-3RAVMVMgBpxSt1i0xxnS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR7lo6aVg1VMiehFYAQIDJA/8CPNEexOEXRUWHwTavnNc0o50lnKgN4Gl
hvsxPBmKA9yfyhGhLRcHKXW+6GyKPr5i0TmxBeL2zgEx6CpH3P+xqmO7l5Q70+p+
xSH1/P3k6tcePF3NkX4G9GF/8y6rd2tmXNEtoCM9URhR79EZ8s5bxDaH1f3tkpBT
RNSynlEnampG4peYN0Ij4XfgVL9NLEhNVNFkhLqZkqa+xywId/BujMNHGU9yGrrM
GIhrS5tA6BEamwmetO42xUv5uhSBLSlTsbiomHXzjLv3TTCautSYEiFMxtSJA2bh
mJhP9q9ujFrV8nYpcRRE4RYG4sWC5TsTceQTbxpL/c1v3Obr9h63zOpsI/CTquxD
uC98/O5BA96sVjQA2hDlFeVhQ/JhInNCL2m/Ni1N02WFV+FC7hstOT8M1E1NGNkZ
rTI6H/wvFw972W9IqEuz1wwF6lUNXzq/nhn/5n7a4DQHgEvak93h690mPPqetvrC
Ap2KyrlaakzK3SSu5vbDYIKHGGlXiPH82DxYpOgZwaxdIPSSOwpQmmD+WvMigIzX
5R5cbBr92G1OO0noTgROJnE+KGBKc5j7dwqQ0MVo/1wAjWlH4uLLZBzgcRc2Yr7U
Ds6JCnnTqZtxgF+US2+ZoeRJULdwvKBRPkxBznKnOnsHkeyEBPYqXEAafmcBSDrv
IGdehL386qo=
=QXPp
-----END PGP SIGNATURE-----

--=-3RAVMVMgBpxSt1i0xxnS--

