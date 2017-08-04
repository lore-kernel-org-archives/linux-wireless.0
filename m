Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60038 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752242AbdHDQHf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 4 Aug 2017 12:07:35 -0400
Date: Fri, 4 Aug 2017 18:07:31 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, kvalo@codeaurora.org,
        chunkeey@googlemail.com, linux-wireless@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] wireless: move prism54 out to staging
Message-ID: <20170804160731.GJ27873@wotan.suse.de> (sfid-20170804_180751_044913_3ECF6CD0)
References: <20170803235937.8604-1-mcgrof@kernel.org>
 <20170803235937.8604-2-mcgrof@kernel.org>
 <20170804004215.GA26035@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170804004215.GA26035@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 03, 2017 at 05:42:15PM -0700, Greg KH wrote:
> On Thu, Aug 03, 2017 at 04:59:36PM -0700, Luis R. Rodriguez wrote:
> > prism54 is deprecated in favor of the p54pci device driver. Although
> > only *one soul* had reported issues with it long ago Linux most Linux
> > distributions these days just disable the device driver given the
> > conflicts with the PCI IDs of p54pci and the *very* unlikely situation
> > of folks really need this driver anymore.
> > 
> > Before trying to due away with prism54 once more stuff it into staging,
> > which is our hospice for dying drivers.
> > 
> > Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
> > ---
> >  MAINTAINERS                                          |  4 ++--
> >  drivers/net/wireless/intersil/Kconfig                | 20 --------------------
> >  drivers/net/wireless/intersil/Makefile               |  1 -
> >  drivers/staging/Kconfig                              |  2 ++
> >  drivers/staging/Makefile                             |  1 +
> 
> Can I get a TODO file that says it will be deleted in a kernel release
> or two so don't worry about touching anything in these files?

Sure, will respin with it.

  Luis
