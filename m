Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:62399 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754916AbcLPKYJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Dec 2016 05:24:09 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Erik Stromdahl <erik.stromdahl@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [RFC v2 06/11] ath10k: htc: Added ATH10K_HTC_FLAG_BUNDLE_LSB
Date: Fri, 16 Dec 2016 10:23:54 +0000
Message-ID: <877f70uq86.fsf@kamboji.qca.qualcomm.com> (sfid-20161216_112413_577615_4E9CF24D)
References: <1479496971-19174-1-git-send-email-erik.stromdahl@gmail.com>
        <1479496971-19174-7-git-send-email-erik.stromdahl@gmail.com>
In-Reply-To: <1479496971-19174-7-git-send-email-erik.stromdahl@gmail.com>
        (Erik Stromdahl's message of "Fri, 18 Nov 2016 20:22:46 +0100")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Erik Stromdahl <erik.stromdahl@gmail.com> writes:

> Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
> ---
>  drivers/net/wireless/ath/ath10k/htc.h |    2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ath10k/htc.h b/drivers/net/wireless=
/ath/ath10k/htc.h
> index f94b25a..2963694 100644
> --- a/drivers/net/wireless/ath/ath10k/htc.h
> +++ b/drivers/net/wireless/ath/ath10k/htc.h
> @@ -62,6 +62,8 @@ enum ath10k_htc_rx_flags {
>  	ATH10K_HTC_FLAG_BUNDLE_MASK     =3D 0xF0
>  };
> =20
> +#define ATH10K_HTC_FLAG_BUNDLE_LSB         4
> +

I think you could fold patches from 6 to 11 into one patch. They are all
about adding code, and most of the commit logs are empty anyway.

--=20
Kalle Valo=
