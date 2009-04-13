Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57782 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbZDMXPr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2009 19:15:47 -0400
Date: Mon, 13 Apr 2009 19:11:23 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Vivek Natarajan <vivek.natraj@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k: Disable autosleep feature for AR9285 based
	chipsets.
Message-ID: <20090413231122.GB18841@tuxdriver.com> (sfid-20090414_011551_238157_F94B5710)
References: <20090331063752.GA9846@myhost.users.atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090331063752.GA9846@myhost.users.atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 31, 2009 at 12:07:52PM +0530, Vivek Natarajan wrote:
> Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
> ---
>  drivers/net/wireless/ath9k/hw.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
> index b15eaf8..7d07f09 100644
> --- a/drivers/net/wireless/ath9k/hw.c
> +++ b/drivers/net/wireless/ath9k/hw.c
> @@ -3411,7 +3411,8 @@ bool ath9k_hw_fill_cap_info(struct ath_hw *ah)
>  	    (ah->hw_version.macVersion == AR_SREV_VERSION_5416_PCIE) ||
>  	    (ah->hw_version.macVersion == AR_SREV_VERSION_9160) ||
>  	    (ah->hw_version.macVersion == AR_SREV_VERSION_9100) ||
> -	    (ah->hw_version.macVersion == AR_SREV_VERSION_9280))
> +	    (ah->hw_version.macVersion == AR_SREV_VERSION_9280) ||
> +	    (ah->hw_version.macVersion == AR_SREV_VERSION_9285))
>  		pCap->hw_caps &= ~ATH9K_HW_CAP_AUTOSLEEP;
>  	else
>  		pCap->hw_caps |= ATH9K_HW_CAP_AUTOSLEEP;

error: drivers/net/wireless/ath9k/hw.c: No such file or directory

Granted, I'm a bit behind on my patch queue.  Perhaps I'm missing a patch?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
