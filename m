Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:30572 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754399Ab0LOOqY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Dec 2010 09:46:24 -0500
Received: from nokia.com (localhost [127.0.0.1])
	by mgw-sa02.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id oBFEkMtK004522
	for <linux-wireless@vger.kernel.org>; Wed, 15 Dec 2010 16:46:22 +0200
Subject: Re: [PATCH v2] wl12xx_sdio_test: rename files to match current
 style
From: Luciano Coelho <luciano.coelho@nokia.com>
To: Roger Quadros <roger.quadros@nokia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1292423633.32385.9.camel@chilepepper>
References: <1292423499-5667-1-git-send-email-luciano.coelho@nokia.com>
	 <1292423633.32385.9.camel@chilepepper>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Dec 2010 16:48:21 +0200
Message-ID: <1292424501.32385.10.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-12-15 at 16:33 +0200, ext Luciano Coelho wrote:
> On Wed, 2010-12-15 at 16:31 +0200, luciano.coelho@nokia.com wrote:
> > From: Luciano Coelho <luciano.coelho@nokia.com>
> > 
> > Change some file names and Kconfig settings so that this new module matches
> > the new way of using wl12xx instead of wl1271.
> > 
> > Also fix SDIO power enabling and disabling to match the latest way of doing
> > it.
> > 
> > Cc: Roger Quadros <roger.quadros@nokia.com>
> > Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
> > ---
> 
> In v2 I used the -M flag (to detect renames, which I stupidly forgot
> before) and removed the file names from the header of the sdio_test.c
> file, since it's a bad idea to have it there (thanks Johannes for the
> comments).

Roger, I have just compile-tested this module in upstream.  Could you
run at least some basic tests with it to make sure it works?


-- 
Cheers,
Luca.

