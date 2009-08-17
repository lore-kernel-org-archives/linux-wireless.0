Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:45593 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757220AbZHQIDb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 04:03:31 -0400
Date: Mon, 17 Aug 2009 10:03:29 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: linux-wireless@vger.kernel.org
Cc: gregkh@suse.de
Subject: question about ieee80211_tx.c (fwd)
Message-ID: <Pine.LNX.4.64.0908171000500.20447@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The files ieee80211_tx.c in the directories 
drivers/staging/rtl8192su/ieee80211 and drivers/staging/rtl8192e/ieee80211 
both contain the following code in the function 
ieee80211_query_protectionmode:

       if (ieee->mode == IW_MODE_MASTER)
		        goto NO_PROTECTION;

Elsewhere in these files when there is a comparison against an IW_MODE 
value, the field that is compared is iw_mode.  Should that be the case 
here as well?

thanks,
julia
