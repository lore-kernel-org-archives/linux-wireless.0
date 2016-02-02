Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:35000 "EHLO
	mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbcBBCWQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Feb 2016 21:22:16 -0500
Received: by mail-io0-f193.google.com with SMTP id m139so87763ioe.2
        for <linux-wireless@vger.kernel.org>; Mon, 01 Feb 2016 18:22:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1454372892-4962-1-git-send-email-rakhish1994@gmail.com>
References: <1454372892-4962-1-git-send-email-rakhish1994@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 2 Feb 2016 13:21:56 +1100
Message-ID: <CAGRGNgUEX2mJWBywwcqE21xiHZubmf=eER6DNHLgeYpB-At+aw@mail.gmail.com> (sfid-20160202_032219_563640_B2FFD186)
Subject: Re: [PATCH v2 5/5] Staging: rtl8723au: core: rtw_ieee80211: Fixed a
 coding style Warning.
To: Rakhi Sharma <rakhish1994@gmail.com>
Cc: Joe Perches <joe@perches.com>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Rakhi,

On Tue, Feb 2, 2016 at 11:28 AM, Rakhi Sharma <rakhish1994@gmail.com> wrote:
> Fixed a braces style warning.
> Warning: braces {} are not necessary for single statement blocks.
>
> Signed-off-by: Rakhi Sharma <rakhish1994@gmail.com>
> ---
> Changes in v2:
>   - remove a blank line. To make it readable.
> ---
>  drivers/staging/rtl8723au/core/rtw_ieee80211.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/staging/rtl8723au/core/rtw_ieee80211.c b/drivers/staging/rtl8723au/core/rtw_ieee80211.c
> index 365f780..55a5078 100644
> --- a/drivers/staging/rtl8723au/core/rtw_ieee80211.c
> +++ b/drivers/staging/rtl8723au/core/rtw_ieee80211.c
> @@ -177,8 +177,8 @@ u8 *rtw_get_ie23a(u8 *pbuf, int index, int *len, int limit)
>         u8 *p;
>
>         if (limit < 1)
> -
>                 return NULL;
> +

This looks line an incremental patch on top of your original one.

You need to resubmit the original patch with this change incorporated.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
