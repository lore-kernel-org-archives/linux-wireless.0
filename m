Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:49572 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932125AbZLKMt5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2009 07:49:57 -0500
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1NJ4wd-000203-48
	for linux-wireless@vger.kernel.org; Fri, 11 Dec 2009 13:50:03 +0100
Received: from p4FF0D4EA.dip.t-dialin.net ([79.240.212.234])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 11 Dec 2009 13:50:03 +0100
Received: from Markus_Baier by p4FF0D4EA.dip.t-dialin.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 11 Dec 2009 13:50:03 +0100
To: linux-wireless@vger.kernel.org
From: Markus Baier <Markus_Baier@web.de>
Subject: Re: [RFC] mac80211: disallow bridging managed/adhoc interfaces
Date: Fri, 11 Dec 2009 12:39:47 +0000 (UTC)
Message-ID: <loom.20091211T133913-639@post.gmane.org>
References: <1258465585.3682.7.camel@johannes.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@...> writes:

> To avoid such mistakes in the future, disallow adding a
> wireless interface to a bridge.

Hello,
after the latest git pull my Linux AP stopt working
because the system is not allowed to add the wlan0
interface to a bridge.
I bisected the problem and ended up here.

So my question is, what is the right way to go after
this patch, to bridge the wireless with the wired
network interface on the AP, if bridging of the wlan
interface isn't allowed anymore?

Routing isn't an option here, because the two interfaces
should form one common boadcast domain.

It have worked fine all the time and the hostapd
documantaion at the linuxwireless.org 
(http://linuxwireless.org/en/users/Documentation/hostapd#Configuring_hostapd)
describes how to bridge both interfaces on the AP, too.

And from now on all that should be wrong?
Sorry, I am confused.

