Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:55619 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287AbYKYRQ4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2008 12:16:56 -0500
Subject: Re: AP (Master Mode) of wireless drivers
From: Pavel Roskin <proski@gnu.org>
To: Mark Ryden <markryde@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <dac45060811250735m6922688fn13c03ebe388d3137@mail.gmail.com>
References: <dac45060811250735m6922688fn13c03ebe388d3137@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 25 Nov 2008 12:16:54 -0500
Message-Id: <1227633414.15224.6.camel@dv> (sfid-20081125_181659_598212_24A3B86B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-11-25 at 17:35 +0200, Mark Ryden wrote:
> Hello,
> 
> According to the linux wireless wiki, only four Linux drivers support
> AP (Master Mode) ; these
> are  b43/b43legacy (Broadcom chips), Intel ipw2200, and
> libertas_tf and p54 (Intersil chips).
> see:
> http://www.linuxwireless.org/en/users/Drivers
> 
> My question is: is this information updated ?

If you check the page history, you'll see that the page is being updated
regularly.  That doesn't mean that it's 100% correct.

> More specifically, I am particularly interested to know whether Intel
> iwl3945 and Intel iwl4965 support AP (Master Mode), and in case they
> do not (as I am afraid is the situation)
> - is there any intention to add AP (masted mode) support to these drivers
> in the near future ?

The driver announces AP mode support (look for NL80211_IFTYPE_AP and
hw->wiphy->interface_modes in iwl-core.c and iwl3945-base.c), so it
might work, or at least the intention is to make it work.  By the way,
rt2x00 announces AP mode support too (in some conditions).

-- 
Regards,
Pavel Roskin
