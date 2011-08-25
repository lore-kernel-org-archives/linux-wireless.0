Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29867 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085Ab1HYTm0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 15:42:26 -0400
Subject: Re: [PATCH] libertas: update readme file
From: Dan Williams <dcbw@redhat.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Thu, 25 Aug 2011 14:44:57 -0500
In-Reply-To: <1314059197-8377-1-git-send-email-bzhao@marvell.com>
References: <1314059197-8377-1-git-send-email-bzhao@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1314301498.3922.10.camel@dcbw.foobar.com> (sfid-20110825_214228_972436_31C2AAC3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-08-22 at 17:26 -0700, Bing Zhao wrote:
> From: Amitkumar Karwar <akarwar@marvell.com>
> 
> Since all wext specific code is removed, currently there is no
> way to configure deep sleep mode. This patch removes deep sleep
> configuration information in readme file.
> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
>  drivers/net/wireless/libertas/README |   25 -------------------------
>  1 files changed, 0 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/README b/drivers/net/wireless/libertas/README
> index 1453eec..91f2ca9 100644
> --- a/drivers/net/wireless/libertas/README
> +++ b/drivers/net/wireless/libertas/README
> @@ -238,28 +238,3 @@ hostsleep
>  		echo "1" > hostsleep : enable host sleep.
>  		echo "0" > hostsleep : disable host sleep
>  
> -========================
> -IWCONFIG COMMANDS
> -========================
> -power period
> -
> -	This command is used to configure the station in deep sleep mode /
> -	auto deep sleep mode.
> -
> -	The timer is implemented to monitor the activities (command, event,
> -	etc.). When an activity is detected station will exit from deep
> -	sleep mode automatically and restart the timer. At timer expiry
> -	(no activity for defined time period) the deep sleep mode is entered
> -	automatically.
> -
> -	Note: this command is for SDIO interface only.
> -
> -	Usage:
> -	To enable deep sleep mode do:
> -		iwconfig wlan0 power period 0
> -	To enable auto deep sleep mode with idle time period 5 seconds do:
> -		iwconfig wlan0 power period 5
> -	To disable deep sleep/auto deep sleep mode do:
> -		iwconfig wlan0 power period -1
> -
> -==============================================================================


