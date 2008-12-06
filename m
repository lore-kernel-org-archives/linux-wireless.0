Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail3.brikks.com ([82.209.166.4]:4849 "EHLO smtp.bredband2.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751963AbYLFTWj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Dec 2008 14:22:39 -0500
Date: Sat, 6 Dec 2008 20:22:37 +0100
From: Mats Johannesson <spamcan1@abrasax.se>
To: Sujith <m.sujith@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [ath9k] 2.6.28-rc7-wl Kernel panic when "iwlist ath0 scan" as
 root
Message-ID: <20081206202237.578b3783@loke.fish.not> (sfid-20081206_202331_663096_06A293D1)
In-Reply-To: <18746.48068.593834.660064@localhost.localdomain>
References: <20081206113406.734f1d94@loke.fish.not>
	<18746.37273.989918.333164@localhost.localdomain>
	<20081206180537.717d1791@loke.fish.not>
	<18746.48068.593834.660064@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 6 Dec 2008 23:22:04 +0530 Sujith wrote:
> Mats Johannesson wrote:
> > It fixes the kernel panic with root "iwlist ath0 scan" but after
> > that the network dies without a sign of any kind (iwlist, ifconfig
> > etc is normal, nothing in logs). Tried several times. Boot -> ping
> > local and remote machine OK -> "iwlist ath0 scan" -> ping
> > nonfunctional: 'no route to host' or some such message.
> > 
> 
> Ok, thanks for testing.
> 
> Can you check if this patch makes the connection stable ?
> Please apply on top of the earlier patch.

Sorry to say, no change. After root scan telnet gives "no route to
host" and ping just reports 100% packet loss. But iwconfig keeps
updating its info regarding link quality and signal strength, like:
Link Quality=82/100  Signal level:-42 dBm

/Mats
