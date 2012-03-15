Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57191 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161282Ab2COTo6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 15:44:58 -0400
Received: by mail-yw0-f46.google.com with SMTP id m54so3504624yhm.19
        for <linux-wireless@vger.kernel.org>; Thu, 15 Mar 2012 12:44:58 -0700 (PDT)
Date: Thu, 15 Mar 2012 12:44:53 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: stern@rowland.harvard.edu, linux-mips@linux-mips.org,
	ralf@linux-mips.org, m@bues.ch, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	=?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: Re: [PATCH v4 3/7] bcma: scan for extra address space
Message-ID: <20120315194453.GB30682@kroah.com> (sfid-20120315_204518_429300_FB81CE9D)
References: <1331597093-425-1-git-send-email-hauke@hauke-m.de>
 <1331597093-425-4-git-send-email-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1331597093-425-4-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 13, 2012 at 01:04:49AM +0100, Hauke Mehrtens wrote:
> Some cores like the USB core have two address spaces. In the USB host
> controller one address space is used for the OHCI and the other for the
> EHCI controller interface. The USB controller is the only core I found
> with two address spaces. This code is based on the AI scan function
> ai_scan() in shared/aiutils.c in the Broadcom SDK.
> 
> CC: Rafał Miłecki <zajec5@gmail.com>
> CC: linux-wireless@vger.kernel.org
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  drivers/bcma/scan.c       |   19 ++++++++++++++++++-
>  include/linux/bcma/bcma.h |    1 +
>  2 files changed, 19 insertions(+), 1 deletions(-)

Is this required for the 4/7 patch?

If so, can I get an ack from the BCMA developers so that I can take this
through the USB tree?

thanks,

greg k-h
