Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43702 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934362AbdLSOXf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Dec 2017 09:23:35 -0500
Date: Tue, 19 Dec 2017 15:23:37 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Aditya Shankar <aditya.shankar@microchip.com>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        ganesh.krishna@microchip.com
Subject: Re: [PATCH] staging: wilc1000: Fix lines ending with parentheses
Message-ID: <20171219142337.GA7564@kroah.com> (sfid-20171219_152341_043390_DB910FCF)
References: <1513410919-6628-1-git-send-email-aditya.shankar@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1513410919-6628-1-git-send-email-aditya.shankar@microchip.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Dec 16, 2017 at 01:25:19PM +0530, Aditya Shankar wrote:
> This patch fixes the "Lines should not end with a '('"
> problem reported by checkpatch
> 
> Signed-off-by: Aditya Shankar <aditya.shankar@microchip.com>
> ---
>  drivers/staging/wilc1000/linux_mon.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)

This does not apply to my tree, can you redo it against linux-next and
resend?

thanks,

greg k-h
