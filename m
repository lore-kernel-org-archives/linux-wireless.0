Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:53502 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab2JVWn2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2012 18:43:28 -0400
Received: by mail-da0-f46.google.com with SMTP id n41so1601596dak.19
        for <linux-wireless@vger.kernel.org>; Mon, 22 Oct 2012 15:43:28 -0700 (PDT)
Date: Mon, 22 Oct 2012 15:43:24 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Pontus Fuchs <pontus.fuchs@gmail.com>,
	linux-wireless@vger.kernel.org, s.L-H@gmx.de
Cc: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 0/4] Driver for the ar5523 chipset
Message-ID: <20121022224324.GC24489@kroah.com> (sfid-20121023_004331_576427_539C479C)
References: <1349985702-21322-1-git-send-email-pontus.fuchs@gmail.com>
 <20121013153923.GA25810@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121013153923.GA25810@lst.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 13, 2012 at 05:39:23PM +0200, Christoph Hellwig wrote:
> Thanks a lot for picking up the work and finshing the driver.
> 
> I agree with the other voices here that the driver should go straight in
> and not to staging.

Ok, I've dropped this from my patch queue, it should go to the wireless
driver maintainers instead.

thanks,

greg k-h
