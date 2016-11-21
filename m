Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:37306 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752452AbcKUJLC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Nov 2016 04:11:02 -0500
Received: by mail-wm0-f50.google.com with SMTP id t79so132063296wmt.0
        for <linux-wireless@vger.kernel.org>; Mon, 21 Nov 2016 01:11:02 -0800 (PST)
From: Sven Eckelmann <sven.eckelmann@open-mesh.com>
To: Ferry Huberts <mailings@hupie.com>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
        ath9k-devel@qca.qualcomm.com,
        Simon Wunderlich <simon.wunderlich@open-mesh.com>
Subject: Re: [ath9k-devel] [RFC v2 2/2] ath9k: Reset chip on potential deaf state
Date: Mon, 21 Nov 2016 10:10:59 +0100
Message-ID: <2358985.PI5q6nxgha@bentobox> (sfid-20161121_101106_171187_3C45F212)
In-Reply-To: <d23407cb-a1c0-860a-3436-5e72402a080b@hupie.com>
References: <20161117083614.19188-1-sven.eckelmann@open-mesh.com> <20161117083614.19188-2-sven.eckelmann@open-mesh.com> <d23407cb-a1c0-860a-3436-5e72402a080b@hupie.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart18973506.RstdKfy8q0"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart18973506.RstdKfy8q0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Montag, 21. November 2016 10:07:43 CET Ferry Huberts wrote:
[...]
> > v2:
> >  - reduce amount of possible goto-raptor attacks by one (thanks Kalle Valo)
> >
> > This problem was discovered in mesh setups. It was noticed that some nodes
> 
> 
> What kind of setup?
> Using 802.11s?

Unencrypted IBSS.

Kind regards,
	Sven
--nextPart18973506.RstdKfy8q0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCgAGBQJYMrojAAoJEF2HCgfBJntGeFwQALq11OBtpPz6x/XouOj5xOZ0
9GOGkWS6W+eILCXp9C5naHYFtGiy/3cphCD5DFIY56DCkxGYjUXcPruaukdNM0CS
mWfSUpgo6XufDbRayMEe+m/Ulp+Q6ss9SmTCl2eVlt5PVcKp5AFOs1Ag3tWbx879
RrX4Elri6OkGVCtzms+lmAseSAp1Ltza3QtL5S+pQpxbg0G4EOdl5lIxPKDbMin2
/wdsLV996GTd5WMVk8oib2HP26aqxVKYqk9iIrz+5ED2m+XkqoI8TxnzSYnTCoTJ
epevZm4+LJK3SulR6K/BZ03lLHs8rcMLAOLsc/Nq/BgvmoU6HC4NiN3iFLbtGhCd
prBys8rABBbG7yVuxmXmbtGrjHNq6fzFD+Npf3j/jfEjg5NcDwv+V7LBJpzsH2Xt
XnTyE7NBLj5dt6yp5aH95qK7Nx5/nBLD7+EqmcFS82TQ2mRQU6jlNtksRCfK7PNM
nJvPO7umCVLYyLDYOcam4tvf3uXeY8omPrvSAf/4qzGhXV6qJKFQ5IrY5cPeqAIi
pWIw7bURj/hW+dbraYPE4I+9ISpngEk2bjEG3Dd3dELb3qLaJO2QM56gR9fysEo1
P9DjvOvWaoLhwZUQkvP3BJr/ZFyNyT3N+RiPN1br/ajEcx0IagQTjJKhblJ6hbtM
cAo+EFz0gsuN6JUcVwB1
=NbX3
-----END PGP SIGNATURE-----

--nextPart18973506.RstdKfy8q0--
