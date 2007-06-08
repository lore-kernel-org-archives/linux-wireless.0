Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58074 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755475AbXFHJDt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2007 05:03:49 -0400
Subject: Re: [PATCH] mac80211: rc80211_lowest, a dumb rate control algorithm
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Benc <jbenc@suse.cz>
Cc: Larry Finger <larry.finger@lwfinger.net>,
	linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <20070608105900.4c401e14@griffin.suse.cz>
References: <4661bc4f.88st9yXgySnzwVtb%Larry.Finger@lwfinger.net>
	 <20070607221939.444e9d74@griffin.suse.cz>
	 <20070607222113.0f752bf8@griffin.suse.cz>
	 <20070607222210.1a445cd7@griffin.suse.cz> <4668A7E5.3070500@lwfinger.net>
	 <20070608105900.4c401e14@griffin.suse.cz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-hLzKInkk7r1zNzegxdCq"
Date: Fri, 08 Jun 2007 11:04:04 +0200
Message-Id: <1181293444.6533.22.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-hLzKInkk7r1zNzegxdCq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-06-08 at 10:59 +0200, Jiri Benc wrote:

> I'd still like to apply the patch allowing to change rate control
> algorithm, but I'd like to hear Johannes' comments first - I suspect he
> won't like what I did with his macros :-)

Oh, I don't care much about those macros, just wanted to save myself
some typing ;)

johannes

--=-hLzKInkk7r1zNzegxdCq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGaRuE/ETPhpq3jKURArcoAJ9iPfgsk806c9btcNYqbBZIPkDR6gCgglls
MRwR9QAEVi9DRBMwE7X/zTQ=
=mvXt
-----END PGP SIGNATURE-----

--=-hLzKInkk7r1zNzegxdCq--

