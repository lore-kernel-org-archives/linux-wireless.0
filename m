Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:34159 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbXI1LtA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Sep 2007 07:49:00 -0400
Subject: Re: iwlwifi scan question
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240709280441s3eceac51x74a8bb8e422808f2@mail.gmail.com>
References: <1190815228.4204.9.camel@johannes.berg>
	 <1ba2fa240709280441s3eceac51x74a8bb8e422808f2@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-PQ5WF1xQZVfRdid5I59B"
Date: Fri, 28 Sep 2007 13:50:14 +0200
Message-Id: <1190980214.13581.2.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-PQ5WF1xQZVfRdid5I59B
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-09-28 at 13:41 +0200, Tomas Winkler wrote:
> On 9/26/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> > When iwlwifi scans in firmware, which MAC address does it use? What if
> > you've added multiple virtual interfaces as you said you could support?
> >
> Scanning is STA feature so only one MAC address is used in that case.
> namely iwl_rxon_cmd.node_addr

Whichever address that will be, ok :)

Though, actually, scanning is not just a STA feature is it? APs will
sometimes want to do a quick background scan too, I think.

> Do you know any use case to support STA with multiple MAC addresses?

Not really, unless you can implement a TSF adoption per local MAC
address. I guess you could turn off powersave and do the backoff
algorithm a bit out of spec and get by with just one timer too.

johannes

--=-PQ5WF1xQZVfRdid5I59B
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG/Op2/ETPhpq3jKURArj+AJ9o7m53lwNx2aYbcX4N0RcCQfUKqgCfQb8O
Xm2RY1NUblIkBIQ47WQGZ4U=
=GWmz
-----END PGP SIGNATURE-----

--=-PQ5WF1xQZVfRdid5I59B--

