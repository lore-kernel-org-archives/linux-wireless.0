Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:50160 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbYHRVMC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Aug 2008 17:12:02 -0400
Received: by nf-out-0910.google.com with SMTP id d3so1268491nfc.21
        for <linux-wireless@vger.kernel.org>; Mon, 18 Aug 2008 14:12:01 -0700 (PDT)
To: Felipe Balbi <me@felipebalbi.com>,
	John Linville <linville@tuxdriver.com>
Subject: Re: [PATCH] net: rfkill: add missing line break
Date: Mon, 18 Aug 2008 23:11:55 +0200
Cc: linux-wireless@vger.kernel.org,
	Felipe Balbi <felipe.balbi@nokia.com>
References: <1219089413-7884-1-git-send-email-me@felipebalbi.com>
In-Reply-To: <1219089413-7884-1-git-send-email-me@felipebalbi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200808182311.56070.IvDoorn@gmail.com> (sfid-20080818_231208_274400_7C7563A1)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 18 August 2008, Felipe Balbi wrote:
> From: Felipe Balbi <felipe.balbi@nokia.com>
> 
> Trivial patch adding a missing line break on
> rfkill_claim_show().
> 
> Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>

Thanks.

Acked-by: Ivo van Doorn <IvDoorn@gmail.co>

> ---
>  net/rfkill/rfkill.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
> index d2d4565..3bc78b0 100644
> --- a/net/rfkill/rfkill.c
> +++ b/net/rfkill/rfkill.c
> @@ -372,7 +372,7 @@ static ssize_t rfkill_claim_show(struct device *dev,
>  {
>  	struct rfkill *rfkill = to_rfkill(dev);
>  
> -	return sprintf(buf, "%d", rfkill->user_claim);
> +	return sprintf(buf, "%d\n", rfkill->user_claim);
>  }
>  
>  static ssize_t rfkill_claim_store(struct device *dev,


