Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59234 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751866AbdHDAmS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Aug 2017 20:42:18 -0400
Date: Thu, 3 Aug 2017 17:42:15 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: kvalo@codeaurora.org, chunkeey@googlemail.com,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] wireless: move prism54 out to staging
Message-ID: <20170804004215.GA26035@kroah.com> (sfid-20170804_024232_516888_BD3524CE)
References: <20170803235937.8604-1-mcgrof@kernel.org>
 <20170803235937.8604-2-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170803235937.8604-2-mcgrof@kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 03, 2017 at 04:59:36PM -0700, Luis R. Rodriguez wrote:
> prism54 is deprecated in favor of the p54pci device driver. Although
> only *one soul* had reported issues with it long ago Linux most Linux
> distributions these days just disable the device driver given the
> conflicts with the PCI IDs of p54pci and the *very* unlikely situation
> of folks really need this driver anymore.
> 
> Before trying to due away with prism54 once more stuff it into staging,
> which is our hospice for dying drivers.
> 
> Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
> ---
>  MAINTAINERS                                          |  4 ++--
>  drivers/net/wireless/intersil/Kconfig                | 20 --------------------
>  drivers/net/wireless/intersil/Makefile               |  1 -
>  drivers/staging/Kconfig                              |  2 ++
>  drivers/staging/Makefile                             |  1 +

Can I get a TODO file that says it will be deleted in a kernel release
or two so don't worry about touching anything in these files?

thanks,

greg k-h
