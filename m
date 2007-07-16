Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:36993 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755717AbXGPV7Y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jul 2007 17:59:24 -0400
Message-ID: <469BEA38.2040804@garzik.org>
Date: Mon, 16 Jul 2007 17:59:20 -0400
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Please pull 'upstream-jgarzik' branch of wireless-2.6
References: <20070710185758.GH7927@tuxdriver.com>
In-Reply-To: <20070710185758.GH7927@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> The following changes since commit 71780f59e127bb281a9302d430495ca9586c14e7:
>   Linus Torvalds (1):
>         Merge branch 'for-linus' of git://git.kernel.org/.../ieee1394/linux1394-2.6
> 
> are found in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git upstream-jgarzik
> 
> Adrian Bunk (1):
>       drivers/net/wireless/libertas/wext.c: remove dead code
> 
> Dan Williams (1):
>       libertas: fix disabling WPA
> 
> Daniel Drake (4):
>       zd1211rw: Allow channels 1-11 for unrecognised regulatory domains
>       zd1211rw: Detect more AL2230S radios
>       zd1211rw: Add ID for Buffalo WLI-U2-KG54L
>       zd1211rw: Defer firmware load until first ifup
> 
> Holger Schurig (1):
>       libertas: fix use-after-free in rx path
> 
> Jean Tourrilhes (1):
>       softmac: Fix ESSID problem
> 
> Matthias Kaehlcke (1):
>       use list_for_each_entry() for iteration in Prism 54 driver
> 
> Michael Wu (1):
>       rtl8187: fix endianness issue in rtl8225 register writing
> 
> Michal Schmidt (5):
>       airo: disable the PCI device when unloading module
>       airo: delay some initialization until the netdev is up
>       airo: fix a race causing initialization failures
>       airo: simpler calling convention for enable_MAC()
>       airo: start with radio off
> 
> Robert P. J. Day (1):
>       WIRELESS: Remove clearly obsolete libertas/version.h file.
> 
> Stephen Hemminger (2):
>       ipw2200: rf kill switch polling power saving
>       ipw2100: RF kill switch timer power save

pulled


