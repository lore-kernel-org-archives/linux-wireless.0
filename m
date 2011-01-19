Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:55463 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896Ab1ASPjM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jan 2011 10:39:12 -0500
Received: by qyk12 with SMTP id 12so1054886qyk.19
        for <linux-wireless@vger.kernel.org>; Wed, 19 Jan 2011 07:39:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110119092036.19628.84273.stgit@localhost6.localdomain6>
References: <20110119091949.19628.28309.stgit@localhost6.localdomain6>
	<20110119092036.19628.84273.stgit@localhost6.localdomain6>
Date: Wed, 19 Jan 2011 10:39:10 -0500
Message-ID: <AANLkTi=0TwkUCHYpZY6sbqv6C_FF_RP1H6=9cwc_AdB6@mail.gmail.com>
Subject: Re: [PATCH 1/8] ath5k: Use mac80211 channel mapping function
From: Bob Copeland <me@bobcopeland.com>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 19, 2011 at 4:20 AM, Bruno Randolf <br1@einfach.org> wrote:
> Use mac80211 channel mapping function instead of own homegrown version.
>
> Signed-off-by: Bruno Randolf <br1@einfach.org>
> ---
>  drivers/net/wireless/ath/ath5k/base.c |   23 ++++++++---------------
>  1 files changed, 8 insertions(+), 15 deletions(-)

Acked-by: Bob Copeland <me@bobcopeland.com>

-- 
Bob Copeland %% www.bobcopeland.com
