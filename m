Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:33848 "EHLO
	mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbcBOXqf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Feb 2016 18:46:35 -0500
Received: by mail-io0-f196.google.com with SMTP id l127so13685151iof.1
        for <linux-wireless@vger.kernel.org>; Mon, 15 Feb 2016 15:46:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1455173229-6383-2-git-send-email-royujjal@gmail.com>
References: <1455173229-6383-1-git-send-email-royujjal@gmail.com> <1455173229-6383-2-git-send-email-royujjal@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 16 Feb 2016 10:46:15 +1100
Message-ID: <CAGRGNgWTsvcQGxoY8iLs_CyEDNj7XTe8RhXgMWqAfZjjgx8soA@mail.gmail.com> (sfid-20160216_004639_014219_3E29928A)
Subject: Re: [PATCH 2/3] mwifiex: Removed extra spaces before commas
To: Ujjal Roy <royujjal@gmail.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	WiFi Mailing List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

On Thu, Feb 11, 2016 at 5:47 PM, Ujjal Roy <royujjal@gmail.com> wrote:
> This patch fixes spaces before commas issue in coding style.
>
> Signed-off-by: Ujjal Roy <royujjal@gmail.com>

Looks right to me.

Reviewed-by: Julian Calaby <julian.calaby@gmail.com>

Thanks,

> ---
>  drivers/net/wireless/marvell/mwifiex/pcie.c    | 2 +-
>  drivers/net/wireless/marvell/mwifiex/uap_cmd.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
> index 6d0dc40..4d29cce 100644
> --- a/drivers/net/wireless/marvell/mwifiex/pcie.c
> +++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
> @@ -1408,7 +1408,7 @@ mwifiex_pcie_send_boot_cmd(struct mwifiex_adapter *adapter, struct sk_buff *skb)
>                 return -1;
>         }
>
> -       if (mwifiex_map_pci_memory(adapter, skb, skb->len , PCI_DMA_TODEVICE))
> +       if (mwifiex_map_pci_memory(adapter, skb, skb->len, PCI_DMA_TODEVICE))
>                 return -1;
>
>         buf_pa = MWIFIEX_SKB_DMA_ADDR(skb);
> diff --git a/drivers/net/wireless/marvell/mwifiex/uap_cmd.c b/drivers/net/wireless/marvell/mwifiex/uap_cmd.c
> index e791166..16d95b2 100644
> --- a/drivers/net/wireless/marvell/mwifiex/uap_cmd.c
> +++ b/drivers/net/wireless/marvell/mwifiex/uap_cmd.c
> @@ -192,7 +192,7 @@ mwifiex_set_ht_params(struct mwifiex_private *priv,
>                 }
>                 priv->ap_11n_enabled = 1;
>         } else {
> -               memset(&bss_cfg->ht_cap , 0, sizeof(struct ieee80211_ht_cap));
> +               memset(&bss_cfg->ht_cap, 0, sizeof(struct ieee80211_ht_cap));
>                 bss_cfg->ht_cap.cap_info = cpu_to_le16(MWIFIEX_DEF_HT_CAP);
>                 bss_cfg->ht_cap.ampdu_params_info = MWIFIEX_DEF_AMPDU;
>         }
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
