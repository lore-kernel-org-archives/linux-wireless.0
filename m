Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:61902 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932105Ab0HOQxz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Aug 2010 12:53:55 -0400
Received: by pxi10 with SMTP id 10so1570199pxi.19
        for <linux-wireless@vger.kernel.org>; Sun, 15 Aug 2010 09:53:54 -0700 (PDT)
Message-ID: <4C681B90.4000802@lwfinger.net>
Date: Sun, 15 Aug 2010 11:53:36 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Fritz <linuxwireless@crusius.info>
CC: linux-wireless@vger.kernel.org
Subject: Re: RTL8192E Kernel 2.6.32 Freeze
References: <loom.20100815T155457-704@post.gmane.org>
In-Reply-To: <loom.20100815T155457-704@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/15/2010 09:17 AM, Fritz wrote:
> Hi,
> 
> I'm using the RTL8192E (r8192_pci) staging driver 
> that comes with ubuntu kernel 2.6.32-24 and am 
> experiencing frequent freezes on an 
> Intel Atom N450 based system.
> 
> Is this a known problem and is there perhaps a newer
> kernel that I should build and run instead?
> 
> The freeze seems to occur whenever the card reconnects
> with the router, see for more detailed problem
> description
> http://ubuntuforums.org/showthread.php?t=1549483

Drivers in drivers/staging are not supported by this group. We look after the
ones in drivers/net/wireless. As the log message tells you, you have been warned
about using anything from staging. To see the full text, use 'dmesg | grep staging'.

I have no idea if it will help, but I suspect that 2.6.35 might be better than
2.6.32. You might also do a 'modinfo r8192_pci' to see who is listed as the
module author. He/she might be able to help.

Larry

