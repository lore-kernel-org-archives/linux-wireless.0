Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:37984 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395Ab3ARRNU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jan 2013 12:13:20 -0500
Message-ID: <1358529142.6252.115.camel@cumari.coelho.fi> (sfid-20130118_181323_337452_246D26ED)
Subject: Re: wl12xx : ping to wlan0(Station) doesn't work after creating
 wlan1 interface
From: Luciano Coelho <coelho@ti.com>
To: Girish Bn <Girish.BN@lnties.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 18 Jan 2013 19:12:22 +0200
In-Reply-To: <1358528900.6252.113.camel@cumari.coelho.fi>
References: <45566970CF58C74CB52107862E0541CD1D1EB092@POCITMSEXMB02.LntUniverse.com>
	 <1358528900.6252.113.camel@cumari.coelho.fi>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-01-18 at 19:08 +0200, Luciano Coelho wrote:
> Hi Girish,
> 
> On Fri, 2013-01-18 at 15:17 +0000, Girish Bn wrote:
> > The issue is, after starting P2P GO, may be after 2 to 3mins, the ping
> > operation from any other PC/Laptop which is connected to the same AP
> > as Station(wlan0) fails.
> 
> Do you mean that before 2 to 3 mins elapse the ping works fine and then
> stops working?
> 
> > However, if I start the ping from my device to the PC/Laptop, ping
> > operation succeeds and also ping from other side works(which failed
> > before).
> 
> Seems to be because the device is sleeping or failing to wake up from
> power saving.
> 
> 
> > We suspect some issue while creating the multi-role interface(wlan1
> > for P2P GO) is causing the problem.
> 
> Can you send some wl12xx logs so we can see what is going on?


BTW, this page seems to describe how to do what you're trying to do.  

http://processors.wiki.ti.com/index.php/OMAP_Wireless_Connectivity_NLCP_Multi_Role_Configuration#Scenario_2:_wlan0_configured_as_Station_.26_wlan1_configured_as_aGO_.28WiFi_Direct_Group_Owner.29

Did you see it? Maybe you can find some hints on what is going wrong.

--
Luca.

