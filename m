Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:58100 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046Ab2CAO1X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2012 09:27:23 -0500
Date: Thu, 1 Mar 2012 19:57:29 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] cfg80211: Add an attribute to set inactivity timeout
 in AP mode
Message-ID: <20120301142727.GA2041@vasanth-laptop> (sfid-20120301_152727_257165_0BB4AA79)
References: <1330606339-9055-1-git-send-email-vthiagar@qca.qualcomm.com>
 <1330611665.3623.3.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1330611665.3623.3.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 01, 2012 at 03:21:05PM +0100, Johannes Berg wrote:
> On Thu, 2012-03-01 at 18:22 +0530, Vasanthakumar Thiagarajan wrote:
> > This patch adds an attribute, NL80211_ATTR_INACTIVITY_TIMEOUT,
> > to set the inactivity timeout which can be used to remove the
> > station in AP mode. This can be passed in NL80211_CMD_START_AP
> > and used by the drivers which have AP MLME in firmware but
> > don't support get_station() properly.
> 
> Doesn't hostapd need to know whether this is done or not? At least if it
> knew it could avoid timers etc. -- seems you should add a flag that
> indicates support for this? .And maybe refuse the setting if the flag
> isn't set.

Makes sense, i'll add a flag. thanks!

Vasanth
