Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:44452 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570AbbEDHic (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2015 03:38:32 -0400
Message-ID: <1430725107.2013.1.camel@sipsolutions.net> (sfid-20150504_093834_969286_F6B1F67D)
Subject: Re: [PATCH] mac80211: add pcpu_sw_netstats field in
 ieee80211_sub_if_data
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 04 May 2015 09:38:27 +0200
In-Reply-To: <1430689381-2339-1-git-send-email-arend@broadcom.com>
References: <1430689381-2339-1-git-send-email-arend@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2015-05-03 at 23:43 +0200, Arend van Spriel wrote:
> Add field in struct ieee80211_sub_if_data pointing to per-cpu
> net statistics. Using this instead of field in struct netdevice
> makes it easier to backport the functionality.

I don't like this either :)

I'll reply on the backports list with a more detailed analysis.

johannes

