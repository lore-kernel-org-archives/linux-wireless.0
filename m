Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751072AbeA2SDy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Jan 2018 13:03:54 -0500
Date: Mon, 29 Jan 2018 12:03:49 -0600
From: Bjorn Helgaas <helgaas@kernel.org>
To: Tobias Schramm <tobleminer@gmail.com>
Cc: kvalo@qca.qualcomm.com, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, bhelgaas@google.com,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH v3 1/2] pci: Add vendor id of Ubiquiti Networks
Message-ID: <20180129180349.GB232763@bhelgaas-glaptop.roam.corp.google.com> (sfid-20180129_190358_447170_C57355F5)
References: <20180125111340.17553-1-tobleminer@gmail.com>
 <20180125111340.17553-2-tobleminer@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180125111340.17553-2-tobleminer@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 25, 2018 at 12:13:39PM +0100, Tobias Schramm wrote:
> Signed-off-by: Tobias Schramm <tobleminer@gmail.com>

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

I see Kalle has already applied this, but if it's updated for any reason,
please add my ack and change the subject to:

  PCI: Add Ubiquiti Networks vendor ID

i.e., match the style of previous changes.

> ---
>  include/linux/pci_ids.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> index ab20dc5db423..35871adfdc86 100644
> --- a/include/linux/pci_ids.h
> +++ b/include/linux/pci_ids.h
> @@ -149,6 +149,8 @@
>  #define PCI_VENDOR_ID_DYNALINK		0x0675
>  #define PCI_DEVICE_ID_DYNALINK_IS64PH	0x1702
>  
> +#define PCI_VENDOR_ID_UBIQUITI		0x0777
> +
>  #define PCI_VENDOR_ID_BERKOM			0x0871
>  #define PCI_DEVICE_ID_BERKOM_A1T		0xffa1
>  #define PCI_DEVICE_ID_BERKOM_T_CONCEPT		0xffa2
> -- 
> 2.16.0
> 
