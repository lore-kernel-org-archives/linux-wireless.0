Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:34640 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbbGaFcc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2015 01:32:32 -0400
MIME-Version: 1.0
In-Reply-To: <1438319755-7438-1-git-send-email-shraddha.6596@gmail.com>
References: <1438319755-7438-1-git-send-email-shraddha.6596@gmail.com>
Date: Fri, 31 Jul 2015 11:02:30 +0530
Message-ID: <CAK-LDbJi8VeQAmK4AaCoD4RqOW09b-vOzJfLJwHVQDFh7oYZ0A@mail.gmail.com> (sfid-20150731_073248_680418_F13508ED)
Subject: Re: [PATCH] Staging:wilc1000 :Remove braces for single statement blocks
From: Vaishali Thakkar <vthakkar1994@gmail.com>
To: Shraddha Barke <shraddha.6596@gmail.com>
Cc: linux-wireless@vger.kernel.org, Rachel Kim <rachel.kim@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Johnny Kim <johnny.kim@atmel.com>,
	linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 31 Jul 2015 10:49, "Shraddha Barke" <shraddha.6596@gmail.com> wrote:
>
> This patch fixes the following checkpatch.pl warning:
>
> WARNING: braces {} are not necessary for single statement blocks

There should be one line space between your commit log
and Signed-off-by line.

> Signed-off-by: Shraddha Barke <shraddha.6596@gmail.com>
> ---
>  drivers/staging/wilc1000/coreconfigurator.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
> index 4d5bd1c..1143282 100644
> --- a/drivers/staging/wilc1000/coreconfigurator.c
> +++ b/drivers/staging/wilc1000/coreconfigurator.c
> @@ -1055,10 +1055,8 @@ s32 DeallocateSurveyResults(wid_site_survey_reslts_s *pstrSurveyResults)
>  {
>         s32 s32Error = WILC_SUCCESS;
>
> -       if (pstrSurveyResults != NULL) {
> +       if (pstrSurveyResults != NULL)
>                 WILC_FREE(pstrSurveyResults);
> -       }
> -
>         return s32Error;
>  }
>  #endif
> --
> 2.1.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
