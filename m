Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:43106 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755729AbZEHU20 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 May 2009 16:28:26 -0400
Subject: Re: [PATCH] mac80211: fix scan channel race
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1241698981.27208.8.camel@johannes.local>
References: <1241698981.27208.8.camel@johannes.local>
Content-Type: text/plain
Date: Fri, 08 May 2009 16:28:25 -0400
Message-Id: <1241814505.3412.0.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-05-07 at 14:23 +0200, Johannes Berg wrote:

> Pavel, I would appreciate if you could give it a quick test run, I don't
> seem to have a dual-band card with me right now.

It's working fine with ath5k.  Sorry for delay.

-- 
Regards,
Pavel Roskin
