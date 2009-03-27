Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:37246 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbZC0W1B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 18:27:01 -0400
Date: Fri, 27 Mar 2009 18:26:59 -0400
From: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 4/8] mac80211: clean up __ieee80211_tx args
Message-ID: <20090327222658.GC5543@bombadil.infradead.org> (sfid-20090327_232706_613421_708B83EB)
References: <20090323162834.154525349@sipsolutions.net> <20090323163052.569487987@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090323163052.569487987@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 23, 2009 at 05:28:38PM +0100, Johannes Berg wrote:
> __ieee80211_tx takes a struct ieee80211_tx_data argument, but only
> uses a few of its members, namely 'skb' and 'sta'. Make that explicit,
> so that less internal knowledge is required in ieee80211_tx_pending
> and the possibility of introducing errors here is removed.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Reviewed-by: Luis R. Rodriguez <lrodriguez@atheros.com>

  Luis

