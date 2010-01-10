Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f194.google.com ([209.85.223.194]:65526 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520Ab0AJBR4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jan 2010 20:17:56 -0500
Received: by iwn32 with SMTP id 32so3930121iwn.33
        for <linux-wireless@vger.kernel.org>; Sat, 09 Jan 2010 17:17:56 -0800 (PST)
Message-ID: <4B492AC1.2080908@lwfinger.net>
Date: Sat, 09 Jan 2010 19:17:53 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Hauke Mehrtens <hauke@hauke-m.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: kernel panic with b43 and hostap on mips
References: <4B490DF9.10802@hauke-m.de>
In-Reply-To: <4B490DF9.10802@hauke-m.de>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/09/2010 05:15 PM, Hauke Mehrtens wrote:
> Hi,
> 
> I am using compat-wireless of 2010-01-07 and mac80211: fix netdev
> queues, mac80211: fix a few work bugs and mac80211: fix endian error by
> Johannes.
> 
> The system is running OpenWrt with kernel 2.6.30.10 on Asus WL-500GP
> (brcm47xx system mips) and hostap git of 2010-01-08.
> 
> The Systems and hostapd starts normal, but if a client tries to connect
> to the access point the AP crashes. Without encryption it works without
> any problems but with PSK and WPA1 the system crashes with the attached
> panic. I have not tried other encryption modes. With compat-wireless of
> 2009-12-05 and hostap git of 2009-11-29 the system worked link expected.

Can you run compat-wireless of 01-07 with hostap of 11-29 to isolate the problem
in compat-wireless? If that shows the problem in compat-wireless, can you
perform what amounts to a bisection?

Larry

