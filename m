Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xi.wantstofly.org ([80.101.37.227]:59457 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbZHSJcD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2009 05:32:03 -0400
Date: Wed, 19 Aug 2009 11:32:03 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 00/29] mwl8k update to version 0.10
Message-ID: <20090819093203.GA14050@mail.wantstofly.org>
References: <20090818034942.GE18639@mail.wantstofly.org> <20090818103043.GA6171@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090818103043.GA6171@mail.wantstofly.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 18, 2009 at 12:30:43PM +0200, Lennert Buytenhek wrote:

> The following changes since commit f0602f40fe362f4ee15aad719d5cf7021de61914:
>   Bob Copeland (1):
>         wl1251: correct definitions for 0th bit defines
> 
> are available in the git repository at:
> 
>   git://git.marvell.com/mwl8k.git master
> 
> Lennert Buytenhek (29):
>       mwl8k: remove various unused struct members and defines
>       mwl8k: s/IEEE80211_ADDR_LEN/ETH_ALEN/g
>       mwl8k: sort firmware command list by opcode, and trim unused commands
>       mwl8k: various coding style cleanups
>       mwl8k: remove MWL8K_RADIO_* defines
>       mwl8k: remove MWL8K_RADIO_*_PREAMBLE defines
>       mwl8k: remove MWL8K_WMM_* defines
>       mwl8k: remove MWL8K_*_SLOTTIME defines
>       mwl8k: fix mwl8k_configure_filter() parameter lifetime issue
>       mwl8k: ->add_interface() is not called for monitor interfaces
>       mwl8k: dma header manipulations can't fail
>       mwl8k: don't touch 'command done' interrupt during firmware load
>       mwl8k: don't hardcode the number of transmit queues
>       mwl8k: no need to hold ->tx_lock while setting the hardware interrupt mask
>       mwl8k: implement rfkill

Johannes pointed out that this subject line is nonsense, which it
is as the patch itself implements IEEE80211_CONF_IDLE, so I've replaced
this commit message by "mwl8k: implement idle mode" and updated the
master branch (renaming the old one to master.old).  No code changes.
