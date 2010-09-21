Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51403 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431Ab0IUGq6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Sep 2010 02:46:58 -0400
Subject: Re: [mac80211] mac80211:  Support receiving data frames on
 multiple vifs.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1285018776-21795-1-git-send-email-greearb@candelatech.com>
References: <1285018776-21795-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Sep 2010 08:47:21 +0200
Message-ID: <1285051641.3710.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-09-20 at 14:39 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> When using multiple STA interfaces on the same radio, some
> data packets need to be received on all interfaces
> (broadcast, for instance).
> 
> Make the STA loop look similar to the mgt-data loop.
> 
> Also, add logic to check RX_FLAG_MMIC_ERROR for last
> interface in mgt-data loop.
> 
> This needs review.

Looks fine to me, I think.

johannes

