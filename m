Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:54039 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038AbYELD2P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 May 2008 23:28:15 -0400
Subject: Re: is there support for my Card
From: Pavel Roskin <proski@gnu.org>
To: Markus Feldmann <feldmann_markus@gmx.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <g01c9i$8ud$1@ger.gmane.org>
References: <fvp2dg$d26$1@ger.gmane.org> <fvp2kq$d26$2@ger.gmane.org>
	 <59055.84.58.170.93.1210134215.squirrel@webmail.madwifi.org>
	 <fvv15v$9jr$1@ger.gmane.org>
	 <58931.84.58.138.216.1210308615.squirrel@webmail.madwifi.org>
	 <g01c9i$8ud$1@ger.gmane.org>
Content-Type: text/plain
Date: Sun, 11 May 2008 23:28:13 -0400
Message-Id: <1210562893.2345.12.camel@dv> (sfid-20080512_052821_259877_16D6D270)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-05-09 at 13:24 +0200, Markus Feldmann wrote:

> I did use the ath_info Tool from the Package 'madwifi-tools' coming with 
> Debian Lenny. But i do not know the Version Number of ath_info.
> The Version of 'madwifi-tools' is '1:0.9.4-rc'.
> 
> However i did,
> <athmem=`lspci -vd 168c: |sed -n 's/.*Memory at \([^ ]*\).*/0x\1/p'`>
> <ath_info $athmem>
> Unable to read EEPROM Magic value!

It you want to figure out the exact MAC, I suggest that you load some
driver that can enable the card, such as the current version of madwifi
from Subversion.  If it works, it's AR5006, otherwise AR5007.  There is
also a special snapshot of madwifi with AR5007 support at 

If you want to check whether the next kernel will support it, check the
Linux git repository (the one from Linus).

-- 
Regards,
Pavel Roskin
