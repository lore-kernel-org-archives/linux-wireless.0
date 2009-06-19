Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:28117 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbZFSVZ5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Jun 2009 17:25:57 -0400
Received: by ey-out-2122.google.com with SMTP id d26so293106eyd.37
        for <linux-wireless@vger.kernel.org>; Fri, 19 Jun 2009 14:25:58 -0700 (PDT)
Message-ID: <4A3C0265.4050902@gmail.com>
Date: Fri, 19 Jun 2009 22:25:57 +0100
From: Dave <kilroyd@googlemail.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
Subject: Re: [PATCH 21/23] orinoco: convert scanning to cfg80211
References: <1245363695-8289-1-git-send-email-kilroyd@googlemail.com> <1245363695-8289-22-git-send-email-kilroyd@googlemail.com> <20090619173541.GC2753@tuxdriver.com> <4A3BD06D.7080702@gmail.com> <20090619180233.GD2753@tuxdriver.com>
In-Reply-To: <20090619180233.GD2753@tuxdriver.com>
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> On Fri, Jun 19, 2009 at 06:52:45PM +0100, Dave wrote:
>> John W. Linville wrote:
>>> Hmmm...please do try to compile test patches before posting! :-)

>> Compile? I'm running it! (and sparse didn't complain either)
>>
>> I'll go have a look see what's special on my end. I'm guessing no SMP or
>> something.
> 
> Haha...yeah, that's probably it...
> 
>> Would you like the series/patch reposted including this fix?
> 
> No, I've got it fixed.

Thanks.

It looks like I can enable DEBUG_SPINLOCKS to highlight this - but it's
expensive to keep turning that on and off.

Alternatively I could submit a patch to either add typechecks to
spinlock_api_up.h or convert the #defines to inlines.

Sounds a bit too controversial for me, so I'll just try to be vigilant
for now.


Regards,

Dave.
