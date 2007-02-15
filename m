Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:36977 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161374AbXBOV17 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Feb 2007 16:27:59 -0500
Date: Thu, 15 Feb 2007 22:27:58 +0100
From: Jiri Benc <jbenc@suse.cz>
To: Michael Wu <flamingice@sourmilk.net>
Cc: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] d80211: remove hosttime from ieee80211_rx_status
Message-ID: <20070215222758.260aa4ed@griffin.suse.cz>
In-Reply-To: <200702091247.36267.flamingice@sourmilk.net>
References: <200702082359.47085.flamingice@sourmilk.net>
	<200702091056.46679.flamingice@sourmilk.net>
	<20070209181513.66fdec56@griffin.suse.cz>
	<200702091247.36267.flamingice@sourmilk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 9 Feb 2007 12:47:31 -0500, Michael Wu wrote:
> Nobody fills hosttime in ieee80211_rx_status. Removing it allows
> ieee80211_rx_status to fit in skb->cb.

Applied to my tree, thanks for the patch!

 Jiri

-- 
Jiri Benc
SUSE Labs
