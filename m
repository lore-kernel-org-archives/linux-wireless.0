Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45336 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754178AbaGUKVt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2014 06:21:49 -0400
Message-ID: <1405938104.32255.18.camel@jlt4.sipsolutions.net> (sfid-20140721_122155_313843_924B357F)
Subject: Re: [PATCH] mac80211: remove redundant IEEE80211_STA_CSA_RECEIVED
 flag
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Date: Mon, 21 Jul 2014 12:21:44 +0200
In-Reply-To: <1404549781-5893-1-git-send-email-luca@coelho.fi>
References: <1404549781-5893-1-git-send-email-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2014-07-05 at 11:43 +0300, Luca Coelho wrote:
> From: Luciano Coelho <luciano.coelho@intel.com>
> 
> The csa_active flag was added in sdata a while ago and made
> IEEE80211_STA_CSA_RECEIVED redundant.  The new flag is also used to
> mark when CSA is ongoing on other iftypes and took over the old one as
> the preferred method for checking whether we're in the middle of a
> channel switch.  Remove the old, redundant flag.

Applied.

johannes

