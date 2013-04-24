Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from avasout08.plus.net ([212.159.14.20]:33891 "EHLO
	avasout08.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757617Ab3DXJuS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Apr 2013 05:50:18 -0400
From: Gerry Gavigan <gerry@gavigan.f9.co.uk>
To: Sujith Manoharan <sujith@msujith.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: ath9k problems on openSUSE 12.3
Date: Wed, 24 Apr 2013 10:50:10 +0100
Message-ID: <7429859.PV3GUgURoz@linux-zd5t.site> (sfid-20130424_115022_629601_F75462E1)
In-Reply-To: <20854.23253.514263.467205@gargle.gargle.HOWL>
References: <d5546f49ab812cc89887b18b41d44da0@imap.force9.net> <2687000.szPz826eEU@linux-zd5t.site> <20854.23253.514263.467205@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 23 Apr 2013 15:26:37 Sujith Manoharan wrote:

> Can you load the driver with more debugging options and post the kernel log
> ? Please use the mask debug=0x8f49.
> 
> See http://wireless.kernel.org/en/users/Drivers/ath9k/debug

Sorry for delay, I had to find debugfs (easy when you realise there's a kernel 
with it preinstalled) 

I can't find the kernel log file - it's not (obviously) in /var/log (and Google 
is not proving to be my friend) 

after 

modprobe ath9k debug=0x8f49

dmesg only contains entries relating to power_supply BAT1

Gerry

 


