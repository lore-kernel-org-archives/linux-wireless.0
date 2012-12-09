Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4857 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752952Ab2LIRwk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Dec 2012 12:52:40 -0500
Message-ID: <50C4CFDA.5020900@broadcom.com> (sfid-20121209_185244_377248_45866410)
Date: Sun, 9 Dec 2012 18:52:26 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Maximilian Engelhardt" <maxi@daemonizer.de>,
	"Johannes Berg" <johannes@sipsolutions.net>
cc: brcm80211-dev-list@broadcom.com,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: WLAN not working anymore after changing the MAC address
References: <201212090940.38269.maxi@daemonizer.de>
In-Reply-To: <201212090940.38269.maxi@daemonizer.de>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/09/2012 09:40 AM, Maximilian Engelhardt wrote:
> Hello,
> 
> According to http://wireless.kernel.org/en/users/Drivers/brcm80211
> I should report bugs to this list so here it is.

Not sure if we are dealing with a bug here.

> After changing the MAC address of my wireless network interface it
> doesn't work anymore. I would very much like to change the MAC
> address to avoid being traceable by it. Steps how this can be
> reproduced are shown below. Here is first some information about my
> Hardware and test setup:
> 

How is this supposed to be distributed to the driver? I have been
looking in the mac80211 interface. The only callback that I can think
is is the change_interface() callback although the documentation does
state this is only for changing the interface type. Or is it to be
done upon add_interface()?

Gr. AvS

