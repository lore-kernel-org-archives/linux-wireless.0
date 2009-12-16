Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36606 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935525AbZLPTP1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2009 14:15:27 -0500
Date: Wed, 16 Dec 2009 14:10:56 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: greg@kroah.com, stable@kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/5] stable-2.6.32: few ath9k fixes/mac80211 which
	missed CC'ing stable
Message-ID: <20091216191056.GL11793@tuxdriver.com>
References: <1260982305-32244-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1260982305-32244-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 16, 2009 at 11:51:40AM -0500, Luis R. Rodriguez wrote:
> Greg, here's a few patches which are stable fixes for which we missed
> to CC stable on. They are all upstream on Linus' tree now. A few required
> some backport work so I took the time to do this for you.
> 
> Felix Fietkau (1):
>   ath9k: fix tx status reporting
> 
> Luis R. Rodriguez (2):
>   ath9k: fix processing of TX PS null data frames
>   ath9k: Fix maximum tx fifo settings for single stream devices
> 
> Sujith (1):
>   ath9k: Fix TX hang poll routine
> 
> Vivek Natarajan (1):
>   mac80211: Fix dynamic power save for scanning.

ACK

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
