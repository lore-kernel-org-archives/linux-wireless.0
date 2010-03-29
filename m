Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:65380 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014Ab0C2XK1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 19:10:27 -0400
Received: by pwi5 with SMTP id 5so7159412pwi.19
        for <linux-wireless@vger.kernel.org>; Mon, 29 Mar 2010 16:10:26 -0700 (PDT)
Message-ID: <4BB1335F.7030306@lwfinger.net>
Date: Mon, 29 Mar 2010 18:10:23 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Philippe De Muyter <phdm@macqel.be>
CC: linux-wireless@vger.kernel.org
Subject: Re: b43 'hardware blocked' but only keyboard/led touch button
References: <20100329201236.GA9587@frolo.macqel>
In-Reply-To: <20100329201236.GA9587@frolo.macqel>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/29/2010 03:12 PM, Philippe De Muyter wrote:
> Hello wireless-linux experts,
> 
> I have installed yesterday the last opensuse 11.3 rc4 on a
> hp pavilion dv6-1300sb laptop which is has a
> 
> 02:00.0 Network controller [0280]: Broadcom Corporation BCM4312 802.11b/g LP-PHY [14e4:4315] (rev 01)
> 
> as wireless chip.
> 
> I needed to install such a bleeding edge distro because opensuse 11.2 does
> not have the lp_phy driver yet.
> 
> with dmesg, I see :
> 
> [   21.818415] b43 ssb0:0: firmware: requesting b43/ucode15.fw
> [   21.820519] b43 ssb0:0: firmware: requesting b43/lp0initvals15.fw
> [   21.823084] b43 ssb0:0: firmware: requesting b43/lp0bsinitvals15.fw
> [   21.975380] b43-phy0: Loading firmware version 478.104 (2008-07-01 00:50:23)
> [   22.076456] b43-phy0: Radio hardware status changed to DISABLED
> [   22.077743] b43-phy0: Radio turned on by software
> [   22.077747] b43-phy0: The hardware RF-kill button still turns the radio physically off. Press the button to turn it on.
> [   22.078413] ADDRCONF(NETDEV_UP): wlan0: link is not ready
> 
> this is confirmed by rfkill :
> 
> 0: phy0: Wireless LAN
>         Soft blocked: no
>         Hard blocked: yes
> 
> BUT, I DON'T SEE A HARDWARE RF-KILL button;  I only see a red-lighted wireless
> symbol, which is also a touch-key; in console mode, when I touch this
> touch-key I get a message asking me to
> 
> 	'setkey e014 <keycode>'
> 
> I have already seen this symbol being blue-lighted in the first seconds of
> linux booting, but I don't know what changes this color or if this has
> an effect on the 'hardware' RF-kill button.  In the BIOS there is no option
> to enable or disable the wireless interface.
> 
> Any hint ?
> 
> Thanks already for the good work so far

Is the module hp-wmi loaded? That module is designed to implement all of the
special keys for HP laptops.

Larry
