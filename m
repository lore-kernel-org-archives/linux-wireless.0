Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:35020 "EHLO
	mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbcFPQAJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2016 12:00:09 -0400
Received: by mail-qk0-f176.google.com with SMTP id c73so57630628qkg.2
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jun 2016 09:00:08 -0700 (PDT)
Date: Thu, 16 Jun 2016 11:59:59 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Cc: ath10k@lists.infradead.org, mohammed@codeaurora.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k: Fix a typo in spectral code commments
Message-ID: <20160616155958.GA24359@localhost> (sfid-20160616_180013_557310_2EECF713)
References: <1465882434-594-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1465882434-594-1-git-send-email-mohammed@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 14, 2016 at 11:03:54AM +0530, Mohammed Shafi Shajakhan wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> 
> Found this obvious typo while going through the spectral
> code design in ath10k

>  		/* TODO: As experiments with an analogue sender and various
> -		 * configuaritions (fft-sizes of 64/128/256 and 20/40/80 Mhz)
> +		 * configurations (fft-sizes of 64/128/256 and 20/40/80 Mhz)
>  		 * show, the particular configuration of 80 MHz/64 bins does
>  		 * not match with the other smaples at all. Until the reason
>  		 * for that is found, don't report these samples.

Also "smaples" :)

-- 
Bob Copeland %% http://bobcopeland.com/
