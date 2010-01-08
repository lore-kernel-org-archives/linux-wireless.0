Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:45320 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753945Ab0AHUfq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jan 2010 15:35:46 -0500
Message-ID: <4B479721.4030007@gmx.net>
Date: Fri, 08 Jan 2010 21:35:45 +0100
From: Rainer Koschnick <arkay@gmx.net>
MIME-Version: 1.0
To: Sujith <Sujith.Manoharan@atheros.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath9k driver in kernel 2.6.33 problems
References: <4B46730E.7000105@gmx.net> <19270.46317.374569.436426@gargle.gargle.HOWL>
In-Reply-To: <19270.46317.374569.436426@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/08/10 05:30, Sujith wrote:
> Rainer Koschnick wrote:
>> Hi,
>>
>> I've been trying to use the last couple of 2.6.33 RCs up to rc3-git2 and
>> am experiencing connection issues with the ath9k driver.  It used to be
>> broken for me in kernel 2.6.31 (haven't tried earlier), then was
>> rock-solid in 2.6.32 and now it's broken again.  I can connect to my
>> 300mbit router--which is in the same room--without problems, but after a
>> while the connection breaks.
> 
> You could build the driver with CONFIG_ATH_DEBUG=y and CONFIG_ATH9K_DEBUGFS=y
> and post the log, along with the contents of 'rcstat' and 'interrupt' debugfs files.
> 
> See: http://wireless.kernel.org/en/users/Drivers/ath9k/debug
> 
> Sujith
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Hi,

I have uploaded the requested information to my server, it's rather big
so I don't want to post it here.

http://arkay.de/temp/ath9k_debug.tar.bz

Since the messages file is around 1GB I have extracted a couple of time
ranges.  First I had a disconnect (messages.reconnect... dhcpcd
complained at 20:47:24) , then later the network connection just hang
for a minute or two.  I was transferring a big file from a LAN server,
must have happened somewhere around 21:08 or 09 (messages.hang).  The
transfer just hang... neither the web nor ping worked.

I still have the messages file saved should anything be missing, I have
now turned debugging off since I don't have that much space on my
notebook :)

Thanks,
Rainer

