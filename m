Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:51994 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752264AbXEAPrM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 May 2007 11:47:12 -0400
Date: Tue, 1 May 2007 17:47:04 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] fix mac80211 compile w/o VERBOSE_DEBUG but w/ DEBUG
Message-ID: <20070501174704.1d7f754f@logostar.upir.cz>
In-Reply-To: <1178017929.3483.23.camel@johannes.berg>
References: <1178017929.3483.23.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 01 May 2007 13:12:09 +0200, Johannes Berg wrote:
> This fixes mac80211 compilation when CONFIG_MAC80211_DEBUG is set but
> CONFIG_MAC80211_VERBOSE_DEBUG is not.

Applied. Thanks.

 Jiri

-- 
Jiri Benc
SUSE Labs
