Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:59620 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756332Ab3BVM1O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2013 07:27:14 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20775.25545.671357.512930@gargle.gargle.HOWL> (sfid-20130222_132718_974417_4AD9DB8A)
Date: Fri, 22 Feb 2013 17:55:45 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: Ben Greear <greearb@candelatech.com>, ath9k-devel@venema.h4ckr.net,
	linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] [RFC] ath9k: Detect and work-around tx-queue hang.
In-Reply-To: <51275837.4020708@openwrt.org>
References: <1361498797-14361-1-git-send-email-greearb@candelatech.com>
	<20774.62475.588131.344540@gargle.gargle.HOWL>
	<5126F732.6040007@candelatech.com>
	<20774.63702.208829.602903@gargle.gargle.HOWL>
	<51270186.6070003@candelatech.com>
	<51275837.4020708@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> Please also check if the station(s) that the frames are queued for are
> in powersave state for some reason. That would prevent the tx path from
> throwing them in the hw queue, yet they'd still take up pending-frame
> slots. I was planning on fixing this eventually by expiring frames that
> stay in the queue for too long, but haven't decided on the exact
> approach yet.

PS is disabled for multi-VIF.

Sujith
