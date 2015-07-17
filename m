Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52989 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758094AbbGQNsd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2015 09:48:33 -0400
Message-ID: <1437140910.1933.25.camel@sipsolutions.net> (sfid-20150717_154838_591136_E99D8286)
Subject: Re: [PATCH v3 5/5] mac80211: select an AID when creating new mesh
 STAs
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Date: Fri, 17 Jul 2015 15:48:30 +0200
In-Reply-To: <1436877119-17577-6-git-send-email-me@bobcopeland.com> (sfid-20150714_143227_832790_AC27A2F3)
References: <1436877119-17577-1-git-send-email-me@bobcopeland.com>
	 <1436877119-17577-6-git-send-email-me@bobcopeland.com>
	 (sfid-20150714_143227_832790_AC27A2F3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-07-14 at 08:31 -0400, Bob Copeland wrote:
> Instead of using peer link id for AID, generate a new
> AID when creating mesh STAs in the kernel peering manager.
> This enables smaller TIM elements and more closely follows
> the standard, and it also enables mesh to work on drivers
> that require a valid AID when the STA is inserted (ath10k
> firmware has this requirement, for example).
> 
> In the case of userspace-managed stations, we use the AID
> from NL80211_CMD_NEW_STATION.
> 
Applied the remaining 3 patches to mac80211-next (after merging
mac80211)

johannes
