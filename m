Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35642 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756862AbYHEUYk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2008 16:24:40 -0400
Subject: Re: hostap: handling device renames better
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1217967821.29886.4.camel@localhost.localdomain> (sfid-20080805_222207_764541_7BCED377)
References: <1217967821.29886.4.camel@localhost.localdomain>
	 (sfid-20080805_222207_764541_7BCED377)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-EeUCBLAQ300kMua05gJP"
Date: Tue, 05 Aug 2008 22:23:44 +0200
Message-Id: <1217967824.3603.62.camel@johannes.berg> (sfid-20080805_222443_243724_DF62ABB3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-EeUCBLAQ300kMua05gJP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-08-05 at 16:23 -0400, Dan Williams wrote:

> How are drivers made aware that their device's name has changed so they
> could potentially update things they stick in /proc or wherever?  hostap
> and airo come to mind as current users of /proc.

You can register a netdevice notifier and follow the renames. mac80211
does this for the debugfs dir.

johannes

--=-EeUCBLAQ300kMua05gJP
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJImLbMAAoJEKVg1VMiehFYZEIQAJe08dODTjyYdvmsch6r4DVH
AhmL1BQPSL8OIfUeSEAgz1yYWRwiWi3XCYkVo5PMxbBegmUlJmV24Ea0igup47x9
vBfiqfPLgd2YnSx3gwrHMn138U3fF2nyplwGc/+Swy5ZX3cIUT138NzYYx5anDKe
aFQitS2iOr3EgMvWNzg3UPYfnRPOEtX4AzS6lm7WkaaVkSBscYg4csf5FMW4j9AJ
ufQpwDlA1zJTLLrDNooa6xvWjWYj/1Bc7F2dcSYKELnPCd6NwKZq81vKAjX+IX/t
yAKEBnxQ0nni80i+S/SCtA5oCW6PvGvhAqYonC66hLI1LfB9Nx6hDNUWRWtXlhMd
0Oij2oxZoIKyMFvmTzCNYU4Uz+KQP6SXNnBeXCAoF6TUX3x9Lbk4E4UjYNd5bpFY
laR9QA8sEszoOJPvQ1BtRQYEzfmv70C0sT0o93UHm8buB+zUa13KLfAWzGxI9P3g
v26aucw58oP6wfIaMNqm0hvMpRXATPqPvwmZQ1LhsRC5p3Uoi8qeXvf4opXnsLPi
iUIcPGq0mgqlpUeRqFke2hR6FI6Jw26mhQ1nC89SoP/K4cEHlyE2yZvvF+apQM2W
7iOrydMnycG3PoCLTTQkX8cOu4dHQeh03acQyaknTZtDSz7Pgevh2bFGUA1mEzvT
ahkZuHRuYgyXtm9EMfyo
=KkL7
-----END PGP SIGNATURE-----

--=-EeUCBLAQ300kMua05gJP--

