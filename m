Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:37009 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161377AbXBOV3K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Feb 2007 16:29:10 -0500
Date: Thu, 15 Feb 2007 22:29:09 +0100
From: Jiri Benc <jbenc@suse.cz>
To: Michael Wu <flamingice@sourmilk.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] d80211: Simplify channel & mode configuration
Message-ID: <20070215222909.2b88dd56@griffin.suse.cz>
In-Reply-To: <200702092343.54479.flamingice@sourmilk.net>
References: <200702092325.39994.flamingice@sourmilk.net>
	<200702092343.54479.flamingice@sourmilk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 9 Feb 2007 23:43:50 -0500, Michael Wu wrote:
> This patch simplifies channel & mode setting while eliminating a race
> between channel configuration and scanning. It also adds a call to
> ieee80211_hw_config after ops->open.

Applied to my tree, thanks for the patch!

 Jiri

-- 
Jiri Benc
SUSE Labs
