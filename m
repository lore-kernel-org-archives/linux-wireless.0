Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:47383 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751005Ab1GMT4L convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 15:56:11 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 13 Jul 2011 12:56:03 -0700
Subject: RE: [PATCH 10/11] mwifiex: add wext include
Message-ID: <477F20668A386D41ADCC57781B1F704307FFB08C50@SC-VEXCH1.marvell.com> (sfid-20110713_215615_795956_250C039C)
References: <20110713083908.713123063@sipsolutions.net>
 <20110713084035.355518062@sipsolutions.net>
In-Reply-To: <20110713084035.355518062@sipsolutions.net>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> From: Johannes Berg <johannes.berg@intel.com>
> 
> In trying to remove the wext includes from mac80211
> and cfg80211 I found that mwifiex currently uses
> them. This is wrong, it shouldn't, but to not break
> it completely include wext there.
> 
> Please remove this and fix all the resulting bugs.

Thanks for pointing that out.
I will remove the wext and fix all the resulting bugs.

Thanks,
Bing

> 
> Cc: Bing Zhao <bzhao@marvell.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Acked-by: Bing Zhao <bzhao@marvell.com>

> ---
>  drivers/net/wireless/mwifiex/ioctl.h |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- a/drivers/net/wireless/mwifiex/ioctl.h	2011-07-13 10:29:57.000000000 +0200
> +++ b/drivers/net/wireless/mwifiex/ioctl.h	2011-07-13 10:32:42.000000000 +0200
> @@ -20,6 +20,7 @@
>  #ifndef _MWIFIEX_IOCTL_H_
>  #define _MWIFIEX_IOCTL_H_
> 
> +#include <linux/wireless.h>
>  #include <net/mac80211.h>
> 
>  enum {
> 

