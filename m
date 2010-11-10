Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:27063 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757118Ab0KJWWu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 17:22:50 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 10 Nov 2010 14:22:38 -0800
Date: Wed, 10 Nov 2010 14:22:48 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Arnaud Lacombe <lacombar@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH 27/44] compat/2.6.33: remove macro not in mainline
Message-ID: <20101110222248.GF4667@tux>
References: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
 <1289355626-25373-28-git-send-email-lacombar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1289355626-25373-28-git-send-email-lacombar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 09, 2010 at 06:20:09PM -0800, Arnaud Lacombe wrote:
> Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
> ---
>  include/linux/compat-2.6.23.h |    4 ----
>  1 files changed, 0 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/compat-2.6.23.h b/include/linux/compat-2.6.23.h
> index 5dd6301..1a486ab 100644
> --- a/include/linux/compat-2.6.23.h
> +++ b/include/linux/compat-2.6.23.h
> @@ -84,10 +84,6 @@ static inline void tcf_destroy_chain_compat(struct tcf_proto **fl)
>  #define da_users	dmi_users
>  #define da_gusers	dmi_gusers
>  
> -/* dev_set_promiscuity() was moved to __dev_set_promiscuity() on 2.6.23 and
> - * dev_set_promiscuity() became a wrapper. */
> -#define __dev_set_promiscuity dev_set_promiscuity
> -

Good call, how did you find these non-in-kernel thingies?

  Luis
