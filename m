Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60640 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728701AbeH2TSO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Aug 2018 15:18:14 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Dave Young <dyoung@redhat.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Intel Wireless 8265/8275 (rev 78) issue
References: <20180829065442.GA3488@dhcp-128-65.nay.redhat.com>
Date: Wed, 29 Aug 2018 18:20:44 +0300
In-Reply-To: <20180829065442.GA3488@dhcp-128-65.nay.redhat.com> (Dave Young's
        message of "Wed, 29 Aug 2018 14:54:42 +0800")
Message-ID: <87bm9ltd0z.fsf@purkki.adurom.net> (sfid-20180829_172105_609607_F1240AF7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dave Young <dyoung@redhat.com> writes:

> Not sure if this is a known issue, I'm seeing this with latest mainline
> kernel on Fedora rawhide.
>
> The wireless networking is not stable, I can not access network any more after
> downloading some big files or just browsing some web pages about some
> time.  I do not see this when I work in office.  So this maybe relate to
> wireless router.
>
> "Can not access network" means ping timeout, can not open web pages etc.
> But the wireless connection looks normal at least from the
> NetworkManager icon it is still connected.
>
> The router I used at home is an old ASUS WL520gc.  I can confirm I can
> reproduce this with another ASUA router WL-500gP v2 
>
> My laptop model is Thinkpad T480s.  It is painful I can only use
> wireless,  any hints how to make it work will be appreciated!

Not everyone use Fedora so providing info which kernel versions work and
which don't would help. Does Fedora usually add their own patches/hacks
to kernel or is it a stock release from kernel.org? Also have you
verified that this isn't a problem in user space, for example by
downgrading the kernel to an older version?

-- 
Kalle Valo
