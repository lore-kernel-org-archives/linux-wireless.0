Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:49248 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754560Ab3DXQjp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Apr 2013 12:39:45 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20856.2640.90900.299786@gargle.gargle.HOWL> (sfid-20130424_183949_428654_0A6D2641)
Date: Wed, 24 Apr 2013 22:07:36 +0530
To: Gerry Gavigan <gerry@gavigan.f9.co.uk>
Cc: linux-wireless@vger.kernel.org
Subject: Re: ath9k problems on openSUSE 12.3
In-Reply-To: <7429859.PV3GUgURoz@linux-zd5t.site>
References: <d5546f49ab812cc89887b18b41d44da0@imap.force9.net>
	<2687000.szPz826eEU@linux-zd5t.site>
	<20854.23253.514263.467205@gargle.gargle.HOWL>
	<7429859.PV3GUgURoz@linux-zd5t.site>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gerry Gavigan wrote:
> I can't find the kernel log file - it's not (obviously) in /var/log (and Google 
> is not proving to be my friend) 
> 
> after 
> 
> modprobe ath9k debug=0x8f49
> 
> dmesg only contains entries relating to power_supply BAT1

You can use the latest compat-drivers release:
https://www.kernel.org/pub/linux/kernel/projects/backports/2013/03/28/compat-drivers-2013-03-28-5.tar.bz2

See: https://backports.wiki.kernel.org/index.php/Documentation/compat-drivers

But, before compiling, uncomment and set "export CONFIG_ATH_DEBUG=y" in config.mk

Sujith
