Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30377 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752828AbZJPQ3I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 12:29:08 -0400
Subject: Re: [PATCH] libertas: make lbs_get_channel() static
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <200910161733.56111.hs4233@mail.mn-solutions.de>
References: <200910161733.56111.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Fri, 16 Oct 2009 09:29:11 -0700
Message-Id: <1255710551.14241.29.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-10-16 at 17:33 +0200, Holger Schurig wrote:
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
> 

Acked-by: Dan Williams <dcbw@redhat.com>

> --- linux-wl.orig/drivers/net/wireless/libertas/cmd.c
> +++ linux-wl/drivers/net/wireless/libertas/cmd.c
> @@ -880,7 +880,7 @@
>   *
>   *  @return 	   	The channel on success, error on failure
>   */
> -int lbs_get_channel(struct lbs_private *priv)
> +static int lbs_get_channel(struct lbs_private *priv)
>  {
>  	struct cmd_ds_802_11_rf_channel cmd;
>  	int ret = 0;
> --- linux-wl.orig/drivers/net/wireless/libertas/cmd.h
> +++ linux-wl/drivers/net/wireless/libertas/cmd.h
> @@ -82,8 +82,6 @@
>  
>  int lbs_update_hw_spec(struct lbs_private *priv);
>  
> -int lbs_get_channel(struct lbs_private *priv);
> -
>  int lbs_set_channel(struct lbs_private *priv, u8 channel);
>  
>  int lbs_update_channel(struct lbs_private *priv);
> 

