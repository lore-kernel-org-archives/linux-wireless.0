Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49831 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147AbYGOINx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2008 04:13:53 -0400
Subject: Re: [PATCH 2/2] mac80211: make listen_interval be configurable by
	low level driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Kalle Valo <kalle.valo@nokia.com>, linville@tuxdriver.com,
	yi.zhu@intel.com, linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240807141434k5260e6b9q6468b450fccba3e7@mail.gmail.com> (sfid-20080714_233427_356097_BD08134E)
References: <1216038684-29725-1-git-send-email-tomas.winkler@intel.com>
	 <1216038684-29725-2-git-send-email-tomas.winkler@intel.com>
	 <1216039127.11189.15.camel@johannes.berg>
	 <1ba2fa240807140546w4f08e32l59ed88dfa1b86403@mail.gmail.com>
	 <87fxqcoaue.fsf@nokia.com>
	 <1ba2fa240807141434k5260e6b9q6468b450fccba3e7@mail.gmail.com>
	 (sfid-20080714_233427_356097_BD08134E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-pQvPT5C63ITSr7Cmfb/3"
Date: Tue, 15 Jul 2008 10:13:43 +0200
Message-Id: <1216109624.23746.23.camel@johannes.berg> (sfid-20080715_101357_696934_EC480975)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-pQvPT5C63ITSr7Cmfb/3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> This is only required for sending correct value of listen interval to
> AP in association. Anything else is handled in
> the driver or firmware anyway.

The question, however, is _why_ the driver needs to tell mac80211.
What's wrong with mac80211 just deciding on the value? How are you
deciding on the value in iwlwifi?

> This patch should go in and we can reconsider it when other HW driver
> will implement PS so we can see the bigger picture.

That we can still if the driver doesn't get to decide about the value.

johannes

--=-pQvPT5C63ITSr7Cmfb/3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIfFw0AAoJEKVg1VMiehFYzUoQAKicXy7bA22mE8S8NLa0d8KN
MndP3AYrM5BOVdCY7zUzFt4bGayFcZ8h5kFajDTshB4hu6VK12MvKNz5BtQyNYNi
79OdYE/DLcnu3RT8zPFPxTCLB3+pHkhFQ1ZcA6gXbb6wS//sNNl49MUBTu4Dfeg7
R3RWn4UQ7uVCSqQ8IQxApewjzClBlejN0oPx7QCLfVylRcsukoyKhmqxa+SPoI/T
lNr/UPz7jC0YVXPxWxSbL9VtpDJL2Q4/fL58Jhcx3getAoe2aBT3EzFs1HOk5fsr
QCplK7Jagsyz2PXKeeBtC4n93xY3+MFGbYt/DuR26nZEH2SQr8ZbSVkd8s5Ptxak
eXKtcmlkILmZny67r8RqN2p5SG0nDkveJK4PYOJfOmjuuCyAum9wipHaYSPj/onM
0ly+y+pjjNLqjQL5yZnTZWWURY2nMrZSVEMtBJyu/E3GHYbMNPF9/5kuIhJB/Q5X
BIMgcbxmBAIp8E/HgngMGGDLTv4kqXTMjAbhVVMhvbevqTSCZ9scKnAcr7DLCSf4
J6tc8rlNXYTc8ohG3Yf/0ow5UdeKLV7g/51Ez15S87nK94yHjn/bbUapMMrvxvJB
JNRZ7JhGhz6Kg2OH+Y+mZt/5S2J/uJo9mO4W2cupLxTq11aAw8ZmMd/RV3kAMheu
eFNj5c/BJFjU3JvQBs99
=zqmp
-----END PGP SIGNATURE-----

--=-pQvPT5C63ITSr7Cmfb/3--

