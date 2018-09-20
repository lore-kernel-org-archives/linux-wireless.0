Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:59921 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732302AbeITUm5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 16:42:57 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: 'Johannes Berg' <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: David Ahern <dsahern@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: RE: [PATCH v2 1/5] netlink: remove NLA_NESTED_COMPAT
Date: Thu, 20 Sep 2018 14:54:59 +0000
Message-ID: <15cc8087b97d4b8693fad397b27f4d10@AcuMS.aculab.com> (sfid-20180920_165916_262823_1EA3F8C2)
References: <20180919194905.16462-1-johannes@sipsolutions.net>
 <20180919194905.16462-2-johannes@sipsolutions.net>
In-Reply-To: <20180919194905.16462-2-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg
> Sent: 19 September 2018 20:49
> This isn't used anywhere, so we might as well get rid of it.
> 
> Reviewed-by: David Ahern <dsahern@gmail.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  include/net/netlink.h |  2 --
>  lib/nlattr.c          | 11 -----------
>  2 files changed, 13 deletions(-)
> 
> diff --git a/include/net/netlink.h b/include/net/netlink.h
> index 318b1ded3833..b680fe365e91 100644
> --- a/include/net/netlink.h
> +++ b/include/net/netlink.h
> @@ -172,7 +172,6 @@ enum {
>  	NLA_FLAG,
>  	NLA_MSECS,
>  	NLA_NESTED,
> -	NLA_NESTED_COMPAT,
>  	NLA_NUL_STRING,
>  	NLA_BINARY,
>  	NLA_S8,
...

Is it safe to remove an item from this emun ?

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
