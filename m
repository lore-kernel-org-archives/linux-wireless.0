Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:34966 "EHLO
	mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbcDPOxZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Apr 2016 10:53:25 -0400
Received: by mail-qk0-f194.google.com with SMTP id u190so5668354qkh.2
        for <linux-wireless@vger.kernel.org>; Sat, 16 Apr 2016 07:53:25 -0700 (PDT)
Date: Sat, 16 Apr 2016 10:53:14 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	kvalo@codeaurora.org, lkml2017@openmailbox.org
Subject: Re: [PATCH] ath9k: ar5008_hw_cmn_spur_mitigate: add missing mask_m &
 mask_p initialisation
Message-ID: <20160416145314.GB2894@localhost> (sfid-20160416_165329_511042_1BA3C476)
References: <120e427452ad7e93f17828e8bba4b043@openmailbox.org>
 <1460482664-21086-1-git-send-email-linux@rempel-privat.de>
 <20160415205939.GA2894@localhost>
 <5711D557.6000803@rempel-privat.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5711D557.6000803@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Apr 16, 2016 at 08:01:59AM +0200, Oleksij Rempel wrote:
> > For a future patch, "sizeof(mask_m)" or even just:
> > 
> >     u8 mask_m[123] = {0};
> > 
> > ... would be better here.  I looked at this bit and thought, no way is
> > "123" actually correct.  Lo and behold, that is actually the number of
> > array elements, whether that has a basis in something real or not :)
> 
> If you already on it can you please rework it on top of this patch?
> This complete function can be probably reworked.

I wasn't on it, but yeah I'll send a patch on top of this momentarily :)

-- 
Bob Copeland %% http://bobcopeland.com/
