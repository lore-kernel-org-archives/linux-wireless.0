Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:51538 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757318Ab3HLQJL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Aug 2013 12:09:11 -0400
Message-ID: <1376323740.11514.27.camel@jlt4.sipsolutions.net> (sfid-20130812_180931_414024_0C19E8C0)
Subject: Re: [PATCHv2] mac80211: ibss - do not scan if not needed when
 creating an IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <ordex@autistici.org>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>
Date: Mon, 12 Aug 2013 18:09:00 +0200
In-Reply-To: <1376067512-733-1-git-send-email-ordex@autistici.org>
References: <1375862917-3625-1-git-send-email-ordex@autistici.org>
	 <1376067512-733-1-git-send-email-ordex@autistici.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-08-09 at 18:58 +0200, Antonio Quartulli wrote:
> From: Antonio Quartulli <antonio@open-mesh.com>
> 
> In some cases mac80211 will scan before creating an IBSS
> even if bssid and frequency have been forced by the user.
> This is not needed and leads only to a delay in the IBSS
> establishment phase.
> 
> Immediately create the cell if both bssid and frequency
> (and fixed_freq is set) have been specified.

Applied.

johannes

