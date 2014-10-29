Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38763 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933413AbaJ2PzS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 11:55:18 -0400
Message-ID: <1414598110.1827.19.camel@jlt4.sipsolutions.net> (sfid-20141029_165522_738020_341DEA24)
Subject: Re: [PATCH] mac80211-hwsim:  add frequency attribute to netlink pkts
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Date: Wed, 29 Oct 2014 16:55:10 +0100
In-Reply-To: <1414447486-10385-1-git-send-email-greearb@candelatech.com>
References: <1414447486-10385-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-10-27 at 15:04 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> Add frequency attribute when sending to user-space over
> netlink socket.  The frequency is currently ignored when
> receiving from user-space.

Applied.

johannes

