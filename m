Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout5.parasun.com ([204.174.16.215]:49774 "EHLO
	mailout5.parasun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406AbXFJPjI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jun 2007 11:39:08 -0400
Date: Sun, 10 Jun 2007 10:21:32 -0500 (CDT)
From: Jeff Williams <angelbane@ou.edu>
To: David Planella <david.planella@googlemail.com>
cc: acx100-devel@lists.sourceforge.net, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: The future of the TI ACX wireless driver
In-Reply-To: <1d9d9b240706100735k374b5800ie64370e1e9bff1ef@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0706101014520.2936@dulcinea>
References: <1d9d9b240706100735k374b5800ie64370e1e9bff1ef@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> * Mac80211 driver, which uses the seemingly
> soon-to-be-included-in-kernel mac80211 stack, available on the
> wireless-dev tree (the stack, not the driver).
> This release is only available here [2] and needs some work before
> being included in wireless-dev, since it was released at the time when
> mac80211 was still called d80211. In any case, having had a quick look
> at the code, I believe that replacing the d80211.h header reference to
> mac80211.h and maybe refactoring some functions might be all what is
> needed for an initial compilation. Note that I haven't got any
> previous driver or kernel module development experience, so I might be
> wrong here. What would also be needed is to merge all changes from the
> softmac and plain drivers.
>
You can find a updated-as-of-last-month mac80211 pci driver at 
http://airgo.wdwconsulting.net/acx-mac80211-20070510.patch.bz2
it may or may not work, it compiles, it responds with aps to iwlist sc. 
Enabling ACX_MAC80211_USB will cause the build to fail. I'll be happy to 
take patches and bug reports.

thanks,

Jeff Williams
