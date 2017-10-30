Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:48617 "EHLO
        mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932252AbdJ3RDM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Oct 2017 13:03:12 -0400
Received: by mail-io0-f178.google.com with SMTP id j17so28736246iod.5
        for <linux-wireless@vger.kernel.org>; Mon, 30 Oct 2017 10:03:12 -0700 (PDT)
Date: Mon, 30 Oct 2017 10:03:08 -0700
From: Brian Norris <briannorris@chromium.org>
To: Ganapathi Bhat <gbhat@marvell.com>
Cc: "linux-firmware@kernel.org" <linux-firmware@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        James Cao <jcao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        Karthik Doddayennegere Ananthapadmanabha <karthida@marvell.com>
Subject: Re: pull-request mwifiex-firmware 2017-10-30
Message-ID: <20171030170308.GA80479@google.com> (sfid-20171030_180325_412126_5DC9CE9C)
References: <9370b3238604464b85bf0c4f8ac79c71@SC-EXCH02.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <9370b3238604464b85bf0c4f8ac79c71@SC-EXCH02.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 30, 2017 at 02:13:31PM +0000, Ganapathi Bhat wrote:
> The following changes since commit e0494e95192ac5329989f4d128cf95c417d618cc:
> 
>   linux-firmware: update Marvell PCIe-USB8997 firmware image (2017-08-01 23:55:30 +0530)
> 
> are available in the git repository at:
> 
>   git://git.marvell.com/mwifiex-firmware.git
> 
> for you to fetch changes up to c5bed1294f6cf6bf6cbef612204f96361a3c2539:
> 
>   linux-firmware: update Marvell PCIe-USB8997 firmware image (2017-10-30 19:23:05 +0530)

Hooray, your git server is working again! And FWIW:

Tested-by: Brian Norris <briannorris@chromium.org>

But quoting your patch...

> --- a/WHENCE
> +++ b/WHENCE
> @@ -757,7 +757,7 @@ File: mrvl/pcieuart8997_combo_v4.bin
>  Version: 16.68.1.p70
>  
>  File: mrvl/pcieusb8997_combo_v4.bin
> -Version: 16.68.1.p133
> +Version: 16.68.1.p40

This says .p40, whereas the commit message (and the version tag within the
firmware) says p140. I think you're missing a "1".

>  
>  File: mrvl/pcie8997_wlan_v4.bin
>  Version: 16.68.1.p97


Brian

> 
> ----------------------------------------------------------------
> Ganapathi Bhat (1):
>       linux-firmware: update Marvell PCIe-USB8997 firmware image
> 
> WHENCE                        |   2 +-
> mrvl/pcieusb8997_combo_v4.bin | Bin 620800 -> 622532 bytes
> 2 files changed, 1 insertion(+), 1 deletion(-)
