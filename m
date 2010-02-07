Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:41697 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837Ab0BGNxt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Feb 2010 08:53:49 -0500
Received: by bwz19 with SMTP id 19so1133773bwz.28
        for <linux-wireless@vger.kernel.org>; Sun, 07 Feb 2010 05:53:47 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Kalle Valo <kalle.valo@iki.fi>
Subject: Re: [PATCH 03/10] ar9170: remove get_tx_stats() mac80211 op
Date: Sun, 7 Feb 2010 14:53:07 +0100
Cc: linux-wireless@vger.kernel.org,
	Christian Lamparter <chunkeey@web.de>
References: <20100207082044.31474.48583.stgit@tikku> <20100207082100.31474.30105.stgit@tikku>
In-Reply-To: <20100207082100.31474.30105.stgit@tikku>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201002071453.07618.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 07 February 2010 09:21:00 Kalle Valo wrote:
> get_tx_stats() will be removed from mac80211.
> 
> Because ar9170 uses ieee80211_tx_queue_stats internally, create a new
> identical struct ar9170_tx_queue_stats which the driver can use.
> 
> Cc: Christian Lamparter <chunkeey@web.de>
> Signed-off-by: Kalle Valo <kalle.valo@iki.fi>
> ---

Tested-by: Christian Lamparter <chunkeey@googlemail.com>
