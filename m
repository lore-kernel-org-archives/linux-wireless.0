Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:35483 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab3K0H1N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Nov 2013 02:27:13 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21141.40370.571357.458347@gargle.gargle.HOWL> (sfid-20131127_082721_685497_5E7B5DA6)
Date: Wed, 27 Nov 2013 12:52:26 +0530
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k: Update AR9580 initvals
In-Reply-To: <1385483800-22004-1-git-send-email-sujith@msujith.org>
References: <1385483800-22004-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith Manoharan wrote:
> @@ -519,7 +624,7 @@ static const u32 ar9580_1p0_mac_core[][2] = {
>  	{0x00008258, 0x00000000},
>  	{0x0000825c, 0x40000000},
>  	{0x00008260, 0x00080922},
> -	{0x00008264, 0x9d400010},
> +	{0x00008264, 0x9bc00010},

I am not sure if this part is correct, so please drop
this patch for now.

Sujith
