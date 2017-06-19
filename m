Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f169.google.com ([209.85.128.169]:33183 "EHLO
        mail-wr0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753861AbdFSH3J (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Jun 2017 03:29:09 -0400
Received: by mail-wr0-f169.google.com with SMTP id r103so66656137wrb.0
        for <linux-wireless@vger.kernel.org>; Mon, 19 Jun 2017 00:29:03 -0700 (PDT)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        Ben Greear <greearb@candelatech.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] ath10k: Configure rxnss_override for 10.4 firmware.
Date: Mon, 19 Jun 2017 09:28:57 +0200
Message-ID: <1562286.k58vxRCSiz@bentobox> (sfid-20170619_092959_042837_CC99EB69)
In-Reply-To: <87o9toz58b.fsf@kamboji.qca.qualcomm.com>
References: <20170609110750.14950-1-sven.eckelmann@openmesh.com> <20170609110750.14950-2-sven.eckelmann@openmesh.com> <87o9toz58b.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1802327.RhgNRe3UZU"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1802327.RhgNRe3UZU
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Freitag, 16. Juni 2017 08:50:13 CEST Kalle Valo wrote:
> We have hw_params for stuff like this so I changed this and the
> following patch to use that. Please review:

Looks good. Thanks for adjusting the patches.

Kind regards,
	Sven
--nextPart1802327.RhgNRe3UZU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAllHfTkACgkQXYcKB8Em
e0YxihAApNnt3WkMb8G9edRJ7N/bf+aCdcx1LZSQz9gDjbnooFfE6/t4CPAwj2+x
mOfwO0lyz01HnuqCVjRZSWfNcPrsEu5SXDb/W3EIegrDV4UxEGUOL3EQZGIOBw0G
VymkkidmM9FeFV9cxGL73j71mItUtlh540SM4Y+W+DD2lbptebaVO+geZDPKJKkk
Ws1KucK3Cs7DwzvnwgSQY326PcNz3wnb052oAg+BeEprmAqtY9XaRf+o4WBZOPva
fK/SvkSG+S+3MV0V4DDMSYkX+suNndkszKyJsw51A//QCV4rylMGovxg6WWzDTr1
bcrX7E2zmDAUJVLjVnu0RFs26WceLj+h1+45QqpMVg69XaK9LfGpJJYZ7vYjCZc9
mG8pibhfby2t7+coz5xInSrFRCD0DwcUO6YfINBfKD0l22ZqAGrGpyG+hIay2BmX
eGlCrHVAiXC3oSPi/qd+GnQ5v88UM71RHCO+6L0O8RSYkkBQr+H0yFv+v/lr3NN+
MsqVMTH08Mj3k0n1ZlEDnTVViAozoXur/FXgtQwMvFBOXPps5bFvZa430rmMt2OP
zN0Yw9TW7JsrFZ8MMP8vyW5hRxnGXaa2YzwcKFnuCHoEhzboGOJBKmP7Gg3ri7oi
mGAO2eqcpPr7D2Lh1HSICSyP24rGCCmJgHX5Eb2dCkveuOoWdzE=
=3NLy
-----END PGP SIGNATURE-----

--nextPart1802327.RhgNRe3UZU--
