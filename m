Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:48685 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932072Ab0BGLcK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Feb 2010 06:32:10 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Kalle Valo <kalle.valo@iki.fi>
Subject: Re: [PATCH 05/10] b43: remove get_tx_stats() mac80211 op
Date: Sun, 7 Feb 2010 12:32:04 +0100
Cc: linux-wireless@vger.kernel.org,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Larry Finger <Larry.Finger@lwfinger.net>
References: <20100207082044.31474.48583.stgit@tikku> <20100207082118.31474.79247.stgit@tikku>
In-Reply-To: <20100207082118.31474.79247.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <201002071232.06381.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 07 February 2010 09:21:19 Kalle Valo wrote:
> -		stats[i].count = ring->nr_tx_packets;

> -		stats[i].count = q->nr_tx_packets;

So you can remove the whole nr_tx_packets variable from the data structures,
because it's only used for the get_stats callback.

-- 
Greetings, Michael.
