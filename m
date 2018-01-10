Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59190 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751665AbeAJSZN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Jan 2018 13:25:13 -0500
Date: Wed, 10 Jan 2018 19:25:13 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Ajay Singh <ajay.kathat@microchip.com>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        venkateswara.kaja@microchip.com, ganesh.krishna@microchip.com,
        aditya.shankar@microchip.com
Subject: Re: [PATCH v2 5/9] staging: wilc1000: removed few unnecessary enums
 typedef
Message-ID: <20180110182513.GA24654@kroah.com> (sfid-20180110_192517_365460_2172C765)
References: <1515582771-28408-1-git-send-email-ajay.kathat@microchip.com>
 <1515582771-28408-6-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1515582771-28408-6-git-send-email-ajay.kathat@microchip.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 10, 2018 at 04:42:47PM +0530, Ajay Singh wrote:
> This patch removes following N_OPERATING_MODE_T,N_OBSS_DETECTION_T,
> N_PROTECTION_TYPE_T,N_SMPS_MODE_T,TX_ABORT_OPTION_T, typedef enum.
> Now, these enums are used as anonymous-enums for constants.
> 
> checkpatch.pl warning to not add new typedef is fixes with this patch.
> 
> Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> ---
>  drivers/staging/wilc1000/wilc_wlan_if.h | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)

This is the same subject line as the previous patch in the series, yet
they are doing different things.

Please take this series and work on the subject lines to make them a bit
more unique and different from each other, and resend.

thanks,

greg k-h
