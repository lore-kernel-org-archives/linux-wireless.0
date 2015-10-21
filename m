Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:35295 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756256AbbJUWAH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Oct 2015 18:00:07 -0400
Received: by lbbes7 with SMTP id es7so48455834lbb.2
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2015 15:00:05 -0700 (PDT)
Subject: Re: [PATCH v2 05/15] net: wireless: ti: Return flow can be simplified
 for wl1271_cmd_interrogate
To: Punit Vara <punitvara@gmail.com>, kvalo@codeaurora.org
References: <1445454428-12331-1-git-send-email-punitvara@gmail.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, jslaby@suse.cz, lkp@intel.com
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <56280AE2.6010502@cogentembedded.com> (sfid-20151022_000037_916737_EE13537C)
Date: Thu, 22 Oct 2015 01:00:02 +0300
MIME-Version: 1.0
In-Reply-To: <1445454428-12331-1-git-send-email-punitvara@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/21/2015 10:07 PM, Punit Vara wrote:

> Remove int ret suggested by kbuild test robot
>
> This patch is to the wlcore/acx.c file that fixes up warning
> reported by coccicheck:
>
> WARNING: end returns can be simplified if negative or 0 value
>
> Prefer direct return value instead of writing 2-3 more sentence.
>
> Signed-off-by: Punit Vara <punitvara@gmail.com>
> ---
>   drivers/net/wireless/ti/wlcore/acx.c | 7 +------
>   1 file changed, 1 insertion(+), 6 deletions(-)
>
> diff --git a/drivers/net/wireless/ti/wlcore/acx.c b/drivers/net/wireless/ti/wlcore/acx.c
> index f28fa3b..6b566d9 100644
> --- a/drivers/net/wireless/ti/wlcore/acx.c
> +++ b/drivers/net/wireless/ti/wlcore/acx.c
> @@ -158,16 +158,11 @@ out:
>   int wl1271_acx_mem_map(struct wl1271 *wl, struct acx_header *mem_map,
>   		       size_t len)
>   {
> -	int ret;
>

    You now need to kill this empty line as well.

[...]

MBR, Sergei+

