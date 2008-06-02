Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:7430 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757AbYFBRoN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jun 2008 13:44:13 -0400
Subject: Re: Broadcom 4311 and Master Mode
From: Pavel Roskin <proski@gnu.org>
To: Ryan Loebs <obsidianx@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1deddf2e0806021023j156ff226n98838622ad77ea9d@mail.gmail.com>
References: <1deddf2e0806021023j156ff226n98838622ad77ea9d@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 02 Jun 2008 13:44:10 -0400
Message-Id: <1212428650.3599.6.camel@dv> (sfid-20080602_194417_172534_CDFCDE52)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-06-02 at 10:23 -0700, Ryan Loebs wrote:
> Hey folks,
> 
> I was wondering if it was possible to get the 4311 chipset to switch
> into master mode? I've been trying, I'm running 2.6.26-rc4 with the
> Johannes Berg patches and the latest git for hostapd.  I read about
> success with the nl80211 driver and b43 so I gave that a shot but this
> is what came up:
> 
> Configuration file: hostapd.conf
> Hardware does not support configured mode
> wlan0: IEEE 802.11 Hardware does not support configured mode (0)
> Could not select hw_mode and channel. (-1)
> rmdir[ctrl_interface]: No such file or directory
> 
> I hope this doesn't mean I'm SOL...  Any help would be great.

So, what are hw_mode and channel in hostapd.conf?  If hostapd complains
about them, would not it be reasonable to show us what it doesn't like?

Maybe you are trying to use 802.11a?  That's not supported in b43 yet.
802.11a is the default in the sample hostapd.conf.  Maybe you forgot to
change it?

-- 
Regards,
Pavel Roskin
