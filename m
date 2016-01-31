Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33553 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757218AbcAaOgX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jan 2016 09:36:23 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Rakhi Sharma <rakhish1994@gmail.com>
Cc: Larry.Finger@lwfinger.net, gregkh@linuxfoundation.org,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH 3/3] Staging: rtl8723au: core: rtw_ieee80211: Fixed space and brace coding style issue.
References: <1454246643-24049-1-git-send-email-rakhish1994@gmail.com>
Date: Sun, 31 Jan 2016 09:36:22 -0500
In-Reply-To: <1454246643-24049-1-git-send-email-rakhish1994@gmail.com> (Rakhi
	Sharma's message of "Sun, 31 Jan 2016 18:54:03 +0530")
Message-ID: <wrfjy4b5zuhl.fsf@redhat.com> (sfid-20160131_153626_373654_7BC98874)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rakhi Sharma <rakhish1994@gmail.com> writes:
> Fixed the space and brace coding style error.
> ERROR: space required before that '='
> ERROR: that open brace { should be on the previous line.
>
> Signed-off-by: Rakhi Sharma <rakhish1994@gmail.com>
> ---
>  drivers/staging/rtl8723au/core/rtw_ieee80211.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/rtl8723au/core/rtw_ieee80211.c b/drivers/staging/rtl8723au/core/rtw_ieee80211.c
> index 3b0d782..0c933e4 100644
> --- a/drivers/staging/rtl8723au/core/rtw_ieee80211.c
> +++ b/drivers/staging/rtl8723au/core/rtw_ieee80211.c
> @@ -65,8 +65,8 @@ static u8 WIFI_OFDMRATES[] = {
>  
>  int rtw_get_bit_value_from_ieee_value23a(u8 val)
>  {
> -	unsigned char dot11_rate_table[] =
> -			{2, 4, 11, 22, 12, 18, 24, 36, 48, 72, 96, 108, 0};
> +	unsigned char dot11_rate_table[] = {
> +		2, 4, 11, 22, 12, 18, 24, 36, 48, 72, 96, 108, 0};
>  
>  	int i = 0;

This is a great example of checkpatch doing the wrong thing. What you
did here was to make the code uglier rather than better.

NACK

Jes
