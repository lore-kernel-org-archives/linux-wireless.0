Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:46666 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbXINSXv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Sep 2007 14:23:51 -0400
Subject: Re: iwlist and network-manager bug report
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: jt@hpl.hp.com, linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1189793380.2508.2.camel@xo-3E-67-34.localdomain>
References: <1189526874.6161.30.camel@johannes.berg>
	 <1189610572.5644.28.camel@xo-3E-67-34.localdomain>
	 <20070912170153.GA25785@bougret.hpl.hp.com>
	 <1189667496.6161.77.camel@johannes.berg>
	 <1189707493.1329.1.camel@johannes.berg>
	 <1189793380.2508.2.camel@xo-3E-67-34.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-WdwpgWmbLCsvOgAwbIQR"
Date: Fri, 14 Sep 2007 20:25:11 +0200
Message-Id: <1189794311.3974.49.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-WdwpgWmbLCsvOgAwbIQR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-09-14 at 14:09 -0400, Dan Williams wrote:

> I've been burning the midnight oil on it for the past few weeks, check
> NM and applet changelogs.  Still not quite there yet, there's some core
> work left to do getting NM to talk to the settings daemons (ie,
> nm-client or knetworkmanager) correctly, getting GUI bits for Connection
> editing in the applet, and making sure the relevant settings are
> honored.

Great, good to know. There are various quirks in 0.6.5, my brother tells
me for example that it's impossible to log on to an _open_ network at
the university where he currently is while it works fine with iwconfig.
Some other things too, my wpa network at home never works with nm and I
was never able to determine why...

johannes

--=-WdwpgWmbLCsvOgAwbIQR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG6tIH/ETPhpq3jKURAgBsAKCIfDHPaZgJ9Lyt125g2yWprIIhEwCghpPg
FnDzO/vE3B6nzoYejSaYibs=
=GdXf
-----END PGP SIGNATURE-----

--=-WdwpgWmbLCsvOgAwbIQR--

