Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47596 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbaIDRaO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Sep 2014 13:30:14 -0400
Date: Thu, 4 Sep 2014 13:24:50 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Sujith Manoharan <sujith@msujith.org>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: Re: [PATCH 0/5] ath9k patches
Message-ID: <20140904172450.GF3467@tuxdriver.com> (sfid-20140904_193018_658311_9EC66733)
References: <1409730929-30208-1-git-send-email-sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1409730929-30208-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am having a lot of trouble determining which of your series are
intended as fixes for the current release (3.17) or updates for the
next release (3.18).  In this series, several seem like fixes but
"ath9k: Fix ath_startrecv" seems like a cleanup.

Would you like to reorganize your patch submissions as fixes
vs. features?  Or do you want them all to be merged as features
for 3.18?

John

On Wed, Sep 03, 2014 at 01:25:24PM +0530, Sujith Manoharan wrote:
> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> 
> Various fixes for MCC.
> 
> Sujith Manoharan (5):
>   ath9k: Fix RX filter calculation
>   ath9k: Fix ath_startrecv()
>   ath9k: Fix COMP_BAR filter
>   ath9k: Fix RX filters in channel contexts
>   ath9k: Fix interface accounting
> 
>  drivers/net/wireless/ath/ath9k/ath9k.h  |  7 ++++---
>  drivers/net/wireless/ath/ath9k/beacon.c |  2 +-
>  drivers/net/wireless/ath/ath9k/debug.c  |  2 +-
>  drivers/net/wireless/ath/ath9k/main.c   | 20 +++++++++-----------
>  drivers/net/wireless/ath/ath9k/recv.c   | 31 +++++++++++++++++++------------
>  drivers/net/wireless/ath/ath9k/tx99.c   |  2 +-
>  drivers/net/wireless/ath/ath9k/wow.c    |  2 +-
>  7 files changed, 36 insertions(+), 30 deletions(-)
> 
> -- 
> 2.1.0
> 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
