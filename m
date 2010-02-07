Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:41254 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933065Ab0BGSkl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Feb 2010 13:40:41 -0500
Received: by wwi18 with SMTP id 18so1393740wwi.19
        for <linux-wireless@vger.kernel.org>; Sun, 07 Feb 2010 10:40:39 -0800 (PST)
To: linux-wireless@vger.kernel.org
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH v2 2/2] b43legacy: remove get_tx_stats() mac80211 op
References: <87d40hhtc5.fsf@purkki.valot.fi>
	<20100207175100.8553.75762.stgit@tikku>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sun, 07 Feb 2010 20:40:37 +0200
In-Reply-To: <20100207175100.8553.75762.stgit@tikku> (Kalle Valo's message of "Sun\, 07 Feb 2010 19\:51\:00 +0200")
Message-ID: <874olsj3dm.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kalle.valo@iki.fi> writes:

> get_tx_stats() will be removed from mac80211.
>
> Compile-tested only.

Sorry, stgit didn't number the patches as I expected. This patch
replaces patch 6 from my remove get_tx_stats() patchset. I removed
nr_tx_packets as suggested by Michael.

-- 
Kalle Valo
