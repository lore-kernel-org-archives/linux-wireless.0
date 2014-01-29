Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42168 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbaA2MHH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jan 2014 07:07:07 -0500
Message-ID: <1390997223.4143.3.camel@jlt4.sipsolutions.net> (sfid-20140129_130710_613226_66887B87)
Subject: Re: [PATCH] mac80211: ibss: remove unnecessary call to release
 channel
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 29 Jan 2014 13:07:03 +0100
In-Reply-To: <1390921748-7566-1-git-send-email-luca@coelho.fi>
References: <1390921748-7566-1-git-send-email-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-01-28 at 17:09 +0200, Luciano Coelho wrote:
> From: Luciano Coelho <luciano.coelho@intel.com>
> 
> The ieee80211_vif_use_channel() function calls
> ieee80211_vif_release_channel(), so there's no need to call it
> explicitly in __ieee80211_sta_join_ibss().

Applied.

johannes

