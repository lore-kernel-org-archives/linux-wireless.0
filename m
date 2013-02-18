Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f178.google.com ([209.85.160.178]:64131 "EHLO
	mail-gh0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756755Ab3BRTUV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2013 14:20:21 -0500
Received: by mail-gh0-f178.google.com with SMTP id g24so633940ghb.37
        for <linux-wireless@vger.kernel.org>; Mon, 18 Feb 2013 11:20:20 -0800 (PST)
Message-ID: <51227EF2.6040706@lwfinger.net> (sfid-20130218_202024_454869_BE7A5C1C)
Date: Mon, 18 Feb 2013 13:20:18 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Mario Vietri <m.vietri@sns.it>
CC: linux-wireless@vger.kernel.org
Subject: Re: Linksys AE3000
References: <web-120409979@sns.it>
In-Reply-To: <web-120409979@sns.it>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/18/2013 12:03 PM, Mario Vietri wrote:
> Dear Sirs,
>
> I run an up-to-date ArchLinux system on a Toshiba Portege R600. I own a Linksys
> AE3000 (0x13b1:0x003b) usb wifi adapter, with driver downloaded from WikiDevi as
> per their AE3000 page, with the usual modifications.
> The driver compiles, installs and runs correctly, until I begin watching a
> Youtube video, when it causes a kernel panic. I can easily reproduce this crash
> at will, and thus I could submit a kernel panic picture.
>
> I have seen that this behaviour is hardly discussed on Google, and, though not
> completely unknown, it seems to me to be under-reported. I am thus wondering
> whether this has been done already, or if you think might be useful
> to you (and to me, of course). Should it be of any interest to you, could you
> please point me to a page where a list of all required info for proper reporting
> is displayed?

The usual way to report a kernel panic would be to post that photograph.

That said, I'm not aware of anyone here that debugs vendor drivers, i.e. the 
ones that are not in the kernel. You will need to look at the cause of the 
panic, trace it back to the driver, and try to fix it yourself.

Because the chip in that device is an RT3573, perhaps the rt2x00 developers 
might help you, but most of us have other things to do.

Larry


