Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31259 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066Ab2E2Mgr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 08:36:47 -0400
Date: Tue, 29 May 2012 14:36:27 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Zero Lin <zero.lin.0203@gmail.com>
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	"Zero.Lin" <Zero.Lin@mediatek.com>
Subject: Re: [PATCH] rt2x00:Add RT539b chipset support
Message-ID: <20120529123626.GE2441@redhat.com> (sfid-20120529_143650_148803_490E7415)
References: <1336615591-2017-1-git-send-email-zero.lin.0203@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1336615591-2017-1-git-send-email-zero.lin.0203@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 10, 2012 at 10:06:31AM +0800, Zero Lin wrote:
> From: "Zero.Lin" <Zero.Lin@mediatek.com>
> 
> Signed-off-by: Zero.Lin <Zero.Lin@mediatek.com>
Reviewed-by: Stanislaw Gruszka <sgruszka@redhat.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800pci.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
> index 931331d..cad25bf 100644
> --- a/drivers/net/wireless/rt2x00/rt2800pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
> @@ -1192,6 +1192,7 @@ static DEFINE_PCI_DEVICE_TABLE(rt2800pci_device_table) = {
>  	{ PCI_DEVICE(0x1814, 0x5390) },
>  	{ PCI_DEVICE(0x1814, 0x5392) },
>  	{ PCI_DEVICE(0x1814, 0x539a) },
> +	{ PCI_DEVICE(0x1814, 0x539b) },
>  	{ PCI_DEVICE(0x1814, 0x539f) },
>  #endif
>  	{ 0, }
> -- 
> 1.7.5.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
