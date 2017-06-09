Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:36945 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751515AbdFIKN7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Jun 2017 06:13:59 -0400
Received: by mail-wm0-f42.google.com with SMTP id d73so46821814wma.0
        for <linux-wireless@vger.kernel.org>; Fri, 09 Jun 2017 03:13:59 -0700 (PDT)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Ben Greear <greearb@candelatech.com>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: ath10k: Configure rxnss_override for 10.4 firmware.
Date: Fri, 09 Jun 2017 12:13:56 +0200
Message-ID: <12172761.EOB4KtkSt3@bentobox> (sfid-20170609_121403_663405_6D9C6BEF)
In-Reply-To: <e379002d2a6a4563baefb435b4552586@eusanexr01a.eu.qualcomm.com>
References: <1486771745-15150-1-git-send-email-greearb@candelatech.com> <e379002d2a6a4563baefb435b4552586@eusanexr01a.eu.qualcomm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart6539135.DE6dNImiSn"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart6539135.DE6dNImiSn
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Mittwoch, 15. Februar 2017 01:26:58 CEST Kalle Valo wrote:
> Ben Greear <greearb@candelatech.com> wrote:
> > From: Ben Greear <greearb@candelatech.com>
> > 
> > QCA9984 hardware can do 4x4 at 80Mhz, but only 2x2 at 160Mhz.
[....]
> Does not apply:
> 
> error: patch failed: drivers/net/wireless/ath/ath10k/mac.c:2760
> error: drivers/net/wireless/ath/ath10k/mac.c: patch does not apply
> error: patch failed: drivers/net/wireless/ath/ath10k/wmi.h:6173
> error: drivers/net/wireless/ath/ath10k/wmi.h: patch does not apply
> stg import: Diff does not apply cleanly
> 
> Patch set to Changes Requested.

I wanted to use this patch to announce the maximum speed for QCA9888.
I hope it is ok for Ben Greear when I rebase and resubmit it.

Kind regards,
	Sven
--nextPart6539135.DE6dNImiSn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAlk6dOQACgkQXYcKB8Em
e0YE7BAAv9uzvYlQ+6R7+Em6ZdP+Jh0qaXkLMPzODNx4HxdHoGnh3RwYzYc95apz
SMtS23xdbETzSGdRVTlODN7fbe+ScOo+6UQTLzZJREfPFTHWpkh3Ls0OFkAUva4T
+2Q0qNK5PAgY7clrZ4NAsq1bSUyoSxs0pVVQRxOzrR1tsevI9vggiTaoRf1eDb+l
cdncgBX+Ybl+ptFE1ceY9U7MC9hTkn6IZ4r74C9fdOphfiZzlhYY65oODf4oyFDm
/qoW88lwaBPUjzurG0P/pzm++I9/ynAnx4VnfLbFWPw7g1zyD1IaUYvLVdTr6X3r
0g2ko2YaLe0ft3lFQkIUVzuhU9I33h0f4/BK/ZRxAkmm3wos7LWENXklXkzfr2QJ
/nlJ580Vipkg8OQGU5l3sn63QxTobmbcfjJv7Vh/7hR49h53AOJwJArK4yDAqyWn
8x5xzUcDza378FswS/wAZfQQ1F/Sut7P0f3TMPZXGPQi4nOW61w8pZzqmAWbBjXD
nWkoRhaJJB/PNxppa+2tpsrvH2AZw+zd3Y109bHSayppEOSzcFYzWvGcpPgDUDfW
ET9ZjPhZf/qK5lXPk3Kjlcu1N2ipFNVg23Uv2Ai/Hbq0Ktwl/HVk2PbE+ZKSBzPY
0YVRM0cYLUW1AjSOSddeOD8I1YIMEgNPVeIU1hE/2ph/imMkojw=
=WOFR
-----END PGP SIGNATURE-----

--nextPart6539135.DE6dNImiSn--
