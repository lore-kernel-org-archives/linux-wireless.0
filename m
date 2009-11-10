Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:56263 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbZKJERn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 23:17:43 -0500
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] rtl8187: Fix sparse warnings
Date: Tue, 10 Nov 2009 02:17:45 -0200
Cc: John W Linville <linville@tuxdriver.com>,
	"Hin-Tak Leung" <htl10@users.sourceforge.net>,
	linux-wireless@vger.kernel.org
References: <4af89e06.WiuJ+1TkMf6eizxN%Larry.Finger@lwfinger.net>
In-Reply-To: <4af89e06.WiuJ+1TkMf6eizxN%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200911100217.45589.herton@mandriva.com.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Em Seg 09 Nov 2009, às 20:56:06, Larry Finger escreveu:
> Due to a missing header include, sparse generates the following warnings:
> 
>   CHECK   drivers/net/wireless/rtl818x/rtl8187_rfkill.c
> warning: symbol 'rtl8187_rfkill_init' was not declared. Should it be static?
> warning: symbol 'rtl8187_rfkill_poll' was not declared. Should it be static?
> warning: symbol 'rtl8187_rfkill_exit' was not declared. Should it be static?
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

Acked-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>

> ---
> 
> John,
> 
> This is 2.6.33 material.
> 
> Larry
> ---
> 
> Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187_rfkill.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187_rfkill.c
> +++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187_rfkill.c
> @@ -18,6 +18,7 @@
>  #include <net/mac80211.h>
>  
>  #include "rtl8187.h"
> +#include "rtl8187_rfkill.h"
>  
>  static bool rtl8187_is_radio_enabled(struct rtl8187_priv *priv)
>  {
> 

-- 
[]'s
Herton
