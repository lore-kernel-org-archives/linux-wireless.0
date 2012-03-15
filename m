Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57191 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031858Ab2COTob (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 15:44:31 -0400
Received: by yhmm54 with SMTP id m54so3504624yhm.19
        for <linux-wireless@vger.kernel.org>; Thu, 15 Mar 2012 12:44:30 -0700 (PDT)
Date: Thu, 15 Mar 2012 12:44:26 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: stern@rowland.harvard.edu, linux-mips@linux-mips.org,
	ralf@linux-mips.org, m@bues.ch, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4 4/7] USB: Add driver for the bcma bus
Message-ID: <20120315194426.GA30682@kroah.com> (sfid-20120315_204438_952809_29DD553F)
References: <1331597093-425-1-git-send-email-hauke@hauke-m.de>
 <1331597093-425-5-git-send-email-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1331597093-425-5-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 13, 2012 at 01:04:50AM +0100, Hauke Mehrtens wrote:
> This adds a USB driver using the generic platform device driver for the
> USB controller found on the Broadcom bcma bus. The bcma bus just
> exposes one device which serves the OHCI and the EHCI controller at the
> same time. This driver probes for this USB controller and creates and
> registers two new platform devices which will be probed by the new
> generic platform device driver. This makes it possible to use the EHCI
> and the OCHI controller on the bcma bus at the same time.
> 
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  drivers/usb/host/Kconfig    |   12 ++

This patch fails to apply here, and I can't seem to figure out what tree
you made this against to fix it up by hand on my end.

Any thoughts?

greg k-h
