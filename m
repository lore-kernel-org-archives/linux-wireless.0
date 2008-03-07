Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:43063 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757245AbYCGL1L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2008 06:27:11 -0500
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1JXajA-0003qR-Sa
	for linux-wireless@vger.kernel.org; Fri, 07 Mar 2008 11:27:05 +0000
Received: from dsl081-096-236.den1.dsl.speakeasy.net ([64.81.96.236])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 07 Mar 2008 11:27:04 +0000
Received: from gmane by dsl081-096-236.den1.dsl.speakeasy.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 07 Mar 2008 11:27:04 +0000
To: linux-wireless@vger.kernel.org
From: Joe Wise <gmane@joewise.com>
Subject: Re: can't bring up wlan0
Date: Fri, 7 Mar 2008 11:26:50 +0000 (UTC)
Message-ID: <loom.20080307T112021-548@post.gmane.org> (sfid-20080307_112731_744348_CBD081F4)
References: <20080223153142.da9fc4e4.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andrew Morton <akpm@...> writes:

> 
> 
> I've been noticing this for a week or two but hadn't paid it much attention
> amongst the storm of other bugs.
> 
> This is on the t61p laptop, running FC8.
> 

Ok, I'm a little embarrassed to say this.  Ok, alot embarrassed.  I also have a
t61 laptop with this same card in it and I messed around for hours and hours
trying to get it working, consistently coming up with this same issue. 
Ultimately, I gave up on it, hoping it would work in a later kernel.

Well, turns out there's a wifi kill switch on the t61 laptops (and probably many
others).  On the t61's, its a small slider switch on the left side of the front
edge of the palm rest.  Right next to the firewire port.  When slid to the left,
the internal wifi radio is turned off.  It's still detected by the kernel, and
the iwl4695 module loads without issue, but with that switch slid to the left,
ifconfig will fail as specified here.  I was not able to figure out how to get
the switch to slide back to the right.  I had to remove the palmrest and mess
with it internally to get it to slide back over.  Once that was done, ifconfig
worked just find and I'm kismetting like crazy now, too.  Enjoy!

-Joe

