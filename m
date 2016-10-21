Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33090 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933841AbcJUNBR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Oct 2016 09:01:17 -0400
Message-ID: <1477054872.4068.43.camel@sipsolutions.net> (sfid-20161021_150133_678812_AABF20F8)
Subject: Re: [PATCH 1/2] mac80211: fix some sphinx warnings
From: Johannes Berg <johannes@sipsolutions.net>
To: Jani Nikula <jani.nikula@intel.com>, linux-wireless@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Date: Fri, 21 Oct 2016 15:01:12 +0200
In-Reply-To: <1477054644-5945-1-git-send-email-jani.nikula@intel.com>
References: <1477054644-5945-1-git-send-email-jani.nikula@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-10-21 at 15:57 +0300, Jani Nikula wrote:
> Signed-off-by: Jani Nikula <jani.nikula@intel.com>
> ---
>  include/net/mac80211.h | 21 +++++++++++++--------
>  1 file changed, 13 insertions(+), 8 deletions(-)
> 
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index a810dfcb83c2..e2dba93e374f 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -811,14 +811,18 @@ enum mac80211_rate_control_flags {
>   * in the control information, and it will be filled by the rate
>   * control algorithm according to what should be sent. For example,
>   * if this array contains, in the format { <idx>, <count> } the
> - * information
> + * information::
> 
[...]

interesting, are these not enabled by default?

I guess I'll pick up these patches, even if they probably make things
worse in my tree, since there it's still using docbook. But once we
merge everything it should be good then.

johannes
