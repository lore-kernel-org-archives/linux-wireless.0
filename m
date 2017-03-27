Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32375 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751468AbdC0H3k (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Mar 2017 03:29:40 -0400
Subject: Re: [PATCH] Fixing Style Problems
To: vaibhavddit@gmail.com, linux-wireless@vger.kernel.org
References: <[PATCH 1/1] Fixing Coding style problems>
 <1490596579-22039-1-git-send-email-vaibhavddit@gmail.com>
From: Vaishali Thakkar <vaishali.thakkar@oracle.com>
Message-ID: <dd4b66c5-d835-4b1d-14ee-2c67799e8f72@oracle.com> (sfid-20170327_092957_901179_8623149F)
Date: Mon, 27 Mar 2017 12:57:37 +0530
MIME-Version: 1.0
In-Reply-To: <1490596579-22039-1-git-send-email-vaibhavddit@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 27 March 2017 12:06 PM, vaibhavddit@gmail.com wrote:
> From: Vaibhav Kothari <vaibhavddit@gmail.com>
>
> - Corrected 80 characters column width

Hi,

There are very high chances that this patch will be ignored.
Mainly because you have not CC'ed proper mailing lists and
maintainers.

I'm just mentioning few things which this patch is lacking:

- Proper Subject and commit log
- Use of scripts/get_maintainer.pl for getting the list of mailing
   lists and maintainers
- The change itself doesn't look correct, most of the time we advise
   newbies to avoid sending patches for 80 characters line warning as
   original author might have some reason for not doing that change.

You can use this[1] and this[2] to improve your patch.

Thanks!

[1] https://kernelnewbies.org/FirstKernelPatch
[2] https://kernelnewbies.org/PatchPhilosophy

> Signed-off-by: Vaibhav Kothari <vaibhavddit@gmail.com>
> ---
>  drivers/staging/wilc1000/coreconfigurator.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
> index 5256f40..794104b 100644
> --- a/drivers/staging/wilc1000/coreconfigurator.h
> +++ b/drivers/staging/wilc1000/coreconfigurator.h
> @@ -123,7 +123,7 @@ struct disconnect_info {
>  s32 wilc_parse_network_info(u8 *msg_buffer,
>  			    struct network_info **ret_network_info);
>  s32 wilc_parse_assoc_resp_info(u8 *buffer, u32 buffer_len,
> -			       struct connect_resp_info **ret_connect_resp_info);
> +			      struct connect_resp_info **ret_connect_resp_info);
>  void wilc_scan_complete_received(struct wilc *wilc, u8 *buffer, u32 length);
>  void wilc_network_info_received(struct wilc *wilc, u8 *buffer, u32 length);
>  void wilc_gnrl_async_info_received(struct wilc *wilc, u8 *buffer, u32 length);
>
