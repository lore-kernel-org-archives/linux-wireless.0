Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:36248 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751999AbXCWSE3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2007 14:04:29 -0400
Date: Fri, 23 Mar 2007 19:04:27 +0100
From: Jiri Benc <jbenc@suse.cz>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: [PATCH] mac80211: Fix pkt_type annotations
Message-ID: <20070323190427.1a9f7781@griffin.suse.cz>
In-Reply-To: <200703061743.41510.mb@bu3sch.de>
References: <200703061743.41510.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 6 Mar 2007 17:43:41 +0100, Michael Buesch wrote:
> There is no need for an instance of the enum in ieee80211_local.
> Remove it. Also make the constants uppercase to respect
> kernel coding style.

Applied to my tree, thanks!

 Jiri

-- 
Jiri Benc
SUSE Labs
