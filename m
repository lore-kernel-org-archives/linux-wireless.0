Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:22865
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751296AbdBYGlE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 25 Feb 2017 01:41:04 -0500
Date: Sat, 25 Feb 2017 07:37:56 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
To: Tahia Khan <tahia.khan@gmail.com>
cc: outreachy-kernel@googlegroups.com, aditya.shankar@microchip.com,
        ganesh.krishna@microchip.com, gregkh@linuxfoundation.org,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Outreachy kernel] [PATCH v4 1/3] staging: wilc1000: Rename
 struct tstrRSSI to rssi_history_buffer
In-Reply-To: <da73d1aef379243ba94a5c1a4e1d6663160451fd.1487947616.git.tahia.khan@gmail.com>
Message-ID: <alpine.DEB.2.20.1702250737410.2088@hadrien> (sfid-20170225_074129_603607_9866CDE0)
References: <cover.1487947616.git.tahia.khan@gmail.com> <da73d1aef379243ba94a5c1a4e1d6663160451fd.1487947616.git.tahia.khan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Fri, 24 Feb 2017, Tahia Khan wrote:

> Rename struct tstrRSSI to rssi_history_buffer for clarity
> and to remove camel casing.
>
> Signed-off-by: Tahia Khan <tahia.khan@gmail.com>

Acked-by: Julia Lawall <julia.lawall@lip6.fr>


> ---
>  drivers/staging/wilc1000/coreconfigurator.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
> index cff1698..1c77529 100644
> --- a/drivers/staging/wilc1000/coreconfigurator.h
> +++ b/drivers/staging/wilc1000/coreconfigurator.h
> @@ -70,7 +70,7 @@ enum connect_status {
>  	CONNECT_STS_FORCE_16_BIT = 0xFFFF
>  };
>
> -struct tstrRSSI {
> +struct rssi_history_buffer {
>  	u8 u8Full;
>  	u8 u8Index;
>  	s8 as8RSSI[NUM_RSSI];
> @@ -93,7 +93,7 @@ struct network_info {
>  	u8 *ies;
>  	u16 ies_len;
>  	void *join_params;
> -	struct tstrRSSI str_rssi;
> +	struct rssi_history_buffer str_rssi;
>  	u64 tsf_hi;
>  };
>
> --
> 2.7.4
>
> --
> You received this message because you are subscribed to the Google Groups "outreachy-kernel" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to outreachy-kernel+unsubscribe@googlegroups.com.
> To post to this group, send email to outreachy-kernel@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/outreachy-kernel/da73d1aef379243ba94a5c1a4e1d6663160451fd.1487947616.git.tahia.khan%40gmail.com.
> For more options, visit https://groups.google.com/d/optout.
>
