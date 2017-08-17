Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48398 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752027AbdHQQz2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Aug 2017 12:55:28 -0400
Date: Thu, 17 Aug 2017 09:55:30 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, chunkeey@googlemail.com,
        kvalo@codeaurora.org
Subject: Re: [PATCH v2 1/2] wireless: move prism54 out to staging
Message-ID: <20170817165530.GA32640@kroah.com> (sfid-20170817_185543_282146_C71209E8)
References: <20170807223011.21926-1-mcgrof@kernel.org>
 <20170807223011.21926-2-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170807223011.21926-2-mcgrof@kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 07, 2017 at 03:30:10PM -0700, Luis R. Rodriguez wrote:
> prism54 is deprecated in favor of the p54pci device driver. Although
> only *one soul* had reported issues with it long ago Linux most Linux
> distributions these days just disable the device driver given the
> conflicts with the PCI IDs of p54pci and the *very* unlikely situation
> of folks really need this driver anymore.
> 
> Before trying to due away with prism54 once more stuff it into staging,
> which is our hospice for dying drivers.
> 
> Acked-by: Kalle Valo <kvalo@codeaurora.org>
> Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>

Did you build this?

I get the following error:

drivers/staging/Kconfig:117: can't open file "drivers/staging/prism54/Kconfig"

Can you fix this and _test it_ and resend it?

thanks,

greg k-h
