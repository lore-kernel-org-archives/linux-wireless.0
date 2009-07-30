Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:42025 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109AbZG3IdJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 04:33:09 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1MWR4T-0005or-Rc
	for linux-wireless@vger.kernel.org; Thu, 30 Jul 2009 08:33:05 +0000
Received: from dslb-084-058-206-191.pools.arcor-ip.net ([84.58.206.191])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2009 08:33:05 +0000
Received: from acid-burn by dslb-084-058-206-191.pools.arcor-ip.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2009 08:33:05 +0000
To: linux-wireless@vger.kernel.org
From: Mladen Horvat <acid-burn@opendreambox.org>
Subject: Re: zd1211rw couldn't load firmware. Error number -145 with Kernel =?utf-8?b?CTIuNi4zMA==?=
Date: Thu, 30 Jul 2009 08:32:52 +0000 (UTC)
Message-ID: <loom.20090730T083104-184@post.gmane.org>
References: <loom.20090729T111851-320@post.gmane.org>  <200907291350.27426.hs4233@mail.mn-solutions.de>  <loom.20090729T120228-576@post.gmane.org> <3ace41890907292043rad37b63y12cacfeb713dc575@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hin-Tak Leung <hintak.leung@...> writes:
> 
> I noticed you have a particularly slow CPU (33MHz?)... the vendor
> driver has some preculiar coding to interrupt some operations to
> prevent deadlocks; I wonder if the rw driver inherit that? One of the
> patches in my patch set for the vendor driver put a delay right after
> firmware load;
> it might be appropriate to add something similiar to the rw driver.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@...
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


Hi,

its an 300 MHz MIPS Prozessor with usb 1.1 but if you point me to the right
place to patch i can test this.

Tech. Tedails are here: http://www.dream-multimedia-tv.de/dm-7025#tech_details

Regards

