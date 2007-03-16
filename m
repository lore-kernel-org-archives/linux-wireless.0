Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40050 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965712AbXCPRGG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2007 13:06:06 -0400
Subject: Re: cfg/nl80211 primitives
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Benc <jbenc@suse.cz>
Cc: Dan Williams <dcbw@redhat.com>,
	Jouni Malinen <jkm@devicescape.com>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20070316163925.4a2d209e@griffin.suse.cz>
References: <1173219649.3503.50.camel@johannes.berg>
	 <20070308004940.GC31388@devicescape.com>
	 <1173380977.3248.55.camel@johannes.berg>
	 <1173382599.3020.34.camel@localhost.localdomain>
	 <1173382607.3248.65.camel@johannes.berg>
	 <20070316163925.4a2d209e@griffin.suse.cz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-hxBEIYzdmnpWjTt1v4x9"
Date: Fri, 16 Mar 2007 18:05:42 +0100
Message-Id: <1174064742.3355.4.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-hxBEIYzdmnpWjTt1v4x9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-03-16 at 16:39 +0100, Jiri Benc wrote:

> I think I was one of people who differentiated "config" and "action"
> calls. The problem with wext is that we don't know when association
> should take place. (When setting a parameter? Which one?)=20

Yeah, I agree.

> We need to
> have a well defined place at which association occurs. I don't care how
> this is achieved as long as it's fulfilled. One solution is to have a
> separate (that doesn't mean it cannot be bundled with other commands)
> "associate" request. There are surely other solutions.

Well what I'm thinking now is that we should have an "associate" request
and all the stuff that previously was "config" requests is just data
items appended to that associate request.

johannes

--=-hxBEIYzdmnpWjTt1v4x9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF+s5m/ETPhpq3jKURAo3kAJ9Z8cDxw3QpwFhl7OnhRzEBZAYFuACcCYeY
PnhokEQO3zBSFuXGQB6GAog=
=SLOZ
-----END PGP SIGNATURE-----

--=-hxBEIYzdmnpWjTt1v4x9--

