Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:40566 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751026AbeAVLIV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jan 2018 06:08:21 -0500
Subject: Re: [PATCH v2 13/14] staging: wilc1000: rename Handle_Connect() to
 avoid camelCase
To: Ajay Singh <ajay.kathat@microchip.com>,
        <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>
References: <1516616547-24654-1-git-send-email-ajay.kathat@microchip.com>
 <1516616547-24654-14-git-send-email-ajay.kathat@microchip.com>
From: Claudiu Beznea <Claudiu.Beznea@microchip.com>
Message-ID: <2490c2d0-98f5-a992-3175-8382a8e2544b@microchip.com> (sfid-20180122_120824_072293_2E787AB6)
Date: Mon, 22 Jan 2018 13:08:18 +0200
MIME-Version: 1.0
In-Reply-To: <1516616547-24654-14-git-send-email-ajay.kathat@microchip.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 22.01.2018 12:22, Ajay Singh wrote:
> Fix "Avoid camelcase" issue found by checkpatch.pl
> script.
> 
Same here as in patch 02 of this series.

> Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
> ---
>  drivers/staging/wilc1000/host_interface.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> index b34243c..6e462db 100644
> --- a/drivers/staging/wilc1000/host_interface.c
> +++ b/drivers/staging/wilc1000/host_interface.c
> @@ -902,7 +902,7 @@ static s32 handle_scan_done(struct wilc_vif *vif,
>  }
>  
>  u8 wilc_connected_ssid[6] = {0};
> -static s32 Handle_Connect(struct wilc_vif *vif,
> +static s32 handle_connect(struct wilc_vif *vif,
>  			  struct connect_attr *attr)
>  {
>  	s32 result = 0;
> @@ -2491,7 +2491,7 @@ static void host_if_work(struct work_struct *work)
>  		break;
>  
>  	case HOST_IF_MSG_CONNECT:
> -		Handle_Connect(msg->vif, &msg->body.con_info);
> +		handle_connect(msg->vif, &msg->body.con_info);
>  		break;
>  
>  	case HOST_IF_MSG_RCVD_NTWRK_INFO:
> 
