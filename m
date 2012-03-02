Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59366 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758458Ab2CBIv5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2012 03:51:57 -0500
Subject: Re: [PATCH 19/21] cw1200: TODO list.
From: Johannes Berg <johannes@sipsolutions.net>
To: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1330652495-25837-20-git-send-email-dmitry.tarnyagin@stericsson.com> (sfid-20120302_024214_419049_90816933)
References: <d53e019b1a0bcd29c2c367fbe5665413f2d33938-submit>
	 <1330652495-25837-1-git-send-email-dmitry.tarnyagin@stericsson.com>
	 <1330652495-25837-20-git-send-email-dmitry.tarnyagin@stericsson.com>
	 (sfid-20120302_024214_419049_90816933)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Mar 2012 09:51:55 +0100
Message-ID: <1330678315.8542.8.camel@jlt3.sipsolutions.net> (sfid-20120302_095202_273626_854715D4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-03-02 at 02:41 +0100, Dmitry Tarnyagin wrote:
> Just a TODO list for the driver.
> 
> Signed-off-by: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
> ---
>  drivers/staging/cw1200/TODO |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/staging/cw1200/TODO
> 
> diff --git a/drivers/staging/cw1200/TODO b/drivers/staging/cw1200/TODO
> new file mode 100644
> index 0000000..8967a29
> --- /dev/null
> +++ b/drivers/staging/cw1200/TODO
> @@ -0,0 +1,7 @@
> +TODO:
> +        - IBSS: Not implemented. Consider as obsolete?
> +	- Convert bh thread to a realtime workqueue.
> +	- Submit mac80211 CQM (beacon miss, tx fail) changes
> +	  and reenable CQM extensions in the driver.
> +	- Align filters in pm.c with wowlan filters.
> +	- Different suspend strategy for Linux and Android.

It's nice that you add this todo list, so we know you have a plan to
still work on it :-)

Apart from my few small comments though I don't really see anything
wrong with the code that would require inclusion into staging. I think
that when you resend (I'd like you to address some of the Kconfig issues
I pointed out) you should just put the driver into drivers/net/wireless/
instead.

johannes

