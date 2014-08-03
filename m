Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yh0-f49.google.com ([209.85.213.49]:63845 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbaHCMN7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Aug 2014 08:13:59 -0400
Received: by mail-yh0-f49.google.com with SMTP id b6so3643602yha.8
        for <linux-wireless@vger.kernel.org>; Sun, 03 Aug 2014 05:13:59 -0700 (PDT)
Message-ID: <1407068037.29448.12.camel@w7> (sfid-20140803_141403_351439_9766B818)
Subject: Re: Problems with rtl8192cu driver (disassociated from ... (Reason:
 2))
From: Steve Brown <sbrown@cortland.com>
To: Manuel Reimer <Manuel.Spam@nurfuerspam.de>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 03 Aug 2014 08:13:57 -0400
In-Reply-To: <lrjs9d$s51$1@ger.gmane.org>
References: <lrjs9d$s51$1@ger.gmane.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2014-08-03 at 01:29 +0200, Manuel Reimer wrote:
> Hello,
> 
> I'm trying to get access to a WLAN access point using the following adapter:
> 
> <http://www.edimax.com/edimax/merchandise/merchandise_detail/data/edimax/global/wireless_adapters_n150/ew-7811un>
> 
> I've used "NetworkManager" to connect to the access point and everything 
> seemed to work well at first.
> 
> But after a few minutes the connection is lost with the following 
> message in dmesg:
> 
> wlan0: disassociated from XX:XX:XX:XX:XX:XX (Reason: 2)
> 
> If I restart NetworkManager, then the connection works again, but only 
> for a few minutes before I get another disconnect.
> 
> I even tried to do a permanent ping to a server on the Internet (to have 
> permanent traffic) but this doesn't change anything. I still get 
> disconnected with "Reason 2".
> 
> Are there known problems with the rtl8192cu driver?
> 
> Can someone here recommend a small USB WLAN adapter which is known to 
> work without problems?
> 
> Thank you very much in advance.
> 
> Greetings
> 
> Manuel
> 
I had a similar problem with this driver. After a while, the aggregation
session seems to hang. If I connect as b/g, no problem. If I disable
aggregation by patching the driver, again the problem goes away.

That's as far as I got.

Steve




