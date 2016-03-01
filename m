Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35905 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753746AbcCAOtq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2016 09:49:46 -0500
Message-ID: <1456843782.3926.32.camel@sipsolutions.net> (sfid-20160301_154949_999177_F69DA0CC)
Subject: Re: [PATCH] mac80211: minstrel_ht: fix a logic error in RTS/CTS
 handling
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
Cc: mrichart@fing.edu.uy, chaitanya.mgit@gmail.com
Date: Tue, 01 Mar 2016 15:49:42 +0100
In-Reply-To: <1456312037-82995-1-git-send-email-nbd@openwrt.org>
References: <1456312037-82995-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-02-24 at 12:07 +0100, Felix Fietkau wrote:
> RTS/CTS needs to be enabled if the rate is a fallback rate *or* if
> it's a dual-stream rate and the sta is in dynamic SMPS mode.
> 
Applied, thanks.

johannes
