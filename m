Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55890 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753117AbdF2OiI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Jun 2017 10:38:08 -0400
Date: Thu, 29 Jun 2017 16:38:06 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Aditya Shankar <aditya.shankar@microchip.com>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        Ganesh.Krishna@microchip.com
Subject: Re: [PATCH v2 5/8] staging: wilc1000: Add new variable for ac queue
 management
Message-ID: <20170629143806.GA13007@kroah.com> (sfid-20170629_163811_720466_D7B932D1)
References: <1498477410-19518-1-git-send-email-aditya.shankar@microchip.com>
 <1498477410-19518-6-git-send-email-aditya.shankar@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1498477410-19518-6-git-send-email-aditya.shankar@microchip.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 26, 2017 at 05:13:27PM +0530, Aditya Shankar wrote:
> This patch adds a new variable in the wilc struct to manage
> ac queues.
> 
> Signed-off-by: Aditya Shankar <aditya.shankar@microchip.com>
> ---
>  drivers/staging/wilc1000/wilc_wfi_netdevice.h | 1 +
>  1 file changed, 1 insertion(+)

Wait, what is this whole patch series for?  You are adding functions and
variables and not using this functionality at all!  Why are you adding
new functionality to the driver now, and not working to get it out of
staging instead?

I'm going to go drop these patches from the tree now...

thanks,

greg k-h
