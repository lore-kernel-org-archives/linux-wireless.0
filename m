Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0138.hostedemail.com ([216.40.44.138]:46886 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751364AbbGaFqG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2015 01:46:06 -0400
Message-ID: <1438321562.19675.50.camel@perches.com> (sfid-20150731_074609_958345_934EF16F)
Subject: Re: [PATCH] Staging : wilc1000 :Remove typedef from struct
From: Joe Perches <joe@perches.com>
To: Shraddha Barke <shraddha.6596@gmail.com>
Cc: Dean Lee <dean.lee@atmel.com>, Rachel Kim <rachel.kim@atmel.com>,
	Johnny Kim <johnny.kim@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Date: Thu, 30 Jul 2015 22:46:02 -0700
In-Reply-To: <1438320752-7921-1-git-send-email-shraddha.6596@gmail.com>
References: <1438320752-7921-1-git-send-email-shraddha.6596@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-07-31 at 11:02 +0530, Shraddha Barke wrote:
> This patch fixes the following checkpatch.pl warning:
> 
> WARNING: do not add new typedefs
> Signed-off-by: Shraddha Barke <shraddha.6596@gmail.com>
> ---
>  drivers/staging/wilc1000/coreconfigurator.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
> index 0f31d63..54eb8a1 100644
> --- a/drivers/staging/wilc1000/coreconfigurator.c
> +++ b/drivers/staging/wilc1000/coreconfigurator.c
> @@ -140,7 +140,7 @@ typedef enum {
>  } tenuInfoElemID;
>  
> 
> -typedef struct {
> +struct {
>  	char *pcRespBuffer;
>  	s32 s32MaxRespBuffLen;
>  	s32 s32BytesRead;

You haven't compiled this.

