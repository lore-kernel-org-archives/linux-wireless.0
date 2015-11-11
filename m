Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37832 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbbKKAdd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2015 19:33:33 -0500
Date: Tue, 10 Nov 2015 16:33:32 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/20] staging/wilc1000: add struct net_device declaration
Message-ID: <20151111003332.GA5422@kroah.com> (sfid-20151111_013350_160708_1DAD01AB)
References: <1447198960-2760143-1-git-send-email-arnd@arndb.de>
 <1447198960-2760143-2-git-send-email-arnd@arndb.de>
 <20151111000248.GA5062@kroah.com>
 <4397901.37Xo7LRaFs@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4397901.37Xo7LRaFs@wuerfel>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 11, 2015 at 01:13:33AM +0100, Arnd Bergmann wrote:
> On Tuesday 10 November 2015 16:02:48 Greg Kroah-Hartman wrote:
> > On Wed, Nov 11, 2015 at 12:42:21AM +0100, Arnd Bergmann wrote:
> > I think this is already fixed in my staging-testing branch, right?
> 
> Ah right. I only got it with some rare randconfig builds, and assumed
> the problem was still there because I did not see a patch that fixed
> it. However, the config that originally failed is now fine, so it's
> probably fixed.
> 
> The other patches won't apply cleanly without this one unfortunately.
> Let me know if I should re-send them without this patch, as I don't
> want to spam everyone unnecessarily.


Let me see how well they apply if I skip this, I can always hand-edit
patches (do it all the time...)

But give me a week or so to catch up on things, these are in my queue,
not lost.

thanks,

greg k-h
