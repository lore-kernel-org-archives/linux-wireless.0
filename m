Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45056 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753901Ab0FWXYl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jun 2010 19:24:41 -0400
Subject: Re: [PATCH 3/3] libertas: mark lbs_ret_802_11d_domain_info static
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, dkiran@marvell.com,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <1277303846-17257-3-git-send-email-linville@tuxdriver.com>
References: <1277281556.3642.6.camel@jlt3.sipsolutions.net>
	 <1277303846-17257-3-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Jun 2010 16:24:43 -0700
Message-ID: <1277335483.25126.29.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-06-23 at 10:37 -0400, John W. Linville wrote:
> Probably little risk of namespace polution, but good practice... :-)
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
>  drivers/net/wireless/libertas/cmdresp.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
> index b4bc103..a0d9482 100644
> --- a/drivers/net/wireless/libertas/cmdresp.c
> +++ b/drivers/net/wireless/libertas/cmdresp.c
> @@ -103,7 +103,7 @@ static int lbs_ret_reg_access(struct lbs_private *priv,
>   *  @param resp    pointer to command response buffer
>   *  @return        0; -1
>   */
> -int lbs_ret_802_11d_domain_info(struct cmd_ds_command *resp)
> +static int lbs_ret_802_11d_domain_info(struct cmd_ds_command *resp)
>  {
>  	struct cmd_ds_802_11d_domain_info *domaininfo =
>  			&resp->params.domaininforesp;


