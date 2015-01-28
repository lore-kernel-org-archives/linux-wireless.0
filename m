Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:54340 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759196AbbA2Bxw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2015 20:53:52 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21704.53700.641822.118302@gargle.gargle.HOWL> (sfid-20150129_025357_650811_01401A7F)
Date: Wed, 28 Jan 2015 17:40:44 +0530
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/6] ath9k: Add a macro to identify PCOEM chips
In-Reply-To: <1421633598-4488-4-git-send-email-sujith@msujith.org>
References: <1421633598-4488-1-git-send-email-sujith@msujith.org>
	<1421633598-4488-4-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith Manoharan wrote:
>  #define AR_SREV_9462(_ah) 0
>  #define AR_SREV_9485(_ah) 0
>  #define AR_SREV_9565(_ah) 0
> +#define AR_SREV_9003_PCOEM(_ah) )

Kalle, this is a typo - I'll resend the series.

Sujith
