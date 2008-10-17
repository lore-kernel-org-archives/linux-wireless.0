Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.197]:60905 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757062AbYJQTSR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Oct 2008 15:18:17 -0400
Subject: Re: 10-17-2008 Build issues - Intel 3945abg - Ubuntu Intrepid
From: Myk Robinson <myk.robinson@kingdomcomputer.info>
Reply-To: myk.robinson@kingdomcomputer.info
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1224256619.3007.0.camel@localhost.localdomain>
References: <1224248117.28593.3.camel@mobileOne>
	 <1224256619.3007.0.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 17 Oct 2008 14:12:58 -0500
Message-Id: <1224270778.6775.4.camel@mobileOne> (sfid-20081017_211838_841297_6975B921)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, thanks for the response.

The NetworkManager applet in the task bar positively identified both my
wireless devices. The Intel 3945abg and the secondary Belkin FD7050 USB
wireless, but both were "grayed out", or unselectable. No wireless
networks were shown. When this happened, running    sudo lshw -C network
in the console showed the wireless devices as "disabled", which explains
the grayed out part.. Just not sure why they were disabled and couldnt
figure how to enable them. 

 Also, when this occurred, trying to check by console with    sudo
iwlist wlan0 scan   yielded no results whatsoever. No error, no positive
results. The cursor just sat there blinking until I pressed Ctrl+C to
stop the process from running any further.

Immediately following this event, uninstalling the compat-wireless
driver and reverting back to the "out of the box" driver provided with
the distro allowed the connection to take place, but with regular
dropped connections.

Thanks,

-- 
--
Myk Robinson
Computer Support Specialist
Kingdom Computer Solutions
http://www.kingdomcomputer.info
myk.robinson@kingdomcomputer.info
(731) 616.5030



On Fri, 2008-10-17 at 11:16 -0400, Dan Williams wrote:
> On Fri, 2008-10-17 at 07:55 -0500, Myk Robinson wrote:
> > Hello-
> > 
> > Used your driver package in Ubuntu Hardy with no trouble at all. Testing
> > the Intrepid beta now. Before today, using the compat-wireless driver
> > for kernel 2.6.27, networkmanager showed all devices grayed out and
> 
> Hmm, what do you mean by "grayed out"?  What exactly did the menu say?
> 
> Dan
> 
> > iwlist scan would not work. Today's driver release has allowed me to
> > connect, but still drops the connection with intel 2945abg. Also, it
> > causes the touchpad to lose sync when the connection is dropped.
> > 
> > Here is a pastebin containing some dmesg info that might be helpful.
> > 
> > http://pastebin.com/f286ee42c
> > 
> > Thanks,
> > 
> 


