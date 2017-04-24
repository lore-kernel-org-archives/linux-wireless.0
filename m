Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from one.firstfloor.org ([193.170.194.197]:59792 "EHLO
        one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S972386AbdDXTF0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Apr 2017 15:05:26 -0400
Date: Mon, 24 Apr 2017 12:05:24 -0700
From: Andi Kleen <andi@firstfloor.org>
To: Luca Coelho <luca@coelho.fi>
Cc: Andi Kleen <andi@firstfloor.org>, linuxwifi@intel.com,
        linux-wireless@vger.kernel.org
Subject: Re: 4.11-rc* iwlwifi instable
Message-ID: <20170424190524.GP22592@two.firstfloor.org> (sfid-20170424_210530_430980_47245284)
References: <20170424005400.GK22592@two.firstfloor.org>
 <1493016631.31741.139.camel@coelho.fi>
 <20170424124017.GL22592@two.firstfloor.org>
 <1493059948.31741.161.camel@coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1493059948.31741.161.camel@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 24, 2017 at 09:52:28PM +0300, Luca Coelho wrote:
> On Mon, 2017-04-24 at 05:40 -0700, Andi Kleen wrote:
> > > > Any fixes/workarounds?
> > > 
> > > It seems that you are using an old firmware version:
> > > 
> > > > [70585.074356] iwlwifi 0000:03:00.0: Loaded firmware version: 21.302800.0
> > > 
> > > We have already published version -27 for 4.11 and you're still using
> > > version -21.  You can get the latest version from here:
> > 
> > Ok if the old firmware is not supported anymore how about a warning
> > or an error? 
> 
> It is expected to work with -21.  If it really doesn't work with it
> anymore, but works with the newer ones, I'll bump the minimum supported
> version so we'll print an error and bail out.

A warning may be better because it can be difficult to get a
new firmware if the network is dead. Or perhaps error + override
argument.

Even the old firmware works at least for some time.


> Hope this helps.  And please let me know if iwlwifi-7265D-27.ucode works
> for you.

So far it seems to work, and connects much faster than the old one.

Thanks,

-Andi
