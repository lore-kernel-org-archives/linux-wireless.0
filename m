Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f66.google.com ([209.85.192.66]:36557 "EHLO
	mail-qg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbcA1No0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2016 08:44:26 -0500
Received: by mail-qg0-f66.google.com with SMTP id 6so3099877qgy.3
        for <linux-wireless@vger.kernel.org>; Thu, 28 Jan 2016 05:44:25 -0800 (PST)
Date: Thu, 28 Jan 2016 08:44:15 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Henning Rogge <hrogge@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	Henning Rogge <henning.rogge@fkie.fraunhofer.de>
Subject: Re: [PATCH 0/2] mac80211: add cleanup path for MPP table entries
Message-ID: <20160128134415.GA24581@localhost> (sfid-20160128_144430_144446_7E8DF6AE)
References: <1453190672-9748-1-git-send-email-henning.rogge@fkie.fraunhofer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1453190672-9748-1-git-send-email-henning.rogge@fkie.fraunhofer.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 19, 2016 at 09:04:30AM +0100, Henning Rogge wrote:
> Currently MPP table entries are only removed from memory when their
> 802.11s mesh interface goes down. This can make the kernel to remember
> a growing list of proxied mac addresses which are not relevant or even
> reachable anymore.

Just so I know what to do with my series: do you plan to resend these
with comments addressed?  Or I could adopt the patches if you want.

-- 
Bob Copeland %% http://bobcopeland.com/
