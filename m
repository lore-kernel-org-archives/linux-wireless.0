Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36034 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756AbaBUIiE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Feb 2014 03:38:04 -0500
Message-ID: <1392971881.4346.26.camel@jlt4.sipsolutions.net> (sfid-20140221_093809_336694_C38EC3AC)
Subject: Re: [PATCH v3 4/7] mac80211: ibss: handle
 cfg80211_chandef_dfs_required() error codes
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, michal.kazior@tieto.com,
	sw@simonwunderlich.de, bzhao@marvell.com, arend@broadcom.com
Date: Fri, 21 Feb 2014 09:38:01 +0100
In-Reply-To: <1392906986-12275-5-git-send-email-luca@coelho.fi>
References: <1392906986-12275-1-git-send-email-luca@coelho.fi>
	 <1392906986-12275-5-git-send-email-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-02-20 at 16:36 +0200, Luciano Coelho wrote:
> From: Luciano Coelho <luciano.coelho@intel.com>
> 
> Error codes returned by cfg80211_chandef_dfs_required() are ignored
> when trying to join an IBSS.  Fix this by printing an error and
> returning.

Applied.

johannes

