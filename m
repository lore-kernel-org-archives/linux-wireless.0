Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:34941 "EHLO
	mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236AbcGDAuQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jul 2016 20:50:16 -0400
Received: by mail-it0-f65.google.com with SMTP id g4so2630832ith.2
        for <linux-wireless@vger.kernel.org>; Sun, 03 Jul 2016 17:50:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1467356767-31646-1-git-send-email-c_traja@qti.qualcomm.com>
References: <1467356767-31646-1-git-send-email-c_traja@qti.qualcomm.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 4 Jul 2016 10:49:55 +1000
Message-ID: <CAGRGNgWd-5ef5bxOkthpfH1hjqO4HJuWuBA=jNRAr=geQDH1zA@mail.gmail.com> (sfid-20160704_025020_290075_DA69AEA0)
Subject: Re: [PATCHv3 1/3] ath10k: move firmware_swap_code_seg_info to ath10k_fw_file
To: c_traja@qti.qualcomm.com
Cc: ath10k@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	tamizhchelvam@codeaurora.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Tamizh,

On Fri, Jul 1, 2016 at 5:06 PM,  <c_traja@qti.qualcomm.com> wrote:
> From: Tamizh chelvam <c_traja@qti.qualcomm.com>
>
> Preparation to make use of firmware_swap_code_seg_info for UTF binary.
>
> Signed-off-by: Tamizh chelvam <c_traja@qti.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath10k/core.c |    6 +++---
>  drivers/net/wireless/ath/ath10k/core.h |    6 ++----
>  drivers/net/wireless/ath/ath10k/swap.c |   26 ++++++++++++++------------
>  drivers/net/wireless/ath/ath10k/swap.h |   11 ++++++++---
>  4 files changed, 27 insertions(+), 22 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
> index 3da18c9..e69e7e7 100644
> --- a/drivers/net/wireless/ath/ath10k/core.h
> +++ b/drivers/net/wireless/ath/ath10k/core.h
> @@ -654,6 +654,8 @@ struct ath10k_fw_file {
>
>         const void *codeswap_data;
>         size_t codeswap_len;
> +       /* FIXME: add a comment */
> +       struct ath10k_swap_code_seg_info *firmware_swap_code_seg_info;

Why not just add a comment? Adding FIXMEs makes the patch look incomplete to me.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
