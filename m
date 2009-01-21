Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:22630 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880AbZAUQsW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jan 2009 11:48:22 -0500
Subject: Re: [ath9k-devel] [PATCH] ath9k: Fix typo in chip version check
From: Pavel Roskin <proski@gnu.org>
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: linville@tuxdriver.com, ath9k-devel@lists.ath9k.org,
	Jouni.Malinen@atheros.com, linux-wireless@vger.kernel.org,
	Luis.Rodriguez@atheros.com
In-Reply-To: <1232538528-14289-1-git-send-email-vasanth@atheros.com>
References: <1232538528-14289-1-git-send-email-vasanth@atheros.com>
Content-Type: text/plain
Date: Wed, 21 Jan 2009 11:48:15 -0500
Message-Id: <1232556495.17147.4.camel@dv> (sfid-20090121_174827_078204_1BADBC9E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello, Vasanthakumar!

On Wed, 2009-01-21 at 17:18 +0530, Vasanthakumar Thiagarajan wrote:
> Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> ---
>  drivers/net/wireless/ath9k/hw.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

I'm not a developer of ath9k, and I don't know much about the hardware.
However, I think your patch should be better explained.

> -	if (AR_SREV_9280(ah)) {
> +	if (AR_SREV_9280_10_OR_LATER(ah)) {

It's not a typo.  A typo would be something like AR_SREV_9380, that is
never defined.  Or maybe a message like "foudn AR9280".  AR_SREV_9280 is
defined and has valid uses.  If you think it needs to be changed in this
particular case, an explanation is needed.  It would be nice if you
mentioned that it fixes something for some hardware.
 
-- 
Regards,
Pavel Roskin
