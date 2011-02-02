Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:32988 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756411Ab1BCNpX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Feb 2011 08:45:23 -0500
Date: Wed, 2 Feb 2011 15:10:41 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Eric Fernandez <zeb@zebulon.org.uk>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Ralink RT2501/RT2573 USB Wireless Adapter crashes kernel 2.6.37
Message-ID: <20110202201040.GC2500@tuxdriver.com>
References: <AANLkTi=bfq+2jev3YGCi0GwfZTkeKa9t2gfuQ8DkbB9p@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTi=bfq+2jev3YGCi0GwfZTkeKa9t2gfuQ8DkbB9p@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 02, 2011 at 07:57:15PM +0000, Eric Fernandez wrote:
> Hi,
> 
> This follows the issue I reported two days ago. I have had two crashes
> tonight using kernel 2.6.37-5 on Archlinux 64. Unfortunately, this
> leads to no log in the kernel log whatsoever. The machine freezes
> completely, if sound is played it loops. I cannot confirm if I can ssh
> to the box (have only one computer), however, this is linked to the
> usage of my wireless adapter, since switching to wired ethernet does
> not lead to this issue.
> One thing: when I reboot (hard reset), I need to unplug my adapter so
> that it works after login. Otherwise, it seems to associate fine with
> the router, but strangely I cannot download anything. Using gkrellm, I
> can see that it sends some packets to the router at regular interval,
> but does not download. I don't know if this is significant and if this
> can help identify the issue.
> 
> I would be very keen to help, but without log messages I am stuck. Any
> suggestions?
> 
> Thanks in advance.
> Eric

Can you use netconsole over the wired link to capture a backtrace
when the lock-up occurs?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
