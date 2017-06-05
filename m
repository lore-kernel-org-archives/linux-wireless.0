Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34611 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751163AbdFEAr5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 4 Jun 2017 20:47:57 -0400
MIME-Version: 1.0
In-Reply-To: <20170604163608.24894-1-colin.king@canonical.com>
References: <20170604163608.24894-1-colin.king@canonical.com>
From: Steve deRosier <derosier@gmail.com>
Date: Sun, 4 Jun 2017 17:47:55 -0700
Message-ID: <CALLGbR+Bn4vXsQVYGTMy++rERu1O2JOHrGfekpo_aa86dLKsYQ@mail.gmail.com> (sfid-20170605_024835_900436_9CFDD3D1)
Subject: Re: [PATCH] ath6kl: fix spelling mistake: "Indicat" -> "Indicate"
To: Colin King <colin.king@canonical.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 4, 2017 at 9:36 AM, Colin King <colin.king@canonical.com> wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> Trivial fix to spelling mistake in ath6kl_dbg debug message
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/wireless/ath/ath6kl/htc_pipe.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/ath6kl/htc_pipe.c b/drivers/net/wireless/ath/ath6kl/htc_pipe.c
> index d127a08d60df..d4fd9e40fffb 100644
> --- a/drivers/net/wireless/ath/ath6kl/htc_pipe.c
> +++ b/drivers/net/wireless/ath/ath6kl/htc_pipe.c
> @@ -383,7 +383,7 @@ static enum htc_send_queue_result htc_try_send(struct htc_target *target,
>                         list_for_each_entry_safe(packet, tmp_pkt,
>                                                  txq, list) {
>                                 ath6kl_dbg(ATH6KL_DBG_HTC,
> -                                          "%s: Indicat overflowed TX pkts: %p\n",
> +                                          "%s: Indicate overflowed TX pkts: %p\n",
>                                            __func__, packet);
>                                 action = ep->ep_cb.tx_full(ep->target, packet);
>                                 if (action == HTC_SEND_FULL_DROP) {
> --
> 2.11.0
>

Looks good to me.

Reviewed-by: Steve deRosier <derosier@gmail.com>

- Steve
