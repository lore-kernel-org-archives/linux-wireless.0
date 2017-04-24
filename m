Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from one.firstfloor.org ([193.170.194.197]:55486 "EHLO
        one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1169322AbdDXMkU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Apr 2017 08:40:20 -0400
Date: Mon, 24 Apr 2017 05:40:17 -0700
From: Andi Kleen <andi@firstfloor.org>
To: Luca Coelho <luca@coelho.fi>
Cc: Andi Kleen <andi@firstfloor.org>, linuxwifi@intel.com,
        linux-wireless@vger.kernel.org
Subject: Re: 4.11-rc* iwlwifi instable
Message-ID: <20170424124017.GL22592@two.firstfloor.org> (sfid-20170424_144024_342304_E46A13FF)
References: <20170424005400.GK22592@two.firstfloor.org>
 <1493016631.31741.139.camel@coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1493016631.31741.139.camel@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > Any fixes/workarounds?
> 
> It seems that you are using an old firmware version:
> 
> > [70585.074356] iwlwifi 0000:03:00.0: Loaded firmware version: 21.302800.0
> 
> We have already published version -27 for 4.11 and you're still using
> version -21.  You can get the latest version from here:

Ok if the old firmware is not supported anymore how about a warning
or an error? 

> 
> https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/iwlwifi-7265D-27.ucode
> 
> We have loads of fixes and improvements in this new version.  And
> hopefully it will make your problems go away. ;)
> 
> Please try it and let me know how it goes.

This is -27, but the driver looks for -28

[12382.760671] iwlwifi 0000:03:00.0: Direct firmware load for
iwlwifi-7265D-28.ucode failed with error -2

Where is version -28?

-Andi
