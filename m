Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45109 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757701Ab0LBTAJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 14:00:09 -0500
Date: Thu, 2 Dec 2010 13:54:44 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k: fix beacon resource related race condition
Message-ID: <20101202185444.GA2358@tuxdriver.com>
References: <1291115197-10883-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1291115197-10883-1-git-send-email-rmanoharan@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 30, 2010 at 04:36:37PM +0530, Rajkumar Manoharan wrote:
> While releasing beacon slot, it can be accessed by beacon tasklet.
> To avoid concurrency, beacon alert is disabled before
> freeing beacon resource and it will be enabled again in the
> persence of other beaconing mode interfaces.
> 
> Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>

Is this intended for 2.6.37?  It looks like it could apply there.

Could you be more specific about the effect of the bug you are fixing?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
