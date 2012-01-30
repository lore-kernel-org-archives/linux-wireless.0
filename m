Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:48734 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751975Ab2A3TxJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jan 2012 14:53:09 -0500
Received: by mail-lpp01m010-f49.google.com with SMTP id r15so3899133lag.36
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jan 2012 11:53:04 -0800 (PST)
Subject: Re: [PATCH 01/12] wl12xx: fw api change - add role_id to
 set_template
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1327924857-1250-2-git-send-email-eliad@wizery.com>
References: <1327924857-1250-1-git-send-email-eliad@wizery.com>
	 <1327924857-1250-2-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Jan 2012 21:53:01 +0200
Message-ID: <1327953181.3626.107.camel@cumari> (sfid-20120130_205313_047460_2C94AD3F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-01-30 at 14:00 +0200, Eliad Peller wrote:
> @@ -191,7 +193,7 @@ enum cmd_templ {
>  /* unit ms */
>  #define WL1271_COMMAND_TIMEOUT     2000
>  #define WL1271_CMD_TEMPL_DFLT_SIZE 252
> -#define WL1271_CMD_TEMPL_MAX_SIZE  548
> +#define WL1271_CMD_TEMPL_MAX_SIZE  512
> #define WL1271_EVENT_TIMEOUT       750 

Is this change here on purpose? Is it really related to the FW API
change?


-- 
Cheers,
Luca.

