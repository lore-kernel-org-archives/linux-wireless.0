Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45448 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978Ab1ASP6U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jan 2011 10:58:20 -0500
Received: by pwj3 with SMTP id 3so180098pwj.19
        for <linux-wireless@vger.kernel.org>; Wed, 19 Jan 2011 07:58:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110119091949.19628.28309.stgit@localhost6.localdomain6>
References: <20110119091949.19628.28309.stgit@localhost6.localdomain6>
Date: Wed, 19 Jan 2011 17:58:19 +0200
Message-ID: <AANLkTimoaMY2BW0HPySk=YGnAiUJT0Yju94ZuO-6=AXF@mail.gmail.com>
Subject: Re: [PATCH 0/8] ath5k 802.11j preparation and cleanup
From: Nick Kossifidis <mickflemm@gmail.com>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/1/19 Bruno Randolf <br1@einfach.org>:
> This series prepares ath5k for 802.11j (4.9GHz) support but most of the patches
> are just cleaning up things i found in the process. 802.11j is still not
> enabled.
>
> bruno
>
> ---
>
> Bruno Randolf (8):
>      ath5k: Use mac80211 channel mapping function
>      ath5k: Simplify loop when setting up channels
>      ath5k: Rename ath5k_copy_channels
>      ath5k: ath5k_setup_channels cleanup and whitespace
>      ath5k: Add 802.11j 4.9GHz channels to allowed channels
>      ath5: Remove unused CTL definitions
>      ath5k: Remove unused sc->curmode
>      ath5k: Remove redundant sc->curband
>
>
>  drivers/net/wireless/ath/ath5k/base.c   |   95 +++++++++++--------------------
>  drivers/net/wireless/ath/ath5k/base.h   |    3 -
>  drivers/net/wireless/ath/ath5k/eeprom.h |   23 --------
>  3 files changed, 34 insertions(+), 87 deletions(-)
>
> --
> Signature

Nice clean up !


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
