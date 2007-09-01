Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:55918 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751273AbXIAJrZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Sep 2007 05:47:25 -0400
Message-ID: <46D9352B.4060606@garzik.org>
Date: Sat, 01 Sep 2007 05:47:23 -0400
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: borkage in 2.6.23-rc4-mm1
References: <20070831211603.083dfed2.akpm@linux-foundation.org>
In-Reply-To: <20070831211603.083dfed2.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andrew Morton wrote:
> Am seeing random crap like this:
> 
> Aug 31 20:57:46 sony dhclient: DHCPREQUEST on eth1 to 255.255.255.255 port 67
> Aug 31 20:57:51 sony dhclient: DHCPREQUEST on eth1 to 255.255.255.255 port 67
> Aug 31 20:57:56 sony dhclient: dhclient(4537) is already running - exiting. 
> Aug 31 20:57:56 sony dhclient: exiting.
> Aug 31 20:58:05 sony dhclient: DHCPDISCOVER on eth1 to 255.255.255.255 port 67 interval 4
> Aug 31 20:58:07 sony kernel: ipw2200: Firmware error detected.  Restarting.
> Aug 31 20:58:09 sony dhclient: DHCPDISCOVER on eth1 to 255.255.255.255 port 67 interval 7
> Aug 31 20:58:16 sony dhclient: DHCPDISCOVER on eth1 to 255.255.255.255 port 67 interval 14
> Aug 31 20:58:16 sony dhclient: DHCPOFFER from 192.168.2.1
> Aug 31 20:58:16 sony dhclient: DHCPREQUEST on eth1 to 255.255.255.255 port 67
> Aug 31 20:58:20 sony dhclient: DHCPREQUEST on eth1 to 255.255.255.255 port 67
> Aug 31 20:58:20 sony dhclient: DHCPACK from 192.168.2.1
> Aug 31 20:58:20 sony NET[4946]: /sbin/dhclient-script : updated /etc/resolv.conf
> Aug 31 20:58:20 sony dhclient: bound to 192.168.2.5 -- renewal in 125513 seconds.
> Aug 31 20:59:45 sony ntpd[2059]: sendto(192.36.143.234): Invalid argument
> Aug 31 20:59:51 sony ntpd[2059]: sendto(193.225.14.163): Invalid argument
> Aug 31 20:59:52 sony ntpd[2059]: sendto(193.60.199.78): Invalid argument
> Aug 31 21:01:31 sony kernel: ipw2200: Firmware error detected.  Restarting.
> Aug 31 21:01:54 sony ntpd[2059]: sendto(192.36.143.234): Invalid argument
> Aug 31 21:01:59 sony ntpd[2059]: sendto(193.225.14.163): Invalid argument
> Aug 31 21:02:02 sony ntpd[2059]: sendto(193.60.199.78): Invalid argument
> Aug 31 21:04:04 sony ntpd[2059]: sendto(192.36.143.234): Invalid argument
> Aug 31 21:04:05 sony kernel: ipw2200: Firmware error detected.  Restarting.
> Aug 31 21:04:07 sony ntpd[2059]: sendto(193.225.14.163): Invalid argument
> Aug 31 21:04:12 sony ntpd[2059]: sendto(193.60.199.78): Invalid argument
> Aug 31 21:05:21 sony kernel: ipw2200: Firmware error detected.  Restarting.

I see this on my Sony Vaio with older, non-mm kernels too.  Incredibly 
frustrating, as it seems to be related to the phase of the moon. 
Sometimes a reboot gets my wireless working, sometimes it doesn't.

	Jeff



