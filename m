Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:41233 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757548Ab0HETfY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Aug 2010 15:35:24 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Oh6Do-0006Bh-FR
	for linux-wireless@vger.kernel.org; Thu, 05 Aug 2010 21:35:21 +0200
Received: from 216-31-249-246.static-ip.telepacific.net ([216.31.249.246])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 05 Aug 2010 21:35:20 +0200
Received: from graman by 216-31-249-246.static-ip.telepacific.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 05 Aug 2010 21:35:20 +0200
To: linux-wireless@vger.kernel.org
From: Gopal Raman <graman@arubanetworks.com>
Subject: Re: ath5k : Channel 149 thru 161 not working with =?utf-8?b?CWNvbXBhdC13aXJlbGVzcy0yLjYuMzQuMQ==?=
Date: Thu, 5 Aug 2010 19:35:11 +0000 (UTC)
Message-ID: <loom.20100805T213232-313@post.gmane.org>
References: <loom.20100805T020816-848@post.gmane.org> <loom.20100805T025322-892@post.gmane.org> <AANLkTikcWNzO7tbheeJp=NYMsY=Kh983DrR2P=OKCJ5p@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jonathan Guerin <jonathan@...> writes:

> 
> I found issues when switching to ath5k where the wrong antenna was selected.
> 
> Try forcing the antenna (especially if you don't have 1 of them
> plugged in) and see how you go:
> http://www.mail-archive.com/ath5k-devel-xDcbHBWguxEUs3QNXV6qNA <at> 
public.gmane.org/msg02979.html
> 

Hi
I could not find the sysfs node where antenna control is being set in the 
compat-wireless-2.6.34.1 driver. Maybe that was taken out ? To rule out 
problems with my NIC card can anyone confirm that with this driver we can 
receive frames on channels 149 thru 161 ?
Thanks much

-gopal

