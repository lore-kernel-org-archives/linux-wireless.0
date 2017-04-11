Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52788 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752473AbdDKRfz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Apr 2017 13:35:55 -0400
Date: Tue, 11 Apr 2017 19:35:46 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Aditya Shankar <aditya.shankar@microchip.com>
Cc: arend.vanspriel@broadcom.com, linux-wireless@vger.kernel.org,
        devel@driverdev.osuosl.org, ganesh.krishna@microchip.com
Subject: Re: [PATCH v3] staging: wilc1000: New cfg packet format in
 handle_set_wfi_drv_handler
Message-ID: <20170411173546.GA29399@kroah.com> (sfid-20170411_193559_125415_FAFC3EBD)
References: <1491928903-2866-1-git-send-email-aditya.shankar@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1491928903-2866-1-git-send-email-aditya.shankar@microchip.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 11, 2017 at 10:11:43PM +0530, Aditya Shankar wrote:
> Change the config packet format used in handle_set_wfi_drv_handler()
> to align the host driver with the new format used in the wilc firmware.

So does this break devices with "old" firmware?

Where is the "new" firmware?  What is enforcing the usage only of new
firmware?

thanks,

greg k-h
