Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:37450 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932454AbcE0IMv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 May 2016 04:12:51 -0400
Received: by mail-wm0-f53.google.com with SMTP id z87so127114481wmh.0
        for <linux-wireless@vger.kernel.org>; Fri, 27 May 2016 01:12:50 -0700 (PDT)
From: Sven Eckelmann <sven.eckelmann@open-mesh.com>
To: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Cc: ath10k@lists.infradead.org, mohammed@codeaurora.org,
	linux-wireless@vger.kernel.org,
	"Valo, Kalle" <kvalo@qca.qualcomm.com>
Subject: Re: [PATCH v1] ath10k: Fix 10.4 extended peer stats update
Date: Fri, 27 May 2016 10:12:45 +0200
Message-ID: <6103547.auMgQrn60O@bentobox> (sfid-20160527_101300_575691_1F927F39)
In-Reply-To: <1462947870-17196-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1462947870-17196-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2016362.accvuSFHEX"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2016362.accvuSFHEX
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Wednesday 11 May 2016 11:54:30 Mohammed Shafi Shajakhan wrote:
>  #else
> -static inline void ath10k_sta_update_rx_duration(struct ath10k *ar,
> -						 struct list_head *peer)
> +static inline
> +void ath10k_sta_update_rx_duration(struct ath10k *ar,
> +				   struct ath10k_fw_stats *stats);
>  {
>  }

Please remove the ";" for the "static inline" version. I can also
submit a patch in case patches in ath.git/pending cannot be dropped
anymore.

Kind regards,
	Sven
--nextPart2016362.accvuSFHEX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJXSAF9AAoJEF2HCgfBJntG/BgP/A6hCPSPgqJ6yESwOrbmyNA5
mIyYbl1TWmSoUXhd8ljL8wOeYK6vTtUArwWSm39l5HapVMQzm4PEY0CQedtt+nRf
p79unSGUFzeUngRegx3G5aDiBiHn7G1WZL33x0YqBiSX7mLTcnERe9xfvM4Jx80O
+tZUbDwhv6PggF55rPiY1sOPGcC2ZS+BzwCURt5mIbDL79KnoeuYioEowK3DEKmX
HBPk1G9oN4A65qe0CkB8xv96spjS9iAi3k84q0UvBkhLUjbGJ57WkYHrGXi325tq
Onb7M6f7Aatl2tnzHRFgrJqT2/t/BAAftwA3TYXvEoHP67do0khyK4DyJmIykQC0
x2iulZLy7alT+2/287OhGvWomM+R4b5P5JlgNaxPhRTS4MBFribmmEZukS+R0O1B
boH4yuaYqbv+O9Rq+Pq6HyJZXRkh3p8VrqEKNJviVKx4ROvJNpAHcQwLOpxsnt/n
Hu8CN7tFW7BCHIly8rXgrSSsFpxI3DH1bzlwsJOsEcNfsScsJKHxFZPAXbgFf8PJ
wVqK6tYqVi1xSWR3kvjqeZ0ZUFQgEjA/qKMQ+wIS4Whi7ajHg50BkDv2zQ2rD6OA
pwTiFsoog4iB3nH8vJ/z6r8cdoTKlATi8jFXXAFC1rtZjMjPH1jFJhLsVgZfzsGz
ki1hOu/MN33be4SimKIq
=zRuz
-----END PGP SIGNATURE-----

--nextPart2016362.accvuSFHEX--

