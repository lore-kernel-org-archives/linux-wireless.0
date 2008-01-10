Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:53860 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546AbYAJMPW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jan 2008 07:15:22 -0500
Subject: Re: [PATCH 1/6] ath5k: code cosmetics
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <bruno@thinktube.com>
Cc: ath5k-devel@lists.ath5k.org, mcgrof@gmail.com, jirislaby@gmail.com,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
In-Reply-To: <1199870169-10476-2-git-send-email-bruno@thinktube.com> (sfid-20080109_091625_314448_BB43B4DA)
References: <1199870169-10476-1-git-send-email-bruno@thinktube.com>
	 <1199870169-10476-2-git-send-email-bruno@thinktube.com>
	 (sfid-20080109_091625_314448_BB43B4DA)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-OyUyviziFfGyjmmNzP/D"
Date: Thu, 10 Jan 2008 01:54:51 +0100
Message-Id: <1199926491.3861.47.camel@johannes.berg> (sfid-20080110_121527_059921_5EED451D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-OyUyviziFfGyjmmNzP/D
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> + * @AR5K_TX_QUEUE_UAPSD: Unscheduled Automatic Power Save Delivery queue

Out of curiosity, do you know how that works? Is that queue simply a way
to avoid the MAC rejecting a packet because the target is in PS?

johannes

--=-OyUyviziFfGyjmmNzP/D
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR4Vs2qVg1VMiehFYAQJqww//aKXVFfzUd1miPmpQqWP2Zc35KWD7NNJ2
y8fE2jQAREx49A1hVhLlomoHG+lZwIJAjIsti3bkbLkTHMsTmkRRJFTBbjpz/Ytp
zCgaAjvVS0VDP2V65w6eTvcZFxgpdKgZ8WnmMUy2tR92DzpUjYxhUb6tSZSlBPOT
Z4HwzF+VX7adtqDziLarzTp0rV4y2Wln+ih0sRzxjtsI7rWxMw0TtzoqGRDFW87U
Nv31HxvkRg6Z9sXJn9FKVbZ8rzkHx7uGZDpwsLnwsriOvwzSeLdu7a4PNJUT+/iK
PgZzWa6Y/7cH9nA3QH0aUTHgWzGiThR0z7n77v9Uu1WHfoKHpEtv+NA3VLsc2HKN
hZ56Ar+bfKOUteQG7qHGuLV6Pl/AORR/MIHgWt4mA5uJ00k3ha6kt++1WdeIdfz1
CPQmBUboKHQlZjhmhPDnpwa+/TMOy59NuVR6iZQk2uobtJSgBaOU+HakOAJCue8A
EAvkb/w8D0E3DigNI8OSGnNLcgxIoHEOnl9u6HD4Sw2dKUGXcEvg6dTA11oacYKc
LhYkk3RcZqWqQyVt+ZMlS2ynPL692bxEZxcYr1wHq0D8Bh+nXDQdyop25NclXBH0
pUeLyVrz/JZrih55nJeUyU4HJvzvuTlUCqVRwcUfvM3GRp/po5SLL6KodyPL3xAL
z9NJdSfq84Y=
=1mnu
-----END PGP SIGNATURE-----

--=-OyUyviziFfGyjmmNzP/D--

