Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43434 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab1FATBN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 15:01:13 -0400
Date: Wed, 1 Jun 2011 14:51:35 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Gustavo F. Padovan" <padovan@profusion.mobi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] bluetooth l2cap: fix locking in l2cap_global_chan_by_psm
Message-ID: <20110601185135.GE2509@tuxdriver.com> (sfid-20110601_210117_414234_DAFDA157)
References: <1306909794.3867.3.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1306909794.3867.3.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 01, 2011 at 08:29:54AM +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> read_lock() ... read_unlock_bh() is clearly bogus.
> This was broken by
> 
> commit 23691d75cdc69c3b285211b4d77746aa20a17d18
> Author: Gustavo F. Padovan <padovan@profusion.mobi>
> Date:   Wed Apr 27 18:26:32 2011 -0300
> 
>     Bluetooth: Remove l2cap_sk_list
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Gustavo, I'm taking this in wireless-2.6 directly.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
