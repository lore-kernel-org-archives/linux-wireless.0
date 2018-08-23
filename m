Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35356 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726556AbeHWOYl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Aug 2018 10:24:41 -0400
Date: Thu, 23 Aug 2018 12:55:27 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Ajay Singh <ajay.kathat@microchip.com>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        venkateswara.kaja@microchip.com, ganesh.krishna@microchip.com,
        adham.abozaeid@microchip.com, aditya.shankar@microchip.com
Subject: Re: [PATCH 23/24] staging: wilc1000: move 'wilc_connecting' static
 variable to 'wilc_vif' struct
Message-ID: <20180823105527.GA1404@kroah.com> (sfid-20180823_125535_122582_155D83FB)
References: <1534229416-13254-1-git-send-email-ajay.kathat@microchip.com>
 <1534229416-13254-24-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1534229416-13254-24-git-send-email-ajay.kathat@microchip.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 14, 2018 at 12:20:15PM +0530, Ajay Singh wrote:
> --- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
> +++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
> @@ -151,6 +151,7 @@ struct wilc_vif {
>  	struct timer_list periodic_rssi;
>  	struct rf_info periodic_stat;
>  	struct tcp_ack_filter ack_filter;
> +	int connecting;

Shouldn't this be a boolean?

thanks,

greg k-h
