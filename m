Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:34102 "EHLO
	mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbbJMSwA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 14:52:00 -0400
Received: by iow1 with SMTP id 1so31537326iow.1
        for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2015 11:52:00 -0700 (PDT)
Date: Tue, 13 Oct 2015 13:37:33 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4 0/5] wireless-regdb: Update TW and US rules to latest
 regulations
Message-ID: <20151013183733.GB50632@ubuntu-hedt> (sfid-20151013_205205_942529_8D532F86)
References: <1444061698-16384-1-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1444061698-16384-1-git-send-email-wens@csie.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 06, 2015 at 12:14:53AM +0800, Chen-Yu Tsai wrote:
> Hi Seth,
> 
> This is v4 of my TW/US 5GHz updates series. Hopefully this one will go
> in without further work.
> 
> Changes since v3:
> 
>   - Moved power limit increase of 5250 ~ 5350 MHz band from patch 4 to
>     patch 5.
> 
> Changes since v2:
> 
>   - Moved the US U-NII-1 (5150 ~ 5250 MHz) patch in front of the TW patch
> 
>   - Drop U-NII-1 power limit from 24 dBm to 23 dBm, to be on the safe
>     side of 250mW
> 
> 
> Patch 1 updates the 5470 ~ 5725 MHz rules for Taiwan, specifically
> the opening up of 5600 ~ 5650 MHz spectrum previously allocated to
> weather radars. The transmission power limit is also corrected to
> match the regulations.
> 
> Patch 2 changes the boundary frequencies for each rule for Taiwan to
> match the frequency allocation table. The "regulation" database shouldn't
> care about artificial channel boundaries.
> 
> Patch 3 updates the transmission power limits for 5150 ~ 5250 MHz for
> the US.
> 
> Patch 4 adds the previously unusable 5150 ~ 5250 MHz band for Taiwan.
> 
> Patch 5 updates the transmission power limits for Taiwan, per the NCC's
> official reply. This patch may be slightly controversial, as there is
> no official English document. Either someone will have to independently
> verify this, or translate the Chinese document.

Applied all 5, thanks.
