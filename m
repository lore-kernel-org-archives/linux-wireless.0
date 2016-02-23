Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59051 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750847AbcBWJlt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 04:41:49 -0500
Message-ID: <1456220507.2041.2.camel@sipsolutions.net> (sfid-20160223_104153_144238_B7AA1956)
Subject: Re: [PATCH 3/3] cfg80211: stop critical protocol session upon
 disconnect event
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 23 Feb 2016 10:41:47 +0100
In-Reply-To: <1455543353-20311-4-git-send-email-arend@broadcom.com>
References: <1455543353-20311-1-git-send-email-arend@broadcom.com>
	 <1455543353-20311-4-git-send-email-arend@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-02-15 at 14:35 +0100, Arend van Spriel wrote:
> When user-space has started a critical protocol session and a
> disconnect
> event occurs, the rdev::crit_prot_nlportid remains set. This caused a
> subsequent NL80211_CMD_CRIT_PROTO_START to fail (-EBUSY). Fix this by
> clearing the rdev attribute and call .crit_proto_stop() callback upon
> disconnect event.
> 
Applied.

johannes
