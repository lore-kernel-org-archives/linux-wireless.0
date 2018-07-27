Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728656AbeG0Xmx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jul 2018 19:42:53 -0400
Date: Fri, 27 Jul 2018 17:18:55 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: linux-pci@vger.kernel.org
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        ath9k-devel@qca.qualcomm.com, linuxwifi@intel.com,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v1 0/4] PCI: Remove unnecessary includes of
 <linux/pci-aspm.h>
Message-ID: <20180727221855.GG173328@bhelgaas-glaptop.roam.corp.google.com> (sfid-20180728_001912_917339_7DCF8416)
References: <153254813164.92573.10755585465477668768.stgit@bhelgaas-glaptop.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <153254813164.92573.10755585465477668768.stgit@bhelgaas-glaptop.roam.corp.google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 25, 2018 at 02:52:08PM -0500, Bjorn Helgaas wrote:
> Remove includes of <linux/pci-aspm.h> from files that don't need
> it.  I'll apply all these via the PCI tree unless there's objection.
> 
> ---
> 
> Bjorn Helgaas (4):
>       igb: Remove unnecessary include of <linux/pci-aspm.h>
>       ath9k: Remove unnecessary include of <linux/pci-aspm.h>
>       iwlwifi: Remove unnecessary include of <linux/pci-aspm.h>
>       PCI: Remove unnecessary include of <linux/pci-aspm.h>
> 
> 
>  drivers/net/ethernet/intel/igb/igb_main.c     |    1 -
>  drivers/net/wireless/ath/ath9k/pci.c          |    1 -
>  drivers/net/wireless/intel/iwlwifi/pcie/drv.c |    1 -
>  drivers/pci/pci-sysfs.c                       |    1 -
>  drivers/pci/pci.c                             |    1 -
>  drivers/pci/probe.c                           |    1 -
>  drivers/pci/remove.c                          |    1 -
>  7 files changed, 7 deletions(-)

I applied these to the pci/aspm branch for v4.19.
