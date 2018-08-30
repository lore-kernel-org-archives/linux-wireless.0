Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:45004 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725996AbeH3JDK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 Aug 2018 05:03:10 -0400
Date: Thu, 30 Aug 2018 13:02:44 +0800
From: Dave Young <dyoung@redhat.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Intel Wireless 8265/8275 (rev 78) issue
Message-ID: <20180830050244.GA2307@dhcp-128-65.nay.redhat.com> (sfid-20180830_070306_102597_84EEAFCF)
References: <20180829065442.GA3488@dhcp-128-65.nay.redhat.com>
 <87bm9ltd0z.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87bm9ltd0z.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/29/18 at 06:20pm, Kalle Valo wrote:
> Dave Young <dyoung@redhat.com> writes:
> 
> > Not sure if this is a known issue, I'm seeing this with latest mainline
> > kernel on Fedora rawhide.
> >
> > The wireless networking is not stable, I can not access network any more after
> > downloading some big files or just browsing some web pages about some
> > time.  I do not see this when I work in office.  So this maybe relate to
> > wireless router.
> >
> > "Can not access network" means ping timeout, can not open web pages etc.
> > But the wireless connection looks normal at least from the
> > NetworkManager icon it is still connected.
> >
> > The router I used at home is an old ASUS WL520gc.  I can confirm I can
> > reproduce this with another ASUA router WL-500gP v2 
> >
> > My laptop model is Thinkpad T480s.  It is painful I can only use
> > wireless,  any hints how to make it work will be appreciated!
> 
> Not everyone use Fedora so providing info which kernel versions work and
> which don't would help. Does Fedora usually add their own patches/hacks
> to kernel or is it a stock release from kernel.org? Also have you
> verified that this isn't a problem in user space, for example by
> downgrading the kernel to an older version?

I sometimes use self-built upstream kernel, sometimes use Fedora
kernels, none of them works well.  Since I got this new laptop about
less two months, this issue happens from the very beginning, not sure if
there's any old release works for me.

Thanks
Dave
