Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:47310 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933152AbXBWQzn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Feb 2007 11:55:43 -0500
Date: Fri, 23 Feb 2007 17:55:41 +0100
From: Jiri Benc <jbenc@suse.cz>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] d80211: optimise if_alloc() name creation.
Message-ID: <20070223175541.72a806b8@griffin.suse.cz>
In-Reply-To: <20070222223941.7f637c2c@localhost>
References: <20070222223941.7f637c2c@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 22 Feb 2007 22:39:41 -0800, Stephen Hemminger wrote:
> The code to do guess and check for creating a sub-device name is unnecessary.
> dev_alloc_name() is optimized to do this already.

Applied, thanks!

 Jiri

-- 
Jiri Benc
SUSE Labs
