Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:45488 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756368AbZLUCoK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Dec 2009 21:44:10 -0500
Subject: RE: Intel 4965 HT rates
From: Zhu Yi <yi.zhu@intel.com>
To: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
Cc: 'Valentin Manea' <linux-wireless@mrs.ro>,
	"'linux-wireless@vger.kernel.org'" <linux-wireless@vger.kernel.org>
In-Reply-To: <E9954878DD1FB34FAE5187FB88C58A357683393C@orsmsx506.amr.corp.intel.com>
References: <E9954878DD1FB34FAE5187FB88C58A357683393C@orsmsx506.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Dec 2009 10:44:07 +0800
Message-ID: <1261363447.12157.624.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-12-21 at 10:33 +0800, Guy, Wey-Yi W wrote:
> For 4965, 40MHz only supported in g band

We don't support 40MHz channels in 2.4G band. See comments in
iwl-eeprom.h:

 *
 * NOTE:  4965 does not support HT40 channels on 2.4 GHz.
 */

Thanks,
-yi

>  -----Original Message-----
> From: 	Valentin Manea [mailto:linux-wireless@mrs.ro]
> Sent:	Sunday, December 20, 2009 05:38 AM Pacific Standard Time
> To:	linux-wireless@vger.kernel.org
> Subject:	Intel 4965 HT rates
> 
> Hi,
> 
>   I'm running compat-wireless-2.6.33-rc1 and iw list shows some confusing HT 
> capabilities:
>         Band 1:            
>                 HT capabilities: 0x082c
>                         * 20 MHz operation
>                         * SM PS disabled  
>                         * 20 MHz short GI 
>                         * max A-MSDU len 7935
> 
> but for 802.11a channels:
>         Band 2:                                                               
>                 HT capabilities: 0x086e                                       
>                         * 20/40 MHz operation                                 
>                         * SM PS disabled                                      
>                         * 20 MHz short GI                                     
>                         * 40 MHz short GI                                     
>                         * max A-MSDU len 7935
> 
> While I can't tell when this happened, I remember older 2.6.29 releases 
> supported HT40 for both bands.
> The wireless card is an Intel 4965 on a Thinkpad T61.
> 
> 
> Regards,
> Valentin
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> N�����r��y���b�X��ǧv�^�)޺{.n�+����{��*ޕ�,�{ay�ʇڙ�,j��f���h���z��w������j:+v���w�j�m��������zZ+�����ݢj"��!�i


