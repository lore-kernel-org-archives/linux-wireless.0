Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:54212 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753600AbeGDLMw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jul 2018 07:12:52 -0400
Received: by mail-wm0-f65.google.com with SMTP id b188-v6so5409358wme.3
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jul 2018 04:12:52 -0700 (PDT)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        kvalo@codeaurora.org
Subject: Re: [PATCH v8] ath10k: fix crash in recent 3.5.3 9984 firmware due wrong handling of peer_bw_rxnss_override parameter
Date: Wed, 04 Jul 2018 13:12:47 +0200
Message-ID: <4756311.uatpdkZPGZ@bentobox> (sfid-20180704_131308_343817_70BF9C97)
In-Reply-To: <0cff058a-3c4b-6617-a034-3df706ba3a32@dd-wrt.com>
References: <20180704092953.32572-1-s.gottschall@dd-wrt.com> <5630152.jDWN9V3RzB@bentobox> <0cff058a-3c4b-6617-a034-3df706ba3a32@dd-wrt.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart4613126.Xrykp8NhWn"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart4613126.Xrykp8NhWn
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Mittwoch, 4. Juli 2018 12:48:06 CEST Sebastian Gottschall wrote:
[...]
> can you explain your request? the macros are unchanged and just 
> reformated for maximum line length restriction. the values have been 
> taken from QCA's wmi header

You use long shift and mask statements in your patch. But you didn't use the 
macros which are there to shorten them. So please check the macros SM and MS 
from core.h and adjust your code accordingly. The code which I've pasted does 
this (with an unintentionally added a copy and paste error).

Kind regards,
	Sven
--nextPart4613126.Xrykp8NhWn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAls8q68ACgkQXYcKB8Em
e0bf/g//fxPfMA/832a0efxxrOMpj4CKzfuYK7nE0hNB8BmwxptLxbf+IHO2IuYB
QX4+dPcSf/kJcjPCtg7tv0FaV+BOfQdPfl+O52qclTaiL2IjzNXEyB0pLcXAwk8u
FtLUj9XSI0+vxhrqJTM2RR7ce1BqZp0cFH39zjxFeJhklE7qGBd0CxvllcWBdl0h
oOBTFPIcXsp5W2MZ/6U+K/8yHXLgdOVw2A5MUVy+2wvVJgIegfBm7/17jhMZWBUQ
yO0TBvBTT/CgoEGrSL8wtYHiT0t2c8bX30hKyZ6Ryn7HDB6z1nTLAMSEGqbAXEXj
3+hQUCtEY0mF4nuXpUQyUpGISrXMtRiH10AuBpsxyUZ+fxxUVWXX9KKrbZtl2XD+
+at1p/YIcR7HfAB/hVrR1RUQa+FJ2yqUpp5EHSjWNFuEICOfKDyTnV/8hKgnDU0g
/qOQq2Saaqvq+wzqQ6kOX8gFa/bLcSSMlhDIyiSlCua3eaYdja/Ogjq2RCtS73BY
sdccmOHzhEfC/2FgZZNRTeuUm/JB2MOxU7VPSBiZzftjqu69QwM8N/fzS1DwyVoj
yl2Y3W8QCJCnBirc5rEhOitgM9vzXB70805dq6AmOowCLbhPUPcdndYyAfdA/wof
0iPB68l11/8ufvUCNnzh7pYwM57KM89+1KW7A05/DOZWXHjuM1Q=
=jIJr
-----END PGP SIGNATURE-----

--nextPart4613126.Xrykp8NhWn--
