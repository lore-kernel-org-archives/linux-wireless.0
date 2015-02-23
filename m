Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60813 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752145AbbBWObd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2015 09:31:33 -0500
Message-ID: <1424701880.3075.0.camel@sipsolutions.net> (sfid-20150223_153139_207506_F3B7A260)
Subject: Re: [PATCH 1/1] nl80211: add NL80211_CMD_GET_TSF
From: Johannes Berg <johannes@sipsolutions.net>
To: Rohan Joyce <rojoyce.github@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Mon, 23 Feb 2015 15:31:20 +0100
In-Reply-To: <1424699832-19284-2-git-send-email-rojoyce.github@gmail.com> (sfid-20150223_151201_815020_CABEA63C)
References: <1424699832-19284-1-git-send-email-rojoyce.github@gmail.com>
	 <1424699832-19284-2-git-send-email-rojoyce.github@gmail.com>
	 (sfid-20150223_151201_815020_CABEA63C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-02-23 at 21:57 +0800, Rohan Joyce wrote:
> This patch adds a command NL80211_CMD_GET_TSF that retrieves the 64 bit time
> synchronisation value for an interface. It returns the value in a uint64
> attribute of type NL80211_ATTR_TSF.

This should explain why and how this could possibly be used - I don't
see any reasonable usage since the TSF is quickly changing and this API
doesn't really allow for any synchronisation.

johannes

