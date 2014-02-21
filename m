Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36008 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028AbaBUIbz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Feb 2014 03:31:55 -0500
Message-ID: <1392971510.4346.22.camel@jlt4.sipsolutions.net> (sfid-20140221_093158_980231_F6E092AF)
Subject: Re: [PATCH v3 1/7] nl80211: make sure we check for DFS with mesh
 channel switch
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, michal.kazior@tieto.com,
	sw@simonwunderlich.de, bzhao@marvell.com, arend@broadcom.com
Date: Fri, 21 Feb 2014 09:31:50 +0100
In-Reply-To: <1392906986-12275-2-git-send-email-luca@coelho.fi>
References: <1392906986-12275-1-git-send-email-luca@coelho.fi>
	 <1392906986-12275-2-git-send-email-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-02-20 at 16:36 +0200, Luciano Coelho wrote:
> From: Luciano Coelho <luciano.coelho@intel.com>
> 
> Since mesh support for DFS channels was added, we also need to check
> for DFS channels when performing a channel switch with
> NL80211_IFTYPE_MESHPOINT.

Applied, but I've changed it to a switch statement and did a small code
cleanup as well.

johannes

