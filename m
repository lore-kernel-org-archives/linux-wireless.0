Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44733 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731Ab2EDJNP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 May 2012 05:13:15 -0400
Received: by eaaq12 with SMTP id q12so754101eaa.19
        for <linux-wireless@vger.kernel.org>; Fri, 04 May 2012 02:13:14 -0700 (PDT)
References: <1336096266-25790-1-git-send-email-zero.lin.0203@gmail.com>
In-Reply-To: <1336096266-25790-1-git-send-email-zero.lin.0203@gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <25F5FD55-8EEC-4930-B2EA-5A29F54E1894@gmail.com> (sfid-20120504_111318_981622_4D372CFD)
Cc: "users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	"Zero.Lin" <Zero.Lin@mediatek.com>
From: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH] rt2x00:Add RT539B chipset support
Date: Fri, 4 May 2012 11:13:12 +0200
To: Zero Lin <zero.lin.0203@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 4 mei 2012, at 03:51, Zero Lin <zero.lin.0203@gmail.com> wrote:

> From: "Zero.Lin" <Zero.Lin@mediatek.com>
> 
> Signed-off-by: Zero.Lin <Zero.Lin@mediatek.com>
> ---
> drivers/net/wireless/rt2x00/rt2800pci.c |    1 +
> 1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
> index 931331d..0c9b51d 100644
> --- a/drivers/net/wireless/rt2x00/rt2800pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
> @@ -1193,6 +1193,7 @@ static DEFINE_PCI_DEVICE_TABLE(rt2800pci_device_table) = {
>    { PCI_DEVICE(0x1814, 0x5392) },
>    { PCI_DEVICE(0x1814, 0x539a) },
>    { PCI_DEVICE(0x1814, 0x539f) },
> +    { PCI_DEVICE(0x1814, 0x539b) },
> #endif
>    { 0, }
> };

Could you please add the new ID in the right numerical order?
So, between 0x539a and 0x539f.

---
Gertjan