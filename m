Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:59236 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758546AbXHGWXB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Aug 2007 18:23:01 -0400
Message-ID: <46B8F0C3.6030409@garzik.org>
Date: Tue, 07 Aug 2007 18:22:59 -0400
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Please pull 'libertas-upstream' branch of wireless-2.6
References: <20070806203005.GL6442@tuxdriver.com>
In-Reply-To: <20070806203005.GL6442@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> Got a big patch bomb from the libertas guys.  I tried to cherry-pick
> some of the fixes for 2.6.23, but they either were fixes to problems
> in new code or all the code cleanups made them difficult for me to
> intelligently backport.
> 
> So, this is intended for 2.6.24...
> 
> ---
> 
> The following changes since commit d4ac2477fad0f2680e84ec12e387ce67682c5c13:
>   Linus Torvalds (1):
>         Linux 2.6.23-rc2
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git libertas-upstream

This is missing the patch.  I looked at it locally, but please do send a 
patch for review with each push, no matter how big.

pulled into #upstream


