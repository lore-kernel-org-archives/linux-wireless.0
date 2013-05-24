Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38130 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab3EXSAM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 May 2013 14:00:12 -0400
Date: Fri, 24 May 2013 13:50:02 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Solomon Peachy <pizza@shaftnet.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ST-E CW1200 driver (v6)
Message-ID: <20130524175001.GB2175@tuxdriver.com> (sfid-20130524_200017_479934_A57D770D)
References: <1367090847-11937-1-git-send-email-pizza@shaftnet.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1367090847-11937-1-git-send-email-pizza@shaftnet.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Apr 27, 2013 at 03:27:13PM -0400, Solomon Peachy wrote:
> I'd love to see this finally committed upstream.  There are no known 
> bugs in the code, and it handles everything I (and other testers I've 
> been working with) have thrown at it.
> 
> Changes from the last patch series (v5):
>  * Updated contact info for original author (Dmitry Tarnyagin)
>  * Better documented the DPLL constants
>  * Fixed more checkpatch warnings
>  * Better logging in scan and bss loss state machines
>  * BSS loss mitigation reimplemented (differently) due to FW bugginess
>  * Reworked locking in the join code to handle rare corner cases

I'm sorry, but this just doesn't build on the current wireless-next
and I don't have enough time ATM to chase-down all the fix-ups.

Could you work that out and repost?  Please also check the Kconfig
stuff, as that still seemed to be broken...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
