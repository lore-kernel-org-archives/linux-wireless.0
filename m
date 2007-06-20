Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:56062 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751571AbXFTLqH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2007 07:46:07 -0400
Date: Wed, 20 Jun 2007 13:46:04 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] clarify some mac80211 things
Message-ID: <20070620134604.72ecbbc7@griffin.suse.cz>
In-Reply-To: <1182333960.3714.54.camel@johannes.berg>
References: <1182333960.3714.54.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 20 Jun 2007 12:05:59 +0200, Johannes Berg wrote:
> The semantics of not having an add_interface callback are not well
> defined, this callback is required because otherwise you cannot obtain
> the requested MAC address of the device. Change the documentation to
> reflect this, add a note about having no MAC address at all, add a
> warning that mac_addr in struct ieee80211_if_init_conf can be NULL and
> finally verify that a few callbacks are assigned by way of BUG_ON()
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Acked-by: Jiri Benc <jbenc@suse.cz>


Maybe it's a time to finally get rid of open and stop callbacks...

 Jiri

-- 
Jiri Benc
SUSE Labs
