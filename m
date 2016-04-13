Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35734 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965886AbcDMJmA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2016 05:42:00 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	lkml2017@openmailbox.org
Subject: Re: [PATCH] ath9k: ar5008_hw_cmn_spur_mitigate: add missing mask_m & mask_p initialisation
References: <120e427452ad7e93f17828e8bba4b043@openmailbox.org>
	<1460482664-21086-1-git-send-email-linux@rempel-privat.de>
Date: Wed, 13 Apr 2016 12:41:55 +0300
In-Reply-To: <1460482664-21086-1-git-send-email-linux@rempel-privat.de>
	(Oleksij Rempel's message of "Tue, 12 Apr 2016 19:37:44 +0200")
Message-ID: <878u0hzvz0.fsf@purkki.adurom.net> (sfid-20160413_114206_020350_0092F892)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Oleksij Rempel <linux@rempel-privat.de> writes:

> by moving common code to ar5008_hw_cmn_spur_mitigate i forgot to move
> mask_m & mask_p initialisation. This coused a performance regression
> on ar9281.
>
> Fixes: f911085ffa88 ("ath9k: split ar5008_hw_spur_mitigate and reuse common code in ar9002_hw_spur_mitigate.")
> Reported-by: Gustav Frederiksen <lkml2017@openmailbox.org>
> Tested-by: Gustav Frederiksen <lkml2017@openmailbox.org>
> Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>

If no objections I'm planning to send this to 4.6.

-- 
Kalle Valo
