Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757524Ab2AROHI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jan 2012 09:07:08 -0500
Date: Wed, 18 Jan 2012 15:07:05 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Mike Edenfield <kutulu@kutulu.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: iwl3945: disassociating from current AP on rescan with kernels >
 3.0
Message-ID: <20120118140702.GA6628@redhat.com> (sfid-20120118_150712_574206_2CADC9CC)
References: <012e01ccc67b$bfe90be0$3fbb23a0$@kutulu.org>
 <20120105113939.GC2222@redhat.com>
 <000301ccccf7$0c9fa800$25def800$@kutulu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <000301ccccf7$0c9fa800$25def800$@kutulu.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 06, 2012 at 11:44:32PM -0500, Mike Edenfield wrote:
> > Problem looks more like software scanning issue, which we enable
> > by default on 2.6.39. Can you check if disable_hw_scan=0 module
> > parameter helps?
> 
> Wow, this appears to have fixed my problem, at least so far. I'm a little
> worried because I had the module parameter set /on/ (disable_hw_scan=1) from
> way back when I first built this laptop and couldn't stay connected to our
> work LAN. I didn't realize that was on by default. I've switched it to be
> off now and hopefully it won't be a problem.

So on one AP you have to do disable_hw_scan=1 to make things work,
and on other one you have to do disable_hw_scan=0 ? Ehh bugger.
Since bugzilla.kernel.org is back again, please report these problem
there. Once you'll open the bug reports, I'll ask you for more info.
Before opening bug reports, please check if by chance problems are
not fixed in the latest kernel version i.e. 3.3-rc1 

Thanks
Stanislaw
