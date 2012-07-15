Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52831 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751422Ab2GOQzI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Jul 2012 12:55:08 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1SqS65-0000yA-Ud
	for linux-wireless@vger.kernel.org; Sun, 15 Jul 2012 18:55:06 +0200
Received: from c-174-63-83-0.hsd1.ma.comcast.net ([174.63.83.0])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 15 Jul 2012 18:55:05 +0200
Received: from yochaigal by c-174-63-83-0.hsd1.ma.comcast.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 15 Jul 2012 18:55:05 +0200
To: linux-wireless@vger.kernel.org
From: Yochai Gal <yochaigal@gmail.com>
Subject: Re: Frequent disconnects with ath9k
Date: Sun, 15 Jul 2012 16:46:22 +0000 (UTC)
Message-ID: <loom.20120715T184407-940@post.gmane.org> (sfid-20120715_185553_620418_8E5AD2ED)
References: <20120712065805.GA15967@miek.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Miek Gieben <miek@...> writes:

> 
> Hello,
> 
> I'm experiencing frequent disconnects with the ath9k driver and the 
> AR9485 wireless adapter. This Ubuntu bug report has more information:
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/773154
> 

I am having the same exact issue (/var/log/kern.log shows the same output on
ubunut 12.04 as well) especially when disconnecting from a power source.
Disabling power management doesn't seem to make much of a difference, nor does
updating compat-wireless.


