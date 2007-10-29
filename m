Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:46992 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715AbXJ2Qek (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Oct 2007 12:34:40 -0400
Subject: Re: [FYI] hostapd state with mac80211 on linux
From: Johannes Berg <johannes@sipsolutions.net>
To: Guillaume Chevillot <guillaume@chevillot.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	hostap <hostap@shmoo.com>, Chuck Tuffli <CTuffli@dspg.com>,
	Alexander Kotelnikov <sacha@myxomop.com>
In-Reply-To: <20071029163045.GA6000@chevillot.net>
References: <1193338400.4406.4.camel@johannes.berg>
	 <20071029125541.GA4304@chevillot.net>
	 <1193674172.5197.73.camel@johannes.berg>
	 <20071029163045.GA6000@chevillot.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-KjQJjyVHAuusl2Sa9a/c"
Date: Mon, 29 Oct 2007 17:35:57 +0100
Message-Id: <1193675757.5197.75.camel@johannes.berg> (sfid-20071029_163454_927231_BB6F494B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-KjQJjyVHAuusl2Sa9a/c
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable



> No I'm talking of kernel patches. The 008 patch for example does not
> fail to hunk automatically on git kernel source (tested on a friday, on
> the main git kernel tree). It applies on 2.6.21-rc1 (I think not tested)
> but not on downloaded from git kernel tree (the same probably with
> 2.6.21-rc1-git5)

Dunno. I make them apply as I update my trees. My patches dir always
contains the output of git-describe to tell you what tree I diffed
against.

> So your patches are OK but won't be for the rc2 I presume.

Trust me, I'll update them.

johannes

--=-KjQJjyVHAuusl2Sa9a/c
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARyYL7aVg1VMiehFYAQLlHg/+M9M/Wv7NE5E6a5gI5870BRX77KjIjrJR
+FSC+kQWWKOCKUp0hFrIuVa8CWKT/hnig3DS+gBGssq9cAblMf0B4HEK2qn29P8Z
ZAM13DSElZBvpq5XEyVPulGgHgpln4lYdKdcQyRD/IHdLQFm3AgS5D7b7wEA6YIO
4MhuR5Fm2KeQhXpH7yO+aZx0IBEG/MSnwTQ3/jyiZxC0ZVonXR4QKWdljDF4a0N7
XlMkxxRj5e/t89RmRBtnwlwKMQD54H22AtSEChGSmpUl/hyoBVPKcqWs8oZA9vBL
hNqqxJbUNrlfMEoDXDkbVpuguYjrAHnl7fXZvVFfwWBNmo+4ivk12sAh4Y3lnZwh
WNWkbLm6lN5wb1cFemU9VQwrzz8su7xkxY2KGUf6UHijjbl8BResHUMTCVsv2ETd
0TTz7Ni4YtgHYpxE/vulNaJ98IvHe0o+eRvLT6BofIXOv0A9c/HLLQxIyv/rwGmf
nJyDqcTOCspybiObGPY0f1mmyDvtJ4yYC1SbTGBSEgk8DDo2n2rHWdS/y4yln/tg
R9Z0dRebFaUQS1k2qzamzuVxO2h43R2Vji5bPx+EcJmS38B7LMXSlb8vUbf+fjrI
I+8gbIt7ksyI5ZcYSeRPGcdK7P7Uz7KcK9Hsnx2hwPf4GG2AXow22PH+rqwPwJes
SS0HoOc53zE=
=aggw
-----END PGP SIGNATURE-----

--=-KjQJjyVHAuusl2Sa9a/c--

