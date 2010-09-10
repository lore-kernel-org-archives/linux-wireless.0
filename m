Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:34126 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258Ab0IJGzH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Sep 2010 02:55:07 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1OtxVo-0004ar-BJ
	for linux-wireless@vger.kernel.org; Fri, 10 Sep 2010 08:55:04 +0200
Received: from pool-96-253-143-208.sttlwa.dsl-w.verizon.net ([96.253.143.208])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 10 Sep 2010 08:55:04 +0200
Received: from yuhongbao_386 by pool-96-253-143-208.sttlwa.dsl-w.verizon.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 10 Sep 2010 08:55:04 +0200
To: linux-wireless@vger.kernel.org
From: Yuhong Bao <yuhongbao_386@hotmail.com>
Subject: Re: [ANN] Full-source Broadcom wireless driver for 11n chips
Date: Fri, 10 Sep 2010 06:49:14 +0000 (UTC)
Message-ID: <loom.20100910T084604-390@post.gmane.org>
References: <20100908150322.17dac9c3@nehalam> <20100908225132.GA12490@kroah.com> <4C88F8CE.5090708@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Henry Ptasinski <henryp@...> writes:

> 
> Broadcom would like to announce the initial release of a fully-open
> Linux driver for it's latest generation of 11n chipsets.  The driver,
> while still a work in progress, is released as full source and uses the
> native mac80211 stack.   It supports multiple current chips (BCM4313,
> BCM43224, BCM43225) as well as providing a framework for supporting
> additional chips in the future, including mac80211-aware embedded chips.
>    The README and TODO files included with the sources provide more
> details about the current feature set, known issues, and plans for
> improving the driver.
> 
> The driver is currently available in staging-next git tree, available at:
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-next-2.6.git
> 
> in the drivers/staging/brcm80211 directory.

This is limited to newer chips. Can you at least authorize redistribution of
firmware blobs for older chips so that b43-fwcutter won't be needed anymore? I
have such a laptop myself with one of the older chips, and I remember the pains
of having to download it after booting from a LiveCD.




