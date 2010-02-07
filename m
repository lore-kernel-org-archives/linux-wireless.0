Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:48051 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199Ab0BGNxt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Feb 2010 08:53:49 -0500
Received: by bwz19 with SMTP id 19so1133774bwz.28
        for <linux-wireless@vger.kernel.org>; Sun, 07 Feb 2010 05:53:47 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Kalle Valo <kalle.valo@iki.fi>
Subject: Re: [PATCH 08/10] p54: remove get_tx_stats() mac80211 op
Date: Sun, 7 Feb 2010 14:52:54 +0100
Cc: linux-wireless@vger.kernel.org,
	Christian Lamparter <chunkeey@web.de>
References: <20100207082044.31474.48583.stgit@tikku> <20100207082146.31474.70086.stgit@tikku>
In-Reply-To: <20100207082146.31474.70086.stgit@tikku>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201002071452.54590.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 07 February 2010 09:21:46 Kalle Valo wrote:
> get_tx_stats() will be removed from mac80211.
> 
> p54 uses struct ieee80211_tx_queue_stats also internally, so create a new
> identical struct p54_tx_queue_stats which the driver can use.
> 
> Cc: Christian Lamparter <chunkeey@web.de>
> Signed-off-by: Kalle Valo <kalle.valo@iki.fi>
> ---

Tested-by: Christian Lamparter <chunkeey@googlemail.com>
