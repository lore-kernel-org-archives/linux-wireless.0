Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:59427 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880AbZDVM4W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2009 08:56:22 -0400
Subject: Re: Problem with IEEE80211_MONITORING_INTERVAL
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>,
	Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <1240402497.21978.12.camel@johannes.local>
References: <1239837672.11795.46.camel@violet>
	 (sfid-20090416_012123_293746_81110E23)  <1239875168.9737.10.camel@johannes.local>
	 <1240247636.5260.11.camel@localhost.localdomain>
	 <1240248008.4632.10.camel@johannes.local>
	 <1240248385.5260.15.camel@localhost.localdomain>
	 (sfid-20090420_192718_984250_38AB6869)  <1240248773.4632.13.camel@johannes.local>
	 <1240343775.3327.3.camel@localhost.localdomain>
	 <1240348792.17388.46.camel@johannes.local>
	 <1240385542.3404.5.camel@localhost.localdomain>
	 <1240391029.20308.1.camel@johannes.local>
	 <1240391541.10072.2.camel@localhost.localdomain>
	 <1240393523.21978.1.camel@johannes.local>
	 <1240399028.10072.14.camel@localhost.localdomain>
	 <1240401205.3313.3.camel@localhost.localdomain>
	 <1240402497.21978.12.camel@johannes.local>
Content-Type: text/plain
Date: Wed, 22 Apr 2009 13:56:18 +0100
Message-Id: <1240404978.3378.4.camel@localhost.localdomain> (sfid-20090422_145627_456765_853E1B8D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> > > > I just don't see anything in the kernel that would ever set the
> > > > interface down, as indicated there.
> > 
> > so I have installed the latest wireless-testing kernel now.
> > 
> > CTRL-EVENT-SCAN-RESULTS 
> > Trying to authenticate with 00:1f:f3:fa:58:59 (SSID='HON Circle' freq=2452 MHz)
> > Trying to associate with 00:1f:f3:fa:58:59 (SSID='HON Circle' freq=2452 MHz)
> > Could not read SSID from driver.
> > WPA: No SSID info found (msg 1 of 4).
> > Associated with 00:1f:f3:fa:58:59
> > WPA: Key negotiation completed with 00:1f:f3:fa:58:59 [PTK=CCMP GTK=CCMP]
> > CTRL-EVENT-CONNECTED - Connection to 00:1f:f3:fa:58:59 completed (auth) [id=1 id_str=]
> > 
> > <starting dhclient wlan0 now>
> > 
> > CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
> > l2_packet_receive - recvfrom: Network is down
> 
> I still don't understand this. Is the AP disconnecting you? Are you
> running NM on the side?

I am not running NM. Just plain wpa_supplicant and dhclient. However I
do have a suspicion that this is faulty firmware on my card and that
this messes things up. I had been doing testing with WiMAX and I run
into some issues and was speculating about interoperability. I started
testing with unreleased firmware. That would indeed explain why I don't
see this kind of issues with any other dongle I attached to the laptop.
I will reboot into a kernel that uses the official firmware.

Regards

Marcel


