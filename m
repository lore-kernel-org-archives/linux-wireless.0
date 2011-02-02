Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:53503 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753703Ab1BBVkR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Feb 2011 16:40:17 -0500
Date: Wed, 2 Feb 2011 22:40:15 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Eric Fernandez <zeb@zebulon.org.uk>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Ralink RT2501/RT2573 USB Wireless Adapter crashes kernel 2.6.37
Message-ID: <20110202214014.GC28687@sig21.net>
References: <AANLkTi=bfq+2jev3YGCi0GwfZTkeKa9t2gfuQ8DkbB9p@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTi=bfq+2jev3YGCi0GwfZTkeKa9t2gfuQ8DkbB9p@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 02, 2011 at 07:57:15PM +0000, Eric Fernandez wrote:
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

No solution yet, but I'd like to point you to the
thread on the rt2x00-users list:
http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/2011-February/003109.html

Johannes
