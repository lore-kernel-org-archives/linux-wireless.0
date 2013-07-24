Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55544 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737Ab3GXTPL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Jul 2013 15:15:11 -0400
Date: Wed, 24 Jul 2013 15:02:51 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>
Subject: Re: [PATCH 18/21] mwifiex: handle driver initialization error paths
Message-ID: <20130724190250.GG2385@tuxdriver.com> (sfid-20130724_211516_475803_977AFA22)
References: <1374545878-15683-1-git-send-email-bzhao@marvell.com>
 <1374545878-15683-19-git-send-email-bzhao@marvell.com>
 <20130724151651.GD2385@tuxdriver.com>
 <477F20668A386D41ADCC57781B1F70430EA311794C@SC-VEXCH1.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <477F20668A386D41ADCC57781B1F70430EA311794C@SC-VEXCH1.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 24, 2013 at 11:48:25AM -0700, Bing Zhao wrote:
> Hi John,
> 
> > This one didn't apply on the current wireless-next tree.  Can you
> > fix it up?
> 
> 18/21 and 19/21 depend on this patch:
> 
> commit 232fde062e0a2cc52e8e18a50cda361b4ba88f34
> Author: Daniel Drake <dsd@laptop.org>
> Date:   Sat Jul 13 10:57:10 2013 -0400
> 
>     mwifiex: fix IRQ enable/disable
> 
> which is in wireless.git and wireless-testing.git currently.
> 
> 
> We can apply 18 and 19 later after commit 232fde0 is merged back to wireless-next.git.
> (I will send you a reminder to merge these two patches once commit 232fde0 is in -next tree.)
> 
> Thanks,
> Bing

OK, thanks for checking!

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
