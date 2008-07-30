Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:56259 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752684AbYG3P0r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 11:26:47 -0400
Message-ID: <48908836.8020609@lwfinger.net> (sfid-20080730_172650_601596_154F1490)
Date: Wed, 30 Jul 2008 10:26:46 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: rschneiderman@yahoo.com
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: broadcom 4306 rev. 3 uses b43 instead of b43legacy
References: <30761.30943.qm@web52411.mail.re2.yahoo.com>
In-Reply-To: <30761.30943.qm@web52411.mail.re2.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Richard Schneiderman wrote:
> Larry,
> Thanks for the reply. Ok, I read the documentation again. It does say that the b43 driver is for my chipset
> 
> The problem I'm having is that that while I can see my wireless connection (using iwlist wlan0 scan), I can't connect to it.  In iwconfig with Suse, it doesn't show the access point. In iwconfig in Ubuntu, I get the AP shown but still can't get a dhcp connection.
> 
> This card worked fine in Suse 10.2, 10.3 and Ubuntu 7.10.  What do you think my step in resolving this may be?
> 
> If this needs to into the listserv, i'll resend it there.

In general, this type of mail should be sent to linux-wireless.

Are you trying to use the traditional method with ifup, or are you using 
NetworkManager?

Have you configured the card with YaST?

Larry

