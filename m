Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:39575 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754809AbZCEUqT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2009 15:46:19 -0500
Message-ID: <49B03A17.1070001@lwfinger.net> (sfid-20090305_214625_148893_BD342658)
Date: Thu, 05 Mar 2009 14:46:15 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Markus Feldmann <feldmann_markus@gmx.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: BCM4303 on HP zv5265ea
References: <gohr71$48f$1@ger.gmane.org> <49AC742D.9030309@lwfinger.net> <gom4ke$vle$1@ger.gmane.org> <49AE9BDD.7070603@lwfinger.net> <gomq5f$n64$1@ger.gmane.org> <49AEF58E.30302@lwfinger.net> <gon99n$b1t$1@ger.gmane.org> <49B00306.8050000@lwfinger.net> <gopctb$rn2$1@ger.gmane.org>
In-Reply-To: <gopctb$rn2$1@ger.gmane.org>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Markus Feldmann wrote:
> 
> With the kernel version 2.6.28.X it doesn't produce
> any keycode. I will try out the current developement
> version in the next days and wrote the results here.
> Ont this Laptop are 2 Operating Systems. Win XP and Debian Lenny.
> On WIn Xp the wlan card works fine. So i think the hardware
> is ok.

The keycode is a function of the hardware, not the kernel. If you don't get one
now, you will _NEVER_ get one. Your only hope is the hp_wmi driver. I cannot
help you there.

Larry
