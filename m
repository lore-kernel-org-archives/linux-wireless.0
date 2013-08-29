Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:51892 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073Ab3H2CZx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Aug 2013 22:25:53 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21022.45135.679715.629719@gargle.gargle.HOWL> (sfid-20130829_042556_621699_35EC859C)
Date: Thu, 29 Aug 2013 07:52:07 +0530
To: "John W. Linville" <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath9k: ar9003_eeprom.c:3618 fix variable name typo
In-Reply-To: <1377702550-11734-1-git-send-email-linville@tuxdriver.com>
References: <1377702550-11734-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> From: "John W. Linville" <linville@tuxdriver.com>
> 
>    drivers/net/wireless/ath/ath9k/ar9003_eeprom.c: In function 'ar9003_hw_ant_ctrl_apply':
> >> drivers/net/wireless/ath/ath9k/ar9003_eeprom.c:3618: warning: 'regval' is used uninitialized in this function
> 
> It seems obvious that 'regval' should have been 'value'...

Good catch and thanks for the fix !

Sujith
