Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51521 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756410AbXHTLWy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Aug 2007 07:22:54 -0400
Subject: Re: question for developers (help plzz!!)
From: Johannes Berg <johannes@sipsolutions.net>
To: maali Al Janoob <mms82@hotmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <BAY111-F3965149B92B333B4E37A4DB6D80@phx.gbl>
References: <BAY111-F3965149B92B333B4E37A4DB6D80@phx.gbl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+foIfBwM0N+NhCYTGuiV"
Date: Mon, 20 Aug 2007 12:44:00 +0200
Message-Id: <1187606640.6090.83.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+foIfBwM0N+NhCYTGuiV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-08-17 at 15:49 +0400, maali Al Janoob wrote:
> Thank you so much for the reply. My advisor is not very convinced with th=
is=20
> answer, and says that there must be somewhere a linux driver that has an=20
> open source firmware for protocol development purposes, or a driver that=20
> implements everything in software.

Clearly, your adviser has no clue how things work wrt. Linux and 802.11.
There's gnuradio, but I don't think they already have a working 802.11
implementation. That your adviser thinks that there could be a driver
that implements retry logic in software is a pretty good indication for
something else that I'll refrain from mentioning though.... Retry logic
is timing sensitive on the order of a microsecond and Linux isn't a
real-time operating system. That should tell you at least something.

> So, firstly, can I please ask you for=20
> some references affirming your answer that I can include in my research?=20

No. Feel free to do the research yourself, I've only answered based on
my own (limited) knowledge.

> and=20
> secondly, are you aware of any attempt in the open source firmware=20
> direction?

We've partially reverse engineered the Broadcom firmware and others have
partially reverse engineered the prism54 firmware, neither have working
replacement firmware. In fact, for Broadcom firmware I haven't been able
to completely identify the retry logic in the existing code from a quick
look.

> Assuming that there is no way I can access the backoff algorithm in any o=
f=20
> the commercial wireless cards,=20

I assure you, this is the case unless you want to invest significant
reverse engineering effort or somehow manage to get vendor support. But
as far as I know, for example Broadcom's NDA doesn't include firmware
because there's no reason for a card vendor to have access to it.

> what would be the solution to my case then? I=20
> need to modify the backoff algorithm for my masters thesis, and if this i=
s=20
> not possible with any card, what should I do?!

Why would you be asking me this question? Remember it's your masters
thesis, not mine, you're the one supposed to solve the problems arising.
I'm told (by my thesis advisers, mind you) one of the points of doing a
Master's is showing that one is able to solve the arising problems.

johannes

--=-+foIfBwM0N+NhCYTGuiV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGyXBw/ETPhpq3jKURAjtCAKCfGYanslFkwXK4n37PsTGVv06pIgCfdOE5
SJRPH1NJDS7wLFCUBqEvG9s=
=3NWT
-----END PGP SIGNATURE-----

--=-+foIfBwM0N+NhCYTGuiV--

