Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:35739 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730357AbeGYWZj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Jul 2018 18:25:39 -0400
MIME-Version: 1.0
In-Reply-To: <153254834342.92573.16877025672192312745.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <153254813164.92573.10755585465477668768.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <153254834342.92573.16877025672192312745.stgit@bhelgaas-glaptop.roam.corp.google.com>
From: Alexander Duyck <alexander.duyck@gmail.com>
Date: Wed, 25 Jul 2018 14:12:08 -0700
Message-ID: <CAKgT0UewV82FKVMkW975+upccaRJF4i6oQYzNh5jC02wcGmhXQ@mail.gmail.com> (sfid-20180725_231224_917023_3C1D27FF)
Subject: Re: [Intel-wired-lan] [PATCH v1 1/4] igb: Remove unnecessary include
 of <linux/pci-aspm.h>
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: linux-pci <linux-pci@vger.kernel.org>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>, linuxwifi@intel.com,
        Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        ath9k-devel@qca.qualcomm.com, LKML <linux-kernel@vger.kernel.org>,
        Luca Coelho <luciano.coelho@intel.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 25, 2018 at 12:52 PM, Bjorn Helgaas <helgaas@kernel.org> wrote:
> From: Bjorn Helgaas <bhelgaas@google.com>
>
> The igb driver doesn't need anything provided by pci-aspm.h, so remove
> the unnecessary include of it.
>
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>

Looks good to me.

Acked-by: Alexander Duyck <alexander.h.duyck@intel.com>

> ---
>  drivers/net/ethernet/intel/igb/igb_main.c |    1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
> index f707709969ac..c77fda05f683 100644
> --- a/drivers/net/ethernet/intel/igb/igb_main.c
> +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> @@ -22,7 +22,6 @@
>  #include <linux/if.h>
>  #include <linux/if_vlan.h>
>  #include <linux/pci.h>
> -#include <linux/pci-aspm.h>
>  #include <linux/delay.h>
>  #include <linux/interrupt.h>
>  #include <linux/ip.h>
>
> _______________________________________________
> Intel-wired-lan mailing list
> Intel-wired-lan@osuosl.org
> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
