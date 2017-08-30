Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:38778 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751309AbdH3Stc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Aug 2017 14:49:32 -0400
Received: by mail-wm0-f49.google.com with SMTP id 187so6892144wmn.1
        for <linux-wireless@vger.kernel.org>; Wed, 30 Aug 2017 11:49:31 -0700 (PDT)
Subject: Re: [PATCH v2] brcmfmac: Log chip id and revision
To: Hans de Goede <hdegoede@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
References: <20170830135449.1075-1-hdegoede@redhat.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <0bb5aefd-a3d9-0d00-eea6-f0da9ea6ebfc@broadcom.com> (sfid-20170830_204935_843257_DA98F542)
Date: Wed, 30 Aug 2017 20:49:29 +0200
MIME-Version: 1.0
In-Reply-To: <20170830135449.1075-1-hdegoede@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 30-08-17 15:54, Hans de Goede wrote:
> For debugging some problems, it is useful to know the chip revision
> add a brcmf_info message logging this.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
> Changes in v2:
> -Put the brcmf_info in brcmf_fw_map_chip_to_name() so that it works for
>   e.g. pcie devices too
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c | 3 +++
>   1 file changed, 3 insertions(+)
