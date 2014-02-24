Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:49614 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbaBXM1M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Feb 2014 07:27:12 -0500
Message-ID: <1393244828.4190.12.camel@jlt4.sipsolutions.net> (sfid-20140224_132714_939596_1BBD33AB)
Subject: Re: [PATCH v1 6/6] mac80211: move flag IEEE80211_TX_CTL_USE_MINRATE
 into info->control.flags
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	nbd@nbd.name
Date: Mon, 24 Feb 2014 13:27:08 +0100
In-Reply-To: <1393164527-13800-7-git-send-email-thomas@net.t-labs.tu-berlin.de>
References: <1393164527-13800-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
	 <1393164527-13800-7-git-send-email-thomas@net.t-labs.tu-berlin.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2014-02-23 at 15:08 +0100, Thomas Huehn wrote:
> Flag IEEE80211_TX_CTL_USE_MINRATE is only used within the tx path while
> ieee80211_tx_info->control is valid. Therefore this patch moves this flag
> from info->flags structure into the info->control.flags and renames it to
> IEEE80211_TX_CTRL_USE_MINRATE.

Same problem as patch 1.

johannes

