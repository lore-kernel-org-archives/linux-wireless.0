Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:38591 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941354AbcKOKZm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Nov 2016 05:25:42 -0500
Received: by mail-wm0-f51.google.com with SMTP id f82so159040072wmf.1
        for <linux-wireless@vger.kernel.org>; Tue, 15 Nov 2016 02:25:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1479141222-8493-6-git-send-email-erik.stromdahl@gmail.com>
References: <1479141222-8493-1-git-send-email-erik.stromdahl@gmail.com> <1479141222-8493-6-git-send-email-erik.stromdahl@gmail.com>
From: Michal Kazior <michal.kazior@tieto.com>
Date: Tue, 15 Nov 2016 11:25:40 +0100
Message-ID: <CA+BoTQmcB7+aH3wvG-mRSdBS8VaJ1OrLYQ0HCbCJeoH9ccxXNQ@mail.gmail.com> (sfid-20161115_112546_023773_E5341E25)
Subject: Re: [RFC 05/12] ath10k: htc: Added ATH10K_HTC_FLAG_BUNDLE_LSB
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
>  drivers/net/wireless/ath/ath10k/htc.h |    2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ath10k/htc.h b/drivers/net/wireless=
/ath/ath10k/htc.h
> index 589800a..df16a04 100644
> --- a/drivers/net/wireless/ath/ath10k/htc.h
> +++ b/drivers/net/wireless/ath/ath10k/htc.h
> @@ -62,6 +62,8 @@ enum ath10k_htc_rx_flags {
>         ATH10K_HTC_FLAG_BUNDLE_MASK     =3D 0xF0
>  };
>
> +#define ATH10K_HTC_FLAG_BUNDLE_LSB         4

Just an idea - we could start using FIELD_GET() with
ATH10K_HTC_FLAG_BUNDLE_MASK alone. I would love to see Jakub's
bitfield stuff be used more. Kalle, thoughts?


Micha=C5=82
