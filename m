Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:52790 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753267AbYJ2QEn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 12:04:43 -0400
Subject: Re: [PATCH] don't use net/ieee80211.h
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1225243531.1369.18.camel@johannes.berg>
References: <1225243531.1369.18.camel@johannes.berg>
Content-Type: text/plain
Date: Wed, 29 Oct 2008 12:04:39 -0400
Message-Id: <1225296279.23265.1.camel@dv> (sfid-20081029_170447_286789_2E1B5E19)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-10-29 at 02:25 +0100, Johannes Berg wrote:
> Convert all the drivers using net/ieee80211.h to use linux/ieee80211.h.
> Contains a bugfix in libertas where the SSID parsing could overrun the
> buffer when the AP sends invalid information.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

For orinoco.c:
Acked-by: Pavel Roskin <proski@gnu.org>

-- 
Regards,
Pavel Roskin
