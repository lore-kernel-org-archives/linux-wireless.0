Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:36013 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755545AbcKOKeN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Nov 2016 05:34:13 -0500
Received: by mail-wm0-f46.google.com with SMTP id g23so157694310wme.1
        for <linux-wireless@vger.kernel.org>; Tue, 15 Nov 2016 02:34:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1479141222-8493-11-git-send-email-erik.stromdahl@gmail.com>
References: <1479141222-8493-1-git-send-email-erik.stromdahl@gmail.com> <1479141222-8493-11-git-send-email-erik.stromdahl@gmail.com>
From: Michal Kazior <michal.kazior@tieto.com>
Date: Tue, 15 Nov 2016 11:34:11 +0100
Message-ID: <CA+BoTQmcyVQDOd2o0YDvepuLbSz76p8hetrWA6mWJeGxvbM8iQ@mail.gmail.com> (sfid-20161115_113416_726135_1CD8498E)
Subject: Re: [RFC 10/12] ath10k: Added QCA65XX hw definition
To: Erik Stromdahl <erik.stromdahl@gmail.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 14 November 2016 at 17:33, Erik Stromdahl <erik.stromdahl@gmail.com> wro=
te:
> Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
> ---
>  drivers/net/wireless/ath/ath10k/hw.h |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/=
ath/ath10k/hw.h
> index 46142e9..ef45ecf 100644
> --- a/drivers/net/wireless/ath/ath10k/hw.h
> +++ b/drivers/net/wireless/ath/ath10k/hw.h
> @@ -224,6 +224,7 @@ enum ath10k_hw_rev {
>         ATH10K_HW_QCA9377,
>         ATH10K_HW_QCA4019,
>         ATH10K_HW_QCA9887,
> +       ATH10K_HW_QCA65XX,

Are you 100% positive that you're supporting all QCA65XX chips? The
rule of thumb is to avoid Xs as much as possible unless totally
perfectly completely sure.


Micha=C5=82
