Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:60667 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755639Ab2EGMju convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 08:39:50 -0400
Received: by lahd3 with SMTP id d3so241095lah.19
        for <linux-wireless@vger.kernel.org>; Mon, 07 May 2012 05:39:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1336361682-2771-1-git-send-email-zero.lin.0203@gmail.com>
References: <1336361682-2771-1-git-send-email-zero.lin.0203@gmail.com>
Date: Mon, 7 May 2012 14:39:46 +0200
Message-ID: <CAL1gcdMBj_w5qbMX=kxcW6yow7UgSfSrWjz6TrKkFZiJCtS1cg@mail.gmail.com> (sfid-20120507_143955_074606_FDF31A56)
Subject: Re: [PATCH] rt2x00:Add RT539B chipset support V2
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Zero Lin <zero.lin.0203@gmail.com>
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	"Zero.Lin" <Zero.Lin@mediatek.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Mon, May 7, 2012 at 5:34 AM, Zero Lin <zero.lin.0203@gmail.com> wrote:
> From: "Zero.Lin" <Zero.Lin@mediatek.com>
>
> Signed-off-by: Zero.Lin <Zero.Lin@mediatek.com>

I'm sorry, but you will have to do this as a complete new patch
replacing your old one, not as an incremental to your initial patch.

> ---
>  drivers/net/wireless/rt2x00/rt2800pci.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
> index 0c9b51d..cad25bf 100644
> --- a/drivers/net/wireless/rt2x00/rt2800pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
> @@ -1192,8 +1192,8 @@ static DEFINE_PCI_DEVICE_TABLE(rt2800pci_device_table) = {
>        { PCI_DEVICE(0x1814, 0x5390) },
>        { PCI_DEVICE(0x1814, 0x5392) },
>        { PCI_DEVICE(0x1814, 0x539a) },
> -       { PCI_DEVICE(0x1814, 0x539f) },
>        { PCI_DEVICE(0x1814, 0x539b) },
> +       { PCI_DEVICE(0x1814, 0x539f) },
>  #endif
>        { 0, }
>  };
> --
> 1.7.5.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
---
Gertjan
