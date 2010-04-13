Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44210 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568Ab0DMUAN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Apr 2010 16:00:13 -0400
Date: Tue, 13 Apr 2010 15:58:06 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 000/102] ath9k: add AR9003 support
Message-ID: <20100413195806.GD6722@tuxdriver.com>
References: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 08, 2010 at 03:25:56PM -0400, Luis R. Rodriguez wrote:
> This series adds support for a new chipset family for the ath9k driver,
> the AR9003 harware family. This family of chipsets will includes 2-stream
> and 3-stream devices. We start off by supporting only 2-streams on both
> devices. Both the 2-stream and 3-stream devices are fully functional at
> this point. We have a few more items which we will iron out as part
> of future patches but we're sending this out so that we don't stall
> development on more cleanups/etc. Our delta is already quite large.
> 
> For information of the status of this driver you can refer to:
> 
> http://wireless.kernel.org/en/users/Drivers/ath9k/todo/ar93xx
> 
> You can download an all-in-one series of all these patches here:
> 
> http://bombadil.infradead.org/~mcgrof/patches/ath9k/2010/all-04-08-v2.patch
> 
> sha1sum:
> 412524e75fb512603a31211e72ff67c635d5d04d  all-04-08-v2.patch

I started trying to apply these, but I got a lot of rejects and even
hit a file that didn't exist.  I hesitate to ask, but can we expect
a repost? :-)

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
