Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web23105.mail.ird.yahoo.com ([217.146.189.45]:39361 "HELO
	web23105.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751353AbZKJACF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 19:02:05 -0500
Message-ID: <133312.81061.qm@web23105.mail.ird.yahoo.com>
Date: Mon, 9 Nov 2009 23:55:28 +0000 (GMT)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: [PATCH] rtl8187: Fix sparse warnings
To: John W Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-wireless@vger.kernel.org
In-Reply-To: <4af89e06.WiuJ+1TkMf6eizxN%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- On Mon, 9/11/09, Larry Finger <Larry.Finger@lwfinger.net> wrote:

> Due to a missing header include,
> sparse generates the following warnings:
> 
>  
> CHECK   drivers/net/wireless/rtl818x/rtl8187_rfkill.c
> warning: symbol 'rtl8187_rfkill_init' was not declared.
> Should it be static?
> warning: symbol 'rtl8187_rfkill_poll' was not declared.
> Should it be static?
> warning: symbol 'rtl8187_rfkill_exit' was not declared.
> Should it be static?
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

Acked-by: Hin-Tak Leung <htl10@users.sourceforge.net>

Looks straight-forward.


> ---
> 
> John,
> 
> This is 2.6.33 material.
> 
> Larry
> ---
> 
> Index:
> wireless-testing/drivers/net/wireless/rtl818x/rtl8187_rfkill.c
> ===================================================================
> ---
> wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187_rfkill.c
> +++
> wireless-testing/drivers/net/wireless/rtl818x/rtl8187_rfkill.c
> @@ -18,6 +18,7 @@
>  #include <net/mac80211.h>
>  
>  #include "rtl8187.h"
> +#include "rtl8187_rfkill.h"
>  
>  static bool rtl8187_is_radio_enabled(struct rtl8187_priv
> *priv)
>  {
> 


      
