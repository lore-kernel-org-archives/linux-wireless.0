Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60872 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbZFASa1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2009 14:30:27 -0400
Date: Mon, 1 Jun 2009 14:26:42 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Christian Lamparter <chunkeey@web.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/4] ar9170: use bitop macros for tx filter flags
Message-ID: <20090601182641.GB3386@tuxdriver.com>
References: <200905232028.21844.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200905232028.21844.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 23, 2009 at 08:28:21PM +0200, Christian Lamparter wrote:
> This patch fixes a bug in configure_filter's (sub-)routines.
> We never really cleared the flags once we updated the hardware state,
> so we wasted our resources by applying already active settings.
> 
> Signed-off-by: Christian Lamparter <chunkeey@web.de>
> ---
> John,
> 
> please apply these together with the bits from the last series
> 
> [PATCH 1/6] ar9170: fix beacon plcp settings
> [PATCH 2/6] ar9170: update hardware definitions
> [PATCH 3/6] ar9170: 40MHz fixes
> [PATCH 4/6] ar9170: introduce functions for MAC programming
> 
> to wireless-2.6 when you're back from Spain.

Ugh...of course, I just deleted these from my mailbox...  Could you
repost these?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
