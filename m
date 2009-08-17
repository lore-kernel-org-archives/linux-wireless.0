Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f215.google.com ([209.85.220.215]:41609 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261AbZHQPoP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 11:44:15 -0400
Received: by fxm11 with SMTP id 11so2361708fxm.39
        for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2009 08:44:16 -0700 (PDT)
To: Bob Copeland <me@bobcopeland.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wl1251: correct definitions for 0th bit defines
References: <20090817151814.GB13125@hash.localnet>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Mon, 17 Aug 2009 18:44:13 +0300
In-Reply-To: <20090817151814.GB13125@hash.localnet> (Bob Copeland's message of "Mon\, 17 Aug 2009 11\:18\:14 -0400")
Message-ID: <87r5vatpgy.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland <me@bobcopeland.com> writes:

> ACX_SLV_SOFT_RESET_BIT and ACX_REG_EEPROM_START_BIT are both defined
> as "1" in the vendor driver code, but they were defined to be BIT(1)
> ("2") here.  
>
> The SOFT_RESET typo ensures that wl1251_boot_soft_reset() doesn't;
> as a result the device hangs when trying to reprogram the PLL
> registers while running.

My bad, thanks for fixing this.

> Signed-off-by: Bob Copeland <me@bobcopeland.com>

Acked-by: Kalle Valo <kalle.valo@nokia.com>

-- 
Kalle Valo
