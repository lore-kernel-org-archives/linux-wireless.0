Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:34985 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932930AbXLNMRc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Dec 2007 07:17:32 -0500
Subject: Re: tx_status reporting of RTS/CTS frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Mattias Nissler <mattias.nissler@gmx.de>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	rt2400-devel <rt2400-devel@lists.sourceforge.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Stefano Brivio <stefano.brivio@polimi.it>
In-Reply-To: <20071214052046.GF5698@jm.kir.nu>
References: <1197412922.7030.11.camel@localhost>
	 <1197479702.6558.125.camel@johannes.berg> <20071214052046.GF5698@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9gC+RktfzbMnXO8aGC25"
Date: Fri, 14 Dec 2007 13:10:23 +0100
Message-Id: <1197634223.16079.30.camel@johannes.berg> (sfid-20071214_121751_646568_BB9927A5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9gC+RktfzbMnXO8aGC25
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> I'm not sure I understood the comment about monitor interface correctly.
> If the driver is configured in monitor mode (or whatever you would call
> a mode where it receives all frames), I do expect to see ACK and RTS/CTS
> frames in mac80211 (and in the monitor interface in user space for that
> matter). I hope that this won't be changed.

We're talking about a virtual monitor interface that is in use while
we're also operating on another virtual interface.

> It sounds perfectly reasonable to not indicate these control frame
> subtypes when in normal (non-monitor) mode since they are most likely
> processed in hardware/microcode/firmware. However, if they provide
> additional information (say, signal strength), it could be useful to
> send them to mac80211 anyway to provide more information for TX rate
> control.

Again, we're only talking about frames we *sent*. There's a flag whether
to pass up control frames or not though which can be set in monitor
mode.

johannes

--=-9gC+RktfzbMnXO8aGC25
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2JyrqVg1VMiehFYAQLy/Q//awrOUlsV6wa3ZbHZ4tahN89HE//SeXiX
nrS1kZZJDYPqSqvmYX9yG2bDVBRsGIcObfUge/7KBcV0NPPsHxXJeTe45sgPfN6j
Dheu31MJn92x6Uz6XoL4yKs+ukHzibb0RpI71RTvoZteA3zFbcYmpJ2WOkccdtjN
c4cUH4CKxW6WGV+kAFlcx9Q9l2fiuBFguQsEwwpW4RoOONqgYJ2dliZQSibscfOb
Wx11iesLeSRyyYqPI+Bqaxgo/YRCRsFsx1n8RxP+sq0Xyabs1so7bIxlixtK04yU
Q9QirHnJvl0Bsn4ZRxXHiaVrLOtogW+lJcA5J6Y5z70dJJT8ox9NMjonQKdqTVTU
sUEKw0uFYx3RH/UQuyQviYQXcid2RWu9H63IzdKbpu6+0+FPhiDIxhSjhmIBW6I5
TwB5sey6IDk0YY8Nh4LZ5DBBsrTU90zb9omzcuSB6/gMcAZbyQ8ZqUlboD8qebvT
utjgrzDHf+fwjLBm0Yop7367IZwwASYsK9Fo5zqorEzdcbdC/pBoGSwXHVXGbh90
YwP54FijJ3i+gGEqeGUsgjYHy180XwAsFgCykJ22u4ZeOxauj5wAnzWSU7dcAwNb
KYtfDc4x2dHLMhoa7/Wak5MmLm4rWllKoAX1h1ap2Sj+wHd/ecnDqa6/OeaqZ/3j
F8yv5+3BtCY=
=FwUy
-----END PGP SIGNATURE-----

--=-9gC+RktfzbMnXO8aGC25--

