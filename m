Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55849 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759417AbYAJNrB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jan 2008 08:47:01 -0500
Subject: Re: [PATCH 1/6] ath5k: code cosmetics
From: Johannes Berg <johannes@sipsolutions.net>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: Bruno Randolf <bruno@thinktube.com>, ath5k-devel@lists.ath5k.org,
	mcgrof@gmail.com, jirislaby@gmail.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <40f31dec0801100542x7de452d1t8d75a571496c9a62@mail.gmail.com> (sfid-20080110_134214_013423_93D229DC)
References: <1199870169-10476-1-git-send-email-bruno@thinktube.com>
	 <1199870169-10476-2-git-send-email-bruno@thinktube.com>
	 <1199926491.3861.47.camel@johannes.berg>
	 <40f31dec0801100542x7de452d1t8d75a571496c9a62@mail.gmail.com>
	 (sfid-20080110_134214_013423_93D229DC)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-C78r7yYcdXS8tNCC2y46"
Date: Thu, 10 Jan 2008 14:46:40 +0100
Message-Id: <1199972801.3861.68.camel@johannes.berg> (sfid-20080110_134708_079045_4C99E4BE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-C78r7yYcdXS8tNCC2y46
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Sort off, this is what i found with a quick look on net80211...
> http://madwifi.org/browser/madwifi/trunk/net80211/ieee80211_power.c
> http://madwifi.org/browser/madwifi/trunk/net80211/ieee80211_input.c#L563
> http://madwifi.org/browser/madwifi/trunk/net80211/ieee80211_output.c#L264

Yeah, I know how u-apsd works, but I'm a bit confused that you need a
separate queue for it.

johannes

--=-C78r7yYcdXS8tNCC2y46
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR4Yhv6Vg1VMiehFYAQL8QQ/9HZmnK1AMFk4IMjZx5suajTiixjhTuO8b
/py/DZ0ZuuMzLJhCJDiGWSpbCYrhuWllWcICDdV0UDtbvPF39geUC0Tt0WOW7Vbd
WqMhycV/dLDaVdjyqsqDcGObI2nfZ1Dw9Lrppid4iJC8c/tqi+O86Qqlkbi42Xuf
9THKH9uBTxCrS5GGqU7GxA1//nPmPMUSLvVnNSPG7CA/Wh4kunbLTSnE3urMhhW4
DPOMEthK9BZQ7ktRiDL9eaD4Gy4K0ahH7MW9BpKMZzla2OzB3SAqUzZXCLpE4uAc
2MikfiVdf1cgcWUqOZSb4FRoeyuvFcSN1Asabqyu0jhX1YkLm49PR5N8gCn8DH21
RcZ5ILdfPr9+x5/i8VLhamF1M7QliNc1IU2tj0V2EIAzgYBZDt7ysCbErckszn5b
lAMhrzsO40so7HhMKADw6Labg4vIRHXFKbHTIRuJiEzaR/Z3jXQsu1xRAPpJ6okT
tyg4YdnIPsID5sX8Kf7zp2F1U3Asug4/PEsaQ0b3S0ghQST2rWrqf2Lw0g7zfciP
luquYZ8ZWm6D5ByyA9kqlRI1d27+JOX07HGp2DssEdJDlTq9aVM0jpTvbSp4N4Kn
fP3It+vuBOirecBZhOFUTBWp57HF0MwFnvszoAAuky7aV0PxoU5PAaiXGrLXjMwv
UO7vOH7jTp4=
=P44l
-----END PGP SIGNATURE-----

--=-C78r7yYcdXS8tNCC2y46--

